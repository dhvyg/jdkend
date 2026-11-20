---
name: creator-graphics
description: >-
  Đọc lời/kịch bản một video (TikTok, Reels, YouTube) rồi lập danh sách đồ họa cần chèn: so sánh, sơ đồ, mốc thời gian,
  biểu đồ, thẻ thông số, chữ nhấn, kèm mốc giây và nội dung chính xác cho từng cái, rồi làm luôn nếu người dùng muốn.
  Dùng khi người dùng gửi video/kịch bản và hỏi "cần chèn hình gì", "làm đồ họa cho video", "b-roll", "minh họa cho video".
---

# Đồ họa cho video

## 1. Lấy lời
- Có video: chép lời có mốc giây bằng skill `nghe-audio`. Có kịch bản: dùng luôn.
- Đọc hết một lượt, ghi chủ đề và người xem là ai.

## 2. Tìm chỗ cần đồ họa
Đi từng câu, đánh dấu chỗ người xem *khó hình dung nếu chỉ nghe*:

| Câu nói có... | Loại đồ họa |
|---|---|
| A với B, trước/sau, nên/không nên | Bảng so sánh 2 cột |
| Các bước, quy trình, "đầu tiên… sau đó" | Sơ đồ bước |
| Năm, ngày, lịch sử, lộ trình | Mốc thời gian |
| Số liệu, %, tăng/giảm | Biểu đồ (cột, đường, tròn) |
| Tên sản phẩm + thông số | Thẻ thông số |
| Câu chốt, con số gây sốc | Chữ nhấn to giữa màn hình |
| Danh sách top N | Thẻ đánh số |

Không chèn đồ họa cho mọi câu: tối đa khoảng 1 cái mỗi 5–8 giây, ưu tiên chỗ có số liệu và so sánh.

## 3. Trả về bảng kế hoạch
Mỗi dòng: `mốc giây | loại | nội dung chính xác (chữ, số, nhãn) | ghi chú bố cục`.
- Số liệu lấy **đúng từ lời nói**; không tự thêm số. Số nghe không rõ thì đánh dấu "cần kiểm tra".
- Video dọc: đồ họa nằm nửa trên, chừa đáy cho phụ đề và nút TikTok.

## 4. Làm đồ họa (nếu người dùng muốn)
- Biểu đồ, so sánh, thẻ: viết HTML/SVG rồi chụp PNG bằng Playwright (khung 1080x1920 hoặc 1080x1080, nền trong suốt nếu cần).
- Sơ đồ quy trình, mốc thời gian: skill `archify`. Infographic dạng ảnh: skill `infographics`.
- Màu, chữ: theo thương hiệu người dùng nếu có (skill `design-md`); tránh tím chuyển màu, phát sáng (xem `unslop`).
- Chèn vào video: skill `edit-video` (overlay ảnh theo mốc giây: `-i hinh.png -filter_complex "[0:v][1:v]overlay=(W-w)/2:H*0.12:enable='between(t,A,B)'"`).
