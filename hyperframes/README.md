# HyperFrames workspace

AI-assisted video creation and editing with [HyperFrames](https://hyperframes.heygen.com) and Claude Code.
Works for any kind of video: product promos, explainers, talking-head recuts, captions, motion graphics,
music videos, slideshows and freeform edits.

## Run locally (recommended)

Rendering and preview run entirely on your machine and are free. Prerequisites: Git, Node.js 22+, FFmpeg,
and the [Claude Code CLI](https://code.claude.com/docs/en/setup) or desktop app.

```bash
git clone https://github.com/naveen16254/Genufy.git
cd Genufy
git checkout claude/hyperframes-claude-code-setup-qi5o80   # until merged into main

hyperframes/scripts/setup-local.sh                          # macOS / Linux
# powershell -ExecutionPolicy Bypass -File hyperframes\scripts\setup-local.ps1   # Windows

claude                                                      # start Claude Code in the repo root
```

The HyperFrames skills are already in `.claude/skills/`, so nothing else needs installing.
To open the Studio preview from another device on your network, use `http://<this-computer's-IP>:3002`
(allow the port through your firewall if prompted).

## Start a new video

```bash
hyperframes/scripts/new-video.sh my-video-name
```

Drop your files into `hyperframes/inbox/my-video-name/`:

| Folder        | Put here                                                                 |
| ------------- | ------------------------------------------------------------------------ |
| `footage/`    | Source footage: A-roll, talking head, interviews, screen recordings      |
| `references/` | Reference videos whose style/pacing you want (studied, never rendered)   |
| `images/`     | Images and screenshots                                                    |
| `broll/`      | B-roll clips                                                              |
| `audio/`      | Voiceover, music or sound effects you supply                              |
| `other/`      | Logos, fonts, scripts, PDFs, data/CSV, brand guides, anything else        |

Optionally fill in `BRIEF-NOTES.md`, then ask Claude:

> Using /hyperframes, make a video from hyperframes/inbox/my-video-name

Claude runs a short intent interview, scaffolds `hyperframes/videos/my-video-name/`, copies what it needs into the
project's `assets/`, builds, checks, and shows you a preview before rendering.

Assets you reuse across many videos (logo, brand colours/`design.md`, fonts, signature music) go in
`hyperframes/library/`.

## Useful commands (run inside `hyperframes/videos/<name>/`)

```bash
npm run dev      # Studio preview with live reload
npm run check    # lint + browser audit
npm run render   # render MP4 into renders/
```

## Notes

- CLI version is pinned in `hyperframes/.hyperframes-version` and in each project's `package.json`.
- GitHub rejects files over 100 MB. For larger footage, use Git LFS or share via a connected drive.
- HyperFrames sends anonymous usage telemetry by default; disable with `npx hyperframes telemetry disable`.
- Updating skills: `npx skills update` (reads `skills-lock.json`), then commit `.claude/skills/`.
