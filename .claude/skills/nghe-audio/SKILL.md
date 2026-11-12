---
name: nghe-audio
description: >-
  "Đôi tai" cho Claude: chép lời (speech-to-text) từ file âm thanh hoặc video (mp4, mp3, m4a, wav, webm...)
  bằng faster-whisper chạy trên CPU, hỗ trợ tiếng Việt và ~100 ngôn ngữ, có mốc thời gian.
  Dùng khi người dùng gửi video/ghi âm và hỏi "video nói gì", "nghe giúp", "chép lời", "tóm tắt video",
  "phụ đề", hoặc khi cần nội dung lời nói trong video TikTok/YouTube đã tải về.
---

# Nghe âm thanh / video

## 1. Cài (mỗi máy/phiên mới, chỉ lần đầu)
Kiểm tra: `test -x ~/.venvs/whisper/bin/python && echo ok`. Nếu chưa có:
```bash
python3 -m venv ~/.venvs/whisper
~/.venvs/whisper/bin/pip install -q faster-whisper "av<16"
```
`av<16`: faster-whisper 1.2.1 lỗi `metadata_errors` với PyAV mới (đã gặp với av 19) — bỏ ghim khi faster-whisper sửa.
Cần mạng tới PyPI và huggingface.co (lần đầu tải mô hình, ~1,6 GB cho `large-v3-turbo`).

## 2. Chạy
```bash
~/.venvs/whisper/bin/python .claude/skills/nghe-audio/scripts/transcribe.py "<đường dẫn file>" [--lang vi] [--model small]
```
- In ra từng câu kèm mốc `[phút:giây - phút:giây]`; dòng `# ngôn ngữ...` in ra stderr.
- Mặc định `large-v3-turbo` (tiếng Việt tốt; đo được: video 44 giây chép xong ~24 giây trên 4 CPU).
  File dài hoặc cần nhanh: `--model small` (kém chính xác hơn với tiếng Việt).
- Biết trước ngôn ngữ thì thêm `--lang vi` cho chắc.
- Chạy nền (`run_in_background`) với file dài trên ~10 phút.

## 3. Trả lời người dùng
- Kết hợp lời nói với hình: cắt vài khung hình bằng ffmpeg (`ffmpeg -ss <giây> -i file -frames:v 1 out.jpg`) rồi xem ảnh.
- Whisper có thể nghe nhầm tên riêng, số liệu, từ chuyên ngành (vd "NVIDIA" thành "NBD"): đối chiếu với chữ trên hình hoặc nguồn khác, nói rõ chỗ không chắc.
- Đoạn chỉ có nhạc, không lời sẽ bị bỏ qua (bộ lọc VAD), nên có thể thiếu mốc thời gian.
- Không chép lời ghi âm của người khác khi họ không biết hoặc không đồng ý.
