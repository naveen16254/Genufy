#!/usr/bin/env bash
# One-time local setup for HyperFrames on macOS / Linux.
# Skills are already committed in .claude/skills; this checks prerequisites
# and installs the pinned Chrome Headless Shell used for rendering.
#
# Usage (from the repo root): hyperframes/scripts/setup-local.sh
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
version="$(cat "$root/hyperframes/.hyperframes-version")"
missing=0

if ! command -v node >/dev/null 2>&1; then
  echo "✗ Node.js not found. Install Node.js 22 or newer: https://nodejs.org" >&2
  missing=1
else
  major="$(node -p 'process.versions.node.split(".")[0]')"
  if [ "$major" -lt 22 ]; then
    echo "✗ Node.js $(node -v) is too old. HyperFrames needs Node.js 22 or newer." >&2
    missing=1
  else
    echo "✓ Node.js $(node -v)"
  fi
fi

if ! command -v ffmpeg >/dev/null 2>&1 || ! command -v ffprobe >/dev/null 2>&1; then
  echo "✗ FFmpeg not found. macOS: brew install ffmpeg | Ubuntu/Debian: sudo apt install ffmpeg" >&2
  missing=1
else
  echo "✓ $(ffmpeg -version | head -n 1)"
fi

[ "$missing" -eq 0 ] || exit 1

echo "Installing Chrome Headless Shell for hyperframes@$version ..."
npx -y "hyperframes@$version" browser ensure

echo
echo "Environment check (whisper-cpp, Kokoro and MusicGen are optional):"
npx -y "hyperframes@$version" doctor || true

echo
echo "Done. Start Claude Code in $root and ask:"
echo "  Using /hyperframes, make a video from hyperframes/inbox/<video-name>"
