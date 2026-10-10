#!/bin/bash
# Ensures HyperFrames can render in Claude Code cloud sessions.
# Skills are committed under .claude/skills; only the render browser needs installing.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

HF_VERSION="$(cat "$CLAUDE_PROJECT_DIR/hyperframes/.hyperframes-version")"

# Idempotent: finds the cached Chrome Headless Shell or downloads the pinned build.
npx -y "hyperframes@${HF_VERSION}" browser ensure >&2
