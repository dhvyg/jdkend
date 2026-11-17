---
name: hoc-tu-web-mau
description: >-
  Trước khi làm hoặc sửa một website/landing page/giao diện, xem 5 nguồn tham khảo thiết kế (Prompt Motion, Grainient,
  Variant, Eyecandy, Rare UI) và thư viện mẫu theo loại phần (hero, bảng giá, navbar, bằng chứng xã hội, email, slide,
  quảng cáo, ảnh OG) rồi rút ra kỹ thuật cụ thể để áp dụng, thay vì để Claude tự vẽ kiểu "AI làm". Dùng khi
  người dùng nói "làm website", "làm landing page", "thiết kế trang web", "làm đẹp web", "web nhìn như AI làm",
  "học kỹ thuật từ web mẫu".
---

# Học kỹ thuật từ web mẫu rồi mới làm

Claude không tự biết "đẹp" là gì, nên **phải cho nó xem thứ đẹp trước khi vẽ**. Lấy *kỹ thuật* (bố cục, màu, chữ, chuyển động, chất liệu), không chép nguyên tác phẩm.

## 1. Chọn nguồn theo việc cần làm (xem 2–3 cái, không cần đủ 5)
| Nguồn | Địa chỉ | Lấy gì | Ghi chú |
|---|---|---|---|
| Prompt Motion | https://prompt-motion.com | ~240 video chuyển động làm bằng Claude, kèm đúng prompt/skill đã dùng: chữ chuyển động, ảnh sản phẩm, hero | Miễn phí. Có tên miền giống hệt `promptmotion.org` nhưng chưa xác minh cùng chủ; ưu tiên `.com` ("bản gốc" theo trang) |
| Grainient | https://grainient.supply | Gradient hạt (grain), mesh, dither, nền động; có trình sửa shader | **Trả phí** ($59/năm hoặc $299 trọn đời, giá lúc xem 17/11/2026). Chỉ xem để học; muốn nền động miễn phí thì dùng skill `paper-shaders` |
| Variant | https://variant.com | Cuộn là ra vô số thiết kế AI: bố cục, ý tưởng cho trang/app | Dùng để chọn hướng, không dùng làm sản phẩm cuối |
| Eyecandy | https://eyecannndy.com | Thư viện kỹ thuật hình ảnh từ phim: Floating UI, Typography, Vintage, Wide shot, Whip pan... | Ba chữ n. Ảnh là cảnh phim có bản quyền: **chỉ lấy ý tưởng, không nhúng ảnh** |
| Rare UI | https://www.rareui.com | ~30 thành phần React có chuyển động lạ (toast, theme selector, thư mục mở...) | Miễn phí, mã nguồn mở, sinh bởi shadcn CLI; xem mục 4 |

### 1b. Thư viện mẫu theo từng loại phần/trang (chọn đúng loại đang làm)
Nguồn: danh sách 10 trang của Will Francis (video TikTok, 20/10/2026). Đã mở từng trang xác nhận còn hoạt động ngày 17/11/2026.
| Đang làm | Trang | Có gì |
|---|---|---|
| Cả trang, nhiều ngành | https://land-book.com | Thư viện thiết kế web chọn tay, lọc theo trang, phần (section), mobile, chuyển động, ảnh OG, tiêu đề |
| Hero (phần đầu trang) | https://supahero.io | Thư viện hero của web, thuộc screensdesign |
| Bảng giá | https://pricingpages.design | Ví dụ trang giá của SaaS, thương mại điện tử, agency; lọc theo thành phần và kiểu thiết kế |
| Tin tưởng, đánh giá khách | https://socialproofexamples.com | 191 ví dụ bằng chứng xã hội kèm lý do tâm lý |
| Thanh điều hướng (navbar) | https://navbar.gallery | Navbar tĩnh, thả xuống, mega menu, thanh bên, thanh thông báo, toàn màn hình, tab |
| Email | https://reallygoodemails.com | Hơn 19.000 email: chào mừng, bản tin, bỏ giỏ hàng, ra mắt, khuyến mãi |
| Slide giới thiệu | https://deck.gallery | Hơn 240 bộ slide và 14.000 slide; xem đầy đủ cần gói Pro |
| Bài đăng mạng xã hội | https://posts.design | Hơn 4.600 bài của 1.130 thương hiệu, kèm ảnh bìa X và ảnh OG |
| Quảng cáo SaaS | https://adfolio.design | Hơn 240 quảng cáo B2B trên Meta, LinkedIn, có giải thích; lọc theo ngành, nền tảng, ưu đãi, góc tiếp cận |
| Ảnh xem trước khi chia sẻ link (OG) | https://ogimage.gallery | Ảnh OG chọn tay, lọc theo SaaS, portfolio, cửa hàng, ứng dụng... |
Các thư viện này là ảnh chụp sản phẩm của người khác: chỉ lấy ý tưởng (bố cục, thứ tự, cách viết), không chép ảnh, chữ hay logo của họ.

## 2. Xem thật, không đoán
- Đọc trang bằng `firecrawl_scrape`; muốn **nhìn** thì chụp ảnh bằng Playwright (desktop 1440 và điện thoại 390) rồi đọc ảnh.
- Mỗi nguồn chọn 2–3 mẫu sát yêu cầu, không lướt hết.

## 3. Viết "ghi chú kỹ thuật" trước khi code (5–8 dòng, cụ thể)
Mỗi dòng là một thứ làm được ngay, ví dụ: "nền kem #F4F1EA + một màu nhấn duy nhất", "chữ tiêu đề cỡ 96px, giãn dòng 0.95", "thẻ nổi có 3 lớp bóng, lệch 8px", "easing 0.22,1,0.36,1, 600ms, trễ 60ms mỗi phần tử". Ghi nguồn từng dòng. Có thể lưu thành `DESIGN.md` (skill `design-md`). Chưa có ghi chú thì chưa code.

## 4. Dùng Rare UI
Dự án cần React + Tailwind + shadcn + `motion`. Lệnh mẫu (ví dụ thành phần `fluid-orb`):
`npx shadcn@latest add swamimalode07/rare-ui/fluid-orb`. Mã được chép vào dự án và thuộc về bạn. Trước khi dùng, mở trang thành phần đó đọc giấy phép (trang chủ chỉ ghi "mã nguồn mở", không nêu tên giấy phép). Dự án HTML thường: học ý tưởng tương tác rồi tự viết lại bằng CSS/JS.

## 5. Tránh những dấu hiệu "AI làm" (bài gốc đánh dấu các lỗi này)
Chữ gradient · nền tím chuyển màu và "AI-powered" · chữ nhạt khó đọc (độ tương phản thấp) · nhãn con nhộng (pill) phía trên tiêu đề · tiêu đề chữ serif nghiêng làm điểm nhấn cho đẹp · số liệu 10K+/99,9% rập khuôn. Dùng thì phải có lý do từ mẫu đã xem.

## 6. Làm xong phải kiểm
Chụp ảnh desktop và điện thoại, đối chiếu với ghi chú ở mục 3, rồi chạy `unslop` hoặc `impeccable` để bắt lỗi còn sót. Báo người dùng: đã học kỹ thuật nào từ nguồn nào, cái gì chưa xem được (trang chặn, cần trả phí).
Phối hợp: `taste-skill` (trang công ty), `emil-design-eng`, `motion` (chuyển động), `stageshow` (giao diện giả để khoe sản phẩm).
