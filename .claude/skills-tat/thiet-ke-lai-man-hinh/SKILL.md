---
name: thiet-ke-lai-man-hinh
description: >-
  Thiết kế lại MỘT màn hình, phần hoặc thành phần đang có (ảnh chụp, mã nguồn, file thiết kế) dựa trên cách các app thật làm,
  giữ nguyên hệ thiết kế và nội dung của người dùng, mỗi thay đổi có bằng chứng, xuất ảnh trước/sau và báo cáo ngắn. Không cần tài khoản Mobbin.
  Dùng khi người dùng chỉ vào một màn và nói "làm lại", "sửa cho dễ dùng hơn", "app khác làm màn này thế nào", "cải thiện màn thanh toán".
---

# Thiết kế lại một màn hình từ mẫu thật

Dựa theo skill `redesign-screen` của mobbin/skills (MIT, © 2026 Mobbin, xem `LICENSE-mobbin-skills`), viết lại tiếng Việt, lấy mẫu từ `tim-mau-ui` (nguồn miễn phí). Làm như người dẫn dắt thiết kế: **mẫu quyết định làm gì; thiết kế của người dùng quyết định trông ra sao.** Hai lỗi hay gặp: chép nguyên mẫu (sai thương hiệu, sai chữ, mất tính năng) hoặc lờ mẫu (không có gì đổi).

## Các bước
1. **Chốt phạm vi.** Viết công việc của màn trong một dòng: ai vào, đến làm gì, xong là thế nào ("quản trị viên chọn gói và trả tiền, xong khi thanh toán được xác nhận"). Lấy từ màn hiện có và lời người dùng, **không lấy từ mẫu**. Liệt kê các trạng thái (đang tải, trống, lỗi, vô hiệu, tràn chữ, màn hẹp) và đánh dấu đang thấy / có trong mã nhưng chưa thấy / chưa có. Từ ảnh chụp chỉ có trạng thái đang chụp.
2. **Đi thử đường dùng** như người đó, qua 6 câu hỏi. Mỗi chỗ gãy là một vấn đề ứng viên:
   1. Mắt có rơi vào bước đầu, có một nút chính hoàn tất việc, không có thứ ngoài đường đi tranh chú ý?
   2. Mỗi quyết định có thông tin ngay bên cạnh, không phải cuộn hay chạm thêm?
   3. Có thiếu thứ việc đó cần không?
   4. Mọi nhãn và giá trị có đúng không (nút làm đúng điều nó ghi, tổng khớp các dòng, icon không nhãn chỉ khi nền tảng đã quen)?
   5. Mọi trạng thái màn đi vào có cho làm xong việc hoặc nói vì sao không?
   6. Mức tối thiểu của nền tảng có đủ (cỡ vùng chạm, chữ nhỏ nhất, độ tương phản)? Xem Apple HIG, Material 3.
   Viết vấn đề theo bước nó chặn ("bước chọn số ghế nằm dưới gói nó tính giá nên chọn giá mù"). "Trông cũ" chưa phải vấn đề cho đến khi chỉ ra bước bị chậm. Lời phàn nàn của người dùng xếp đầu, dùng đúng chữ của họ.
3. **Hỏi người dùng một lượt ngắn**: chọn tối đa 5 vấn đề cần sửa, cái gì phải giữ, chế độ (xem mục Chế độ). Mỗi đáp án và giả định ghi vào **dòng Phạm vi** của báo cáo.
4. **Đóng băng nền**: viết **danh sách Giữ nguyên** theo thứ tự: ngành sản phẩm; hệ thiết kế và giao diện sáng/tối; chữ và dữ liệu của màn (nhãn mới viết theo ngôn ngữ sản phẩm này, không lấy từ mẫu); mọi thứ ngoài phạm vi (nêu rõ ranh giới: tệp và tên hàm, hoặc mép nhìn thấy trong ảnh); phần đã tốt và điều người dùng bảo giữ. Vấn đề chưa chọn vào **sổ Hoãn**, không đưa vào báo cáo.
5. **Tìm mẫu** bằng `tim-mau-ui`, mỗi vấn đề một lượt (tối đa hai trước khi tìm thêm). Nhóm mẫu theo **hướng** khi chúng khác nhau về cấu trúc (tab hay hàng chip; thẻ bấm được hay thẻ có link). **Chọn một hướng làm trọn cho cả màn, không trộn hai hướng**, ghi lý do chọn đủ cụ thể để không biện hộ được cho hướng kia. Đánh dấu mẫu: *chủ đạo* (2 đến 4 mẫu thể hiện rõ hướng), *phụ* (chỉ để lấy một chi tiết), *bỏ* (không trả lời vấn đề nào).
6. **Lập bảng thay đổi**, mỗi vấn đề **một** thay đổi (tối đa 5), mỗi dòng: vấn đề, hướng, mẫu (kèm địa chỉ nguồn), thêm gì, bỏ gì. **Không có mẫu thì không có thay đổi** (chỉ chi tiết nhỏ như vị trí, câu chữ mới do phán đoán). Cắt thay đổi nào: thêm lần hai cho vấn đề đã có; bỏ nội dung màn gốc có (nó vẫn ở trên màn); chuyển nội dung ra khỏi màn; không app nào ở hướng đó làm vậy; thêm chi tiết trang trí (tim yêu thích, huy hiệu, icon trên mọi nhãn, hiệu ứng nâng khi rê chuột, lớp phủ gradient) mà không có vấn đề và hai sản phẩm ở hướng đó làm.
7. **Áp dụng** dưới dạng nguồn đã đến: sửa mã, một khung mới bên cạnh (file thiết kế), PNG (ảnh). Chỉ sửa phần đích; không đổi theme, token, thành phần dùng chung nếu không được bảo. Chỉ dùng thành phần, token, thang cỡ chữ và khoảng cách của sản phẩm; không thêm thư viện, font, bộ icon, mã màu rời. **Lấy cấu trúc của mẫu, không lấy diện mạo** (nền sáng/tối, màu nhấn, font, logo, minh họa).
8. **Kiểm** bằng cách đi lại 6 câu hỏi trên bản mới, cộng: chỉ trạng thái mà thay đổi mới làm tới được mới được vẽ; không gì ngoài đích bị dịch chuyển; không phạm điều cấm bên dưới. Đạt hay không từng câu; sửa trong phạm vi và kiểm lại, tối đa 3 vòng. Câu vẫn rớt thì cắt thay đổi gây ra nó và ghi vào báo cáo. Chạy lệnh kiểm của dự án nếu có (lint, build).
9. **Ảnh trước/sau**: chụp bản mới bằng Playwright (`playwright-cli`, rộng 390 điện thoại hoặc 1440 máy tính) và ghép cạnh ảnh gốc. Ảnh "sau" phải là bản chụp thật, không vẽ lại.
10. **Báo cáo** theo `viet-bao-cao-ui`.

## Chế độ
- **Khám phá**: tối đa 3 phương án, mỗi cái làm trọn một hướng, đặt cạnh bản gốc; chưa áp dụng cho đến khi người dùng chọn.
- **Chỉnh đích**: sửa các vấn đề người dùng chọn thành một thiết kế rồi áp dụng. Mặc định nếu không nói.

## Bằng chứng (luật cứng)
Mọi câu người dùng đọc phải có bằng chứng, chỉ ba loại: (1) màn nguồn, đã đọc hoặc đo; (2) lời người dùng; (3) mẫu bạn **đã nhìn thấy ảnh**, kèm địa chỉ. Hai sản phẩm trở lên là tiền lệ, một là ví dụ, không có là ý kiến của tôi và chỉ lấp một phần của thay đổi, không bao giờ cả thay đổi.
Không viết: "hầu hết app", "chuẩn ngành", "nghiên cứu cho thấy", tên định luật; không hứa kết quả hành vi (tăng chuyển đổi, giữ chân, giảm ma sát); không dùng tính từ cảm tính ("hiện đại", "sạch", "sang") mà không chỉ ra bộ phận; đo bằng pixel trong ghi chú nhưng nói điều nhìn thấy ("nút đóng nay đạt cỡ tối thiểu của nền tảng"); không tả điều ảnh không thể hiện.

## Điều cấm khi dựng (gu)
1. **Không thêm cho có.** Mỗi phần tử mới trả lời một vấn đề trong bảng. Chỗ trống không phải vấn đề: không thêm icon, huy hiệu, đường kẻ, bóng, nền, hình minh họa.
2. **Không thêm chữ khi việc không cần.** Không phụ đề lặp tiêu đề, không dòng giải thích dưới nút đã rõ. Cần chữ thì viết nhãn ngắn nhất, đúng kiểu viết hoa, thì, giọng của chữ xung quanh.
3. **Không thêm gradient** nếu hệ thiết kế chưa có; dùng màu phẳng của phần tử gần nhất.
4. **Không trộn hướng.**
Quy tắc quan hệ: đổi ít nhất có thể để giải quyết vấn đề (sắp xếp lại trước khi tạo kiểu mới); phần mới sao chép phần anh em gần nhất (thành phần, cỡ, độ đậm, vai trò màu, khoảng cách); **một thứ dẫn đầu**, phần mới không vượt thứ phục vụ bước đầu; nhãn nằm cạnh thứ nó nói về, khoảng trong nhóm nhỏ hơn giữa các nhóm; căn theo mép và bậc khoảng cách có sẵn; hai thứ cùng việc thì cùng trông; nút chính/quay lại/đóng nằm đúng chỗ nền tảng quy định. Nếu người đọc nhìn là biết phần nào mới thêm thì đã sai quy tắc phần anh em.

## Giới hạn phải nói thật
Không có kho 600.000 màn của Mobbin: ít mẫu hơn, nên nhiều thay đổi sẽ chỉ có "ví dụ" hoặc "ý kiến của tôi". Ghi rõ điều đó trong báo cáo, và nói phần chưa xem (trạng thái, màn khác).
