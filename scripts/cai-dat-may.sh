#!/usr/bin/env bash
# Cài các công cụ chạy trên máy (macOS / Linux) mà repo jdkend cần nhưng không cài qua repo được.
# Chạy: bash scripts/cai-dat-may.sh   (hỏi có/không cho từng mục)
set -u

hoi() { read -r -p "$1 [y/N] " r; [[ "$r" =~ ^[Yy]$ ]]; }
co() { command -v "$1" >/dev/null 2>&1; }
OS=$(uname -s)
# uv, bun và các lệnh "uv tool install" cài vào đây; thêm sẵn để dùng được ngay trong lần chạy này
export PATH="$HOME/.local/bin:$HOME/.bun/bin:$PATH"

pkg() { # cài gói hệ thống: Homebrew trên Mac, apt trên Linux
  if [ "$OS" = Darwin ]; then
    co brew || { echo "Cần Homebrew: https://brew.sh"; return 1; }
    brew install "$@"
  else
    sudo apt-get update -qq && sudo apt-get install -y "$@"
  fi
}

echo "== Kiểm tra nền tảng =="
co node && echo "Node.js: $(node -v)" || { echo "Thiếu Node.js (cần 22+): https://nodejs.org"; exit 1; }
co git || { echo "Thiếu git"; exit 1; }
co python3 && echo "Python: $(python3 --version)" || echo "Thiếu Python 3 — bỏ qua MinerU/Whisper"

if ! co ffmpeg && hoi "Cài ffmpeg (cho plugin ffmpeg-skill, cắt ghép video)?"; then pkg ffmpeg; fi

if hoi "Cài gstack (bộ 23 công cụ của Garry Tan, cần Bun)?"; then
  co bun || { curl -fsSL https://bun.sh/install | bash; export PATH="$HOME/.bun/bin:$PATH"; }
  [ -d ~/.claude/skills/gstack ] || git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
  (cd ~/.claude/skills/gstack && ./setup)
fi

hoi "Cài codegraph (bản đồ code, ít token hơn)?" && npm i -g @colbymchenry/codegraph

if hoi "Cài agent-desktop (cho Claude điều khiển app trên máy qua accessibility)?"; then
  npm i -g agent-desktop && agent-desktop status
  [ "$OS" = Darwin ] && echo "Mac cần cấp quyền Accessibility: agent-desktop permissions --guide"
fi

hoi "Cài claude-code-router (chuyển Claude Code sang model khác)?" && npm i -g @musistudio/claude-code-router

if hoi "Cài OpenRig (đội nhiều AI lập trình, cần tmux)?"; then
  co tmux || pkg tmux
  npm i -g @openrig/cli && echo "Chạy 'rig setup' để thiết lập."
fi

if co python3 && hoi "Cài MinerU (đọc PDF/scan/Word, tải khá nặng)?"; then
  python3 -m pip install -U "mineru[all]"
fi

if co python3 && hoi "Cài Whisper (chuyển giọng nói thành chữ)?"; then
  python3 -m pip install -U openai-whisper
fi

if hoi "Cài Ollama (chạy model AI miễn phí trên máy)?"; then
  if [ "$OS" = Darwin ]; then echo "Tải bản Mac tại https://ollama.com/download"; else curl -fsSL https://ollama.com/install.sh | sh; fi
fi

hoi "Cài VoiceStudio (nhân bản giọng, lồng tiếng — app desktop)?" && curl -fsSL https://voicestudio.sh/install | sh

# Skill làm video quá nặng để để trong repo (ảnh mẫu, dự án Remotion) — cài thẳng vào ~/.claude/skills
if hoi "Cài 4 skill làm video (dashi-animationstyle, huashu-art-motion, video-shotcraft, anything2video)?"; then
  for r in chuspeeism/dashi-animationstyle alchaincyf/huashu-art-motion Vincentwei1021/video-shotcraft solplum/anything2video; do
    npx -y skills add "$r" -g
  done
fi

# baoyu-design: slide, canvas thiết kế, design system, dashboard mở bằng editor chạy trên máy (Node 20+)
if hoi "Cài baoyu-design (slide, thiết kế, design system, dashboard từ prompt)?"; then
  npx -y skills add JimLiu/baoyu-design -g --agent claude-code --skill claude-slides --skill claude-design --skill claude-design-system --skill claude-dashboard
fi

# cell_su7: biến ảnh sơ đồ PNG/JPG thành PPTX hoặc AI chỉnh sửa được (dịch vụ trả phí xiaomiao-ai.com; cần PowerPoint hoặc Illustrator)
if co python3 && hoi "Cài cell_su7 (ảnh sơ đồ → PowerPoint/Illustrator chỉnh sửa được, trả phí theo lượt)?"; then
  [ -d ~/cell_su7 ] || git clone --depth 1 https://github.com/yrui-cmd/cell_su7.git ~/cell_su7
  python3 -m pip install --requirement ~/cell_su7/requirements.lock && python3 ~/cell_su7/install.py --destination ~/.claude/skills
fi

# Earshot (Leonxlnx/earshot): cho Claude "nghe" âm thanh/video, chạy CPU, tải ~1.1 GB model lần đầu; cần ffmpeg
if co python3 && hoi "Cài Earshot (Claude nghe và chấm âm thanh/video, MCP server; tải ~1.1 GB model)?"; then
  [ -d ~/earshot ] || git clone --depth 1 https://github.com/Leonxlnx/earshot.git ~/earshot
  (cd ~/earshot && python3 -m venv .venv && .venv/bin/python -m pip install torch --index-url https://download.pytorch.org/whl/cpu \
    && .venv/bin/python -m pip install -e ".[mcp]" && .venv/bin/python -m earshot doctor --fetch) \
    && co claude && claude mcp add earshot --scope user -e EARSHOT_THREADS=3 -- "$HOME/earshot/.venv/bin/python" -m earshot mcp
fi

# Spec Kit (github/spec-kit): 9 lệnh /speckit.* làm phần mềm theo quy trình spec → plan → tasks → implement
if hoi "Cài Spec Kit vào repo này (cần uv)?"; then
  co uv || curl -LsSf https://astral.sh/uv/install.sh | sh
  uv tool install specify-cli && specify init --here --integration claude --script sh
fi

# Nhà máy nội dung AI: công cụ Python chạy trên máy
if co python3; then
  hoi "Cài thư viện Python cho plugin PPT Master (xuất PPTX chỉnh sửa được)?" && python3 -m pip install -U -r https://raw.githubusercontent.com/hugohe3/ppt-master/HEAD/requirements.txt
  hoi "Cài Kokoro (đọc văn bản thành giọng nói, chạy offline)?" && python3 -m pip install -U kokoro soundfile
  hoi "Cài Podcastfy (biến bài viết/PDF/web thành podcast hội thoại; cần API key LLM)?" && python3 -m pip install -U podcastfy
  hoi "Cài Local Deep Research (nghiên cứu sâu nhiều nguồn, chạy với Ollama hoặc API key)?" && python3 -m pip install -U local-deep-research && echo "Chạy: python3 -m local_deep_research.web.app rồi mở http://localhost:5000"
fi

# Công ty AI chạy riêng (framework/app), không phải plugin Claude Code
if co python3 && hoi "Cài MetaGPT (công ty phần mềm AI: CEO, PM, kiến trúc sư, lập trình viên; cần Python 3.9–3.11)?"; then
  python3 -m pip install -U metagpt && metagpt --init-config && echo "Điền API key vào ~/.metagpt/config2.yaml rồi chạy: metagpt \"ý tưởng\""
fi

if hoi "Tải ChatDev (công ty phần mềm ảo, cần uv + Node.js)?"; then
  [ -d ~/ChatDev ] || git clone --depth 1 https://github.com/OpenBMB/ChatDev.git ~/ChatDev
  echo "Xem ~/ChatDev/README.md: chạy 'uv sync', 'cd frontend && npm install', rồi 'make dev'."
fi

if hoi "Mở trang tải Agent Teams AI (app desktop: agent tự nhận việc, nhắn tin, soát bài nhau)?"; then
  u=https://github.com/777genius/agent-teams-ai/releases/latest
  if [ "$OS" = Darwin ]; then open "$u"; else xdg-open "$u" 2>/dev/null || echo "$u"; fi
fi

# Bộ dịch ngược (REA): chỉ dùng trên phần mềm của mình hoặc được phép phân tích
if hoi "Cài bộ dịch ngược (REA, radare2, Frida, mitmproxy, angr, jadx, apktool)?"; then
  npx -y rea-agents setup
  for p in radare2 apktool jadx; do pkg "$p" || echo "Không cài được $p qua trình quản lý gói, tải ở trang dự án"; done
  co python3 && python3 -m pip install -U frida-tools mitmproxy angr
  echo "Tải thêm khi cần: Ghidra https://ghidra-sre.org (cần JDK 21) + GhidraMCP https://github.com/LaurieWired/GhidraMCP/releases,"
  echo "ImHex https://imhex.werwolv.net, Rizin https://rizin.re, ILSpy (avaloniaui) https://github.com/icsharpcode/AvaloniaILSpy/releases"
fi

# fscan (shadow1ng) & firerpa/lamda: công cụ tấn công/kiểm thử MẠNH — CHỈ dùng trên hệ thống của mình hoặc được phép bằng văn bản
if hoi "Cài fscan (quét lỗ hổng mạng nội bộ; CHỈ trên mạng của bạn, phạm pháp nếu quét trái phép)?"; then
  if co go; then go install github.com/shadow1ng/fscan@latest && echo "fscan cài ở ~/go/bin. Chỉ quét mạng bạn sở hữu/được phép."; else echo "Cần Go: https://go.dev/dl — hoặc tải bản biên dịch sẵn ở https://github.com/shadow1ng/fscan/releases"; fi
  echo "CẢNH BÁO: quét/brute-force hệ thống người khác khi chưa được phép là phạm pháp. Phần mềm diệt virus có thể chặn fscan."
fi
if co python3 && hoi "Cài firerpa/lamda (điều khiển & tự động hoá Android: MITM, Frida...; CHỈ trên thiết bị của bạn)?"; then
  python3 -m pip install -U lamda && echo "Xem https://github.com/firerpa/lamda. Chỉ dùng trên thiết bị bạn sở hữu/được phép kiểm thử."
  echo "CẢNH BÁO: cài lên điện thoại người khác hay chặn bắt dữ liệu của họ khi chưa được phép là phạm pháp."
fi

# TradingAgents (TauricResearch, Apache-2.0): đội AI phân tích cổ phiếu (phân tích, tranh luận, quản trị rủi ro); chỉ để nghiên cứu, không phải lời khuyên đầu tư
if co python3 && hoi "Cài TradingAgents (đội AI phân tích chứng khoán, cần Python 3.11+ và API key LLM)?"; then
  [ -d ~/TradingAgents ] || git clone --depth 1 https://github.com/TauricResearch/TradingAgents.git ~/TradingAgents
  (cd ~/TradingAgents && python3 -m venv .venv && .venv/bin/pip install .) \
    && echo "Chạy: ~/TradingAgents/.venv/bin/tradingagents (đặt ANTHROPIC_API_KEY hoặc key khác trong ~/.zshrc, KHÔNG ghi vào repo)"
fi

# swarm-cursors (DhvanilPatel): tiện ích Chrome cho đàn con trỏ "dựng lại" trang web như video timelapse; chỉ là hiệu ứng, chưa có giấy phép nên không chép vào repo
if hoi "Tải swarm-cursors (tiện ích Chrome: đàn con trỏ dựng lại trang web, để quay video)?"; then
  [ -d ~/swarm-cursors ] || git clone --depth 1 https://github.com/DhvanilPatel/swarm-cursors.git ~/swarm-cursors
  echo "Mở chrome://extensions → bật Developer mode → Load unpacked → chọn ~/swarm-cursors/swarm-rebuild. Dùng: Alt+Shift+S"
fi

# SkillSpector (NVIDIA, Apache-2.0): quét skill AI tìm prompt injection, mã độc, lén gửi dữ liệu trước khi cài
if hoi "Cài SkillSpector (quét skill AI trước khi cài, cần uv + Python 3.12)?"; then
  co uv || curl -LsSf https://astral.sh/uv/install.sh | sh
  uv tool install git+https://github.com/NVIDIA/skillspector.git \
    && echo "Quét skill trong repo: skillspector scan .claude/skills/<tên-skill>/"
fi

# Agent Reach (Panniantong, MIT): cho agent đọc/tìm Twitter, Reddit, YouTube, GitHub, LinkedIn, Xiaohongshu... một CLI, không tốn phí API
# Lưu ý: gói "agent-reach" trên PyPI KHÔNG phải dự án này, chỉ cài từ link GitHub
if hoi "Cài Agent Reach (agent đọc mạng xã hội, YouTube, web; cần uv)?"; then
  co uv || curl -LsSf https://astral.sh/uv/install.sh | sh
  uv tool install https://github.com/Panniantong/Agent-Reach/releases/latest/download/agent-reach.zip && agent-reach setup
  echo "Thêm kênh: agent-reach add reddit | linkedin | xiaohongshu ..."
fi

# FreeLLMAPI (tashfeenahmed, MIT): gom gói miễn phí của 34 nhà cung cấp AI vào 1 endpoint, tự chuyển model khi hết lượt; chỉ dùng cá nhân
if hoi "Cài FreeLLMAPI (router AI miễn phí, cần Docker)?"; then
  if co docker; then curl -fsSL https://freellmapi.co/install.sh | bash
    echo "Mở http://localhost:3001 → thêm key từng nhà cung cấp → lấy unified key. Nối Claude Code: npx freellmapi setup-claude --url http://localhost:3001 --api-key <key>"
  else echo "Cần Docker. Bản Mac (.dmg): https://github.com/tashfeenahmed/freellmapi/releases/latest"; fi
fi

# Laya (NandhaKishorM, Apache-2.0): phân loại email/lead/ticket/bình luận chạy trên máy, 100+ ngôn ngữ; MCP server cho Claude; tải model ~0.8B lần đầu
if hoi "Cài Laya (AI phân loại nhanh trên máy, MCP server; cần uv, tải model lần đầu)?"; then
  co uv || curl -LsSf https://astral.sh/uv/install.sh | sh
  uv tool install "laya[mcp]" && co claude && claude mcp add laya --scope user -e LAYA_DEVICE=cpu -- laya-mcp-server
fi

# OpenBot (nightly-labs): app desktop giữ cả đội AI (Claude, Codex, Grok...) với không gian làm việc, hàng đợi việc, trình duyệt riêng
# Giấy phép PolyForm Noncommercial: chỉ dùng phi thương mại
if hoi "Mở trang tải OpenBot (app desktop cho đội AI, chỉ dùng phi thương mại)?"; then
  u=https://github.com/nightly-labs/openbot/releases/latest
  if [ "$OS" = Darwin ]; then open "$u"; else xdg-open "$u" 2>/dev/null || echo "$u"; fi
  echo "Mac: tải file .dmg. Linux: tải .AppImage, chạy chmod +x rồi mở (Ubuntu 23.10+ cần cài profile AppArmor, xem README)."
fi

# Locals (Generated-Computers, Apache-2.0): server AI chạy trên máy cho nhiều agent cùng lúc (Claude Code, OpenCode, Cline...), không gửi gì lên mây; chỉ Mac chip Apple
if [ "$OS" = Darwin ] && [ "$(uname -m)" = arm64 ] && hoi "Cài Locals (chạy nhiều AI agent bằng model trên máy, chỉ Mac chip Apple; cần uv)?"; then
  co uv || curl -LsSf https://astral.sh/uv/install.sh | sh
  uv tool install --python 3.12 locals && echo "Dùng: locals code ~/thu-muc-du-an (tải model lần đầu)"
fi

# rea-video (JuneYaooo, Apache-2.0): lệnh rea-video cho plugin rea-video (mổ xẻ video từng cảnh: quay thật/AI/3D/code, cách làm lại); cần ffmpeg
# shortcut: bỏ extra [ocr] vì nó kéo opencv-python đè opencv-headless; cần OCR chữ trên hình thì chạy scripts/install_skill.sh của repo
if hoi "Cài lệnh rea-video (mổ xẻ video, đi kèm plugin rea-video; cần uv + ffmpeg)?"; then
  co uv || curl -LsSf https://astral.sh/uv/install.sh | sh
  co ffmpeg || pkg ffmpeg
  uv tool install "rea-video @ git+https://github.com/JuneYaooo/rea-video" && rea-video --help >/dev/null && echo "rea-video đã sẵn sàng"
fi

# mg-styles-15 (Vincentwei1021, MIT): 15 phong cách motion design, mỗi kiểu có prompt + mã nguồn để Claude làm phim bằng code
# Bỏ thư mục videos/ và assets/ (phim mẫu nặng); xem phim mẫu tại https://vincentwei1021.github.io/mg-styles-15/
if hoi "Tải mg-styles-15 (15 kiểu motion design: prompt + mã nguồn mẫu)?"; then
  if [ ! -d ~/mg-styles-15 ]; then
    git clone --depth 1 --filter=blob:none --sparse https://github.com/Vincentwei1021/mg-styles-15.git ~/mg-styles-15 \
      && git -C ~/mg-styles-15 sparse-checkout set prompts demos lib harness
  fi
  echo "Dùng: nhờ Claude 'đọc ~/mg-styles-15/prompts/10-synthwave.md rồi làm phim 10 giây về <chủ đề> theo kiểu này'"
fi

# OpenMontage (OpenMontageInc, AGPL-3.0): hệ thống làm phim bằng agent (tư liệu thật, giải thích, quảng cáo); cần Python 3.10+, Node 22+, ffmpeg
if hoi "Cài OpenMontage (agent làm phim tài liệu/giải thích/quảng cáo; tải khá nặng)?"; then
  co ffmpeg || pkg ffmpeg
  [ -d ~/OpenMontage ] || git clone --depth 1 https://github.com/OpenMontageInc/OpenMontage.git ~/OpenMontage
  (cd ~/OpenMontage && make setup) && echo "Dùng: cd ~/OpenMontage && claude, rồi nói 'Làm video 60 giây giải thích ...'. Điền API key vào ~/OpenMontage/.env (KHÔNG ghi vào repo jdkend)"
fi

# T3 Code (pingdotgg/t3code, MIT): bảng điều khiển cho nhiều coding agent (Claude Code, Codex, Cursor...), điều khiển cả từ điện thoại
if hoi "Cài T3 Code (bảng điều khiển cho coding agent)?"; then
  curl -fsSL https://t3.codes/install.sh | sh && echo "Chạy: t3 (mở web app trên máy). t3 service install để chạy nền."
fi

# PR-Agent (qodo-ai/pr-agent, MIT): agent tự review pull request, viết mô tả, gợi ý cải thiện (/review /describe /improve); chạy CLI hoặc GitHub Action
if co python3 && hoi "Cài PR-Agent (AI review pull request; cần API key LLM)?"; then
  python3 -m pip install -U "pr-agent[github]" \
    && echo "Dùng: đặt key trong biến môi trường rồi 'pr-agent --pr_url <link PR> review'. Hoặc chạy bằng GitHub Action, xem docs.pr-agent.ai"
fi

# Langfuse (langfuse/langfuse, self-host): nền tảng theo dõi và chấm điểm ứng dụng LLM/agent; cần Docker
if hoi "Cài Langfuse (giám sát/đánh giá ứng dụng AI, chạy trên máy; cần Docker)?"; then
  if co docker; then
    [ -d ~/langfuse ] || git clone --depth=1 https://github.com/langfuse/langfuse.git ~/langfuse
    echo "Chạy: cd ~/langfuse && docker compose up -d, rồi mở http://localhost:3000"
  else echo "Cần Docker: https://docs.docker.com/get-docker"; fi
fi

# CADCraft (storytold/cadcraft, MIT/Apache-2.0): phần mềm vẽ kỹ thuật kiểu AutoCAD, viết bằng Rust, nhẹ và nhanh; app desktop có bộ cài riêng
if hoi "Mở trang tải CADCraft (phần mềm vẽ kỹ thuật thay AutoCAD, mã nguồn mở)?"; then
  u=https://github.com/storytold/cadcraft/releases/latest
  if [ "$OS" = Darwin ]; then open "$u"; else xdg-open "$u" 2>/dev/null || echo "$u"; fi
  echo "Mac: tải .dmg. Linux: tải bản cho Linux. Nhớ đối chiếu checksum với SHA256SUMS.txt trong trang release."
fi

# Mister Download Manager (anefzaoui, GPL-3.0): trình quản lý tải mã nguồn mở kiểu IDM, viết bằng Rust; app desktop + tiện ích trình duyệt
if hoi "Mở trang tải Mister Download Manager (quản lý tải kiểu IDM, mã nguồn mở)?"; then
  u=https://github.com/anefzaoui/misterdownloadmanager/releases/latest
  if [ "$OS" = Darwin ]; then open "$u"; else xdg-open "$u" 2>/dev/null || echo "$u"; fi
  echo "Có tiện ích cho Firefox/Chrome để bắt link tải. Mac: tải bản macOS. Linux: tải bản Linux."
fi

# ACE-Step 1.5 (ace-step/ACE-Step-1.5, MIT): tạo nhạc có lời trên máy từ mô tả/lời bài, 50+ ngôn ngữ; cần uv, GPU khuyến nghị (bản 2B chạy <4GB VRAM)
if hoi "Cài ACE-Step 1.5 (tạo nhạc có lời trên máy; cần uv, tải model lần đầu)?"; then
  co uv || curl -LsSf https://astral.sh/uv/install.sh | sh
  [ -d ~/ACE-Step-1.5 ] || git clone https://github.com/ACE-Step/ACE-Step-1.5.git ~/ACE-Step-1.5
  (cd ~/ACE-Step-1.5 && uv sync) && echo "Chạy: cd ~/ACE-Step-1.5 && uv run acestep (mở giao diện web, model tự tải lần đầu)"
fi

# === Ứng dụng mã nguồn mở TỰ HOST (thay SaaS trả phí) — hầu hết cần Docker, chạy trên máy/VPS; làm chủ 100% dữ liệu ===
# Mỗi app chỉ clone repo về; cách chạy (thường là docker compose) xem trang self-host của từng dự án, vì mỗi dự án đặt file compose khác nhau.
selfhost() { # $1=tên thư mục  $2=repo  $3=link hướng dẫn self-host
  [ -d ~/"$1" ] || git clone --depth 1 "https://github.com/$2.git" ~/"$1"
  echo "Đã tải ~/$1. Cách chạy (Docker): $3"
}
if hoi "Cài n8n (tự động hóa luồng việc qua 1500+ app; tự host miễn phí; cần Docker)?"; then selfhost n8n n8n-io/n8n "https://docs.n8n.io/hosting/installation/docker/"; fi
if hoi "Cài Twenty CRM (quản lý khách hàng thay Salesforce; cần Docker)?"; then selfhost twenty twentyhq/twenty "https://twenty.com/developers/section/self-hosting"; fi
if hoi "Cài Cal.com (đặt lịch hẹn thay Calendly; cần Docker)?"; then selfhost cal.com calcom/cal.com "https://github.com/calcom/cal.com (docker compose up trong repo)"; fi
if hoi "Cài PostHog (phân tích sản phẩm, ghi hình thao tác thay Mixpanel/Amplitude; cần Docker)?"; then selfhost posthog PostHog/posthog "https://posthog.com/docs/self-host"; fi
if hoi "Cài Documenso (ký hợp đồng điện tử thay DocuSign; cần Docker)?"; then selfhost documenso documenso/documenso "https://docs.documenso.com/developers/self-hosting"; fi
if hoi "Cài Formbricks (khảo sát khách hàng thay Typeform; cần Docker)?"; then selfhost formbricks formbricks/formbricks "https://formbricks.com/docs/self-hosting/overview"; fi
if hoi "Cài Firecrawl (biến web thành Markdown cho AI; đã có sẵn dạng connector, đây là bản tự host; cần Docker)?"; then selfhost firecrawl firecrawl/firecrawl "https://docs.firecrawl.dev/contributing/self-host"; fi
if hoi "Cài Plane (quản lý task/sprint thay Jira, ClickUp; cần Docker)?"; then selfhost plane makeplane/plane "https://developers.plane.so/self-hosting/overview"; fi
if hoi "Cài Chatwoot (live-chat, hỗ trợ khách thay Intercom; cần Docker)?"; then selfhost chatwoot chatwoot/chatwoot "https://www.chatwoot.com/docs/self-hosted/deployment/docker"; fi
if hoi "Cài OpenProject (quản lý dự án thay Asana/Jira; cần Docker)?"; then selfhost openproject opf/openproject "https://www.openproject.org/docs/installation-and-operations/installation/docker/"; fi
if hoi "Cài GenOffice (bộ văn phòng AI: Docs/Sheets/Slides/PDF; tự host)?"; then selfhost genoffice genspark-ai/genoffice "README của repo (xem phần self-host/Docker)"; fi
if hoi "Cài AstrBot (chatbot AI cắm vào app nhắn tin; tự host, cần Docker)?"; then selfhost astrbot AstrBotDevs/AstrBot "https://astrbot.app"; fi
if hoi "Cài FalkorDB (graph database cho GraphRAG/trí nhớ agent; cần Docker)?"; then selfhost falkordb FalkorDB/FalkorDB "docker run -p 6379:6379 falkordb/falkordb — xem README"; fi
if hoi "Cài cognee (bộ nhớ dài hạn cho AI agent; Python/Docker)?"; then selfhost cognee topoteretes/cognee "https://docs.cognee.ai (pip install cognee hoặc docker)"; fi
if hoi "Cài OpenSRE (đội AI trực hệ thống/SRE; tự host)?"; then selfhost opensre Tracer-Cloud/opensre "README của repo"; fi
if hoi "Cài CowAgent (trợ lý AI tự tiến hoá, chạy 24/7; tự host)?"; then selfhost cowagent zhayujie/CowAgent "README của repo"; fi
if hoi "Cài Project NOMAD (máy chủ tri thức offline: Wikipedia, sách, AI cục bộ; cần Docker)?"; then selfhost project-nomad Crosstalk-Solutions/project-nomad "README của repo"; fi
if hoi "Cài LibreChat (giao diện chat AI tự host thay ChatGPT, nhiều model; cần Docker)?"; then selfhost librechat LibreChat-AI/LibreChat "https://www.librechat.ai/docs/local/docker"; fi
if hoi "Cài Yuxi (nền tảng AI agent + RAG tri thức nội bộ, tự host; cần Docker)?"; then selfhost yuxi xerrors/Yuxi "README của repo"; fi
if hoi "Cài Hoppscotch (test API thay Postman; tự host, cần Docker)?"; then selfhost hoppscotch hoppscotch/hoppscotch "https://docs.hoppscotch.io/documentation/self-host/getting-started — hoặc dùng bản web hoppscotch.io / app desktop"; fi
if hoi "Cài pgAdmin 4 (quản trị PostgreSQL; cần Docker)?"; then selfhost pgadmin4 pgadmin-org/pgadmin4 "docker run -p 5050:80 dpage/pgadmin4"; fi
if hoi "Cài AnythingLLM (chat tài liệu + AI agent cục bộ, riêng tư; cần Docker hoặc bản desktop)?"; then selfhost anything-llm Mintplex-Labs/anything-llm "https://docs.anythingllm.com — hoặc tải app desktop ở anythingllm.com"; fi
if hoi "Cài GOWA (REST API cho WhatsApp đa tài khoản, có webhook/MCP/Chatwoot; cần Docker)?"; then selfhost gowa aldinokemal/go-whatsapp-web-multidevice "README của repo (docker compose). Tuân thủ điều khoản WhatsApp, chỉ nhắn người đã đồng ý."; fi
# Coolify (coollabsio/coolify, Apache-2.0): tự dựng "Vercel/Heroku của riêng mình" trên VPS — bấm nút là deploy app/web/database, HTTPS tự động. DÀNH CHO VPS/máy chủ, KHÔNG phải laptop cá nhân
if hoi "Xem hướng dẫn cài Coolify (tự dựng Vercel trên VPS của bạn)?"; then
  echo "Coolify cài trên 1 VPS (Ubuntu/Debian) bằng 1 lệnh (chạy TRÊN VPS, không phải máy này):"
  echo "    curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash"
  echo "Hướng dẫn đầy đủ: https://coolify.io/docs/get-started/installation . Cần VPS (DigitalOcean/Hetzner/Vultr...) ~4-6 USD/tháng. Laptop thường không hợp (phải bật 24/7, có IP tĩnh)."
fi
# OctoBot: bot giao dịch crypto — RỦI RO TÀI CHÍNH
if hoi "Cài OctoBot (bot giao dịch crypto tự động; RỦI RO MẤT TIỀN, cân nhắc kỹ)?"; then
  selfhost OctoBot Drakkar-Software/OctoBot "https://www.octobot.cloud/en/guides"
  echo "CẢNH BÁO: giao dịch crypto tự động có thể mất sạch tiền. Chỉ dùng tiền bạn chấp nhận mất, thử chế độ giả lập (paper trading) trước. Không phải lời khuyên đầu tư."
fi
# AppFlowy: ghi chú + quản lý dự án thay Notion, có app desktop sẵn
if hoi "Mở trang tải AppFlowy (ghi chú/quản lý dự án thay Notion, app desktop)?"; then
  u=https://github.com/AppFlowy-IO/AppFlowy/releases/latest
  if [ "$OS" = Darwin ]; then open "$u"; else xdg-open "$u" 2>/dev/null || echo "$u"; fi
fi
# Open Generative AI (Anil-matcha, web UI tạo ảnh/video qua 600+ model; chạy qua dịch vụ MuAPI, cần API key trả theo lượt)
if co node && hoi "Cài Open Generative AI (giao diện tạo ảnh/video AI, cần MuAPI key trả theo lượt)?"; then
  [ -d ~/Open-Generative-AI ] || git clone --depth 1 https://github.com/Anil-matcha/Open-Generative-AI.git ~/Open-Generative-AI
  (cd ~/Open-Generative-AI && npm install) && echo "Lấy API key ở muapi.ai, điền vào ~/Open-Generative-AI/.env, rồi 'npm run dev'. Bạn tự chịu trách nhiệm nội dung tạo ra."
fi

# OpenCreator / KrillinAI: dịch video, lồng tiếng, tạo giọng đọc — chạy trên máy, cần Codex/API key
if co node && hoi "Cài OpenCreator (dịch & lồng tiếng video bằng AI; trước là KrillinAI)?"; then
  [ -d ~/OpenCreator ] || git clone --depth 1 https://github.com/krillinai/OpenCreator.git ~/OpenCreator
  echo "Xem ~/OpenCreator/README để chạy. Cần API key mô hình; đặt ngoài repo jdkend."
fi
# xerj: tìm/đánh chỉ mục code cho AI, tiết kiệm token (giống codegraph đã có)
if co cargo && hoi "Cài xerj (lập chỉ mục code cho AI, ít token hơn; cần Rust)?"; then
  cargo install --git https://github.com/xerj-org/xerj || echo "Xem README của xerj-org/xerj để cài."
fi

# App desktop tải thẳng (mở trang Releases)
open_rel() { u="https://github.com/$1/releases/latest"; if [ "$OS" = Darwin ]; then open "$u"; else xdg-open "$u" 2>/dev/null || echo "$u"; fi; echo "Tải $2: $u"; }
hoi "Mở trang tải OpenCut (dựng video thay CapCut; web/desktop)?" && open_rel OpenCut-app/OpenCut "OpenCut"
# ArtCraft (escbase, getartcraft.com): bộ app đồ hoạ viết bằng Rust — Craft Anything, PhotoCraft, FilmCraft, DesignCraft, CADCraft... Tải ở trang chính thức.
if hoi "Mở trang ArtCraft (bộ app đồ hoạ Rust: Craft Anything, PhotoCraft...; CADCraft đã có ở trên)?"; then
  u=https://getartcraft.com/apps
  if [ "$OS" = Darwin ]; then open "$u"; else xdg-open "$u" 2>/dev/null || echo "$u"; fi
  echo "Chỉ tải từ getartcraft.com. Trên GitHub có nhiều repo 'artcraft' của bên thứ ba (launcher, installer), không chắc bản gốc."
fi
hoi "Mở trang tải OpenMausBot (đội AI bot trong app chat, mỗi bot là một agent Claude/Codex; thay Grok Bot)?" && open_rel milind-soni/OpenMausBot "OpenMausBot"
hoi "Mở trang tải Cap (quay màn hình thay Loom)?" && open_rel CapSoftware/Cap "Cap"
hoi "Mở trang tải Dyad (dựng app bằng AI trên máy, thay Lovable)?" && open_rel dyad-sh/dyad "Dyad"
hoi "Mở trang tải OpenWhispr (đọc thành chữ thay Wispr Flow)?" && open_rel OpenWhispr/openwhispr "OpenWhispr"
hoi "Mở trang Nanobrowser (tiện ích Chrome tự động hoá duyệt web bằng AI, thay OpenAI Operator)?" && open_rel nanobrowser/nanobrowser "Nanobrowser"
hoi "Mở trang tải dsh-pet (thú cưng hoạt hình trên màn hình)?" && open_rel PC2005-cloud/dsh-pet "dsh-pet"
hoi "Mở trang tải Upscayl (phóng to ảnh bằng AI không vỡ nét)?" && open_rel upscayl/upscayl "Upscayl"
hoi "Mở trang tải cc-haha (giao diện desktop cho Claude Code)?" && open_rel NanmiCoder/cc-haha "cc-haha"
hoi "Mở trang tải AIRI (AI companion/VTuber chạy trên máy)?" && open_rel moeru-ai/airi "AIRI"
hoi "Mở trang tải OpenBot của CopilotKit (AI đồng nghiệp có máy tính riêng; khác OpenBot ở trên)?" && open_rel CopilotKit/OpenBot "OpenBot (CopilotKit)"
hoi "Mở trang tải Orkas (đội 16 AI agent chạy trên máy, local-first; thêm app cho đội AI)?" && open_rel Orkas-AI/Orkas "Orkas"
hoi "Mở trang tải DyberPet (thú cưng trên màn hình, PySide6)?" && open_rel ChaozhongLiu/DyberPet "DyberPet"
# Fay: framework làm người ảo/trợ lý số (streamer ảo, lễ tân số...); cần Python
if co python3 && hoi "Cài Fay (framework làm người ảo/trợ lý số kết nối LLM)?"; then
  [ -d ~/Fay ] || git clone --depth 1 https://github.com/xszyou/Fay.git ~/Fay
  echo "Xem ~/Fay/README để chạy (có nhiều bản: trợ lý, thương mại, người ảo). Cần API key/model, đặt ngoài repo."
fi

# FastAPI là THƯ VIỆN Python, không phải app chạy riêng: cài khi lập trình API, không cần ở đây
echo "FastAPI là thư viện: khi code API thì 'pip install fastapi uvicorn' trong dự án, không cần cài sẵn."

# MoneyPrinterTurbo (harry0703, MIT): gõ 1 chủ đề → ra video ngắn hoàn chỉnh (kịch bản, giọng đọc, phụ đề, nhạc); cần Python, có giao diện web
if co python3 && hoi "Cài MoneyPrinterTurbo (gõ chủ đề ra video ngắn tự động; cần Python, một số tính năng cần API key)?"; then
  [ -d ~/MoneyPrinterTurbo ] || git clone --depth 1 https://github.com/harry0703/MoneyPrinterTurbo.git ~/MoneyPrinterTurbo
  echo "Xem ~/MoneyPrinterTurbo/README (có bản Docker và bản chạy trực tiếp). Giọng đọc/hình nền có thể cần API key, đặt ngoài repo."
fi
# Scrapling (D4Vinci, BSD-3): thư viện cào web Python, vượt được một số chặn bot (Cloudflare)
if co python3 && hoi "Cài Scrapling (thư viện cào web Python, qua được một số chặn bot)?"; then
  python3 -m pip install -U "scrapling" && python3 -m scrapling install 2>/dev/null; echo "Chỉ cào trang bạn được phép; tôn trọng robots.txt và điều khoản của trang."
fi

# Harness2 (google-research/harness2, Apache-2.0): framework để agent TỰ cải thiện giàn đỡ (prompt/tool/memory/skill) qua nhiều vòng, không chỉnh trọng số model. Nghiên cứu; cần Linux, Python 3.12, uv
if co python3 && hoi "Cài Harness2 của Google (framework agent tự cải thiện; cần Linux + Python 3.12 + uv)?"; then
  co uv || curl -LsSf https://astral.sh/uv/install.sh | sh
  [ -d ~/harness2 ] || git clone --depth 1 https://github.com/google-research/harness2.git ~/harness2
  (cd ~/harness2 && uv venv --python 3.12 .venv && .venv/bin/python -m pip install -e ".[render]") \
    && echo "Chạy demo: cd ~/harness2 && source .venv/bin/activate && harness2-demo --output runs/demo --k 2 (xem README)"
fi

# google-colab-cli (googlecolab, Apache-2.0): chạy máy Colab (GPU T4 miễn phí) từ dòng lệnh — hợp khi máy không có GPU. Lệnh: colab
if co python3 && hoi "Cài google-colab-cli (dùng GPU Colab miễn phí từ dòng lệnh; cần tài khoản Google)?"; then
  co uv && uv tool install google-colab-cli || python3 -m pip install -U google-colab-cli
  echo "Xác thực: chạy 'colab' theo hướng dẫn (đăng nhập Google Cloud ADC). GPU T4 miễn phí; A100/H100 trả phí khi cần. Xem README của repo."
fi

# Agent Lightning (microsoft/agent-lightning, MIT): framework HUẤN LUYỆN/tối ưu AI agent bằng reinforcement learning. Nâng cao, cần GPU; dành cho người làm nghiên cứu/model
if co python3 && hoi "Cài Agent Lightning (huấn luyện agent bằng RL; nâng cao, cần GPU mạnh)?"; then
  python3 -m pip install -U agentlightning && echo "Xem https://microsoft.github.io/agent-lightning. Có 'Agent Lightning Skill' trong repo giúp một coding agent cải thiện agent khác theo benchmark."
fi

# Artemis (google/artemis, Apache-2.0): cho AI agent điều khiển ĐIỆN THOẠI ANDROID THẬT (mở app, bấm, test); MCP server nối Claude Code. Cần uv + ADB; chỉ dùng trên máy/điện thoại của bạn
if co python3 && hoi "Cài Artemis của Google (AI điều khiển điện thoại Android thật; cần uv, bật USB debugging trên máy của bạn)?"; then
  co uv || curl -LsSf https://astral.sh/uv/install.sh | sh
  [ -d ~/artemis ] || git clone --depth 1 https://github.com/google/artemis.git ~/artemis
  (cd ~/artemis && uv run artemis init) && echo "Nối Claude Code: cd ~/artemis && uv run artemis mcp --install all. Chỉ điều khiển điện thoại của bạn (bật Gỡ lỗi USB)."
fi

# === 5 repo "kiếm tiền với AI" ===
# OpenHands: nền tảng coding agent tự host (trước là OpenDevin)
if hoi "Cài OpenHands (coding agent tự host, bảng điều khiển dev; cần Docker)?"; then selfhost openhands All-Hands-AI/OpenHands "https://docs.all-hands.dev (chạy bằng docker run, xem README)"; fi
# screenshot-to-code: ảnh chụp/Figma -> code (HTML/React/Tailwind). Cần API key OpenAI/Anthropic
if co python3 && hoi "Cài screenshot-to-code (ảnh chụp màn hình -> code; cần API key AI)?"; then
  [ -d ~/screenshot-to-code ] || git clone --depth 1 https://github.com/abi/screenshot-to-code.git ~/screenshot-to-code
  echo "Xem ~/screenshot-to-code/README (chạy backend + frontend, hoặc Docker). Cần OPENAI/ANTHROPIC key, đặt ngoài repo."
fi
# CrewAI: framework Python điều phối nhiều AI agent làm việc nhóm
if co python3 && hoi "Cài CrewAI (framework lập trình nhiều AI agent làm việc nhóm)?"; then
  python3 -m pip install -U crewai && echo "Xem https://docs.crewai.com. Cần API key model, đặt ngoài repo."
fi
# PPTAgent: tạo slide PowerPoint từ tài liệu
if co python3 && hoi "Cài PPTAgent (tạo slide PowerPoint từ tài liệu bằng AI)?"; then
  [ -d ~/PPTAgent ] || git clone --depth 1 https://github.com/icip-cas/PPTAgent.git ~/PPTAgent
  echo "Xem ~/PPTAgent/README để cài phụ thuộc và chạy. Cần API key model."
fi
# Open AI UGC: tạo video quảng cáo UGC (diễn viên AI) qua MuAPI (trả phí theo lượt); tự chịu trách nhiệm nội dung
if co node && hoi "Cài Open AI UGC (tạo video quảng cáo UGC diễn viên AI; qua MuAPI, trả phí theo lượt)?"; then
  [ -d ~/Open-AI-UGC ] || git clone --depth 1 https://github.com/Anil-matcha/Open-AI-UGC.git ~/Open-AI-UGC
  (cd ~/Open-AI-UGC && npm install) && echo "Lấy key ở muapi.ai, điền vào .env, chạy theo README. Bạn tự chịu trách nhiệm nội dung và quyền hình ảnh."
fi

# Unlimited-OCR 2 (baidu/Unlimited-OCR, MIT): model VLM 6.7B đọc cả cuốn sách/tài liệu dài thành văn bản (OCR). CẦN GPU MẠNH (thử nghiệm trên A800-80GB) — máy thường không chạy nổi, nên dùng qua Colab (google-colab-cli ở trên) hoặc giao diện web win4r/unlimited-ocr2-webui
if co python3 && hoi "Tải Unlimited-OCR 2 của Baidu (OCR tài liệu dài; CẦN GPU rất mạnh)?"; then
  [ -d ~/Unlimited-OCR ] || git clone --depth 1 https://github.com/baidu/Unlimited-OCR.git ~/Unlimited-OCR
  echo "Xem ~/Unlimited-OCR/README. Máy không có GPU mạnh thì chạy trên Colab, hoặc dùng giao diện web: https://github.com/win4r/unlimited-ocr2-webui . Số hoá tài liệu ít trang: dùng MinerU (đã có ở trên) nhẹ hơn."
fi

# DeepTutor (HKUDS/DeepTutor, Apache-2.0): "gia sư AI" — đưa tài liệu/giáo trình vào, nó dạy bạn theo kiểu cá nhân hoá, nhớ tiến độ. Có app desktop Mac/Windows tải thẳng
if hoi "Mở trang tải DeepTutor (gia sư AI cá nhân hoá; app desktop Mac/Windows)?"; then
  case "$OS" in
    Darwin) u="https://github.com/HKUDS/DeepTutor/releases/latest" ;;
    *) u="https://github.com/HKUDS/DeepTutor/releases/latest" ;;
  esac
  if [ "$OS" = Darwin ]; then open "$u"; else xdg-open "$u" 2>/dev/null || echo "$u"; fi
  echo "Tải: Mac Apple Silicon / Mac Intel / Windows (.exe) ở trang Releases. Tài liệu: https://deeptutor.info . Cần API key model (đặt trong app, KHÔNG ghi vào repo)."
fi
# Cherry Studio (CherryHQ/cherry-studio, AGPL-3.0): "văn phòng AI" trên desktop — gom mọi model (Claude, GPT, Gemini...) + kho tài liệu + trợ lý vào 1 app. Win/Mac/Linux
if hoi "Mở trang tải Cherry Studio (văn phòng AI trên desktop: mọi model 1 cửa sổ)?"; then
  u="https://github.com/CherryHQ/cherry-studio/releases/latest"
  if [ "$OS" = Darwin ]; then open "$u"; else xdg-open "$u" 2>/dev/null || echo "$u"; fi
  echo "Tải bản Win/Mac/Linux ở trang Releases (hoặc cherry-ai.com). Cần API key của từng model (đặt trong app, KHÔNG ghi vào repo)."
fi
# LLM Wiki (DimitrisLianos/LLM_Wiki_SecondBrain): "bộ não thứ hai" chạy 100% CỤC BỘ — LLM Gemma 4 đọc tài liệu, tự dựng wiki liên kết trong Obsidian, KHÔNG gửi dữ liệu lên mây. Chuẩn nhất: Mac chip Apple (M-series, RAM >=16GB); Linux GPU/CPU cũng chạy; Windows phải qua WSL2. Phải tải model ~16GB
if co python3 && hoi "Tải LLM Wiki (bộ não thứ hai LLM cục bộ; cần Mac chip Apple RAM>=16GB hoặc GPU, tải model ~16GB)?"; then
  [ -d ~/LLM_Wiki_SecondBrain ] || git clone --depth 1 https://github.com/DimitrisLianos/LLM_Wiki_SecondBrain.git ~/LLM_Wiki_SecondBrain
  echo "Xem ~/LLM_Wiki_SecondBrain/README (phần Quick Start + docs/arc42/07-deployment-view.md). Lõi ingest/query chỉ cần Python chuẩn; web UI thêm fastapi+ddgs. Chạy được trên máy có đủ RAM/GPU; máy yếu thì bỏ qua."
fi
# GSD (get-shit-done, gsd-build/get-shit-done): bộ khung làm việc theo đặc tả (spec-driven) cho AI agent coding — tải về rồi làm theo README
if hoi "Tải GSD (get-shit-done: quy trình làm phần mềm theo đặc tả cho AI agent)?"; then
  [ -d ~/get-shit-done ] || git clone --depth 1 https://github.com/gsd-build/get-shit-done.git ~/get-shit-done
  echo "Xem ~/get-shit-done/README. Là bộ khung quy trình (không phải plugin), làm theo hướng dẫn trong repo."
fi
# LightRAG (HKUDS/LightRAG): RAG nhanh gọn dựa trên đồ thị tri thức cho AI agent; cần API key model đặt NGOÀI repo
if co python3 && hoi "Cài LightRAG (RAG đồ thị tri thức cho AI; cần API key model)?"; then
  python3 -m pip install -U lightrag-hku && echo "Xem https://github.com/HKUDS/LightRAG. Cần OPENAI/ANTHROPIC key (hoặc model cục bộ), đặt trong biến môi trường, KHÔNG ghi vào repo."
fi

echo
echo "Xong. Không cần cài: vibe-kanban (chạy 'npx vibe-kanban' khi dùng)."
echo "Token Apify/OpenRouter: đặt trong biến môi trường (~/.zshrc hoặc ~/.bashrc), KHÔNG ghi vào repo."
