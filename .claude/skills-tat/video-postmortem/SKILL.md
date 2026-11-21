---
name: video-postmortem
description: >-
  Mổ xẻ một video đã đăng: đọc số liệu (lượt hiển thị, CTR, thời lượng xem, tỉ lệ giữ chân, nguồn lượt xem), tiêu đề,
  ảnh bìa, lời mở đầu để giải thích vì sao video lên/xịt và lần sau nên đổi gì. Dùng khi người dùng hỏi "sao video này
  ít view", "video này sao viral", "phân tích video của tôi", "CTR thấp", "người xem thoát sớm".
---

# Mổ xẻ video đã đăng

## 1. Thu thập (hỏi những gì còn thiếu)
- Số liệu: lượt hiển thị, CTR ảnh bìa, lượt xem, thời lượng xem trung bình, % xem trung bình, biểu đồ giữ chân (ảnh chụp màn hình cũng được), nguồn lượt xem, ngày đăng.
  YouTube: YouTube Studio → Số liệu phân tích của video. TikTok: Phân tích → video → tổng thời gian xem, xem hết, nguồn.
- Có vidIQ: `vidiq_video_stats`, `vidiq_channel_analytics`. Có YouTube API: skill `youtube-analytics`.
- Tiêu đề, ảnh bìa, file video hoặc link (tải bằng `yt-dlp` nếu được).
- **Mốc so sánh:** số liệu trung bình 5–10 video gần nhất của chính kênh. Chỉ so với kênh mình, không dùng "chuẩn ngành" tự nghĩ ra.

## 2. Chẩn đoán theo phễu — tìm tầng gãy đầu tiên
1. **Không được hiển thị** (hiển thị thấp hơn hẳn mọi khi): chủ đề ít người quan tâm, từ khóa sai, đăng sai giờ, kênh mới. → xem `video-seo`, `competitor-videos`.
2. **Hiển thị nhưng không bấm** (CTR thấp hơn trung bình kênh): ảnh bìa/tiêu đề yếu hoặc không khớp người xem. → `thumbnail-strategist`.
3. **Bấm rồi thoát sớm** (giữ chân rơi mạnh trong 30 giây đầu, TikTok 3 giây đầu): hook chậm, mở đầu không đúng lời hứa của ảnh bìa.
   Chép 30 giây đầu bằng `nghe-audio`, đối chiếu với tiêu đề/ảnh bìa.
4. **Rơi giữa video:** tìm chỗ biểu đồ giữ chân tụt dốc, xem đoạn đó nói gì (đoạn dài dòng, quảng cáo, lạc đề). Chỗ biểu đồ *tăng* = đoạn người xem tua lại, đáng giữ.
5. **Xem hết nhưng không lan**: thiếu lý do chia sẻ/bình luận, thiếu lời kêu gọi.
Video viral: làm ngược lại — chỉ ra tầng nào vượt trội và yếu tố nào lặp lại được.

## 3. Trả về
1. Kết luận 2–3 câu: video gãy (hoặc thắng) ở tầng nào, bằng chứng là số nào.
2. Từng tầng: số của video vs trung bình kênh → nhận xét.
3. 3 việc cụ thể cho video sau, xếp theo tác động; nếu đáng thì đề xuất đổi tiêu đề/ảnh bìa ngay cho video này.
4. Điều chưa chắc (thiếu số liệu nào, video còn quá mới).
Không bịa số; số liệu nào người dùng chưa đưa thì ghi "chưa có" thay vì đoán.
