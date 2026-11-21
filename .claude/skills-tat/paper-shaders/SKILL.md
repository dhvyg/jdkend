---
name: paper-shaders
description: Thêm nền shader động (mesh gradient, sóng, hạt, kim loại lỏng, nhiễu, dithering...) cho landing page, portfolio, hero section bằng thư viện Paper Shaders (npm @paper-design/shaders-react, của paper.design). Dùng khi người dùng muốn "nền gradient động", "hero đẹp", "shader background", "nền chuyển màu", hoặc nhắc tới Paper Shaders / shaders.paper.design.
---

# Paper Shaders

Shader canvas không phụ thuộc thư viện nào khác, nhẹ, chạy trên mọi trình duyệt. Xem trước và chỉnh thông số tại https://shaders.paper.design

## Cài và dùng

```bash
npm i @paper-design/shaders-react@0.0.82   # React 18/19
npm i @paper-design/shaders@0.0.82         # JS thuần
```

Ghim đúng phiên bản: thư viện còn ở 0.0.x và có thể đổi API giữa các bản.

```tsx
import { MeshGradient } from "@paper-design/shaders-react";

export function Hero() {
  return (
    <section style={{ position: "relative", minHeight: "100vh" }}>
      <MeshGradient
        colors={["#5100ff", "#00ff80", "#ffcc00", "#ea00ff"]}
        distortion={1}
        swirl={0.8}
        speed={0.2}
        style={{ position: "absolute", inset: 0 }}
      />
      <h1 style={{ position: "relative" }}>Tiêu đề</h1>
    </section>
  );
}
```

Mỗi component có sẵn bộ preset (`meshGradientPresets`, `wavesPresets`...). Dùng `{...meshGradientPresets[0].params}` để có ngay một kiểu đẹp rồi chỉnh tiếp.

## Component có sẵn (bản 0.0.82)

| Việc | Component |
|---|---|
| Nền gradient | `MeshGradient`, `StaticMeshGradient`, `StaticRadialGradient`, `GrainGradient`, `ColorPanels` |
| Nhiễu, chất liệu | `SimplexNoise`, `PerlinNoise`, `NeuroNoise`, `Voronoi`, `Warp`, `PaperTexture`, `FlutedGlass`, `Water` |
| Chuyển động | `Waves`, `Spiral`, `Swirl`, `SmokeRing`, `GemSmoke`, `GodRays`, `Metaballs`, `LiquidMetal` |
| Chấm, dither | `DotOrbit`, `DotGrid`, `Dithering`, `HalftoneDots`, `HalftoneCmyk` |
| Hiệu ứng trên ảnh | `ImageDithering`, `LensDistortion`, `Heatmap` |
| Viền nổi bật | `PulsingBorder` |

Không chắc prop nào thì đọc file `.d.ts` của component đó trong `node_modules/@paper-design/shaders-react/dist/` thay vì đoán.

## Quy tắc
- Dự án không phải React thì dùng gói `@paper-design/shaders` (JS thuần); đừng ép đổi framework.
- Mỗi trang chỉ nên có 1–2 shader lớn. Kiểm tra trên điện thoại.
- Tôn trọng `prefers-reduced-motion`: khi người dùng bật giảm chuyển động thì đặt `speed={0}`.
- Chữ đặt trên shader phải đủ tương phản. Thêm lớp phủ tối hoặc sáng nếu cần.
