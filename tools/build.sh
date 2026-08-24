#!/usr/bin/env bash
# Compiles the sources and wraps the entry point in a function, so the result
# can be run, sourced, or joined onto a caller by bundle.sh.
#
#     tools/build.sh              # writes xylitol.sh
#     tools/build.sh /tmp/out.sh
set -euo pipefail

here=$(cd "$(dirname "$0")/.." && pwd)
case "${1-}" in
    ("") out="$here/xylitol.sh" ;;
    (/*) out="$1" ;;
    (*)  out="$PWD/$1" ;;
esac

raw=$(mktemp)
trap 'rm -f "$raw"' EXIT
# Compiled from the repository root, because the source path Amber bakes into
# its bounds messages would otherwise differ per machine.
cd "$here"
amber build --target bash-3.2 src/main.ab "$raw"

split=$(grep -n '^}' "$raw" | tail -1 | cut -d: -f1)
if [ -z "$split" ]; then
    echo "build.sh: the compiler emitted no top level function" >&2
    exit 1
fi

entry=$(tail -n "+$((split + 1))" "$raw" | grep -v '^[[:space:]]*$' | head -1)
case "$entry" in
    (typeset\ -r\ args_*) ;;
    (*)
        echo "build.sh: expected the entry point to open with 'typeset -r args_', got:" >&2
        echo "  $entry" >&2
        exit 1
        ;;
esac

{
    head -n "$split" "$raw"
    echo
    echo 'xylitol() ('
    echo '    # The compiler reads $? after tests that are meant to fail.'
    echo '    set +euo pipefail'
    tail -n "+$((split + 1))" "$raw"
    echo ')'
    echo
    echo 'if [ "${BASH_SOURCE[0]}" = "$0" ]; then'
    echo '    xylitol "$@"'
    echo 'fi'
} > "$out"
chmod +x "$out"
