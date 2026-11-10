# Cài các công cụ chạy trên máy (Windows 10/11) mà repo jdkend cần nhưng không cài qua repo được.
# Chạy trong PowerShell:  powershell -ExecutionPolicy Bypass -File scripts\cai-dat-may.ps1
# Mỗi mục đều hỏi có/không. Dùng winget (có sẵn trên Windows 10/11).

function Hoi($q) { (Read-Host "$q [y/N]") -match '^[Yy]$' }
function Co($c) { [bool](Get-Command $c -ErrorAction SilentlyContinue) }
# Lệnh do winget (uv...) và "uv tool install" cài vào hai thư mục này; thêm sẵn để dùng được ngay
$env:Path += ";$env:LOCALAPPDATA\Microsoft\WinGet\Links;$HOME\.local\bin"

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

# Bộ dịch ngược (REA): chỉ dùng trên phần mềm của mình hoặc được phép phân tích
if (Hoi "Cài bộ dịch ngược (REA, Ghidra, x64dbg, dnSpy, ILSpy, ImHex, radare2, Frida, mitmproxy)?") {
  npx -y rea-agents setup
  foreach ($id in "NSA.Ghidra","x64dbg.x64dbg","dnSpyEx.dnSpy","IcSharpCode.ILSpy","WerWolv.ImHex","RadareOrg.Radare2","mitmproxy.mitmproxy") { winget install -e --id $id; if ($LASTEXITCODE) { Write-Host "Không tìm thấy $id trên winget, tải ở trang dự án" } }
  if (Co python) { python -m pip install -U frida-tools angr }
  Write-Host "Ghidra cần JDK 21. GhidraMCP: https://github.com/LaurieWired/GhidraMCP/releases ; jadx/Apktool: https://github.com/skylot/jadx/releases"
}

# fscan & firerpa/lamda: công cụ tấn công/kiểm thử MẠNH — CHỈ dùng trên hệ thống của bạn hoặc được phép
if (Hoi "Cài fscan (quét lỗ hổng mạng nội bộ; CHỈ trên mạng của bạn)?") {
  if (Co go) { go install github.com/shadow1ng/fscan@latest } else { Write-Host "Cần Go (go.dev) hoặc tải bản sẵn: https://github.com/shadow1ng/fscan/releases" }
  Write-Host "CẢNH BÁO: quét/brute-force hệ thống người khác khi chưa được phép là phạm pháp. AV có thể chặn fscan."
}
if ((Co python) -and (Hoi "Cài firerpa/lamda (điều khiển & tự động hoá Android; CHỈ trên thiết bị của bạn)?")) {
  python -m pip install -U lamda
  Write-Host "Xem https://github.com/firerpa/lamda. CẢNH BÁO: dùng trên thiết bị người khác khi chưa được phép là phạm pháp."
}

# TradingAgents (TauricResearch, Apache-2.0): đội AI phân tích cổ phiếu; chỉ để nghiên cứu, không phải lời khuyên đầu tư
if ((Co python) -and (Hoi "Cài TradingAgents (đội AI phân tích chứng khoán, cần Python 3.11+ và API key LLM)?")) {
  $t = "$HOME\TradingAgents"
  if (-not (Test-Path $t)) { git clone --depth 1 https://github.com/TauricResearch/TradingAgents.git $t }
  python -m venv "$t\.venv"; & "$t\.venv\Scripts\python.exe" -m pip install $t
  Write-Host "Chạy: $t\.venv\Scripts\tradingagents.exe (đặt ANTHROPIC_API_KEY trong biến môi trường Windows)"
}

# swarm-cursors: tiện ích Chrome, đàn con trỏ dựng lại trang web (hiệu ứng để quay video); chưa có giấy phép
if (Hoi "Tải swarm-cursors (tiện ích Chrome: đàn con trỏ dựng lại trang web, để quay video)?") {
  if (-not (Test-Path "$HOME\swarm-cursors")) { git clone --depth 1 https://github.com/DhvanilPatel/swarm-cursors.git "$HOME\swarm-cursors" }
  Write-Host "Mở chrome://extensions, bật Developer mode, Load unpacked, chọn $HOME\swarm-cursors\swarm-rebuild. Dùng: Alt+Shift+S"
}

# SkillSpector (NVIDIA, Apache-2.0): quét skill AI tìm prompt injection, mã độc, lén gửi dữ liệu trước khi cài
if (Hoi "Cài SkillSpector (quét skill AI trước khi cài, cần uv + Python 3.12)?") {
  if (-not (Co uv)) { winget install -e --id astral-sh.uv; $env:Path += ";$HOME\.local\bin" }
  uv tool install git+https://github.com/NVIDIA/skillspector.git
  Write-Host "Quét skill trong repo: skillspector scan .claude\skills\<tên-skill>\"
}

# Agent Reach (Panniantong, MIT): agent đọc/tìm mạng xã hội, YouTube, web. Gói "agent-reach" trên PyPI KHÔNG phải dự án này
if (Hoi "Cài Agent Reach (agent đọc mạng xã hội, YouTube, web; cần uv)?") {
  if (-not (Co uv)) { winget install -e --id astral-sh.uv; $env:Path += ";$HOME\.local\bin" }
  uv tool install https://github.com/Panniantong/Agent-Reach/releases/latest/download/agent-reach.zip; agent-reach setup
  Write-Host "Thêm kênh: agent-reach add reddit | linkedin | xiaohongshu ..."
}

# FreeLLMAPI (tashfeenahmed, MIT): router gom gói miễn phí của 34 nhà cung cấp AI; chỉ dùng cá nhân
if (Hoi "Tải FreeLLMAPI (router AI miễn phí, app desktop .exe)?") {
  Start-Process "https://github.com/tashfeenahmed/freellmapi/releases/latest"
  Write-Host "Cài .exe, thêm key nhà cung cấp, lấy unified key. Nối Claude Code: npx freellmapi setup-claude --url http://localhost:3001 --api-key <key>"
}

# Laya (NandhaKishorM, Apache-2.0): phân loại email/lead/ticket/bình luận chạy trên máy; MCP server cho Claude; tải model lần đầu
if (Hoi "Cài Laya (AI phân loại nhanh trên máy, MCP server; cần uv, tải model lần đầu)?") {
  if (-not (Co uv)) { winget install -e --id astral-sh.uv }
  uv tool install "laya[mcp]"
  if (Co claude) { claude mcp add laya --scope user -e LAYA_DEVICE=cpu -- laya-mcp-server }
}

# OpenBot (nightly-labs): app desktop cho đội AI (Claude, Codex, Grok...); giấy phép PolyForm Noncommercial, chỉ dùng phi thương mại
if (Hoi "Mở trang tải OpenBot (app desktop cho đội AI, chỉ dùng phi thương mại)?") {
  Start-Process "https://github.com/nightly-labs/openbot/releases/latest"
  Write-Host "Tải file OpenBot-*-x64.exe rồi chạy."
}

# rea-video (JuneYaooo, Apache-2.0): lệnh rea-video cho plugin rea-video (mổ xẻ video từng cảnh, cách làm lại); cần ffmpeg
if (Hoi "Cài lệnh rea-video (mổ xẻ video, đi kèm plugin rea-video; cần uv + ffmpeg)?") {
  if (-not (Co uv)) { winget install -e --id astral-sh.uv }
  if (-not (Co ffmpeg)) { winget install -e --id Gyan.FFmpeg }
  uv tool install "rea-video @ git+https://github.com/JuneYaooo/rea-video"
}

# mg-styles-15 (Vincentwei1021, MIT): 15 phong cách motion design, mỗi kiểu có prompt + mã nguồn; bỏ phim mẫu nặng
if (Hoi "Tải mg-styles-15 (15 kiểu motion design: prompt + mã nguồn mẫu)?") {
  $m = "$HOME\mg-styles-15"
  if (-not (Test-Path $m)) { git clone --depth 1 --filter=blob:none --sparse https://github.com/Vincentwei1021/mg-styles-15.git $m; git -C $m sparse-checkout set prompts demos lib harness }
  Write-Host "Dùng: nhờ Claude đọc $m\prompts\<kiểu>.md rồi làm phim theo kiểu đó. Xem mẫu: https://vincentwei1021.github.io/mg-styles-15/"
}

# OpenMontage (OpenMontageInc, AGPL-3.0): hệ thống làm phim bằng agent; cần Python 3.10+, Node 22+, ffmpeg
if ((Co python) -and (Hoi "Cài OpenMontage (agent làm phim tài liệu/giải thích/quảng cáo; tải khá nặng)?")) {
  if (-not (Co ffmpeg)) { winget install -e --id Gyan.FFmpeg }
  $o = "$HOME\OpenMontage"
  if (-not (Test-Path $o)) { git clone --depth 1 https://github.com/OpenMontageInc/OpenMontage.git $o }
  Push-Location $o
  py -3 -m venv .venv; .\.venv\Scripts\python.exe -m pip install "pip>=26.2.2"; .\.venv\Scripts\python.exe -m pip install -r requirements.txt
  Push-Location remotion-composer; npm install; Pop-Location
  .\.venv\Scripts\python.exe -m pip install piper-tts; if (-not (Test-Path .env)) { Copy-Item .env.example .env }
  Pop-Location
  Write-Host "Dùng: cd $o; claude, rồi nói 'Làm video 60 giây giải thích ...'. API key điền vào $o\.env"
}

# T3 Code (pingdotgg/t3code, MIT): bảng điều khiển cho nhiều coding agent, điều khiển cả từ điện thoại
if (Hoi "Cài T3 Code (bảng điều khiển cho coding agent)?") {
  winget install -e --id T3Tools.T3Code; if ($LASTEXITCODE) { irm https://t3.codes/install.ps1 | iex }
  Write-Host "Chạy: t3 (mở web app trên máy)."
}

# PR-Agent (qodo-ai/pr-agent, MIT): AI review pull request, viết mô tả, gợi ý cải thiện; cần API key LLM
if ((Co python) -and (Hoi "Cài PR-Agent (AI review pull request; cần API key LLM)?")) {
  python -m pip install -U "pr-agent[github]"
  Write-Host "Dùng: đặt key trong biến môi trường rồi 'pr-agent --pr_url <link PR> review'. Xem docs.pr-agent.ai"
}

# Langfuse (langfuse/langfuse): giám sát/đánh giá ứng dụng AI, chạy trên máy; cần Docker
if (Hoi "Cài Langfuse (giám sát/đánh giá ứng dụng AI; cần Docker)?") {
  if (Co docker) {
    if (-not (Test-Path "$HOME\langfuse")) { git clone --depth=1 https://github.com/langfuse/langfuse.git "$HOME\langfuse" }
    Write-Host "Chạy: cd $HOME\langfuse; docker compose up -d, rồi mở http://localhost:3000"
  } else { Write-Host "Cần Docker: https://docs.docker.com/get-docker" }
}

# CADCraft (storytold/cadcraft, MIT/Apache-2.0): phần mềm vẽ kỹ thuật kiểu AutoCAD, viết bằng Rust; app desktop có bộ cài riêng
if (Hoi "Mở trang tải CADCraft (phần mềm vẽ kỹ thuật thay AutoCAD, mã nguồn mở)?") {
  Start-Process "https://github.com/storytold/cadcraft/releases/latest"
  Write-Host "Tải cadcraft-<ver>-windows-x64.msi rồi chạy. Đối chiếu checksum với SHA256SUMS.txt trong trang release."
}

# Mister Download Manager (anefzaoui, GPL-3.0): trình quản lý tải mã nguồn mở kiểu IDM, viết bằng Rust
if (Hoi "Mở trang tải Mister Download Manager (quản lý tải kiểu IDM, mã nguồn mở)?") {
  Start-Process "https://github.com/anefzaoui/misterdownloadmanager/releases/latest"
  Write-Host "Tải bản Windows rồi chạy. Có tiện ích cho Chrome/Edge/Brave và Firefox để bắt link tải."
}

# ACE-Step 1.5 (ace-step/ACE-Step-1.5, MIT): tạo nhạc có lời trên máy từ mô tả/lời bài; cần uv, GPU khuyến nghị
if (Hoi "Cài ACE-Step 1.5 (tạo nhạc có lời trên máy; cần uv, tải model lần đầu)?") {
  if (-not (Co uv)) { winget install -e --id astral-sh.uv; $env:Path += ";$env:LOCALAPPDATA\Microsoft\WinGet\Links" }
  $a = "$HOME\ACE-Step-1.5"
  if (-not (Test-Path $a)) { git clone https://github.com/ACE-Step/ACE-Step-1.5.git $a }
  Push-Location $a; uv sync; Pop-Location
  Write-Host "Chạy: cd $a; uv run acestep (mở giao diện web, model tự tải lần đầu). Card AMD/Intel xem hướng dẫn trong README."
}

# === Ứng dụng mã nguồn mở TỰ HOST (thay SaaS trả phí) — cần Docker Desktop ===
function SelfHost($name,$repo,$doc) {
  if (-not (Test-Path "$HOME\$name")) { git clone --depth 1 "https://github.com/$repo.git" "$HOME\$name" }
  Write-Host "Đã tải $HOME\$name. Cách chạy (Docker): $doc"
}
if (Hoi "Cài n8n (tự động hóa luồng việc; tự host; cần Docker)?") { SelfHost "n8n" "n8n-io/n8n" "https://docs.n8n.io/hosting/installation/docker/" }
if (Hoi "Cài Twenty CRM (thay Salesforce; cần Docker)?") { SelfHost "twenty" "twentyhq/twenty" "https://twenty.com/developers/section/self-hosting" }
if (Hoi "Cài Cal.com (đặt lịch thay Calendly; cần Docker)?") { SelfHost "cal.com" "calcom/cal.com" "docker compose up trong repo" }
if (Hoi "Cài PostHog (phân tích sản phẩm; cần Docker)?") { SelfHost "posthog" "PostHog/posthog" "https://posthog.com/docs/self-host" }
if (Hoi "Cài Documenso (ký hợp đồng thay DocuSign; cần Docker)?") { SelfHost "documenso" "documenso/documenso" "https://docs.documenso.com/developers/self-hosting" }
if (Hoi "Cài Formbricks (khảo sát thay Typeform; cần Docker)?") { SelfHost "formbricks" "formbricks/formbricks" "https://formbricks.com/docs/self-hosting/overview" }
if (Hoi "Cài Firecrawl (web thành Markdown, bản tự host; cần Docker)?") { SelfHost "firecrawl" "firecrawl/firecrawl" "https://docs.firecrawl.dev/contributing/self-host" }
if (Hoi "Cài Plane (quản lý task/sprint thay Jira/ClickUp; cần Docker)?") { SelfHost "plane" "makeplane/plane" "https://developers.plane.so/self-hosting/overview" }
if (Hoi "Cài Chatwoot (live-chat thay Intercom; cần Docker)?") { SelfHost "chatwoot" "chatwoot/chatwoot" "https://www.chatwoot.com/docs/self-hosted/deployment/docker" }
if (Hoi "Cài OpenProject (quản lý dự án thay Asana/Jira; cần Docker)?") { SelfHost "openproject" "opf/openproject" "https://www.openproject.org/docs/installation-and-operations/installation/docker/" }
if (Hoi "Cài GenOffice (bộ văn phòng AI; tự host)?") { SelfHost "genoffice" "genspark-ai/genoffice" "README repo" }
if (Hoi "Cài AstrBot (chatbot AI trong app nhắn tin; cần Docker)?") { SelfHost "astrbot" "AstrBotDevs/AstrBot" "https://astrbot.app" }
if (Hoi "Cài FalkorDB (graph DB cho GraphRAG; cần Docker)?") { SelfHost "falkordb" "FalkorDB/FalkorDB" "docker run -p 6379:6379 falkordb/falkordb" }
if (Hoi "Cài cognee (bộ nhớ dài hạn cho AI agent)?") { SelfHost "cognee" "topoteretes/cognee" "https://docs.cognee.ai" }
if (Hoi "Cài OpenSRE (AI trực hệ thống)?") { SelfHost "opensre" "Tracer-Cloud/opensre" "README repo" }
if (Hoi "Cài CowAgent (trợ lý AI chạy 24/7)?") { SelfHost "cowagent" "zhayujie/CowAgent" "README repo" }
if (Hoi "Cài Project NOMAD (tri thức offline: Wikipedia, AI cục bộ; cần Docker)?") { SelfHost "project-nomad" "Crosstalk-Solutions/project-nomad" "README repo" }
if (Hoi "Cài LibreChat (chat AI tự host thay ChatGPT; cần Docker)?") { SelfHost "librechat" "LibreChat-AI/LibreChat" "https://www.librechat.ai/docs/local/docker" }
if (Hoi "Cài Yuxi (AI agent + RAG nội bộ; cần Docker)?") { SelfHost "yuxi" "xerrors/Yuxi" "README repo" }
if (Hoi "Cài Hoppscotch (test API thay Postman; cần Docker)?") { SelfHost "hoppscotch" "hoppscotch/hoppscotch" "hoppscotch.io hoặc self-host docs" }
if (Hoi "Cài pgAdmin 4 (quản trị PostgreSQL; cần Docker)?") { SelfHost "pgadmin4" "pgadmin-org/pgadmin4" "docker run -p 5050:80 dpage/pgadmin4" }
if (Hoi "Cài AnythingLLM (chat tài liệu + AI agent cục bộ; Docker hoặc app desktop)?") { SelfHost "anything-llm" "Mintplex-Labs/anything-llm" "https://docs.anythingllm.com hoặc app desktop anythingllm.com" }
if (Hoi "Cài GOWA (REST API WhatsApp đa tài khoản; cần Docker)?") { SelfHost "gowa" "aldinokemal/go-whatsapp-web-multidevice" "README (docker compose). Tuân thủ điều khoản WhatsApp." }
if (Hoi "Cài OctoBot (bot giao dịch crypto; RỦI RO MẤT TIỀN)?") { SelfHost "OctoBot" "Drakkar-Software/OctoBot" "https://www.octobot.cloud/en/guides"; Write-Host "CẢNH BÁO: giao dịch crypto tự động có thể mất sạch tiền. Thử paper trading trước." }
if (Hoi "Mở trang tải AppFlowy (ghi chú thay Notion, app desktop)?") { Start-Process "https://github.com/AppFlowy-IO/AppFlowy/releases/latest" }
if ((Co node) -and (Hoi "Cài OpenCreator (dịch & lồng tiếng video bằng AI; trước là KrillinAI)?")) {
  if (-not (Test-Path "$HOME\OpenCreator")) { git clone --depth 1 https://github.com/krillinai/OpenCreator.git "$HOME\OpenCreator" }
  Write-Host "Xem $HOME\OpenCreator\README để chạy. Cần API key mô hình, đặt ngoài repo."
}
if ((Co node) -and (Hoi "Cài Open Generative AI (tạo ảnh/video AI, cần MuAPI key trả theo lượt)?")) {
  if (-not (Test-Path "$HOME\Open-Generative-AI")) { git clone --depth 1 https://github.com/Anil-matcha/Open-Generative-AI.git "$HOME\Open-Generative-AI" }
  Push-Location "$HOME\Open-Generative-AI"; npm install; Pop-Location
  Write-Host "Lấy API key ở muapi.ai, điền vào .env, rồi 'npm run dev'. Bạn tự chịu trách nhiệm nội dung tạo ra."
}
if (Hoi "Mở trang tải OpenCut (dựng video thay CapCut)?") { Start-Process "https://github.com/OpenCut-app/OpenCut/releases/latest" }
if (Hoi "Mở trang tải OpenMausBot (đội AI bot trong app chat, thay Grok Bot)?") { Start-Process "https://github.com/milind-soni/OpenMausBot/releases/latest" }
if (Hoi "Mở trang ArtCraft (bộ app đồ hoạ Rust: Craft Anything, PhotoCraft...; CADCraft đã có ở trên)?") { Start-Process "https://getartcraft.com/apps"; Write-Host "Chỉ tải từ getartcraft.com; trên GitHub có nhiều repo artcraft bên thứ ba." }
if (Hoi "Mở trang tải Cap (quay màn hình thay Loom)?") { Start-Process "https://github.com/CapSoftware/Cap/releases/latest" }
if (Hoi "Mở trang tải Dyad (dựng app bằng AI trên máy, thay Lovable)?") { Start-Process "https://github.com/dyad-sh/dyad/releases/latest" }
if (Hoi "Mở trang tải OpenWhispr (đọc thành chữ thay Wispr Flow)?") { Start-Process "https://github.com/OpenWhispr/openwhispr/releases/latest" }
if (Hoi "Mở trang Nanobrowser (tiện ích Chrome tự động duyệt web bằng AI)?") { Start-Process "https://github.com/nanobrowser/nanobrowser/releases/latest" }
if (Hoi "Mở trang tải dsh-pet (thú cưng trên màn hình)?") { Start-Process "https://github.com/PC2005-cloud/dsh-pet/releases/latest" }
if (Hoi "Mở trang tải Upscayl (phóng to ảnh bằng AI)?") { Start-Process "https://github.com/upscayl/upscayl/releases/latest" }
if (Hoi "Mở trang tải cc-haha (giao diện desktop cho Claude Code)?") { Start-Process "https://github.com/NanmiCoder/cc-haha/releases/latest" }
if (Hoi "Mở trang tải AIRI (AI companion chạy trên máy)?") { Start-Process "https://github.com/moeru-ai/airi/releases/latest" }
if (Hoi "Mở trang tải OpenBot của CopilotKit (khác OpenBot ở trên)?") { Start-Process "https://github.com/CopilotKit/OpenBot/releases/latest" }
if (Hoi "Mở trang tải Orkas (đội 16 AI agent chạy trên máy, local-first)?") { Start-Process "https://github.com/Orkas-AI/Orkas/releases/latest" }
if (Hoi "Mở trang tải DyberPet (thú cưng trên màn hình)?") { Start-Process "https://github.com/ChaozhongLiu/DyberPet/releases/latest" }
if ((Co python) -and (Hoi "Cài Fay (framework làm người ảo/trợ lý số)?")) {
  if (-not (Test-Path "$HOME\Fay")) { git clone --depth 1 https://github.com/xszyou/Fay.git "$HOME\Fay" }
  Write-Host "Xem $HOME\Fay\README để chạy. Cần API key/model, đặt ngoài repo."
}
Write-Host "FastAPI là thư viện: khi code API thì 'pip install fastapi uvicorn' trong dự án, không cần cài sẵn."

# MoneyPrinterTurbo (harry0703, MIT): gõ chủ đề ra video ngắn tự động; cần Python
if ((Co python) -and (Hoi "Cài MoneyPrinterTurbo (gõ chủ đề ra video ngắn; cần Python)?")) {
  if (-not (Test-Path "$HOME\MoneyPrinterTurbo")) { git clone --depth 1 https://github.com/harry0703/MoneyPrinterTurbo.git "$HOME\MoneyPrinterTurbo" }
  Write-Host "Xem $HOME\MoneyPrinterTurbo\README. Một số tính năng cần API key, đặt ngoài repo."
}
# Scrapling (D4Vinci, BSD-3): thư viện cào web Python
if ((Co python) -and (Hoi "Cài Scrapling (thư viện cào web Python)?")) {
  python -m pip install -U scrapling; python -m scrapling install
  Write-Host "Chỉ cào trang bạn được phép; tôn trọng robots.txt."
}

# Harness2 (google-research/harness2, Apache-2.0): framework agent tự cải thiện giàn đỡ. Chính thức chỉ hỗ trợ Linux + Python 3.12; trên Windows nên dùng WSL2.
if (Hoi "Tải Harness2 của Google (framework agent tự cải thiện; khuyến nghị chạy trong WSL2)?") {
  if (-not (Test-Path "$HOME\harness2")) { git clone --depth 1 https://github.com/google-research/harness2.git "$HOME\harness2" }
  Write-Host "Harness2 cần Linux + Python 3.12 + uv. Trên Windows: mở WSL2 rồi làm theo README trong $HOME\harness2."
}

# google-colab-cli (googlecolab, Apache-2.0): chạy máy Colab (GPU T4 miễn phí) từ dòng lệnh. Lệnh: colab
if ((Co python) -and (Hoi "Cài google-colab-cli (dùng GPU Colab miễn phí từ dòng lệnh; cần tài khoản Google)?")) {
  if (Co uv) { uv tool install google-colab-cli } else { python -m pip install -U google-colab-cli }
  Write-Host "Xác thực: chạy 'colab' theo hướng dẫn (đăng nhập Google Cloud ADC). GPU T4 miễn phí; A100/H100 trả phí."
}

# Agent Lightning (microsoft/agent-lightning, MIT): framework huấn luyện AI agent bằng RL. Nâng cao, cần GPU
if ((Co python) -and (Hoi "Cài Agent Lightning (huấn luyện agent bằng RL; nâng cao, cần GPU)?")) {
  python -m pip install -U agentlightning
  Write-Host "Xem https://microsoft.github.io/agent-lightning"
}

# Artemis (google/artemis, Apache-2.0): AI điều khiển điện thoại Android thật; MCP server. Cần uv + ADB; chỉ dùng trên điện thoại của bạn
if ((Co python) -and (Hoi "Cài Artemis của Google (AI điều khiển điện thoại Android thật; cần uv, bật USB debugging)?")) {
  if (-not (Co uv)) { winget install -e --id astral-sh.uv }
  if (-not (Test-Path "$HOME\artemis")) { git clone --depth 1 https://github.com/google/artemis.git "$HOME\artemis" }
  Push-Location "$HOME\artemis"; uv run artemis init; Pop-Location
  Write-Host "Nối Claude Code: cd $HOME\artemis; uv run artemis mcp --install all. Chỉ điều khiển điện thoại của bạn."
}

# === 5 repo "kiếm tiền với AI" ===
if (Hoi "Cài OpenHands (coding agent tự host; cần Docker)?") { SelfHost "openhands" "All-Hands-AI/OpenHands" "https://docs.all-hands.dev" }
if ((Co python) -and (Hoi "Cài screenshot-to-code (ảnh -> code; cần API key AI)?")) {
  if (-not (Test-Path "$HOME\screenshot-to-code")) { git clone --depth 1 https://github.com/abi/screenshot-to-code.git "$HOME\screenshot-to-code" }
  Write-Host "Xem $HOME\screenshot-to-code\README. Cần OPENAI/ANTHROPIC key."
}
if ((Co python) -and (Hoi "Cài CrewAI (nhiều AI agent làm việc nhóm)?")) { python -m pip install -U crewai; Write-Host "Xem https://docs.crewai.com" }
if ((Co python) -and (Hoi "Cài PPTAgent (tạo PowerPoint từ tài liệu)?")) {
  if (-not (Test-Path "$HOME\PPTAgent")) { git clone --depth 1 https://github.com/icip-cas/PPTAgent.git "$HOME\PPTAgent" }
  Write-Host "Xem $HOME\PPTAgent\README. Cần API key model."
}
if ((Co node) -and (Hoi "Cài Open AI UGC (video quảng cáo UGC; qua MuAPI trả phí)?")) {
  if (-not (Test-Path "$HOME\Open-AI-UGC")) { git clone --depth 1 https://github.com/Anil-matcha/Open-AI-UGC.git "$HOME\Open-AI-UGC" }
  Push-Location "$HOME\Open-AI-UGC"; npm install; Pop-Location
  Write-Host "Lấy key muapi.ai, điền .env. Tự chịu trách nhiệm nội dung và quyền hình ảnh."
}

# Unlimited-OCR 2 (baidu/Unlimited-OCR, MIT): model VLM 6.7B đọc tài liệu dài thành văn bản. CẦN GPU rất mạnh
if ((Co python) -and (Hoi "Tải Unlimited-OCR 2 của Baidu (OCR tài liệu dài; CẦN GPU rất mạnh)?")) {
  if (-not (Test-Path "$HOME\Unlimited-OCR")) { git clone --depth 1 https://github.com/baidu/Unlimited-OCR.git "$HOME\Unlimited-OCR" }
  Write-Host "Xem README. Không có GPU mạnh thì chạy trên Colab, hoặc webui: github.com/win4r/unlimited-ocr2-webui . Ít trang thì dùng MinerU nhẹ hơn."
}

Write-Host ""
Write-Host "Xong. OpenRig không chạy trên Windows thường (cần WSL2). Locals chỉ chạy trên Mac chip Apple."
Write-Host "Không cần cài: vibe-kanban (chạy 'npx vibe-kanban' khi dùng)."
Write-Host "Token Apify/OpenRouter: đặt trong biến môi trường Windows, KHÔNG ghi vào repo."
