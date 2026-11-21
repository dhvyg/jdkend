---
name: threeui
description: Thêm hiệu ứng web 3D, shader, hạt (particle), nền động, nút và CTA có hiệu ứng vào dự án React bằng thư viện ThreeUI Community (npm @designcodeio/threeui, MIT, của MengTo). Dùng khi người dùng muốn "hiệu ứng 3D", "nền hạt", "shader", "hero động", "nút phát sáng", hoặc nhắc tới ThreeUI / threeui.com.
---

# ThreeUI Community

Thư viện ~100 component React dựng bằng Three.js/WebGL/shader. Xem trước tại https://threeui.com (chỉ dùng component Community; Pro/Beta cần tài khoản trả phí, không tự dùng).

## Cài và dùng

```bash
npm install @designcodeio/threeui
```

```tsx
import { NebulaBackground } from "@designcodeio/threeui";
import "@designcodeio/threeui/style.css";

export function Hero() {
  return <NebulaBackground />;
}
```

- Import gọn hơn theo từng component: `import { NebulaBackground } from "@designcodeio/threeui/components/NebulaBackground";`
- `react`, `react-dom`, `three` là peer dependency: dự án phải có sẵn.
- Component render cả trang HTML cần file runtime: chép thư mục `node_modules/@designcodeio/threeui/lib-dist/assets/` vào thư mục public của app, hoặc đặt prop `sourceUrl` / `assetBaseUrl` nếu component có.

## Component có sẵn (chọn theo việc)

| Việc | Component |
|---|---|
| Nền động | `NebulaBackground`, `FluidFieldBackground`, `WarpFieldBackground`, `DotMatrixBackground`, `RibbonFieldBackground`, `LiquidFormBackground`, `OrbitalSphereBackground`, `CrtBackground`, `CondensationBackground`, `EmeraldHorizonBackground`, `StreamConvergenceBackground`, `BellFieldBackground`, `ElementsBackground` |
| Hạt / trường | `ParticleDrift`, `ParticleNetwork`, `ParticleWordmark`, `ConstellationField`, `FlowField`, `CloudField`, `TopoField`, `VoidField`, `EmberStorm`, `FluxVortex`, `DataField` |
| Nút | `LiquidMetalButton`, `PlasmaButton`, `GradientPillButton`, `SpinningBorderButton`, `DotBorderButton`, `IgnitionButton`, `LaunchButton`, `GenerateButton`, `ThinkingButton`, `TactileButton`, `ShaderButtons`, `CircleButtons`, `RectangleButtons` |
| CTA / section | `GradientCta`, `GradientBeamCta`, `GlassmorphismCta`, `LumenCta`, `FloatingDotsCta`, `SlidingTextCta`, `NewsletterFooterSection`, `EditorialIntroSection`, `AnimatedTopDock` |
| Chữ | `NeonTypography`, `OutlineTypeflow`, `TypographyVortexCanvas`, `MorphingGlyphCloud`, `TextAnimationCollection`, `TextPathStudies`, `AudioWordmark` |
| Cảnh / trang mẫu | `SylvaHero`, `LandscapeScene`, `TempleNightScene`, `JapaneseTowerLandscape`, `BookshelfScene`, `KageLandingPage`, `CompleteShelfLandingPage`, `Gallery` |

Không chắc tên hoặc prop thì đọc file `.d.ts` trong `node_modules/@designcodeio/threeui/lib-dist/package-components/` thay vì đoán.

## Quy tắc
- Dự án không phải React thì báo người dùng; đừng ép đổi framework.
- WebGL nặng: dùng tối đa 1–2 hiệu ứng lớn mỗi trang, kiểm tra trên điện thoại, tôn trọng `prefers-reduced-motion`.
- Không dùng lệnh `npx @designcodeio/threeui-cli` (chỉ cho thành viên Pro, cần đăng nhập).
