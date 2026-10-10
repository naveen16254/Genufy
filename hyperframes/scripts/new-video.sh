#!/usr/bin/env bash
# Creates the intake folder for a new video: hyperframes/inbox/<name>/
#
# The HyperFrames project itself (hyperframes/videos/<name>/) is scaffolded later
# by the /hyperframes router, which runs `hyperframes init` after its intent
# interview. `init` refuses non-empty folders, so source files live in the inbox
# and the agent copies what the video needs into the project's assets/.
#
# Usage: hyperframes/scripts/new-video.sh <video-name>
set -euo pipefail

usage() {
  echo "Usage: $0 <video-name>   (lowercase letters, digits and dashes, e.g. q3-product-promo)" >&2
  exit 1
}

[ $# -eq 1 ] || usage
name="$1"
[[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || usage

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
inbox="$root/inbox/$name"

if [ -e "$inbox" ]; then
  echo "Inbox already exists: hyperframes/inbox/$name" >&2
  exit 1
fi
if [ -e "$root/videos/$name" ]; then
  echo "A project named '$name' already exists in hyperframes/videos/" >&2
  exit 1
fi

for dir in footage references images broll audio other; do
  mkdir -p "$inbox/$dir"
  touch "$inbox/$dir/.gitkeep"
done

cat > "$inbox/BRIEF-NOTES.md" <<EOF
# $name

<!-- Optional. Anything you already know helps the /hyperframes intent interview. -->

- Goal / audience:
- Platform & aspect ratio (16:9, 9:16, 1:1, 4:5):
- Target length:
- Tone / style (and what to copy from the reference videos):
- Must include (copy, facts, CTA, logo):
- Must avoid:
EOF

echo "Created hyperframes/inbox/$name/"
echo "  footage/     source footage (A-roll, talking head, screen recordings)"
echo "  references/  reference videos for style only (never rendered)"
echo "  images/      images and screenshots"
echo "  broll/       B-roll clips"
echo "  audio/       voiceover, music, SFX you supply"
echo "  other/       logos, fonts, scripts, PDFs, data, anything else"
echo
echo "Then ask Claude: Using /hyperframes, make a video from hyperframes/inbox/$name"
