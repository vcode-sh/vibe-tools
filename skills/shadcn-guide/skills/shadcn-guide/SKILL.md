---
name: shadcn-guide
description: Guide for shadcn/ui — the open-code component system for React. Use when user asks to install, configure, theme, or use shadcn/ui components, set up dark mode, create forms, build a registry, configure MCP, or set up RTL/monorepo/JavaScript mode. Covers 58+ components (Base UI and Radix variants), CLI commands, components.json, CSS variable theming, framework installation (Next.js, Vite, Astro, Remix, Laravel, Gatsby, TanStack), registry system, and form patterns. Do NOT use for Chakra UI, Material UI, Ant Design, or vanilla Tailwind without shadcn context.
metadata:
  author: documentation-analysis
  version: 1.2.0
  source: documentation-analysis
  source-docs: source/shadcn/
  category: ui-framework
  tags: [shadcn, ui, react, components, tailwind, radix, base-ui, theming, forms, dark-mode, rtl, registry, v0, figma, blocks, javascript, mcp]
---

# shadcn/ui Guide

## Purpose

shadcn/ui is **not a component library** — it's a system to build your own component library. Components are copied into your project as open source code you fully own and control. Two primitive variants are available: **Base UI** (by MUI) and **Radix UI** (default).

**Core Principles:** Open Code, Composition, Distribution (schema + CLI), Beautiful Defaults, AI-Ready.

**Upstream updates:** shadcn/ui follows a headless component architecture. The core receives fixes by updating dependencies (e.g. radix-ui, input-otp). The topmost layer (closest to your design system) stays open for modification and is not coupled with the library implementation.

**Do NOT use this guide** for Chakra UI, Material UI (MUI), Ant Design, or vanilla Tailwind CSS without shadcn/ui context — those have different installation, theming, and component APIs.

## Quick Start

```bash
# Initialize a new project (or add to existing)
npx shadcn@latest init

# Add components
npx shadcn@latest add button dialog card

# Add all components
npx shadcn@latest add --all

# Interactive setup with custom themes
npx shadcn@latest create
```

## CLI Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `create` | Interactive project scaffolding | `npx shadcn@latest create` |
| `init` | Initialize project config | `npx shadcn@latest init` |
| `add` | Add components to project | `npx shadcn@latest add button card` |
| `add --all` | Add all components | `npx shadcn@latest add --all` |
| `view` | View registry items | `npx shadcn@latest view @acme/button` |
| `search` / `list` | Search/list registries | `npx shadcn@latest search @v0 -q "button"` |
| `build` | Build registry JSON | `npx shadcn@latest build` |
| `migrate` | Run migrations | `npx shadcn@latest migrate rtl` |
| `mcp` | Start MCP server | `npx shadcn@latest mcp init --client claude` |

**Key CLI flags:** `-y` (skip prompts), `-o` (overwrite), `-a` (all), `-c <cwd>` (working directory), `-s` (silent). See `references/configuration.md` for full CLI command details.

## Configuration (components.json)

Located at project root. Created by `init`. Schema: `https://ui.shadcn.com/schema.json`

```json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "",
    "css": "app/globals.css",
    "baseColor": "neutral",
    "cssVariables": true
  },
  "iconLibrary": "lucide",
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "hooks": "@/hooks"
  }
}
```

**Immutable after init:** `style`, `baseColor`, `cssVariables`. Use `new-york` style (`default` is deprecated).

## Theming (CSS Variables)

Colors use **OKLCH** format. Convention: `--[role]` for background, `--[role]-foreground` for text.

```css
:root {
  --background: oklch(1 0 0);
  --foreground: oklch(0.145 0 0);
  --primary: oklch(0.205 0 0);
  --primary-foreground: oklch(0.985 0 0);
  --secondary: oklch(0.97 0 0);
  --muted: oklch(0.97 0 0);
  --muted-foreground: oklch(0.556 0 0);
  --accent: oklch(0.97 0 0);
  --destructive: oklch(0.577 0.245 27.325);
  --border: oklch(0.922 0 0);
  --input: oklch(0.922 0 0);
  --ring: oklch(0.708 0 0);
  --radius: 0.625rem;
}
```

Usage: `<div className="bg-primary text-primary-foreground" />`

**Adding custom colors:**

```css
:root { --warning: oklch(0.84 0.16 84); --warning-foreground: oklch(0.28 0.07 46); }
.dark { --warning: oklch(0.41 0.11 46); --warning-foreground: oklch(0.99 0.02 95); }
@theme inline { --color-warning: var(--warning); --color-warning-foreground: var(--warning-foreground); }
```

**Base colors:** neutral, stone, zinc, gray, slate.

## Component Pattern

All components follow the same pattern:

```bash
npx shadcn@latest add [component-name]
```

```tsx
import { Component } from "@/components/ui/component"

export function Example() {
  return <Component>Content</Component>
}
```

**58 components available** in both Base UI and Radix variants. See `references/components-*.md` (6 files by category).

**Most-used components:** Button, Card, Dialog, Input, Select, Table, Tabs, Form/Field, Sidebar, Sheet, Dropdown Menu, Command, Toast (Sonner), Badge, Avatar.

## Essential Utility

```tsx
// lib/utils.ts — created by init
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

## JavaScript Support (TypeScript Opt-Out)

Set `"tsx": false` in `components.json` to generate `.jsx` files instead of `.tsx`:

```json
{ "tsx": false }
```

Configure import aliases in `jsconfig.json`:

```json
{
  "compilerOptions": {
    "paths": { "@/*": ["./*"] }
  }
}
```

## v0 Integration

Every shadcn/ui component is editable on [v0.dev](https://v0.dev) — AI-powered customization in natural language, then paste into your app. Requires a free Vercel account.

**Open in v0 for registries:** If your registry is publicly accessible, use the endpoint:
`https://v0.dev/chat/api/open?url=[REGISTRY_ITEM_URL]`

Limitations: Open in v0 does NOT support `cssVars`, `css`, `envVars`, namespaced registries, or advanced authentication (only query parameter auth with `?token=`).

## Figma Resources

Community-contributed Figma kits for design-to-development workflow:

**Free:** Obra shadcn/ui (MIT, design-to-code plugin), shadcn/ui components by Sitsiilia Bergmann, shadcn/ui design system by Pietro Schirano.

**Paid:** shadcn/ui kit (shadcndesign.com), Shadcraft UI Kit (shadcraft.com, with tweakcn theming), shadcn/studio UI Kit (shadcnstudio.com/figma, 550+ blocks, 10+ templates).

## Blocks (Community Contributions)

Blocks are community-contributed complex components (dashboards, marketing sections, product pages). Contribute via PR to `github.com/shadcn-ui/ui`.

**Structure:** `apps/www/registry/new-york/blocks/[block-name]/` with page.tsx, components/, hooks/, lib/. Register in `registry-blocks.tsx` with required fields: `name`, `description`, `type`, `files`, `categories`. Build with `pnpm registry:build`, preview at `localhost:3333/blocks/[CATEGORY]`.

See `references/registry-advanced.md` for full blocks contribution workflow.

## Community Registries (Directory)

Community registries are built into the CLI — no configuration needed. Install with `npx shadcn add @<registry>/<component>`.

**Security warning:** Community registries are maintained by third-party developers. Always review code on installation.

Browse the directory at `ui.shadcn.com/docs/registry`. Add your registry to the index via PR to `apps/v4/registry/directory.json`.

## Legacy Docs

For Tailwind v3 projects, visit [v3.shadcn.com](https://v3.shadcn.com). Current docs cover Tailwind v4 only.

## Key Rules & Constraints

1. **Style is immutable** — cannot change `style`, `baseColor`, or `cssVariables` after init
2. **Toast is deprecated** — use Sonner (`npx shadcn@latest add sonner`)
3. **Default style deprecated** — use `new-york`
4. **Tailwind v4** — use `@theme inline` directive, leave `tailwind.config` blank, use OKLCH colors
5. **React 19** — no more `forwardRef`, use `React.ComponentProps<>`, all primitives have `data-slot`
6. **Animation library** — `tw-animate-css` replaces `tailwindcss-animate`
7. **Aliases must match** `tsconfig.json` / `jsconfig.json` paths
8. **Imports** — use `@/components/ui/[component]` path pattern
9. **npm + React 19** — may need `--force` or `--legacy-peer-deps` flag
10. **Monorepo** — run CLI from `apps/web`, components install to `packages/ui`
11. **JavaScript** — set `"tsx": false` in `components.json`, use `jsconfig.json` for aliases
12. **Legacy** — Tailwind v3 docs at v3.shadcn.com; current docs are v4 only

## Installation (Framework Quick Reference)

| Framework | Create Command |
|-----------|---------------|
| Next.js | `npx shadcn@latest init` (or `create`) |
| Vite | `npm create vite@latest` → configure → `npx shadcn@latest init` |
| Astro | `npx create-astro@latest --template with-tailwindcss --add react` → init |
| React Router | `npx create-react-router@latest my-app` → init |
| Remix | `npx create-remix@latest my-app` → init |
| Laravel | `laravel new my-app --react` (auto-configured) |
| Gatsby | `npm init gatsby` → configure → `npx shadcn@latest init` |
| TanStack Start | `npm create @tanstack/start@latest --tailwind --add-ons shadcn` |
| TanStack Router | `npx create-tsrouter-app@latest --template file-router --tailwind --add-ons shadcn` |
| Manual | Install deps → configure CSS → create `components.json` |

See `references/installation.md` for full step-by-step guides.

## Dark Mode

Use `next-themes` (Next.js), `remix-themes` (Remix), or custom context (Vite/Astro).

```tsx
// Next.js: wrap in ThemeProvider
import { ThemeProvider } from "@/components/theme-provider"
<ThemeProvider attribute="class" defaultTheme="system" enableSystem disableTransitionOnChange>
  {children}
</ThemeProvider>
```

See `references/patterns.md` for full dark mode setup per framework.

## Forms

Two approaches: **React Hook Form** (with zod) or **TanStack Form**. Use with `Field` component for accessible form fields.

```tsx
<Field>
  <FieldLabel htmlFor="email">Email</FieldLabel>
  <Input id="email" type="email" />
  <FieldDescription>We'll never share your email.</FieldDescription>
  <FieldError>Invalid email address</FieldError>
</Field>
```

See `references/forms.md` for complete form integration guides.

## Registry System

Distribute custom components, hooks, pages via the registry schema:

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry.json",
  "name": "acme",
  "homepage": "https://acme.com",
  "items": [{ "name": "hello-world", "type": "registry:block", "files": [...] }]
}
```

Build: `npx shadcn@latest build` → serves at `/r/[name].json`

Install from registries: `npx shadcn@latest add @acme/button @v0/dashboard`

See `references/registry-core.md` for full registry documentation.

## Troubleshooting

- **npm peer dependency errors (React 19):** Use `--force` or `--legacy-peer-deps` flag. See `references/configuration.md`.
- **Components not styled:** Verify `tailwind.css` path in `components.json` points to your global CSS. Ensure `@theme inline` block is present.
- **Path alias not resolving:** Aliases in `components.json` must match `tsconfig.json` / `jsconfig.json`. For Vite, also update `vite.config.ts` resolve aliases.
- **Wrong style after init:** `style`, `baseColor`, `cssVariables` are immutable. Delete `components.json` and re-run `npx shadcn@latest init`.
- **Tailwind v3 vs v4 confusion:** Leave `tailwind.config` blank for v4. Legacy v3 docs at v3.shadcn.com.
- **RSC errors in non-Next.js:** Set `rsc: false` in `components.json` for Vite, Remix, Astro, Gatsby.
- **Missing animations:** Replace `tailwindcss-animate` with `tw-animate-css`. Add `@import "tw-animate-css"` to CSS.
- **Monorepo component not found:** Run CLI from `apps/web`, not project root. Both workspaces need `components.json`.

## Reference Files

- `references/components-overlay.md` — Overlays: Alert Dialog, Command, Dialog, Drawer, Hover Card, Popover, Sheet, Tooltip
- `references/components-navigation.md` — Navigation: Breadcrumb, Context Menu, Dropdown Menu, Menubar, Navigation Menu, Pagination, Sidebar, Tabs
- `references/components-form-inputs.md` — Form inputs: Combobox, Field, Input, Input Group, Input OTP, Label, Native Select, Select, Textarea
- `references/components-form-controls.md` — Form controls: Button, Button Group, Calendar, Checkbox, Date Picker, Radio Group, Slider, Switch, Toggle, Toggle Group
- `references/components-data-display.md` — Data display: Alert, Avatar, Badge, Card, Carousel, Chart, Data Table, Empty, Item, Table, Typography
- `references/components-layout.md` — Layout & feedback: Accordion, Aspect Ratio, Collapsible, Direction, Kbd, Progress, Resizable, Scroll Area, Separator, Skeleton, Sonner, Spinner
- `references/forms.md` — Form patterns (React Hook Form + Zod, TanStack Form, Server Actions, Field component)
- `references/patterns.md` — Dark mode (per framework), RTL support, monorepo setup
- `references/installation.md` — Complete framework installation guides
- `references/configuration.md` — components.json, theming, CSS variables, Tailwind v4 migration
- `references/registry-core.md` — Registry system: schema, item types, files, dependencies, namespaces
- `references/registry-advanced.md` — Registry advanced: authentication, MCP server, blocks, Open in v0, FAQ
