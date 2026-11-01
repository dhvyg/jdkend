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

echo
echo "Xong. Không cần cài: vibe-kanban (chạy 'npx vibe-kanban' khi dùng)."
echo "Token Apify/OpenRouter: đặt trong biến môi trường (~/.zshrc hoặc ~/.bashrc), KHÔNG ghi vào repo."
