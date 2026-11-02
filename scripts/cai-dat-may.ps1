# Cài các công cụ chạy trên máy (Windows 10/11) mà repo jdkend cần nhưng không cài qua repo được.
# Chạy trong PowerShell:  powershell -ExecutionPolicy Bypass -File scripts\cai-dat-may.ps1
# Mỗi mục đều hỏi có/không. Dùng winget (có sẵn trên Windows 10/11).

function Hoi($q) { (Read-Host "$q [y/N]") -match '^[Yy]$' }
function Co($c) { [bool](Get-Command $c -ErrorAction SilentlyContinue) }

Write-Host "== Kiểm tra nền tảng =="
if (-not (Co node)) {
  if (Hoi "Thiếu Node.js. Cài Node.js LTS?") { winget install -e --id OpenJS.NodeJS.LTS } else { exit 1 }
  Write-Host "Mở lại PowerShell rồi chạy lại script."; exit 0
}
Write-Host "Node.js: $(node -v)"
if (-not (Co git)) { winget install -e --id Git.Git }

if (-not (Co ffmpeg) -and (Hoi "Cài ffmpeg (cho plugin ffmpeg-skill, cắt ghép video)?")) { winget install -e --id Gyan.FFmpeg }

if (Hoi "Cài gstack (bộ 23 công cụ của Garry Tan, cần Bun)?") {
  if (-not (Co bun)) { powershell -c "irm bun.sh/install.ps1 | iex"; $env:Path += ";$HOME\.bun\bin" }
  $g = "$HOME\.claude\skills\gstack"
  if (-not (Test-Path $g)) { git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git $g }
  Push-Location $g; .\setup.ps1; Pop-Location
}

if (Hoi "Cài codegraph (bản đồ code, ít token hơn)?") { npm i -g @colbymchenry/codegraph }

if (Hoi "Cài claude-code-router (chuyển Claude Code sang model khác)?") { npm i -g @musistudio/claude-code-router }

if (Co python) {
  if (Hoi "Cài MinerU (đọc PDF/scan/Word, tải khá nặng)?") { python -m pip install -U "mineru[all]" }
  if (Hoi "Cài Whisper (chuyển giọng nói thành chữ)?") { python -m pip install -U openai-whisper }
} else {
  Write-Host "Chưa có Python — bỏ qua MinerU/Whisper (cài: winget install -e --id Python.Python.3.12)"
}

if (Hoi "Cài Ollama (chạy model AI miễn phí trên máy)?") { winget install -e --id Ollama.Ollama }

if (Hoi "Cài VoiceStudio (nhân bản giọng, lồng tiếng — app desktop)?") { irm https://voicestudio.sh/install.ps1 | iex }

# Skill làm video quá nặng để để trong repo (ảnh mẫu, dự án Remotion) — cài thẳng vào ~/.claude/skills
if (Hoi "Cài 4 skill làm video (dashi-animationstyle, huashu-art-motion, video-shotcraft, anything2video)?") {
  foreach ($r in "chuspeeism/dashi-animationstyle","alchaincyf/huashu-art-motion","Vincentwei1021/video-shotcraft","solplum/anything2video") { npx -y skills add $r -g }
}

Write-Host ""
Write-Host "Xong. OpenRig không chạy trên Windows thường (cần WSL2)."
Write-Host "Không cần cài: vibe-kanban (chạy 'npx vibe-kanban' khi dùng)."
Write-Host "Token Apify/OpenRouter: đặt trong biến môi trường Windows, KHÔNG ghi vào repo."
