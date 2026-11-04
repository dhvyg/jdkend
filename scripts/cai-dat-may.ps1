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

if (Hoi "Cài agent-desktop (cho Claude điều khiển app trên máy qua accessibility)?") { npm i -g agent-desktop; agent-desktop status }

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

# baoyu-design: slide, canvas thiết kế, design system, dashboard mở bằng editor chạy trên máy (Node 20+)
if (Hoi "Cài baoyu-design (slide, thiết kế, design system, dashboard từ prompt)?") {
  npx -y skills add JimLiu/baoyu-design -g --agent claude-code --skill claude-slides --skill claude-design --skill claude-design-system --skill claude-dashboard
}

# cell_su7: biến ảnh sơ đồ PNG/JPG thành PPTX hoặc AI chỉnh sửa được (dịch vụ trả phí xiaomiao-ai.com; cần PowerPoint hoặc Illustrator)
if ((Co python) -and (Hoi "Cài cell_su7 (ảnh sơ đồ → PowerPoint/Illustrator chỉnh sửa được, trả phí theo lượt)?")) {
  if (-not (Test-Path "$HOME\cell_su7")) { git clone --depth 1 https://github.com/yrui-cmd/cell_su7.git "$HOME\cell_su7" }
  python -m pip install --requirement "$HOME\cell_su7\requirements.lock"; python "$HOME\cell_su7\install.py" --destination "$HOME\.claude\skills"
}

# Earshot (Leonxlnx/earshot): cho Claude "nghe" âm thanh/video, chạy CPU, tải ~1.1 GB model lần đầu; cần ffmpeg
if ((Co python) -and (Hoi "Cài Earshot (Claude nghe và chấm âm thanh/video, MCP server; tải ~1.1 GB model)?")) {
  $e = "$HOME\earshot"
  if (-not (Test-Path $e)) { git clone --depth 1 https://github.com/Leonxlnx/earshot.git $e }
  python -m venv "$e\.venv"; $py = "$e\.venv\Scripts\python.exe"
  & $py -m pip install torch --index-url https://download.pytorch.org/whl/cpu
  & $py -m pip install -e "$e[mcp]"; & $py -m earshot doctor --fetch
  if (Co claude) { claude mcp add earshot --scope user -e EARSHOT_THREADS=3 -- $py -m earshot mcp }
}

# Spec Kit (github/spec-kit): 9 lệnh /speckit.* làm phần mềm theo quy trình spec → plan → tasks → implement
if (Hoi "Cài Spec Kit vào repo này (cần uv)?") {
  if (-not (Co uv)) { winget install -e --id astral-sh.uv; $env:Path += ";$HOME\.local\bin" }
  uv tool install specify-cli; specify init --here --integration claude --script ps
}

# Nhà máy nội dung AI: công cụ Python chạy trên máy
if (Co python) {
  if (Hoi "Cài thư viện Python cho plugin PPT Master (xuất PPTX chỉnh sửa được)?") { python -m pip install -U -r https://raw.githubusercontent.com/hugohe3/ppt-master/HEAD/requirements.txt }
  if (Hoi "Cài Kokoro (đọc văn bản thành giọng nói, chạy offline)?") { python -m pip install -U kokoro soundfile }
  if (Hoi "Cài Podcastfy (biến bài viết/PDF/web thành podcast hội thoại; cần API key LLM)?") { python -m pip install -U podcastfy }
  if (Hoi "Cài Local Deep Research (nghiên cứu sâu nhiều nguồn, chạy với Ollama hoặc API key)?") { python -m pip install -U local-deep-research; Write-Host "Chạy: python -m local_deep_research.web.app rồi mở http://localhost:5000" }
}

# Công ty AI chạy riêng (framework/app), không phải plugin Claude Code
if ((Co python) -and (Hoi "Cài MetaGPT (công ty phần mềm AI: CEO, PM, kiến trúc sư, lập trình viên; cần Python 3.9–3.11)?")) {
  python -m pip install -U metagpt; metagpt --init-config
  Write-Host "Điền API key vào $HOME\.metagpt\config2.yaml rồi chạy: metagpt `"ý tưởng`""
}

if (Hoi "Tải ChatDev (công ty phần mềm ảo, cần uv + Node.js)?") {
  if (-not (Test-Path "$HOME\ChatDev")) { git clone --depth 1 https://github.com/OpenBMB/ChatDev.git "$HOME\ChatDev" }
  Write-Host "Xem $HOME\ChatDev\README.md: chạy 'uv sync', 'cd frontend; npm install', rồi 'make dev'."
}

if (Hoi "Tải Agent Teams AI (app desktop: agent tự nhận việc, nhắn tin, soát bài nhau)?") {
  Start-Process "https://github.com/777genius/agent-teams-ai/releases/latest/download/Agent.Teams.AI.Setup.exe"
}

Write-Host ""
Write-Host "Xong. OpenRig không chạy trên Windows thường (cần WSL2)."
Write-Host "Không cần cài: vibe-kanban (chạy 'npx vibe-kanban' khi dùng)."
Write-Host "Token Apify/OpenRouter: đặt trong biến môi trường Windows, KHÔNG ghi vào repo."
