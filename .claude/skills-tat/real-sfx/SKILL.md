---
name: real-sfx
description: >-
  Thêm hiệu ứng âm thanh THẬT (bản ghi âm có giấy phép, không tự tạo tiếng bằng mã) vào video: liệt kê chỗ cần tiếng
  theo mốc giây, tìm tiếng động đúng cảnh (cửa, bước chân, gió, sóng, đám đông, thành phố, nổ, click...), nghe chọn bằng
  số đo, cắt, hạ âm lượng dưới lời nói, đặt đúng mốc, đo lại bản xuất ra và ghi công tác giả. Dùng khi người dùng nói
  "thêm tiếng động", "thêm hiệu ứng âm thanh", "sound effect cho video", "tiếng thật", "real SFX", "video bị trống
  tiếng", "lồng tiếng môi trường".
---

# Hiệu ứng âm thanh thật cho video

Claude không nghe được: **mọi lựa chọn dựa trên số đo**, và không bao giờ nói "nghe hay". Bàn giao file cho người dùng nghe lại. Chỉ dùng **bản ghi âm thật có giấy phép**; không tạo tiếng bằng mã (tiếng bíp, nhiễu). Nhạc có bản quyền thì không dùng ở đây.

Dùng cùng: `openverse-sfx` (tìm và tải, có lọc giấy phép), `earshot` (nghe và đo), `edit-video` (ffmpeg), `nghe-audio` (chép lời).

## 1. Lập bảng tiếng cần có
Xem video: lấy khung hình (xem `edit-video`) và, nếu có lời nói, chép lời bằng `nghe-audio`. Viết bảng: `mốc giây | việc xảy ra trên hình | tiếng cần | dài bao lâu | to hay nhỏ`.
- Chỉ thêm tiếng cho việc người xem **thấy** (cửa đóng, bước chân, chạm, gió ngoài trời). Không rải tiếng khắp nơi.
- Có lời nói: tiếng động phải nhỏ hơn lời; có nhạc nền: chừa chỗ cho nhạc.
- Video không có tiếng sẵn: thêm một lớp **không khí nền** (phòng, phố, gió) chạy suốt, rồi mới đến tiếng chi tiết.

## 2. Tìm tiếng thật
Dùng script của `openverse-sfx` (không cần khóa, bắt buộc lọc giấy phép CC0/CC-BY/PD). Từ khóa viết **bằng tiếng Anh**, mỗi loại tiếng tìm **một lần** (mỗi ngày chỉ khoảng 200 lượt):
```bash
python3 .claude/skills/openverse-sfx/scripts/sfx_search.py --query "door close" --max-ms 8000 --max-results 8
python3 .claude/skills/openverse-sfx/scripts/sfx_fetch.py --audio-url URL --name cua_dong --attribution "..." --dir sfx --credits credits.txt
```
Gợi ý từ khóa: cửa mở/đóng `door open|door close wood`; bước chân `footsteps gravel|footsteps wood floor`; gió `wind gentle|wind strong`; sóng `sea waves gentle`; chim `birds ambience`; phố `city ambience|traffic`; đám đông `crowd murmur`; nổ `explosion`; chạm/click `click|tap|button press`; mưa `rain light|rain heavy`; vỗ tay `applause`.
Chưa tải được thì nói rõ (cần mạng tới api.openverse.org) và hỏi người dùng có file riêng không. Mỗi file tải về phải được ghi vào `credits.txt` nguyên văn (CC BY bắt buộc ghi công).

## 3. Chọn bằng số đo, không bằng cảm giác
Với 2–3 ứng viên mỗi tiếng, dùng `earshot` (xem skill đó để biết lệnh và thời gian chờ):
- `earshot find FILE "mô tả tiếng" --top 3`: tìm khoảnh khắc sạch nhất trong bản ghi.
- `earshot match FILE "mô tả" --alts "tiếng khác"`: kiểm tra nó đúng loại tiếng cần.
- `earshot realness FILE --start S --end E`: kiểm tra đoạn định dùng có đọc như bản ghi thật không.
Báo kèm con số. Loại ứng viên có giọng nói lạ, nhạc, tiếng ồn máy, hoặc bị cắt cụt.

## 4. Đặt vào video bằng ffmpeg
Công thức đã chạy thử (ffmpeg 6.1): cắt đoạn, làm mờ vào/ra 20–50 mili giây để không bị "tách", hạ âm lượng, dời tới mốc (mili giây), trộn:
```bash
# video CÓ tiếng: đặt 2 tiếng tại 1,0 s và 3,5 s
ffmpeg -y -i IN.mp4 -i cua.wav -i buoc.wav -filter_complex \
"[1:a]atrim=0:1.5,afade=t=in:d=0.02,afade=t=out:st=1.45:d=0.05,volume=-8dB,adelay=1000|1000[a1];\
[2:a]afade=t=in:d=0.02,afade=t=out:st=0.95:d=0.05,volume=-10dB,adelay=3500|3500[a2];\
[0:a][a1][a2]amix=inputs=3:duration=first:normalize=0[a]" \
-map 0:v -map "[a]" -c:v copy -c:a aac -b:a 160k out.mp4
# video KHÔNG có tiếng: bỏ [0:a], thêm apad cho đủ độ dài video
#   ...volume=-8dB,adelay=1000|1000,apad=whole_dur=<tổng giây>[a]  rồi -map "[a]" -t <tổng giây>
# lớp nền chạy suốt: -stream_loop -1 -i nen.wav, rồi [1:a]atrim=0:<giây>,afade=t=in:d=0.3,afade=t=out:st=<giây-0.5>:d=0.5,volume=-20dB
```
- Mẹo mức to: tiếng chi tiết thấp hơn lời 8–12 dB; lớp nền thấp hơn lời 18–25 dB. Chỉnh theo số đo, không theo cảm giác.
- Lặp lớp nền: chọn bản ghi dài hơn video nếu có; ghép vòng dễ nghe thấy chỗ nối, nên báo rõ.
- Mốc giây phải khớp khung hình: sai quá 2–3 khung (khoảng 0,1 s ở 30 fps) là thấy lệch.

## 5. Đo lại bản xuất ra (không đo file trung gian)
- Âm lượng tổng: `ffmpeg -i out.mp4 -af ebur128=peak=true -f null -`; mục tiêu cho TikTok/Reels khoảng −14 LUFS, đỉnh không vượt −1,5 dBTP; cần thì thêm `loudnorm` như `edit-video`.
- Không méo (peak không chạm 0 dBFS), không có đoạn im lặng bất thường, tiếng nằm đúng mốc (kiểm bằng `earshot` hoặc cắt khung hình quanh mốc).
- Báo người dùng: danh sách tiếng đã thêm (mốc, tên file, nguồn, giấy phép), số đo trước và sau, và **mời họ nghe lại** vì Claude không nghe được. Giao cả `credits.txt`; nếu đăng công khai, dán phần ghi công vào mô tả video.

## Không làm
Không dùng tiếng người nói, nhạc có bản quyền hay mẫu thanh của hãng khi chưa có quyền; không tạo tiếng bằng mã; không giấu giấy phép CC BY.
