---
name: uiverse-galaxy
description: >-
  Kho ~3.800 thành phần giao diện HTML/CSS (một số dùng Tailwind) miễn phí, MIT, từ Uiverse.io (repo uiverse-io/galaxy):
  nút bấm, thẻ (card), loader, công tắc, checkbox, radio, ô nhập, form, tooltip, thông báo, họa tiết nền.
  Dùng khi người dùng muốn nút/loader/card/toggle... đẹp, có hiệu ứng, cho trang web hoặc app, hoặc nói
  "lấy mẫu từ uiverse", "nút đẹp", "hiệu ứng loading", "giao diện có sẵn".
---

# Uiverse Galaxy

Mỗi file là một thành phần độc lập: HTML ở trên, `<style>` ở dưới. Dòng chú thích đầu CSS ghi tác giả và tag, ví dụ
`/* From Uiverse.io by 0x-Sarthak  - Tags: button, hover, rounded, animated */`.

## 1. Lấy kho về (không lưu trong repo; ~20 MB, mỗi phiên mới tải lại)
```bash
G=~/.cache/uiverse-galaxy
test -d "$G" || git clone -q --depth 1 https://github.com/uiverse-io/galaxy "$G"
```

## 2. Tìm theo tag
Thư mục: `Buttons` (~1230), `Cards` (~730), `loaders` (~720), `Toggle-switches`, `Inputs`, `Forms`, `Checkboxes`,
`Radio-buttons`, `Patterns`, `Tooltips`, `Notifications`.
```bash
grep -l -i "Tags:.*neumorphism" "$G"/Buttons/*.html | head -20      # tìm theo tag
grep -h -o "Tags:.*\*/" "$G"/loaders/*.html | tr ',' '\n' | sort | uniq -c | sort -rn | head -30   # các tag phổ biến
```
Đọc 3–5 ứng viên, chọn cái hợp yêu cầu nhất. Muốn cho người dùng xem trước: ghép vài mẫu vào một trang HTML rồi chụp màn hình bằng Playwright, hoặc publish thành Artifact.

## 3. Dùng
- Đổi tên class nếu trùng với CSS sẵn có; đổi màu, chữ theo dự án.
- Giữ dòng chú thích tác giả `From Uiverse.io by ...` khi chép vào code (MIT, tác giả mong được ghi công).
- Kho dừng cập nhật từ 9/2024; mẫu mới hơn chỉ có trên uiverse.io.
