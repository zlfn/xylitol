#!/usr/bin/env bash
# Render every tape into examples/demo/out/. Needs vhs and ttyd on PATH.
set -euo pipefail

cd "$(dirname "$0")/../.."

if ! command -v vhs > /dev/null; then
    echo "vhs is not installed (Arch: pacman -S vhs ttyd)" >&2
    exit 1
fi

mkdir -p examples/demo/out

for tape in examples/demo/*.tape; do
    printf '==> %s\n' "$tape"
    vhs "$tape"
done

echo
echo "Done. The GIFs are in examples/demo/out/ and are not committed;"
echo "drop them into a GitHub comment to get a usercontent URL for the README."
