//! Drives the built `xylitol.sh` through a pseudo terminal the way a person
//! would, either on this machine or inside a container with a chosen bash.
//!
//!     cargo run --manifest-path tools/e2e-test/Cargo.toml -- --local
//!     cargo run --manifest-path tools/e2e-test/Cargo.toml -- --docker bash:3.2
//!     cargo run --manifest-path tools/e2e-test/Cargo.toml -- --bash /bin/bash
//!     cargo run --manifest-path tools/e2e-test/Cargo.toml -- --local --filter choose

mod cases;

use cases::{Case, Step};
use rexpect::reader::Options;
use rexpect::session::{spawn_with_options, PtySession};
use std::io::IsTerminal;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::time::{Duration, Instant};

/// Colour is on for a terminal and for CI, which renders escapes, and off
/// whenever NO_COLOR asks for it.
struct Paint(bool);

impl Paint {
    fn detect() -> Self {
        let wanted = std::env::var_os("NO_COLOR").is_none();
        let shown = std::io::stdout().is_terminal() || std::env::var_os("CI").is_some();
        Paint(wanted && shown)
    }
    fn green(&self, s: &str) -> String { self.wrap("32", s) }
    fn red(&self, s: &str) -> String { self.wrap("31", s) }
    fn dim(&self, s: &str) -> String { self.wrap("90", s) }
    fn bold(&self, s: &str) -> String { self.wrap("1", s) }
    fn wrap(&self, code: &str, s: &str) -> String {
        if self.0 { format!("\x1b[{code}m{s}\x1b[0m") } else { s.to_string() }
    }
}

const TIMEOUT_MS: u64 = 10_000;

enum Target {
    /// Run on this machine, optionally through a specific bash.
    Local(Option<String>),
    Docker(String),
}

struct Paths {
    repo: PathBuf,
    scratch: PathBuf,
}

fn build_session(target: &Target, paths: &Paths, case: &Case, id: usize) -> Result<PtySession, String> {
    let (rows, cols) = case.size;
    let pipe = case.stdin.map(|c| format!("{c} | ")).unwrap_or_default();

    let mut command = match target {
        Target::Local(bash) => {
            let run = match bash {
                Some(path) => format!("{path} xylitol.sh"),
                None => "./xylitol.sh".to_string(),
            };
            let script = format!(
                "stty rows {rows} cols {cols} 2>/dev/null; cd {repo}; \
                 {pipe}{run} {args} > {out}; printf '%s' $? > {status}",
                repo = paths.repo.display(),
                args = case.args,
                out = paths.scratch.join(format!("out.{id}")).display(),
                status = paths.scratch.join(format!("status.{id}")).display(),
            );
            let mut c = Command::new("sh");
            c.arg("-c").arg(script);
            c
        }
        Target::Docker(image) => {
            // The pipe has to live inside the container, otherwise docker's
            // stdin is a pipe and `-t` refuses to allocate a terminal.
            let script = format!(
                "stty rows {rows} cols {cols} 2>/dev/null; \
                 {pipe}bash xylitol.sh {args} > /s/out.{id}; printf '%s' $? > /s/status.{id}",
                args = case.args,
            );
            let mut c = Command::new("docker");
            c.args(["run", "--rm", "-i", "-t"])
                .arg("-v")
                .arg(format!("{}:/w", paths.repo.display()))
                .arg("-v")
                .arg(format!("{}:/s", paths.scratch.display()))
                .args(["-w", "/w", image, "bash", "-c"])
                .arg(script);
            c
        }
    };
    command.env("TERM", "xterm");

    let options = Options::new()
        .timeout_ms(Some(TIMEOUT_MS))
        .strip_ansi_escape_codes(true);
    spawn_with_options(command, options).map_err(|e| format!("spawn: {e}"))
}

/// Drop CSI sequences so widths are counted in visible columns. rexpect does
/// this for the terminal stream, but stdout is captured through a file.
fn strip_ansi(text: &str) -> String {
    let mut out = String::with_capacity(text.len());
    let mut chars = text.chars().peekable();
    while let Some(c) = chars.next() {
        if c != '\x1b' {
            out.push(c);
            continue;
        }
        if chars.peek() == Some(&'[') {
            chars.next();
            while let Some(c) = chars.next() {
                if c.is_ascii_alphabetic() {
                    break;
                }
            }
        }
    }
    out
}

/// Run one case and return the reasons it failed, if any.
fn run(target: &Target, paths: &Paths, case: &Case, id: usize) -> (Vec<String>, Duration) {

    let started = Instant::now();
    let mut session = match build_session(target, paths, case, id) {
        Ok(s) => s,
        Err(e) => return (vec![e], started.elapsed()),
    };

    let mut screen = String::new();
    for step in case.steps {
        match step {
            Step::Wait(needle) => match session.exp_string(needle) {
                Ok(before) => {
                    screen.push_str(&before);
                    screen.push_str(needle);
                }
                Err(e) => {
                    screen.push_str(&session.exp_eof().unwrap_or_default());
                    return (
                        vec![format!("'{needle}' never appeared ({e})\n--- screen ---\n{screen}")],
                        started.elapsed(),
                    );
                }
            },
            Step::Send(keys) => {
                if let Err(e) = session.send(keys).and_then(|_| session.flush()) {
                    return (vec![format!("could not send {keys:?}: {e}")], started.elapsed());
                }
            }
        }
    }
    match session.exp_eof() {
        Ok(rest) => screen.push_str(&rest),
        Err(e) => {
            return (
                vec![format!("did not finish ({e})\n--- screen ---\n{screen}")],
                started.elapsed(),
            )
        }
    }

    let _ = session.process_mut().wait();
    (check(case, &screen, paths, id), started.elapsed())
}

fn check(case: &Case, screen: &str, paths: &Paths, id: usize) -> Vec<String> {
    let mut failures = Vec::new();
    let read = |name: &str| {
        std::fs::read_to_string(paths.scratch.join(format!("{name}.{id}")))
            .unwrap_or_default()
            .trim_end_matches('\n')
            .to_string()
    };

    if let Some(want) = case.expect.stdout {
        let got = read("out");
        if got != want {
            failures.push(format!("stdout: want {want:?}, got {got:?}"));
        }
    }
    if let Some(want) = case.expect.status {
        let got = read("status");
        if got != want.to_string() {
            failures.push(format!("exit status: want {want}, got {got:?}"));
        }
    }
    for needle in case.expect.stdout_has {
        if !read("out").contains(needle) {
            failures.push(format!("stdout is missing {needle:?}"));
        }
    }
    for needle in case.expect.screen_has {
        if !screen.contains(needle) {
            failures.push(format!("screen is missing {needle:?}"));
        }
    }
    for needle in case.expect.screen_lacks {
        if screen.contains(needle) {
            failures.push(format!("screen should not contain {needle:?}"));
        }
    }
    if let Some(limit) = case.expect.max_line_width {
        let shown = format!("{}\n{}", strip_ansi(&read("out")), screen);
        for line in shown.lines() {
            let line = line.trim_end_matches('\r');
            if line.chars().count() > limit {
                failures.push(format!(
                    "line is {} columns, over the {limit} available: {line:?}",
                    line.chars().count()
                ));
                break;
            }
        }
    }
    failures
}

fn main() {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let mut target = Target::Local(None);
    let mut filter: Option<String> = None;
    let mut i = 0;
    while i < args.len() {
        match args[i].as_str() {
            "--local" => target = Target::Local(None),
            "--bash" => {
                i += 1;
                target = Target::Local(Some(
                    args.get(i).cloned().expect("--bash needs a path"),
                ));
            }
            "--docker" => {
                i += 1;
                target = Target::Docker(args.get(i).cloned().expect("--docker needs an image"));
            }
            "--filter" => {
                i += 1;
                filter = args.get(i).cloned();
            }
            other => {
                eprintln!("unknown argument {other}");
                std::process::exit(2);
            }
        }
        i += 1;
    }

    let repo = std::fs::canonicalize(
        Path::new(env!("CARGO_MANIFEST_DIR")).join("../.."),
    )
    .expect("repository root");
    // Per process, so two runs can go at once without eating each other's
    // output files.
    let scratch = std::env::temp_dir().join(format!("xylitol-e2e.{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&scratch);
    std::fs::create_dir_all(&scratch).expect("scratch directory");
    let paths = Paths { repo, scratch };

    let paint = Paint::detect();
    let label = match &target {
        Target::Local(None) => "local".to_string(),
        Target::Local(Some(p)) => p.clone(),
        Target::Docker(image) => image.clone(),
    };
    println!("running against {}\n", paint.bold(&label));

    let mut passed = 0;
    let mut failed = 0;
    let mut timings: Vec<(String, Duration)> = Vec::new();
    let overall = Instant::now();

    for (index, case) in cases::all().into_iter().enumerate() {
        if let Some(f) = &filter {
            if !case.name.contains(f.as_str()) {
                continue;
            }
        }
        let (failures, took) = run(&target, &paths, &case, index);
        let secs = paint.dim(&format!("{:>6.2}s", took.as_secs_f64()));
        if failures.is_empty() {
            passed += 1;
            println!("  {}  {:<44} {secs}", paint.green("ok  "), case.name);
        } else {
            failed += 1;
            println!("  {}  {:<44} {secs}", paint.red("FAIL"), case.name);
            for f in failures {
                for line in f.lines() {
                    println!("          {}", paint.dim(line));
                }
            }
        }
        timings.push((case.name.to_string(), took));
    }

    let _ = std::fs::remove_dir_all(&paths.scratch);

    let total = overall.elapsed();
    let summary = format!("{passed} passed, {failed} failed in {:.1}s", total.as_secs_f64());
    println!(
        "\n{}",
        if failed > 0 { paint.red(&summary) } else { paint.green(&summary) }
    );

    timings.sort_by(|a, b| b.1.cmp(&a.1));
    if timings.len() > 1 {
        let slowest: Vec<String> = timings
            .iter()
            .take(3)
            .map(|(name, d)| format!("{name} {:.2}s", d.as_secs_f64()))
            .collect();
        println!("{}", paint.dim(&format!("slowest: {}", slowest.join(" · "))));
    }

    if failed > 0 {
        std::process::exit(1);
    }
}
