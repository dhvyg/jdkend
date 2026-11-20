---
name: thumbnail-strategist
description: >-
  Lên ý tưởng ảnh bìa (thumbnail YouTube, ảnh bìa TikTok/Reels) từ ý tưởng video: 3 concept có bố cục, chữ trên ảnh,
  prompt tạo ảnh; hoặc chấm điểm và sửa một ảnh bìa có sẵn. Dùng khi người dùng hỏi "làm thumbnail", "ảnh bìa video",
  "ý tưởng ảnh bìa", "thumbnail này được không", "sửa thumbnail".
---

# Chiến lược ảnh bìa

Ảnh bìa và tiêu đề là một cặp: ảnh gây tò mò, tiêu đề nói rõ hơn — **không lặp lại cùng một câu**.

## A. Tạo mới từ ý tưởng video
1. Hỏi (nếu chưa có): video nói gì, người xem là ai, nền tảng (YouTube 16:9 1280x720 / TikTok bìa 9:16 1080x1920), tiêu đề dự kiến.
2. Tìm **một** điều khiến người ta muốn bấm: kết quả bất ngờ, trước/sau, con số, xung đột, bí mật, sai lầm.
3. Đưa 3 concept khác hẳn nhau, mỗi concept:
   - **Bố cục:** chủ thể chính (mặt người có cảm xúc rõ, vật, kết quả) ở đâu, chiếm bao nhiêu khung.
   - **Chữ trên ảnh:** tối đa 3–4 từ, chữ to đậm, viền tương phản; tiếng Việt phải có dấu đúng.
   - **Màu:** 2–3 màu, nền và chủ thể tương phản mạnh.
   - **Prompt tạo ảnh** (tiếng Anh, chi tiết ánh sáng, góc máy, cảm xúc) để dùng với skill `ai-image-creator` hoặc `higgsfield`.
   - Lý do concept này có thể hút người bấm, và rủi ro (giật tít quá đà, giống kênh khác).
4. Người dùng chọn → tạo ảnh bằng `ai-image-creator`, ghép chữ bằng HTML + Playwright (skill `generate-cover` có mẫu) hoặc ffmpeg drawtext.

## B. Chấm ảnh bìa có sẵn
Xem ảnh, chấm từng mục 1–5 và nói lý do cụ thể:
1. Thu nhỏ còn cỡ ô gợi ý (khoảng 160 px ngang) vẫn hiểu được không? Kiểm tra thật: `ffmpeg -i bia.jpg -vf scale=160:-1 nho.jpg` rồi xem.
2. Một điểm nhìn chính hay rối nhiều thứ?
3. Chữ đọc được ở cỡ nhỏ? Có trùng y tiêu đề không?
4. Tương phản màu, nổi bật trên nền trắng và nền đen của app?
5. Cảm xúc/tò mò có rõ không?
6. Ảnh có hứa đúng nội dung video không (không lừa người xem)?
Sau đó đưa 2–3 sửa đổi cụ thể, ưu tiên cái dễ làm mà tác động lớn.
Có kết nối vidIQ thì chấm thêm bằng `vidiq_score_thumbnail` và nói rõ đó là điểm của vidIQ.

## Không làm
Không dùng mặt, logo, ảnh của người/thương hiệu khác khi chưa có quyền; không làm ảnh bìa giả mạo kênh khác.
