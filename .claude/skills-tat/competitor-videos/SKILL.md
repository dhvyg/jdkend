---
name: competitor-videos
description: >-
  Phân tích các kênh cùng ngách trên YouTube/TikTok: video nào nổi trội so với chính kênh đó, vì sao (chủ đề, tiêu đề,
  ảnh bìa, hook), và chủ đề nào họ chưa làm để người dùng làm trước. Dùng khi người dùng đưa tên kênh và hỏi "phân tích
  đối thủ", "kênh này làm gì hay", "tìm ý tưởng video", "chủ đề chưa ai làm", "video nào đang viral trong ngách".
  Phân tích đối thủ về SEO, quảng cáo, giá thì dùng competitor-analysis.
---

# Phân tích video đối thủ

## 1. Lấy dữ liệu (dùng nguồn có thật, không bịa số)
Thử theo thứ tự, nói rõ đang dùng nguồn nào:
1. **vidIQ** (nếu đã kết nối): `vidiq_channel_search` → `vidiq_channel_videos` / `vidiq_channel_stats`; `vidiq_outliers` tìm video nổi trội; TikTok: `vidiq_tiktok_profile_videos`.
2. **YouTube Data API** (nếu có key): xem skill `youtube-analytics`.
3. **yt-dlp** (không cần key): `yt-dlp --flat-playlist --print "%(id)s\t%(title)s\t%(view_count)s\t%(upload_date)s" "https://www.youtube.com/@kenh/videos" | head -60`.
4. Không lấy được: nhờ người dùng dán danh sách video + lượt xem.

## 2. Tìm video nổi trội (outlier)
- So mỗi video với **trung vị lượt xem của chính kênh đó** (không so giữa các kênh to nhỏ khác nhau). Gấp ≥ 3 lần trung vị = nổi trội.
- Bỏ video quá mới (chưa đủ thời gian lên view) hoặc ghi chú tuổi video.

## 3. Giải thích vì sao nổi trội
Với 5–10 video nổi trội, xem tiêu đề, ảnh bìa, và nếu tải được thì 15 giây đầu (chép bằng `nghe-audio`):
- Chủ đề / nỗi đau người xem; kiểu tiêu đề; ảnh bìa (mặt, chữ, màu); cách mở đầu.
- Gom thành **mẫu lặp lại** (vd "so sánh giá X vs Y", "thử làm X trong 7 ngày").

## 4. Khoảng trống nội dung
- Chủ đề người xem hỏi nhiều (bình luận: `vidiq_comment_insights` hoặc đọc bình luận) mà chưa kênh nào làm tốt.
- Mẫu nổi trội của kênh A mà kênh B, C chưa thử.
- Góc nhìn riêng người dùng có (nghề, địa phương, ngôn ngữ) mà đối thủ không có.

## Trả về
1. Bảng video nổi trội: kênh | tiêu đề | lượt xem | gấp mấy lần trung vị | lý do.
2. 3–5 mẫu thành công.
3. 5–10 ý tưởng video cho người dùng: tiêu đề nháp + vì sao có cơ hội + mức chắc chắn.
Không khuyên sao chép nguyên video, tiêu đề hay ảnh bìa của người khác.
