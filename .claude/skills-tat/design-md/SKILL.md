---
name: design-md
description: Give a project a DESIGN.md (design tokens + rationale) so UI matches a chosen brand style. Use when the user wants a UI "in the style of" a brand (Apple, Airbnb, Stripe, Linear, ...), asks for a DESIGN.md, or wants consistent colors/typography/spacing across generated UI.
---

# DESIGN.md

- `spec.md` — the DESIGN.md format (google-labs-code/design.md, Apache-2.0): YAML tokens (colors, typography, rounded, spacing) + markdown rationale.
- `library/<brand>/DESIGN.md` — 84 ready-made brand design systems (VoltAgent/awesome-design-md, MIT). `ls library` to list brands.

1. Pick a brand from `library/` that fits the user's request (or ask if none is given), or write a new one following `spec.md`.
2. Copy it to the project root as `DESIGN.md`; adapt name, colors and fonts to the user's brand if they have one.
3. Build UI using only the tokens in `DESIGN.md`; follow its prose for tone and usage.
4. Optional check when Node is available: `npx @google/design.md lint DESIGN.md`.
