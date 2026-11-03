#!/usr/bin/env bash
# Cài các công cụ chạy trên máy (macOS / Linux) mà repo jdkend cần nhưng không cài qua repo được.
# Chạy: bash scripts/cai-dat-may.sh   (hỏi có/không cho từng mục)
set -u

hoi() { read -r -p "$1 [y/N] " r; [[ "$r" =~ ^[Yy]$ ]]; }
co() { command -v "$1" >/dev/null 2>&1; }
OS=$(uname -s)

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

echo
echo "Xong. Không cần cài: vibe-kanban (chạy 'npx vibe-kanban' khi dùng)."
echo "Token Apify/OpenRouter: đặt trong biến môi trường (~/.zshrc hoặc ~/.bashrc), KHÔNG ghi vào repo."
