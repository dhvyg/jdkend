---
name: tim-mau-ui
description: >-
  Tìm ảnh giao diện app/web THẬT, miễn phí (không cần tài khoản Mobbin) để làm mẫu trước khi thiết kế hoặc sửa một màn hình:
  nguồn nào dùng được, cách viết câu tìm, cách xem ảnh và chọn mẫu đáng tin. Dùng khi người dùng nói "tìm mẫu giao diện",
  "xem app khác làm màn hình này thế nào", "tham khảo màn đăng nhập/thanh toán/onboarding", "Mobbin miễn phí".
---

# Tìm mẫu giao diện thật, không tốn tiền

Dựa theo skill `search` của mobbin/skills (MIT, © 2026 Mobbin), viết lại cho nguồn miễn phí. Mobbin có hơn 600.000 màn hình; bản này **không có kho đó**, nên mẫu ít hơn và phải tự xem từng ảnh. Đã mở thử các địa chỉ dưới đây ngày 18/11/2026.

## 1. Nguồn dùng được (từ chắc nhất đến yếu nhất)
| Nguồn | Dùng cho | Ghi chú |
|---|---|---|
| Ảnh chụp trên trang App Store / Google Play của app (`apps.apple.com/...`, `play.google.com/store/apps/details?id=...`) | Màn hình app thật, miễn phí | Chỉ có ảnh quảng bá của nhà làm app, thường 5 đến 10 màn, không đủ mọi trạng thái |
| App người dùng đang có (TikTok, Facebook, Netflix, YouTube...) | Màn hình thật, đủ trạng thái | Nhờ người dùng gửi ảnh chụp màn hình; Claude không tự mở app được |
| Hướng dẫn nền tảng: Apple HIG `developer.apple.com/design/human-interface-guidelines`, Material 3 `m3.material.io` | Kích thước tối thiểu, vị trí nút chính/quay lại/đóng | Là quy tắc, không phải mẫu đẹp |
| Refero `refero.design` | Kho ảnh UI web và iOS, tìm theo từ khóa | Tôi chưa kiểm giới hạn gói miễn phí: thử, nếu bị chặn thì bỏ |
| Phần web (hero, bảng giá, navbar...) | Trang web, không phải app | Xem `hoc-tu-web-mau` mục 1b |
| CollectUI `collectui.com`, Dribbble, Behance | Ý tưởng | Là bản thiết kế ý tưởng, **không chứng minh** app thật làm vậy. Ghi rõ "ý tưởng" khi dùng |
| Page Flows `pageflows.com` (screenlane.com chuyển về đây) | Luồng dùng thật có quay màn hình | **Trả phí** (gói thử 3 ngày giá $2,95 lúc xem): không dùng mặc định |

## 2. Viết câu tìm (giữ các quy tắc của skill gốc)
- **Một màn hình, một luồng hoặc một phần mỗi lần tìm.** Mở đầu bằng loại màn: "màn hình đăng nhập", "paywall", "màn trống danh sách".
- **Tối đa 3 điều kiện** (trạng thái, bước, bộ phận nhìn thấy, đặc điểm như dark mode, bottom sheet). Loại màn, ngành ("app thiền", "app ngân hàng") và tên app không tính.
- **Mọi điều kiện đến từ yêu cầu hoặc vấn đề**, đừng thêm bộ phận bạn đoán là có. Không đưa cách sửa vào câu tìm.
- **Tìm đúng cấp của đích:** đích là màn hình thì tìm cả màn, không tìm một thẻ trong màn. Đích là thành phần thì tìm màn chứa nó.
- **Chọn giữa các cách làm:** gọi tên bộ phận, không gọi tên một cách ("paywall có thẻ gói và nút dùng thử", không phải "paywall có nút chuyển năm").
- **Không cho vào câu tìm** chữ, dữ liệu, thương hiệu của người dùng, hay từ cảm tính ("đẹp", "hiện đại").
- Tìm bằng tiếng Anh cho kho nước ngoài. Dùng `firecrawl_search` với `site:` hoặc `includeDomains` để giới hạn vào một nguồn.

## 3. Xem ảnh rồi mới tính là mẫu
1. **Mở ảnh và nhìn** (tải ảnh về scratchpad rồi dùng Read, hoặc chụp bằng Playwright). Ảnh không mở được thì **không trích dẫn**.
2. Một mẫu chỉ tính khi **quyết định thiết kế cần học nhìn thấy được trong ảnh**, không phải chỉ có trong tiêu đề hay mô tả.
3. **Đếm sản phẩm, không đếm ảnh:** hai mươi ảnh của một app là một mẫu. Từ hai sản phẩm trở lên cho cùng một quyết định mới gọi là "nhiều app cùng làm"; một sản phẩm là "ví dụ".
4. Ghi mỗi mẫu: tên app, địa chỉ nguồn, ngày xem, **cái học được** và **cái không lấy** (màu, chữ, nội dung, logo).
5. App khác ngành chỉ cho cấu trúc: ghi rõ "chỉ lấy cấu trúc".

## 4. Khi tìm không ra
- Tên app không xuất hiện: thử cách viết khác của tên đó, rồi tìm theo loại màn. **Không tả app đó theo trí nhớ** và không lấy app khác thay vào.
- Ít kết quả nghĩa là nguồn miễn phí thiếu, không phải app không có. Nói thẳng "tôi chỉ tìm được N app" thay vì thổi phồng.
- Bị chặn (đăng nhập, trả phí): nói một dòng rồi dừng nguồn đó, không lách.
- Chưa đủ hai sản phẩm cho một quyết định thì ghi là ý kiến của tôi, không giả làm tiền lệ.

Dùng cùng: `thiet-ke-lai-man-hinh` (sửa một màn), `quy-tac-mau-ui` (giới hạn), `hoc-tu-web-mau` (web).
