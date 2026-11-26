---
name: tim-y-tuong
description: >-
  Tìm ý tưởng kinh doanh/app mà người ta ĐÃ trả tiền: lấy sản phẩm có doanh thu được xác minh (TrustMRR, xếp hạng app,
  sàn TMĐT), đọc đánh giá xấu của chúng, rồi đề xuất bản làm tốt hơn đúng chỗ khách đang chê. Dùng khi người dùng hỏi
  "tìm ý tưởng kinh doanh", "nên làm app gì", "ý tưởng kiếm tiền với AI", "sản phẩm nào đang bán được", "làm gì để có
  khách trả tiền". Kiểm chứng sâu một ý tưởng đã chọn thì chuyển sang validate-hypothesis.
---

# Tìm ý tưởng từ doanh thu thật và lời chê thật

Ý chính: đừng bắt đầu từ ý tưởng tự nghĩ. Bắt đầu từ thứ **đã có người trả tiền**, rồi làm tốt hơn ở chỗ khách **đang chê**.

## 1. Hỏi nhanh (tối đa 3 câu, có sẵn thì bỏ qua)
- Bạn làm được gì / có gì: kỹ năng, thời gian mỗi tuần, vốn, biết code hay không.
- Bán cho ai: người Việt hay nước ngoài, cá nhân hay doanh nghiệp.
- Dạng sản phẩm muốn làm: app/web (SaaS), app điện thoại, hàng hóa, dịch vụ.

## 2. Tìm sản phẩm đang có doanh thu thật
Chỉ dùng nguồn có số liệu xác minh; ghi rõ nguồn và ngày xem cho mọi con số.
- **TrustMRR** (https://trustmrr.com): doanh thu startup xác minh qua kết nối Stripe; trang `/startup/<tên>` có doanh thu, danh mục, giá bán.
  Đọc bằng `firecrawl_scrape`. Đây là dữ liệu chủ yếu của thị trường nước ngoài, nghiêng về sản phẩm nhỏ do một người làm.
- **App điện thoại:** xếp hạng "có doanh thu cao nhất" trên App Store / Google Play theo danh mục.
- **Thị trường Việt Nam:** Shopee/Lazada/TikTok Shop (lượt bán, số đánh giá), Google Maps (quán, dịch vụ đông khách), nhóm Facebook (người hỏi mua gì nhiều).
- Có sẵn trong phiên: Firecrawl/Alexandria (`firecrawl_search`, `alexandria_library_search`) để tìm nhà cung cấp dữ liệu app, công ty.

Chọn 5–10 sản phẩm hợp với mục 1. **Không** dùng ảnh chụp doanh thu khoe trên mạng xã hội làm bằng chứng.

## 3. Đọc lời chê
Với mỗi sản phẩm, gom 20–50 đánh giá 1–3 sao: App Store/Google Play, Trustpilot, G2, Capterra, Reddit, đánh giá Shopee, bình luận Facebook/TikTok.
Gom thành nhóm lời chê và đếm số lần lặp lại:

| Nhóm chê | Ví dụ thường gặp |
|---|---|
| Giá / thu tiền | gói dùng thử lừa, khó hủy, tính tiền bất ngờ |
| Khó dùng | giao diện rối, bấm không chạy, chậm |
| Thiếu tính năng | không xuất file, không có tiếng Việt, thiếu tích hợp |
| Kết quả kém | AI làm sai, chất lượng không như quảng cáo |
| Hỗ trợ | không trả lời, lỗi lâu không sửa |

Trích nguyên văn 1–2 câu chê tiêu biểu cho mỗi nhóm, kèm link nguồn.

## 4. Đề xuất cơ hội
Mỗi cơ hội gồm:
1. Sản phẩm gốc + doanh thu xác minh (nguồn, ngày).
2. Lời chê lớn nhất (số lần lặp, trích dẫn).
3. Bản làm tốt hơn: sửa đúng lời chê đó, **một** điểm khác biệt rõ, không sao chép tên, giao diện, nội dung của sản phẩm gốc.
4. Vì sao hợp với người dùng (kỹ năng, thị trường, ngôn ngữ — vd bản tiếng Việt cho người Việt).
5. Phiên bản nhỏ nhất làm được trong 1–2 tuần, và cách thu tiền.
6. Rủi ro: đối thủ lớn, chi phí AI/máy chủ, pháp lý, nền tảng chặn.
7. Mức chắc chắn: cao / trung bình / thấp, và vì sao.

Xếp 3–5 cơ hội tốt nhất lên đầu. Kết thúc bằng bước tiếp theo rẻ nhất để thử có người trả tiền thật
(trang giới thiệu + nút đặt trước, hỏi 10 người trong nhóm khách) — chi tiết dùng skill `validate-hypothesis`.

## Không làm
- Không bịa doanh thu, số lượt tải, số đánh giá; không thấy số thì ghi "chưa có số liệu".
- Không hứa thu nhập; doanh thu của người khác không có nghĩa người dùng sẽ kiếm được như vậy.
- Không khuyên sao chép sản phẩm, thương hiệu, nội dung của người khác hay làm sản phẩm vi phạm luật.
- Không đưa lời khuyên đầu tư hay vay tiền để làm.
