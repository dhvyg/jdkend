---
name: luu-link
description: >-
  Ghi nhớ link trang web, công cụ, repo mà người dùng gửi (link, ảnh chụp màn hình, video) vào bộ nhớ Vertiso để lần sau
  lấy lại theo chủ đề. Dùng khi người dùng nói "ghi nhớ trang web này", "lưu link", "lưu các trang này", "nhớ giúp tôi
  web này", hoặc hỏi lại "lấy danh sách web thiết kế", "link công cụ cho nhà thiết kế đâu", "trang web hôm trước".
---

# Ghi nhớ và lấy lại link

Lưu trong **Vertiso Memory** (công cụ `remember`, `recall`, `search`, `update_memory`): sống qua các phiên, không cần commit.
Gói miễn phí giới hạn 20 lần ghi mỗi tháng, nên **gom nhiều link vào một bản ghi theo chủ đề**, không ghi từng link.

## Lưu
1. Lấy link thật: từ tin nhắn, từ chữ trong ảnh, hoặc từ video (xem khung hình có thanh địa chỉ; nghe lời để biết tên trang). Không đoán địa chỉ. Chữ không đọc rõ thì ghi "chưa rõ" và hỏi lại.
2. Mở từng trang bằng `firecrawl_scrape` (hoặc `firecrawl_search`) để kiểm tra trang còn sống và mô tả đúng một dòng. Trang không mở được thì vẫn lưu, ghi "chưa kiểm tra được".
3. Chọn chủ đề: thiết kế, video, kinh doanh, học tập, công cụ miễn phí... Chủ đề đã có thì `search` tag `link` trước, rồi `update_memory` thêm dòng vào bản ghi đó (tránh trùng link).
4. Chưa có chủ đề thì `remember`: type `observation`, attribution `assistant`, tags `["link", "<chủ đề>"]`, tiêu đề `Link: <chủ đề>`, nội dung mỗi dòng:
   `- Tên: https://địa-chỉ — mô tả một dòng (nguồn: video/ảnh của ai, ngày lưu)`
5. Không lưu link có mã đăng nhập, token, đường dẫn riêng tư trong URL.

## Lấy lại
`recall` hoặc `search` với tag `link` và chủ đề người dùng nói. Trả danh sách ngắn: tên, link, mô tả. Không thấy thì nói thẳng là chưa lưu và hỏi có muốn tìm mới không.

## Nhắc người dùng
Cuối mỗi lần lưu, nói đã lưu vào chủ đề nào và cách lấy lại ("lấy link <chủ đề>").
