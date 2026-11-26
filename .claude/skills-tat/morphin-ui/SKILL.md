---
name: morphin-ui
description: >-
  Dùng kho thành phần Morphin UI (29 thành phần React có chuyển động, miễn phí MIT: nút, menu, ô nhập, bảng dữ liệu, toast, chat, ô nhập
  prompt...) bằng morphinui hoặc shadcn CLI. Dùng khi người dùng nói "Morphin", "thành phần React có chuyển động", "web đỡ bị vibe-coded",
  "copy component vào dự án React", hoặc làm giao diện React/Tailwind cần chi tiết tương tác tinh.
---

# Morphin UI

Kho thành phần **dạng shadcn registry**: lệnh cài chép mã vào dự án và thuộc về dự án (https://morphin.dev, docs https://morphin.dev/docs). Đã xem tài liệu `/docs` và `/docs/installation` ngày 20/11/2026; kiểm thấy `https://morphin.dev/r/button.json` trả về được và gói npm `morphinui` bản 0.1.2 (đẩy 29/10/2026). Trang tài liệu có dòng "Early access" nói registry chưa mở, nhưng thực tế đã mở: tin kiểm thật, và thấy khác thì tin trang mới.

## Miễn phí và trả phí
- **29 thành phần miễn phí**, giấy phép MIT, không cần tài khoản hay khóa: Button, Button Group, Split Button, Link Button, Dropdown, Select, Input, Textarea, Checkbox, Radio, Switch, Slider, Date Picker, Badge, Chip, Avatar, Card, Announcement, Action Card, Toast, Spinner, Skeleton, Data Table, Bar Chart, Prompt Input, Chat, Modal, Tabs, Accordion. Thêm 2 khối cả màn hình (vd AI Chat).
- **7 thành phần "Max" là gói Lifetime trả phí** (cần `npx morphinui@latest login`): không cài và không giới thiệu trừ khi người dùng hỏi. Thành phần miễn phí không bao giờ phụ thuộc Max.
- Số bài viết ghi 27 thành phần, trang hiện nay ghi 29: trang có thể đổi tiếp.

## Điều kiện
React 19, Tailwind CSS v4, TypeScript khuyến nghị (alias `@/*`), framework nào cũng được (Next.js, Vite, React Router, Astro...). Nền dùng Base UI, chuyển động bằng GSAP. **Không dùng được cho React Native/Expo**: dự án HTML thường hay Expo thì học ý tưởng rồi tự viết lại.

## Cài
```bash
npx morphinui@latest init            # tạo components.json nếu chưa có, thêm registry @morphin
npx morphinui@latest add button dropdown    # tên là đủ; mỗi thành phần kéo theo phần phụ thuộc
npx morphinui@latest list            # xem tất cả
```
- `init --theme` **thay bảng màu và cỡ chữ hiện có** bằng của Morphin: chỉ dùng khi người dùng muốn; mặc định bỏ cờ này.
- Cách khác bằng shadcn CLI: thêm `"registries": { "@morphin": "https://morphin.dev/r/{name}.json" }` vào `components.json`, rồi `npx shadcn@latest add @morphin/button`.
- Mã vào `components/ui/<tên>.tsx`, kèm `lib/motion.tsx` và `lib/sound.tsx`; nếu dự án đã có `button.tsx` của shadcn, CLI hỏi trước khi ghi đè: trả lời **không** nếu chưa đọc khác biệt.

## Dùng
- Tài liệu cho máy đọc: `https://morphin.dev/llms.txt` (mục lục) và `/llms-full.txt` (cả thư viện trong một file). Đọc trang của thành phần trước khi dùng, không đoán props; mỗi trang có Preview, Cài đặt, Cách dùng, API và Trợ năng.
- Thành phần đã cài là mã của dự án: **sửa tại chỗ** cho hợp thương hiệu; màu lấy từ các biến shadcn (`--primary`, `--border`...), chế độ tối bằng lớp `.dark`.
- Chuyển động tự theo `prefers-reduced-motion`; âm thanh tùy chọn, mặc định tắt.
- Đừng để cả trang toàn thành phần mẫu: chọn vài cái đúng chỗ, giữ một hệ màu và chữ (xem `design-md`, `hoc-tu-web-mau`, `kokonut-ui`).

## Kiểm
Dựng trang, chụp ảnh máy tính và điện thoại (sáng và tối), thử bàn phím và bật giảm chuyển động. Báo rõ phần chưa thử. Tôi chưa chạy lệnh cài thật trong một dự án.
