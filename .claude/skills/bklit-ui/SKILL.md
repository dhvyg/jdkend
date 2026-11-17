---
name: bklit-ui
description: >-
  Dựng biểu đồ và trực quan hóa dữ liệu đẹp cho dashboard bằng Bklit UI (thành phần React trên shadcn/ui): biểu đồ
  đường, vùng, cột, phễu, nến, v.v., có tooltip, hiệu ứng vào, trạng thái đang tải. Dùng khi người dùng nói "vẽ biểu
  đồ", "dashboard", "chart cho React", "Bklit", "biểu đồ đẹp kiểu shadcn", hoặc làm trang có số liệu theo thời gian.
---

# Bklit UI: biểu đồ cho React

Thư viện biểu đồ ghép từ các thành phần nhỏ, dựng trên shadcn/ui (https://bklit.com, mã nguồn https://github.com/bklit/bklit-ui, MIT). Do một cá nhân (uixmat) duy trì. Đã xem tài liệu `bklit.com/docs` và trang Line Chart ngày 17/11/2026. Danh sách đầy đủ các loại biểu đồ và props: mở trang `https://bklit.com/docs/components/<tên-biểu-đồ>` (ví dụ `line-chart`, `funnel-chart`, `candlestick-chart`, `area-chart`) rồi đọc; không đoán props.

## Điều kiện
Dự án React/Next.js có Tailwind và shadcn/ui (`components.json`). Dự án HTML thường thì không dùng được: chọn thư viện khác hoặc vẽ SVG tay.

## Cài một biểu đồ
```bash
pnpm dlx shadcn@latest add @bklit/line-chart
```
(npm: `npx shadcn@latest add @bklit/line-chart`). Lệnh cài thêm phần phụ thuộc cần thiết. Nếu phải cài tay: `d3-shape d3-scale d3-array motion`.

## Dùng: ghép thành phần, không truyền một object cấu hình lớn
```tsx
import { LineChart, Line, Grid, XAxis, ChartTooltip } from "@bklitui/ui/charts";

const data = [{ date: new Date("2025-01-01"), users: 1200 }, /* ... */];

<LineChart data={data}>
  <Grid horizontal />
  <Line dataKey="users" />
  <XAxis />
  <ChartTooltip />
</LineChart>
```
- Dữ liệu là mảng object có trường `date` kiểu `Date` (đổi tên bằng `xDataKey`).
- Thứ tự con quan trọng: lớp nền (`Grid`, `Band`, `LineBackdrop`) đặt **trước** `Line`; `TrendLine` đặt **sau** `Line`.
- Màu và nền lấy từ biến CSS `--chart-*` (có bản sáng và tối `.dark`); đổi giao diện bằng cách sửa biến, không sửa từng biểu đồ.

## Cập nhật dữ liệu và trạng thái tải
- Đổi dữ liệu (lọc 7/30/90 ngày, gọi lại API) thì cứ truyền `data` mới; biểu đồ tự chuyển mượt. **Đừng** truyền hay đổi `revealSignature` (chỉ để phát lại hiệu ứng vào).
- Đang tải: một biểu đồ duy nhất, đổi `status="loading"` sang `"ready"` khi có dữ liệu (kèm `loadingLabel="..."`); không thay bằng component khác.

## Thêm tùy chọn khi cần
Điểm đánh dấu sự kiện (`ChartMarkers`), kéo chọn đoạn (`SegmentBackground`...), thu phóng (`@bklit/brush`), cột mốc (`Deadline`, `Weekends`), dải (`Band`), dự báo (`ProjectionLine`). Mỗi cái có trang docs riêng và có thể cần `shadcn add` riêng.

## Studio
`https://bklit.com/studio` cho chỉnh biểu đồ bằng giao diện rồi lấy mã; mỗi ví dụ trong docs có nút "Open in Studio".

## Kiểm
Dựng trang, chụp ảnh sáng/tối, bấm rê chuột thử tooltip, thử dữ liệu rỗng và một điểm. Chữ trên biểu đồ phải đọc được (độ tương phản). Kết hợp: `data:create-viz`/`dataviz` cho chọn loại biểu đồ, `hoc-tu-web-mau`.
