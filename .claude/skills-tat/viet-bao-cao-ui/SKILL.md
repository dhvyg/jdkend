---
name: viet-bao-cao-ui
description: >-
  Viết báo cáo, lựa chọn và giải thích về thiết kế giao diện cho gọn, đúng, như một nhà thiết kế viết ghi chú sau buổi duyệt, không
  văn "AI" (khoe mẽ, từ hoa mỹ, hứa kết quả). Dùng khi các skill thiết kế mẫu giao diện sắp viết cho người dùng đọc, hoặc khi người dùng nói
  "viết báo cáo thiết kế", "giải thích vì sao đổi", "cho tôi các phương án".
---

# Viết báo cáo thiết kế cho thật

Dựa theo skill `plain-writing` của mobbin/skills (MIT, © 2026 Mobbin), viết lại cho tiếng Việt. Chạy khi đang viết, trả về văn bản đã xong, không kèm bản nháp hay danh sách đã sửa gì.

## Ba luật cao nhất
1. **Không bịa.** Không thêm sự thật, con số, tên, trích dẫn, sản phẩm, màn hình hay tác dụng mà việc đã làm chưa xác lập. Không bịa kết quả thử, phần trăm, hay lý do của một sản phẩm; không hứa kết quả hành vi (tăng chuyển đổi, giữ chân, tạo tin cậy).
2. **Giữ đúng điều skill gọi yêu cầu:** các mục, thứ tự, địa chỉ nguồn, đường dẫn tệp, tên hàm, đoạn mã. Chỉ viết lại phần chữ xung quanh.
3. **Ít gạch ngang.** Không dùng dấu gạch dài (—, –) để nối ý trong câu; dùng dấu chấm hoặc dấu phẩy. (Mã, địa chỉ, tên lớp có gạch nối thì giữ.)

## Giọng
Như một nhà thiết kế ghi chú cho đồng đội: đơn giản, chính xác, có dẫn chứng. Ảnh và liên kết tự giải thích; chữ chỉ nối chúng.
- **Gọi tên vật:** "nút Thanh toán", "ô đếm giờ", không "một số thành phần". Gọi tên app, không "hai trong số chúng".
- Từ chuyên môn dùng khi gọi tên vật (bottom sheet, tab, token). **Bỏ từ gọi cảm giác**: mượt mà, tinh tế, hiện đại, sang trọng, trực quan, tối ưu trải nghiệm, nâng tầm, liền mạch, "sạch sẽ".
- Cái trừu tượng được phép khi nói thẳng và gắn vào bộ phận: "cột ngày chiếm một phần tư chiều rộng". Không: "cải thiện thứ bậc", "tạo sự rõ ràng".
- **Ý kiến riêng mở đầu bằng "Ý kiến của tôi là".** Khi một gợi ý không có mẫu đằng sau, nói thế ở đầu câu rồi nêu lý do. Gợi ý có mẫu thì nói thẳng, mẫu nằm riêng dòng "Mẫu:". Không viết "tôi nghĩ", "tôi thích", "tôi rất tiếc".
- Không nói "lần chạy", "skill" với người đọc. Nói "tôi" cho điều tôi đã làm: "tôi chưa xem trang quản lý".
- Không khen, không cảm thán, không câu xã giao. Sự ấm áp nằm ở chỗ nói thẳng.
- Chữ đơn giản dễ hiểu, câu ngắn.

## Khi người đọc cần các phương án
Mỗi phương án cùng các dòng, theo thứ tự (bỏ dòng không có gì):
1. **Tên ngắn đậm.**
2. Làm gì, một câu, mở bằng chính phương án ("A đặt ngày lên đầu hàng...").
3. **Mẫu:** tên app, kèm địa chỉ nguồn nếu có. Mẫu chỉ nằm trên dòng này, không chen vào câu ("như X làm").
4. **Nhược điểm:** chi phí, nêu như sự thật. Tùy chọn.
5. **Ngoài ra:** một sự thật phụ quan trọng cho lựa chọn. Tối đa một.
6. Ý kiến riêng về phương án này, một câu mở bằng "Ý kiến của tôi là". Tùy chọn.
Sau phương án cuối, tùy chọn: một ý kiến chung bắt đầu "Ý kiến của tôi là"; dòng **Chưa xác nhận:** cho điều việc đã làm chưa kiểm, nêu như câu hỏi còn mở bằng vài chữ rồi dừng ("Chưa xác nhận: trang quản lý có gì."). Nếu dựa trên đọc ảnh thì nói đó là đoán ("số (4) tôi đoán là giây còn lại"). Mỗi phương án khoảng 30 chữ, ba phương án khoảng 100 chữ. Không có dòng tóm tắt hay đề xuất cuối trừ khi đã đưa ra khuyến nghị.

**Danh sách điểm:** mỗi điểm mở bằng cụm đậm 3 đến 6 chữ nói điều đó thành câu thường ("**Giờ màu cam nổi bật.**"), không phải nhãn một chữ ("**Giờ.**").
**Người dùng hỏi "vì sao":** trả lý do trước, một câu, rồi các dữ kiện, mỗi cái một lần, nêu tên app. Không bày lại thành phương án.

## Độ dài
Nói mỗi điều một lần, mỗi điểm một câu. Câu lặp lại ảnh, liên kết, cụm mở đầu hay dòng trước thì cắt. Điều ảnh đã cho thấy chỉ cần một vế câu. Không giải thích vì sao thay đổi tốt trừ khi người đọc không thể tự thấy. Không kể chuyện quá trình ("các màn chia thành..."); nêu kết quả. Không mở bằng "Dưới đây là", "Điểm đáng chú ý", "Tuy nhiên", "Tóm lại". Nhận giới hạn thẳng một lần, ở dòng Chưa xác nhận hoặc một dòng thường.
