---
name: lenis
description: >-
  Thêm cuộn trang mượt (smooth scroll) bằng thư viện Lenis cho website: cài, bật trong React/Next.js hoặc HTML thường,
  nối với GSAP ScrollTrigger, xử lý hộp cuộn lồng nhau, cửa sổ bật lên, link neo. Dùng khi người dùng nói "cuộn mượt",
  "smooth scroll", "Lenis", "web cuộn bị giật", "cuộn kiểu web cao cấp", hoặc khi làm trang cuộn có hiệu ứng theo cuộn.
---

# Lenis: cuộn trang mượt

Thư viện nhỏ của Darkroom Engineering (https://github.com/darkroomengineering/lenis, giấy phép MIT). Làm cuộn chuột/cảm ứng trượt êm thay vì nhảy từng nấc. Đã xem tài liệu chính thức ngày 17/11/2026; thấy API khác với đây thì tin tài liệu mới.

## Khi nào dùng, khi nào không
- Dùng: trang giới thiệu, portfolio, trang kể chuyện có cuộn kèm hiệu ứng.
- Không dùng: ứng dụng/bảng điều khiển nhiều vùng cuộn, trang cần cuộn gốc của trình duyệt (form dài, tài liệu). Cuộn "trượt" có thể làm người dùng chóng mặt: tôn trọng `prefers-reduced-motion` (tắt Lenis khi bật).

## Cài
```bash
npm i lenis
```
CSS cần có (Lenis tự thêm class `lenis` lên `<html>`): thường là `import "lenis/dist/lenis.css";`; nếu đường dẫn không có trong gói đã cài, chép nội dung tệp `lenis.css` của gói (đường dẫn này tôi chưa thử cài thật). Thiếu CSS thì vùng cuộn lồng nhau và iframe dễ lỗi.

## HTML/JS thường
```js
import Lenis from "lenis";
const lenis = new Lenis({ autoRaf: true });   // tự chạy vòng lặp
```
Tắt: `lenis.destroy()`. Dừng/tiếp tục cuộn tạm (mở modal): `lenis.stop()` / `lenis.start()`.

## React / Next.js
```jsx
"use client";
import { ReactLenis } from "lenis/react";
export default function Providers({ children }) {
  return <ReactLenis root>{children}</ReactLenis>;   // root = cuộn cả trang
}
```
Đặt component này ở layout; không bọc từng trang. Lấy instance: `useLenis((lenis) => {...})`.

## Nối với GSAP ScrollTrigger (dùng skill `gsap-scrolltrigger`)
```js
const lenis = new Lenis();
lenis.on("scroll", ScrollTrigger.update);
gsap.ticker.add((time) => lenis.raf(time * 1000));   // giây -> mili giây
gsap.ticker.lagSmoothing(0);
```
React: `<ReactLenis root options={{ autoRaf: false }} ref={lenisRef} />` rồi thêm/bỏ `lenisRef.current?.lenis?.raf(time * 1000)` vào `gsap.ticker` trong `useEffect` (nhớ `gsap.ticker.remove` khi dọn dẹp). Khi nối GSAP thì **không** bật `autoRaf`.

## Những chỗ hay hỏng
- **Hộp cuộn bên trong** (modal, danh sách, bản đồ): thêm thuộc tính `data-lenis-prevent` vào phần tử đó, hoặc dùng tùy chọn `prevent: (node) => node.id === "modal"`.
- **Link neo `#muc`:** mặc định bị chặn; bật `anchors: true`, hoặc gọi `lenis.scrollTo("#muc", { offset: -80 })`.
- **Mở modal:** `lenis.stop()` khi mở, `lenis.start()` khi đóng.
- **Hiệu ứng theo cuộn lệch nhịp:** cho Lenis và GSAP dùng chung một vòng lặp (mục nối GSAP), đừng chạy hai `requestAnimationFrame` riêng.
- Tùy chỉnh độ êm: `lerp` (nhỏ = êm hơn) hoặc `duration`; chọn một trong hai.

## Kiểm
Chụp ảnh và cuộn thử bằng Playwright (`playwright-cli`); báo rõ phần chưa thử trên điện thoại thật. Kết hợp: `scroll-craft`, `motion`, `hoc-tu-web-mau`.
