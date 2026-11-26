#!/usr/bin/env bash
# Một lệnh: video bất kỳ -> dọc 9:16 nền mờ + phụ đề in cứng + âm lượng chuẩn -14 LUFS + nén cho TikTok.
# Dùng: auto.sh IN.mp4 [OUT.mp4] [ngôn ngữ: vi|en|...|none]   (none = không phụ đề)
set -euo pipefail
IN=$(realpath "$1"); OUT=$(realpath -m "${2:-${1%.*}-auto.mp4}"); LANG_SUB=${3:-vi}
[ "$IN" != "$OUT" ] || { echo "OUT trùng file gốc, không ghi đè" >&2; exit 1; }
HERE=$(cd "$(dirname "$0")" && pwd)
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT

VF="[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=20:5[bg];\
[0:v]scale=1080:1920:force_original_aspect_ratio=decrease[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2,setsar=1,fps=30"
if [ "$LANG_SUB" != none ]; then
  ~/.venvs/whisper/bin/python "$HERE/../../nghe-audio/scripts/transcribe.py" "$IN" --lang "$LANG_SUB" --srt > "$WORK/sub.srt"
  # subtitles= đọc đường dẫn tương đối từ $WORK, tránh lỗi thoát ký tự trong đường dẫn
  [ -s "$WORK/sub.srt" ] && VF="$VF,subtitles=sub.srt:force_style='FontName=DejaVu Sans,FontSize=12,Bold=1,Outline=2,Shadow=0,Alignment=2,MarginV=50'"
fi

AUD=(); ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$IN" | grep -q . && AUD=(-map 0:a:0 -af loudnorm=I=-14:TP=-1.5:LRA=11 -c:a aac -b:a 128k -ar 48000)
(cd "$WORK" && ffmpeg -v error -y -i "$IN" -filter_complex "$VF[v]" -map "[v]" "${AUD[@]}" \
  -c:v libx264 -preset medium -crf 23 -pix_fmt yuv420p -movflags +faststart "$OUT")
[ -s "$WORK/sub.srt" ] && cp "$WORK/sub.srt" "${OUT%.*}.srt"
echo "xong: $OUT"
