---
name: video-ai-dien-anh
description: >-
  Quy trình làm video AI có chất phim điện ảnh bằng 7 repo mã nguồn mở (ComfyUI, Wan 2.2, LTX-Video, HunyuanVideo, FramePack,
  Practical-RIFE, Video2X): repo nào làm bước nào, cần máy gì, giấy phép ra sao, và Claude giúp được gì. Dùng khi người dùng nói
  "video AI nhìn rẻ tiền", "làm video AI chất điện ảnh", "ComfyUI", "Wan", "tạo video bằng model chạy máy", "tăng fps/upscale video AI".
---

# Video AI chất điện ảnh: 7 repo và thứ tự dùng

Nguồn: bài đăng TikTok 8 trang của @chuanhdn ("Video AI của bạn nhìn rẻ tiền không phải do tool dở, là do thiếu 7 repo GitHub này"). Số sao/ngày đẩy dưới đây tôi kiểm lại trên GitHub ngày 18/11/2026. Câu "cài vào là ra chất phim" là lời quảng cáo của bài; **chất lượng phụ thuộc kịch bản cảnh, lời nhắc (prompt) và model, không phải số repo**.

## Đây KHÔNG phải skill hay plugin
Bài ghi "PLUGIN" nhưng cả 7 là phần mềm/model tạo video, chạy trên card đồ họa. **Máy Claude cloud này không có GPU** (kiểm: không có `nvidia-smi`), nên tôi **không cài hay chạy** được chúng ở đây. Chúng chạy trên máy Windows/Linux có card Nvidia của bạn, hoặc máy GPU thuê. FramePack ghi rõ cần card Nvidia RTX 30/40/50 và ít nhất 6GB VRAM (README). Điện thoại không chạy được.

## Thứ tự trong quy trình
| Bước | Repo | Làm gì | Giấy phép · sao · đẩy lần cuối |
|---|---|---|---|
| 0. Trung tâm | `Comfy-Org/ComfyUI` | Kéo thả các khối (node) nối model tạo ảnh, tạo video, upscale, chỉnh màu thành một quy trình | GPL-3.0 · 147K · 18/11/2026 |
| 1. Tạo cảnh | `Wan-Video/Wan2.2` | Model video của Alibaba, mạnh về chuyển động máy quay, ánh sáng, bố cục; chữ-sang-video và ảnh-sang-video | Apache-2.0 · 18,7K · 21/9/2026 |
| 1. Tạo cảnh | `Lightricks/LTX-Video` | Tạo nhanh, hợp để thử nhiều phương án góc máy rồi chọn bản đẹp nhất | Apache-2.0 · 11,4K · 2/11/2026 |
| 1. Tạo cảnh | `Tencent-Hunyuan/HunyuanVideo` | Model của Tencent, mạnh về mặt người và chuyển động người | **Giấy phép riêng** (GitHub ghi NOASSERTION): đọc `LICENSE` trước khi dùng thương mại · 12,8K · 8/10/2026 |
| 2. Kéo dài | `lllyasviel/FramePack` | Tạo video dài trên máy VRAM thấp (README: 1 phút 30fps cần tối thiểu 6GB) | Apache-2.0 · 17,4K · 16/10/2025 (lâu chưa cập nhật) |
| 3. Mượt | `hzwer/Practical-RIFE` | Nội suy khung hình, tăng 24fps lên 60fps | MIT · 1,0K · 27/8/2026 |
| 4. Nét | `k4yt3x/video2x` | Phóng to video lên 2K/4K, bước cuối bớt cảm giác mờ | **AGPL-3.0** · 22,8K · 7/3/2026 |

Chọn **một** model ở bước 1, không cần cả ba. Bước 2 chỉ khi cần cảnh dài. Các bước 3 và 4 là hậu kỳ.

## Claude giúp được gì (không cần GPU)
1. **Danh sách cảnh** (shot list): mỗi cảnh một câu có chủ thể, góc máy, ánh sáng, chuyển động, dài mấy giây; dùng được cho cả ba model ở bước 1.
2. **Viết prompt** từng cảnh, thử nhiều biến thể cho LTX-Video (nhanh) rồi chọn bản để làm kỹ bằng Wan 2.2.
3. **Lệnh ffmpeg** ghép cảnh, cắt, chỉnh màu, thêm tiếng (xem `edit-video`, `real-sfx`); kiểm kết quả bằng `ffprobe` và khung hình trích ra, không bằng cảm giác.
4. **Đọc README từng repo** và đưa đúng bước cài cho máy của bạn. Tôi **không bịa lệnh cài**: lấy từ README ở thời điểm đó, và hỏi bạn hệ điều hành, hãng và dung lượng bộ nhớ card trước.
5. Giấy phép: nhắc khi video bán ra ngoài (HunyuanVideo giấy phép riêng; ComfyUI GPL-3.0 và Video2X AGPL-3.0 ảnh hưởng nếu bạn đóng gói hay cung cấp dịch vụ dựa trên mã của họ, không ảnh hưởng chuyện bạn đăng video làm ra).

## Nếu không có card Nvidia
Dùng dịch vụ có sẵn: kết nối Higgsfield (skill `higgsfield`) hoặc `ai-image-creator`, hoặc thuê máy GPU rồi chạy ComfyUI ở đó. Mỗi cách tốn tiền hoặc giới hạn riêng; tôi chưa thử cái nào trong phiên này.

## Chưa kiểm
Tôi chưa chạy repo nào, chưa kiểm số liệu VRAM của Wan, LTX, Hunyuan (README mỗi repo mỗi khác), và chưa xem video mẫu đầu ra. Báo người dùng điều đó khi đưa kế hoạch.
