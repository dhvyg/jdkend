---
name: kokonut-ui
description: >-
  Dùng kho thành phần Kokonut UI (nhiều thành phần React/Tailwind có chuyển động, nhiều cái cho giao diện AI: ô chat,
  nút hạt, đồng hồ xoay, thanh trượt...) bằng shadcn CLI. Dùng khi người dùng nói "Kokonut", "thành phần có sẵn",
  "nút/ô nhập chat AI đẹp", "chép component vào dự án React", hoặc khi làm giao diện React cần chi tiết tương tác lạ.
---

# Kokonut UI

Kho thành phần mã nguồn mở (MIT) dạng **shadcn registry**: lệnh cài chép mã vào dự án và thuộc về dự án (https://kokonutui.com, https://github.com/kokonut-labs/kokonutui, tác giả Dorian Baffier). Đã xem tài liệu `kokonutui.com/docs` và `/docs/agents` ngày 17/11/2026. Có bản **Kokonut UI Pro** trả phí (kokonutui.pro): chỉ nhắc nếu người dùng hỏi; không tự thêm.

## Điều kiện
React hoặc Next.js, Tailwind CSS v4, đã `shadcn init` (có `components.json`). Không phải dự án này thì học ý tưởng rồi tự viết lại.

## Thiết lập một lần
1. Thêm registry vào `components.json`:
```json
{ "registries": { "@kokonutui": "https://kokonutui.com/r/{name}.json" } }
```
2. Cài hàm tiện ích (`cn`): `npx shadcn@latest add https://kokonutui.com/r/utils.json`.
3. (Tùy chọn, cho agent tự tìm/cài) `npx shadcn@latest mcp init --client claude`, hoặc đọc `https://kokonutui.com/setup.md`.

## Tìm và cài
- Danh sách tất cả: `https://kokonutui.com/llms.txt` (mỗi thành phần một dòng mô tả). Chi tiết một thành phần kèm mã đầy đủ: thêm `.md` vào địa chỉ trang, ví dụ `https://kokonutui.com/docs/buttons/particle-button.md`. Chỉ mục kỹ thuật: `https://kokonutui.com/r/registry.json`.
- Cài: `npx shadcn@latest add @kokonutui/particle-button` → mã vào `components/kokonutui/`, tự cài `motion`, `lucide-react` và các primitive shadcn cần. Monorepo: thêm `-c ./apps/<tên>`.
- Dùng: `import ParticleButton from "@/components/kokonutui/particle-button";`
- Ưu tiên lệnh CLI hơn chép tay (chép tay dễ thiếu tệp và phụ thuộc).

## Quy tắc khi dùng
- Trước khi tự viết một thành phần chuyển động/tương tác, xem `llms.txt` có sẵn chưa.
- Thành phần đã cài là mã của dự án: **sửa tại chỗ** cho hợp thương hiệu (màu, chữ, kích thước), không bọc thêm lớp.
- Không để hết trang toàn thành phần mẫu: chọn vài cái đúng chỗ, giữ một hệ thống màu và chữ (xem `design-md`, `hoc-tu-web-mau`).
- Kiểm tra trước khi giao: dựng, chụp ảnh máy tính và điện thoại, thử tab bằng bàn phím, và bật `prefers-reduced-motion` thử xem chuyển động có giảm không. Nói rõ phần chưa thử.
