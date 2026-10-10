# Genufy — AI-assisted video editing with HyperFrames

This repo is set up for [HyperFrames](https://github.com/heygen-com/hyperframes) (HTML → deterministic MP4).
The 21 published HyperFrames skills are installed project-locally in `.claude/skills/` (source: `skills-lock.json`).

## Entry point

For any request to make, edit, caption, recut, animate or render a video, load the `/hyperframes` skill first.
It runs the intent interview, writes `BRIEF.md`, and routes to the right workflow
(`product-launch-video`, `faceless-explainer`, `talking-head-recut`, `embedded-captions`,
`motion-graphics`, `music-to-video`, `general-video`, `slideshow`, `pr-to-video`, ...).
All workflow skills are already installed, so `hyperframes skills update <workflow>` is not needed.

## Folder layout

```
hyperframes/
  .hyperframes-version     pinned CLI version — always run `npx -y hyperframes@<that version> ...`
  inbox/<video>/           user-supplied ORIGINALS for one video (read-only for the agent)
    footage/               source footage (A-roll, talking head, screen recordings)
    references/            reference videos — study for style/pacing only, never place on the timeline
    images/                images and screenshots
    broll/                 B-roll clips
    audio/                 voiceover, music, SFX supplied by the user
    other/                 logos, fonts, scripts, PDFs, data, anything else
    BRIEF-NOTES.md         optional notes; feed into the intent interview
  library/                 assets shared across videos (brand, fonts, music, sfx, images, footage)
  videos/<video>/          one HyperFrames project per video, created with `hyperframes init`
  scripts/new-video.sh     creates inbox/<video>/
```

## Rules

- Create each project with `npx -y hyperframes@$(cat hyperframes/.hyperframes-version) init hyperframes/videos/<video> --non-interactive`
  (pass `--skill=<workflow>` when the workflow says so). Use the same `<video>` name as its inbox folder.
- Never modify or delete files in `hyperframes/inbox/` or `hyperframes/library/`. Copy what the video needs into
  `hyperframes/videos/<video>/assets/` (prepared/trimmed/graded derivatives get a clear suffix, e.g. `interview-trim.mp4`).
- Reference videos are analysis input only: extract frames/contact sheets with ffmpeg into a temp dir, describe the
  style, pacing, typography and transitions to borrow, and confirm with the user. Do not copy them into `assets/`.
- If a referenced inbox folder is empty or missing, ask the user for the files instead of inventing placeholders.
- Follow the skills' review loop: `check` must pass and the user must approve the preview before any final render.
  Render outputs go in the project's `renders/` (git-ignored).
- In cloud sessions the SessionStart hook installs Chrome Headless Shell. If rendering reports a missing browser,
  run `npx -y hyperframes@$(cat hyperframes/.hyperframes-version) browser ensure`.
- Cloud sessions whose network policy blocks `cdn.jsdelivr.net` fail `check`/`render` with
  `sub_timeline_script_failure` (GSAP failed to load). Fix: allow that domain in the environment's network settings,
  or vendor GSAP into the project — copy `.claude/skills/talking-head-recut/assets/vendor/gsap.min.js` to
  `<project>/assets/vendor/` and point the composition's `<script src>` at `assets/vendor/gsap.min.js`.
