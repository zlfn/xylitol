#!/usr/bin/env bash
# Joins xylitol with a script that calls it, producing one file to ship.
# The script should call `xylitol`, not `./xylitol.sh`.
#
#     tools/bundle.sh app.sh > app-standalone.sh
#     tools/bundle.sh app.sh /path/to/xylitol.sh > app-standalone.sh
set -euo pipefail

app="${1:?usage: bundle.sh <script> [xylitol.sh]}"
lib="${2-}"
if [ -z "$lib" ]; then
    for candidate in "./xylitol.sh" "$(dirname "$0")/../xylitol.sh"; do
        if [ -f "$candidate" ]; then
            lib="$candidate"
            break
        fi
    done
fi
if [ -z "$lib" ] || [ ! -f "$lib" ]; then
    echo "bundle.sh: no xylitol.sh found; pass its path as the second argument" >&2
    exit 1
fi

guard='^if \[ "\${BASH_SOURCE\[0\]}" = "\$0" \]; then$'
if ! grep -q "$guard" "$lib"; then
    echo "bundle.sh: $lib was not produced by build.sh" >&2
    exit 1
fi

sed "/$guard/,\$d" "$lib"
echo
cat "$app"
