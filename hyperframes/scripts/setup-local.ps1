# One-time local setup for HyperFrames on Windows (PowerShell).
# Skills are already committed in .claude/skills; this checks prerequisites
# and installs the pinned Chrome Headless Shell used for rendering.
#
# Usage (from the repo root): powershell -ExecutionPolicy Bypass -File hyperframes\scripts\setup-local.ps1
$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '..\..')
$version = (Get-Content (Join-Path $root 'hyperframes\.hyperframes-version') -Raw).Trim()
$missing = $false

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  Write-Host 'x Node.js not found. Install Node.js 22 or newer: https://nodejs.org' -ForegroundColor Red
  $missing = $true
} else {
  $major = [int](node -p 'process.versions.node.split(".")[0]')
  if ($major -lt 22) {
    Write-Host "x Node.js $(node -v) is too old. HyperFrames needs Node.js 22 or newer." -ForegroundColor Red
    $missing = $true
  } else {
    Write-Host "OK Node.js $(node -v)"
  }
}

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue) -or -not (Get-Command ffprobe -ErrorAction SilentlyContinue)) {
  Write-Host 'x FFmpeg not found. Install with: winget install Gyan.FFmpeg  (then reopen the terminal)' -ForegroundColor Red
  $missing = $true
} else {
  Write-Host "OK $((ffmpeg -version | Select-Object -First 1))"
}

if ($missing) { exit 1 }

Write-Host "Installing Chrome Headless Shell for hyperframes@$version ..."
npx -y "hyperframes@$version" browser ensure
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ''
Write-Host 'Environment check (whisper-cpp, Kokoro and MusicGen are optional):'
npx -y "hyperframes@$version" doctor

Write-Host ''
Write-Host "Done. Start Claude Code in $root and ask:"
Write-Host '  Using /hyperframes, make a video from hyperframes/inbox/<video-name>'
