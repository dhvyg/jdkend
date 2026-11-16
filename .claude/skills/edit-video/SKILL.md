---
name: edit-video
description: >-
  Sửa video có sẵn bằng ffmpeg: cắt đoạn, ghép nhiều clip, đổi khung dọc 9:16 cho TikTok/Reels/Shorts,
  thêm phụ đề tiếng Việt (tự chép lời bằng nghe-audio), chèn chữ, chèn nhạc nền tự hạ khi có lời nói,
  tăng/giảm tốc, chuẩn hóa âm lượng, nén để đăng mạng xã hội, lấy ảnh bìa. Dùng khi người dùng gửi video
  và nói "cắt", "ghép", "thêm phụ đề", "làm video TikTok", "đổi sang dọc", "chèn nhạc", "nén video",
  "tua nhanh". Không dùng để tạo video mới từ đầu (dùng video-shotcraft, remotion-*); cắt từ đệm/khoảng
  lặng trong podcast thì dùng podcast-edit.
---

# Sửa video bằng ffmpeg

## Nguyên tắc
1. **Không ghi đè file gốc.** Làm trong thư mục riêng (scratchpad hoặc thư mục dự án), đặt tên `out-<bước>.mp4`.
2. **Xem trước khi làm:** `ffprobe -v error -show_entries format=duration:stream=codec_type,width,height,r_frame_rate -of compact IN`.
3. **Kiểm tra sau khi làm:** cắt 4–8 khung hình ghép lưới rồi xem (`Read` file ảnh); nghe lại phần lời bằng `nghe-audio` nếu có sửa âm thanh.
   ```bash
   d=$(ffprobe -v error -show_entries format=duration -of csv=p=0 OUT)
   for i in 0 1 2 3; do ffmpeg -v error -y -ss $(python3 -c "print($d*($i+0.5)/4)") -i OUT -frames:v 1 -vf scale=360:-1 f$i.jpg; done
   ffmpeg -v error -y -i f%d.jpg -vf tile=4x1 check.jpg
   ```
4. Mã hóa chung (mặc định cho mọi lệnh bên dưới): `ENC="-c:v libx264 -preset veryfast -crf 20 -pix_fmt yuv420p -c:a aac -b:a 160k -movflags +faststart"`.
5. Báo người dùng: đã làm gì, độ dài/kích thước trước–sau, chỗ chưa chắc (phụ đề nghe nhầm tên riêng, số).

## Công thức

**Cắt đoạn** (từ giây A đến B, chính xác từng khung):
```bash
ffmpeg -y -ss A -to B -i IN $ENC out-trim.mp4
```

**Ghép nhiều clip** (khác kích thước/tốc độ khung vẫn được; chuẩn về 1080x1920, 30 fps):
```bash
ffmpeg -y -i a.mp4 -i b.mp4 -filter_complex \
"[0:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v0];\
[1:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v1];\
[0:a]aresample=48000[a0];[1:a]aresample=48000[a1];[v0][a0][v1][a1]concat=n=2:v=1:a=1[v][a]" \
-map "[v]" -map "[a]" $ENC out-concat.mp4
```
Clip không có tiếng: thêm `-f lavfi -t <giây> -i anullsrc=r=48000:cl=stereo` làm âm thanh rỗng cho clip đó.

**Đổi sang dọc 9:16** — nền mờ (giữ trọn khung hình gốc):
```bash
ffmpeg -y -i IN -filter_complex \
"[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=20:5[bg];\
[0:v]scale=1080:1920:force_original_aspect_ratio=decrease[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2,setsar=1" \
$ENC out-vertical.mp4
```
Hoặc cắt giữa cho đầy khung (mất hai bên): `-vf "scale=-2:1920,crop=1080:1920"`.

**Phụ đề tiếng Việt** (chép lời → SRT → in cứng lên hình):
```bash
~/.venvs/whisper/bin/python .claude/skills/nghe-audio/scripts/transcribe.py IN --lang vi --srt > sub.srt
# đọc sub.srt, sửa chỗ nghe nhầm (tên riêng, số) trước khi in
ffmpeg -y -i IN -vf "subtitles=sub.srt:force_style='FontName=DejaVu Sans,FontSize=12,Bold=1,Outline=2,Shadow=0,Alignment=2,MarginV=50'" $ENC out-sub.mp4
```
Cài `nghe-audio` trước nếu máy chưa có (xem skill đó). FontSize và MarginV tính theo khung cao 288 của libass, không phải pixel:
FontSize 16 trên video dọc đã ra 3 dòng to (đã thử); 11–13 vừa cho 1–2 dòng, MarginV 40–60 né nút TikTok.
Whisper có thể cho một câu dài 5–8 giây; video ngắn nên tách câu dài trong `sub.srt` thành nhiều dòng ngắn trước khi in.

**Chèn chữ** (tiêu đề góc trên, 0–3 giây):
```bash
ffmpeg -y -i IN -vf "drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='TIÊU ĐỀ':fontsize=64:fontcolor=white:borderw=4:bordercolor=black:x=(w-tw)/2:y=h*0.08:enable='between(t,0,3)'" $ENC out-text.mp4
```
Chữ có dấu `'` hoặc `:` thì ghi vào file và dùng `textfile=title.txt`.

**Nhạc nền tự hạ khi có lời nói:**
```bash
ffmpeg -y -i IN -stream_loop -1 -i music.mp3 -filter_complex \
"[1:a]volume=0.35[m];[m][0:a]sidechaincompress=threshold=0.03:ratio=8:attack=20:release=400[duck];\
[0:a][duck]amix=inputs=2:duration=first:normalize=0[a]" -map 0:v -map "[a]" -c:v copy -c:a aac -b:a 160k -shortest out-music.mp4
```
Chỉ dùng nhạc người dùng có quyền dùng (tự làm, nhạc miễn phí bản quyền). Video gốc không có tiếng: bỏ sidechain, chỉ `-map 0:v -map 1:a -shortest`.

**Tăng/giảm tốc** (vd nhanh gấp 1,5):
```bash
ffmpeg -y -i IN -filter_complex "[0:v]setpts=PTS/1.5[v];[0:a]atempo=1.5[a]" -map "[v]" -map "[a]" $ENC out-speed.mp4
```
`atempo` nhận 0.5–2.0; nhanh hơn 2 thì nối `atempo=2,atempo=1.5`.

**Chuẩn hóa âm lượng** (to đều, hợp mạng xã hội): `-af loudnorm=I=-14:TP=-1.5:LRA=11` kèm `-c:v copy -c:a aac`.

**Nén để đăng TikTok/Reels** (≤1080x1920, 30 fps):
```bash
ffmpeg -y -i IN -vf "scale='min(1080,iw)':-2,fps=30" -c:v libx264 -preset medium -crf 23 -pix_fmt yuv420p -c:a aac -b:a 128k -movflags +faststart out-final.mp4
```

**Ảnh bìa** (khung ở giây T): `ffmpeg -y -ss T -i IN -frames:v 1 -q:v 2 cover.jpg`.

**Bỏ tiếng / tách tiếng:** `-an` (bỏ tiếng) · `ffmpeg -i IN -vn -c:a libmp3lame -q:a 2 audio.mp3` (lấy tiếng).

## Giao file
Gửi file kết quả cho người dùng bằng `SendUserFile` (video nằm trong thư mục người dùng mở được). File lớn hơn ~100 MB thì nén lại trước.
Không sửa video để mạo danh người khác, xóa logo/bản quyền của người khác, hay ghép mặt/giọng người thật khi họ không đồng ý.
