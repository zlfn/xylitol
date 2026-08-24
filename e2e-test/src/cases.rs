//! What each case asserts is written here as data; `main.rs` runs it.

pub enum Step {
    /// Read until this text shows up on screen, or fail on timeout.
    Wait(&'static str),
    /// Write these bytes to the terminal.
    Send(&'static str),
}

pub const UP: &str = "\x1b[A";
pub const DOWN: &str = "\x1b[B";
pub const RIGHT: &str = "\x1b[C";
pub const ENTER: &str = "\n";
pub const SPACE: &str = " ";
pub const TAB: &str = "\t";
pub const CTRL_A: &str = "\x01";

#[derive(Default)]
pub struct Expect {
    /// What the command must print on stdout.
    pub stdout: Option<&'static str>,
    pub status: Option<i32>,
    /// Text the command must print on stdout.
    pub stdout_has: &'static [&'static str],
    pub screen_has: &'static [&'static str],
    pub screen_lacks: &'static [&'static str],
    /// Fail if any screen line is wider than this.
    pub max_line_width: Option<usize>,
}

pub struct Case {
    pub name: &'static str,
    /// Shell command piped into xylitol, if the case feeds it options.
    pub stdin: Option<&'static str>,
    pub args: &'static str,
    /// Terminal size the case runs under, as (rows, columns).
    pub size: (u16, u16),
    pub steps: &'static [Step],
    pub expect: Expect,
}

/// Entry points, flag parsing and help layout. Nothing here needs keystrokes.
fn surface() -> Vec<Case> {
    let mut out = vec![
        Case {
            name: "no arguments prints help",
            stdin: None,
            args: "",
            size: (40, 100),
            steps: &[],
            expect: Expect {
                status: Some(0),
                stdout_has: &["Usage:", "Commands:"],
                screen_lacks: &["Index out of bounds", "syntax error"],
                ..Default::default()
            },
        },
        Case {
            name: "unknown command still prints help",
            stdin: None,
            args: "bogus-command",
            size: (40, 100),
            steps: &[],
            expect: Expect {
                stdout_has: &["Usage:", "Unknown command"],
                ..Default::default()
            },
        },
        Case {
            name: "version",
            stdin: None,
            args: "--version",
            size: (40, 100),
            steps: &[],
            expect: Expect {
                status: Some(0),
                stdout_has: &["version:"],
                ..Default::default()
            },
        },
    ];

    for cmd in ["choose", "input", "confirm", "file"] {
        out.push(Case {
            name: Box::leak(format!("{cmd} --help").into_boxed_str()),
            stdin: None,
            args: Box::leak(format!("{cmd} --help").into_boxed_str()),
            size: (40, 100),
            steps: &[],
            expect: Expect {
                status: Some(0),
                stdout_has: &["Usage:", "Flags:"],
                ..Default::default()
            },
        });
    }

    // Values that cannot be parsed have to be reported, not silently accepted.
    for (args, msg) in [
        ("choose --limit=abc", "Invalid limit value"),
        ("choose --page-size=xyz", "Invalid page-size value"),
        ("file --page-size=zz", "Invalid page-size value"),
        ("confirm --default=maybe", "Invalid default value"),
    ] {
        out.push(Case {
            name: Box::leak(format!("rejects {args}").into_boxed_str()),
            stdin: Some("printf 'a\\n'"),
            args: Box::leak(args.to_string().into_boxed_str()),
            size: (40, 100),
            steps: &[],
            expect: Expect {
                screen_has: Box::leak(vec![msg].into_boxed_slice()),
                ..Default::default()
            },
        });
    }

    // Help has to fit the terminal it is printed into.
    for cols in [100u16, 30] {
        for cmd in ["", "choose", "input"] {
            out.push(Case {
                name: Box::leak(
                    format!("help fits {cols} columns ({})", if cmd.is_empty() { "main" } else { cmd })
                        .into_boxed_str(),
                ),
                stdin: None,
                args: Box::leak(format!("{cmd} --help").trim().to_string().into_boxed_str()),
                size: (40, cols),
                steps: &[],
                expect: Expect {
                    max_line_width: Some(cols as usize),
                    ..Default::default()
                },
            });
        }
    }
    out
}

/// The interactive commands.
fn interactive() -> Vec<Case> {
    vec![
        Case {
            name: "choose: moves down",
            stdin: Some("printf 'alpha\\nbravo\\ncharlie\\n'"),
            args: "choose",
            size: (40, 100),
            steps: &[Step::Wait("alpha"), Step::Send(DOWN), Step::Send(ENTER)],
            expect: Expect { stdout: Some("bravo"), ..Default::default() },
        },
        Case {
            name: "choose: wraps upwards",
            stdin: Some("printf 'alpha\\nbravo\\ncharlie\\n'"),
            args: "choose",
            size: (40, 100),
            steps: &[Step::Wait("alpha"), Step::Send(UP), Step::Send(ENTER)],
            expect: Expect { stdout: Some("charlie"), ..Default::default() },
        },
        Case {
            name: "choose: pages forward",
            stdin: Some("seq 1 25"),
            args: "choose --page-size=5",
            size: (40, 100),
            steps: &[
                Step::Wait("Page 1/5"),
                Step::Send(RIGHT),
                Step::Wait("Page 2/5"),
                Step::Send(RIGHT),
                Step::Wait("Page 3/5"),
                Step::Send(DOWN),
                Step::Send(ENTER),
            ],
            expect: Expect { stdout: Some("12"), ..Default::default() },
        },
        Case {
            name: "choose: wraps to the last page",
            stdin: Some("seq 1 25"),
            args: "choose --page-size=5",
            size: (40, 100),
            steps: &[Step::Wait("Page 1/5"), Step::Send(UP), Step::Send(ENTER)],
            expect: Expect { stdout: Some("25"), ..Default::default() },
        },
        Case {
            name: "choose: checks two options",
            stdin: Some("printf 'alpha\\nbravo\\ncharlie\\n'"),
            args: "choose --no-limit",
            size: (40, 100),
            steps: &[
                Step::Wait("alpha"),
                Step::Send("x"),
                Step::Send(DOWN),
                Step::Send("x"),
                Step::Send(ENTER),
            ],
            expect: Expect { stdout: Some("alpha\nbravo"), ..Default::default() },
        },
        Case {
            name: "choose: space confirms",
            stdin: Some("printf 'alpha\\nbravo\\n'"),
            args: "choose",
            size: (40, 100),
            steps: &[Step::Wait("alpha"), Step::Send(DOWN), Step::Send(SPACE)],
            expect: Expect { stdout: Some("bravo"), ..Default::default() },
        },
        Case {
            name: "choose: selects everything",
            stdin: Some("printf 'alpha\\nbravo\\ncharlie\\n'"),
            args: "choose --no-limit",
            size: (40, 100),
            steps: &[Step::Wait("alpha"), Step::Send("a"), Step::Send(ENTER)],
            expect: Expect { stdout: Some("alpha\nbravo\ncharlie"), ..Default::default() },
        },
        Case {
            name: "choose: tab toggles",
            stdin: Some("printf 'alpha\\nbravo\\ncharlie\\n'"),
            args: "choose --no-limit",
            size: (40, 100),
            steps: &[
                Step::Wait("alpha"),
                Step::Send(TAB),
                Step::Send(DOWN),
                Step::Send(DOWN),
                Step::Send(TAB),
                Step::Send(ENTER),
            ],
            expect: Expect { stdout: Some("alpha\ncharlie"), ..Default::default() },
        },
        Case {
            name: "choose: ctrl-a selects everything",
            stdin: Some("printf 'alpha\\nbravo\\ncharlie\\n'"),
            args: "choose --no-limit",
            size: (40, 100),
            steps: &[Step::Wait("alpha"), Step::Send(CTRL_A), Step::Send(ENTER)],
            expect: Expect { stdout: Some("alpha\nbravo\ncharlie"), ..Default::default() },
        },
        Case {
            name: "choose: honours the limit",
            stdin: Some("printf 'alpha\\nbravo\\ncharlie\\n'"),
            args: "choose --limit=2",
            size: (40, 100),
            steps: &[
                Step::Wait("alpha"),
                Step::Send("x"),
                Step::Send(DOWN),
                Step::Send("x"),
                Step::Send(DOWN),
                Step::Send("x"),
                Step::Send(ENTER),
            ],
            expect: Expect { stdout: Some("alpha\nbravo"), ..Default::default() },
        },
        Case {
            name: "filter: narrows as you type",
            stdin: Some("printf 'alpha\\nbravo\\ncharlie\\n'"),
            args: "filter",
            size: (40, 100),
            steps: &[Step::Wait("alpha"), Step::Send("ch"), Step::Send(ENTER)],
            expect: Expect { stdout: Some("charlie"), ..Default::default() },
        },
        Case {
            name: "filter: prefixes rank above later hits",
            stdin: Some("printf 'dash\\nshadow\\nsh\\n'"),
            args: "filter",
            size: (40, 100),
            steps: &[Step::Wait("dash"), Step::Send("sh"), Step::Wait("3/3"), Step::Send(ENTER)],
            expect: Expect { stdout: Some("sh"), ..Default::default() },
        },
        Case {
            name: "filter: prefix beats a later hit",
            stdin: Some("printf 'dash\\nshadow\\n'"),
            args: "filter",
            size: (40, 100),
            steps: &[Step::Wait("dash"), Step::Send("sh"), Step::Wait("2/2"), Step::Send(ENTER)],
            expect: Expect { stdout: Some("shadow"), ..Default::default() },
        },
        Case {
            name: "filter: matches ignore case",
            stdin: Some("printf 'Alpha\\nBravo\\n'"),
            args: "filter",
            size: (40, 100),
            steps: &[Step::Wait("Alpha"), Step::Send("br"), Step::Send(ENTER)],
            expect: Expect { stdout: Some("Bravo"), ..Default::default() },
        },
        Case {
            name: "filter: backspace widens again",
            stdin: Some("printf 'alpha\\nbravo\\n'"),
            args: "filter",
            size: (40, 100),
            steps: &[
                Step::Wait("alpha"),
                Step::Send("br"),
                Step::Send("\x7f"),
                Step::Send("\x7f"),
                Step::Wait("alpha"),
                Step::Send(ENTER),
            ],
            expect: Expect { stdout: Some("alpha"), ..Default::default() },
        },
        Case {
            name: "filter: moves within the matches",
            stdin: Some("printf 'alpha\\nalbatross\\nbravo\\n'"),
            args: "filter",
            size: (40, 100),
            steps: &[
                Step::Wait("alpha"),
                Step::Send("al"),
                Step::Send(DOWN),
                Step::Send(ENTER),
            ],
            expect: Expect { stdout: Some("albatross"), ..Default::default() },
        },
        Case {
            name: "filter: tab checks two matches",
            stdin: Some("printf 'alpha\\nbravo\\ncharlie\\n'"),
            args: "filter --no-limit",
            size: (40, 100),
            steps: &[
                Step::Wait("alpha"),
                Step::Send(TAB),
                Step::Send(DOWN),
                Step::Send(DOWN),
                Step::Send(TAB),
                Step::Send(ENTER),
            ],
            expect: Expect { stdout: Some("alpha\ncharlie"), ..Default::default() },
        },
        Case {
            name: "filter: keeps checks across a query",
            stdin: Some("printf 'alpha\\nbravo\\n'"),
            args: "filter --no-limit",
            size: (40, 100),
            steps: &[
                Step::Wait("alpha"),
                Step::Send(TAB),
                Step::Send("br"),
                Step::Send(TAB),
                Step::Send(ENTER),
            ],
            expect: Expect { stdout: Some("alpha\nbravo"), ..Default::default() },
        },
        Case {
            name: "filter: will not confirm nothing",
            stdin: Some("printf 'alpha\\nbravo\\n'"),
            args: "filter",
            size: (40, 100),
            steps: &[
                Step::Wait("alpha"),
                Step::Send("zzz"),
                Step::Wait("0/2"),
                Step::Send(ENTER),
                Step::Send("\x7f\x7f\x7f"),
                Step::Wait("alpha"),
                Step::Send(ENTER),
            ],
            expect: Expect { stdout: Some("alpha"), ..Default::default() },
        },
        Case {
            name: "filter: narrows on CJK input",
            stdin: Some("printf '애로우\\n버블스\\n체인지\\n'"),
            args: "filter",
            size: (40, 100),
            steps: &[
                Step::Wait("3/3"),
                Step::Send("버"),
                Step::Wait("1/3"),
                Step::Send(ENTER),
            ],
            expect: Expect { stdout: Some("버블스"), ..Default::default() },
        },
        Case {
            name: "filter: space goes into the query",
            stdin: Some("printf 'red apple\\nredhat\\n'"),
            args: "filter",
            size: (40, 100),
            steps: &[Step::Wait("redhat"), Step::Send("d a"), Step::Send(ENTER)],
            expect: Expect { stdout: Some("red apple"), ..Default::default() },
        },
        Case {
            name: "input: returns what was typed",
            stdin: None,
            args: "input",
            size: (40, 100),
            steps: &[Step::Wait(">"), Step::Send("hello world"), Step::Send(ENTER)],
            expect: Expect { stdout: Some("hello world"), ..Default::default() },
        },
        Case {
            name: "input: keeps a value containing '='",
            stdin: None,
            args: "input --prompt='a=b: '",
            size: (40, 100),
            steps: &[Step::Wait("a=b:"), Step::Send("value"), Step::Send(ENTER)],
            expect: Expect {
                stdout: Some("value"),
                screen_has: &["a=b:"],
                ..Default::default()
            },
        },
        Case {
            name: "input: returns a value wider than the terminal",
            stdin: None,
            args: "input",
            size: (40, 30),
            steps: &[
                Step::Wait(">"),
                Step::Send("0123456789012345678901234567890123456789"),
                Step::Send(ENTER),
            ],
            expect: Expect {
                stdout: Some("0123456789012345678901234567890123456789"),
                ..Default::default()
            },
        },
        Case {
            name: "input: returns a value filling the terminal exactly",
            stdin: None,
            args: "input",
            size: (40, 30),
            steps: &[
                Step::Wait(">"),
                Step::Send("0123456789012345678901234567"),
                Step::Send(ENTER),
            ],
            expect: Expect {
                stdout: Some("0123456789012345678901234567"),
                ..Default::default()
            },
        },
        Case {
            name: "input: hides a password",
            stdin: None,
            args: "input --password",
            size: (40, 100),
            steps: &[Step::Wait(">"), Step::Send("secret"), Step::Send(ENTER)],
            expect: Expect {
                stdout: Some("secret"),
                screen_lacks: &["secret"],
                ..Default::default()
            },
        },
        Case {
            name: "confirm: yes exits 0",
            stdin: None,
            args: "confirm",
            size: (40, 100),
            steps: &[Step::Wait("Yes"), Step::Send("y")],
            expect: Expect { status: Some(0), ..Default::default() },
        },
        Case {
            name: "confirm: no exits 1",
            stdin: None,
            args: "confirm",
            size: (40, 100),
            steps: &[Step::Wait("Yes"), Step::Send("n")],
            expect: Expect { status: Some(1), ..Default::default() },
        },
    ]
}

pub fn all() -> Vec<Case> {
    let mut cases = surface();
    cases.extend(interactive());
    cases
}
