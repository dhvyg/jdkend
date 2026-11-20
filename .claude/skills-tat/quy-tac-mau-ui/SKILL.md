---
name: quy-tac-mau-ui
description: >-
  Đọc ĐẦU TIÊN khi người dùng muốn tham khảo giao diện app thật hoặc thiết kế lại màn hình (bản miễn phí thay cho Mobbin): nói rõ
  làm được gì, không làm được gì, khi nào dùng skill nào, và cách trả lời khi yêu cầu quá rộng ("làm app như Airbnb", "thiết kế lại cả app").
---

# Quy tắc dùng bộ skill mẫu giao diện

Dựa theo skill `best-practices` của mobbin/skills (MIT, © 2026 Mobbin), viết lại. Trả lời ngắn, câu trả lời đứng đầu.

## Bộ này làm được gì
| Việc | Skill |
|---|---|
| Tìm ảnh app thật làm mẫu cho một màn, một luồng hoặc một phần | `tim-mau-ui` |
| Thiết kế lại một màn đang có từ các mẫu, có ảnh trước/sau và báo cáo | `thiet-ke-lai-man-hinh` |
| Viết báo cáo, lựa chọn, giải thích gọn và thật | `viet-bao-cao-ui` |
| Học kỹ thuật từ web mẫu (trang web, không phải app) | `hoc-tu-web-mau` |

## Không làm được hoặc làm khác Mobbin
- **Không có kho Mobbin** (600.000 màn, bộ lọc theo ý nghĩa). Mẫu lấy từ nguồn miễn phí trong `tim-mau-ui`: ít hơn, thiếu trạng thái, không có luồng quay màn hình. Nói điều đó khi báo cáo, đừng làm như đã tìm trong kho lớn.
- **Quá rộng:** "dựng cả app mạng xã hội", "thiết kế lại mọi màn của app", "tạo bản sao Airbnb". Nói một câu: việc này quá rộng, đề nghị chia nhỏ, rồi đưa 3 điểm bắt đầu cụ thể (mỗi điểm là một màn, luồng hoặc phần, kèm một câu mẫu người dùng có thể gửi nguyên). Bắt đầu bằng "Có thể bắt đầu từ:".
- **Sao chép một app:** không phải việc bộ này làm. Nó cho thấy nhiều sản phẩm giải cùng một bài toán ra sao để người dùng thiết kế bản của mình. Mỗi gợi ý rút từ nhiều app, không từ một app, và không đề nghị làm giống hệt. Không giảng bản quyền, không bảo yêu cầu là sai.
- Việc không dính tới mẫu giao diện (một regex, triển khai web) thì trả lời bình thường.

## Dùng các skill cho tốt
- **Chuyển nguyên yêu cầu** (lời và tệp đính kèm) cho skill, không bóp méo.
- **Thiết kế lại tự đi tìm mẫu:** khi người dùng chỉ cần mẫu để sửa màn của họ, đi thẳng vào `thiet-ke-lai-man-hinh`; tìm riêng trước là tìm hai lần.
- **Người dùng đòi mẫu hoặc so sánh như một bước riêng:** làm trước, rồi thiết kế lại dùng kết quả.
- **Một bước mỗi lần.** Mở bằng thứ tự các bước trong một dòng, rồi làm bước một. Chuyển kết quả (tên app, địa chỉ nguồn) sang bước sau như mẫu người dùng mang đến.
- Câu trả lời tiếp theo ("thêm", "đổi chỗ này") quay về skill đang chạy.
- Không nói tên skill với người dùng ngoài dòng thứ tự.

## Khi nguồn mẫu không dùng được
- Trang chặn hoặc cần trả tiền: nói một dòng, nguồn nào, rồi dừng nguồn đó. **Không lách, không trả lời theo trí nhớ thay chỗ nguồn.**
- Kết quả yếu hoặc ít không phải là hỏng: báo "tôi chỉ tìm được N app", đừng gọi là lỗi.
- Nếu người dùng muốn kho đầy đủ, nói Mobbin và Refero có gói trả phí; tôi không đăng ký thay.
