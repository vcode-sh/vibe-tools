# shadcn/ui Installation Guides

This reference covers installation and configuration of shadcn/ui across all supported frameworks. Every framework uses the same CLI (`npx shadcn@latest`) but requires different project setup and configuration.

**Quick start for any framework:**

```bash
npx shadcn@latest create
```

This interactive command scaffolds a complete project with your preferred framework, icon library, and theme.

---

## Next.js

### Prerequisites

- Node.js 18+
- Next.js 13.4+ (App Router or Pages Router)

### Step-by-Step Installation

**1. Run the init command** to create a new Next.js project or set up an existing one:

```bash
npx shadcn@latest init
```

Choose between a Next.js project or a Monorepo when prompted.

**2. Add components:**

```bash
npx shadcn@latest add button
```

### Configuration Files

The `init` command automatically configures:
- `components.json` in the project root
- `tsconfig.json` path aliases (`@/*`)
- Global CSS with Tailwind and CSS variables
- `lib/utils.ts` with the `cn` helper

### First Component Usage

```tsx
// app/page.tsx
import { Button } from "@/components/ui/button"

export default function Home() {
  return (
    <div>
      <Button>Click me</Button>
    </div>
  )
}
```

### Import Path Convention

```
@/components/ui/button    # UI components
@/components/             # Custom components
@/lib/utils               # Utility functions (cn helper)
@/hooks/                  # Custom hooks
```

### Special Notes

- Next.js is the most streamlined installation -- `npx shadcn@latest init` handles everything automatically.
- The CLI detects whether you use the App Router or Pages Router and configures `rsc` accordingly.
- For new projects, prefer `npx shadcn@latest create` which also sets up custom themes and icon libraries.

---

## Vite

### Prerequisites

- Node.js 18+
- Vite 5+
- React 18+ or React 19

### Step-by-Step Installation

**1. Create a new Vite project** with the React + TypeScript template:

```bash
npm create vite@latest
```

**2. Add Tailwind CSS:**

```bash
npm install tailwindcss @tailwindcss/vite
```

Replace everything in `src/index.css` with:

```css
/* src/index.css */
@import "tailwindcss";
```

**3. Edit tsconfig.json** -- add `baseUrl` and `paths` to `compilerOptions`:

```json
{
  "files": [],
  "references": [
    {
      "path": "./tsconfig.app.json"
    },
    {
      "path": "./tsconfig.node.json"
    }
  ],
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

**4. Edit tsconfig.app.json** -- add the same path resolution for your IDE:

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": [
        "./src/*"
      ]
    }
  }
}
```

**5. Update vite.config.ts** -- install `@types/node` and configure path aliases and the Tailwind plugin:

```bash
npm install -D @types/node
```

```typescript
// vite.config.ts
import path from "path"
import tailwindcss from "@tailwindcss/vite"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
})
```

**6. Run the shadcn CLI:**

```bash
npx shadcn@latest init
```

You will be prompted:

```
Which color would you like to use as base color? > Neutral
```

**7. Add components:**

```bash
npx shadcn@latest add button
```

### First Component Usage

```tsx
// src/App.tsx
import { Button } from "@/components/ui/button"

function App() {
  return (
    <div className="flex min-h-svh flex-col items-center justify-center">
      <Button>Click me</Button>
    </div>
  )
}

export default App
```

### Import Path Convention

```
@/components/ui/button    # UI components (resolves to src/components/ui/)
@/lib/utils               # Utility functions
```

### Special Notes

- Vite splits TypeScript configuration into three files (`tsconfig.json`, `tsconfig.app.json`, `tsconfig.node.json`). You must add `baseUrl` and `paths` to both `tsconfig.json` and `tsconfig.app.json`.
- The `@tailwindcss/vite` plugin is used instead of PostCSS for Tailwind v4.
- You must install `@types/node` as a dev dependency for path resolution in `vite.config.ts`.

---

## Astro

### Prerequisites

- Node.js 18+
- Astro 3+
- React integration for Astro

### Step-by-Step Installation

**1. Create a new Astro project** with Tailwind and React:

```bash
npx create-astro@latest astro-app  --template with-tailwindcss --install --add react --git
```

**2. Edit tsconfig.json** -- add path aliases:

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": [
        "./src/*"
      ]
    }
  }
}
```

**3. Run the shadcn CLI:**

```bash
npx shadcn@latest init
```

**4. Add components:**

```bash
npx shadcn@latest add button
```

### First Component Usage

```astro
---
// src/pages/index.astro
import { Button } from "@/components/ui/button"
---

<html lang="en">
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width" />
		<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
		<meta name="generator" content={Astro.generator} />
		<title>Astro + TailwindCSS</title>
	</head>

	<body>
		<div className="grid place-items-center h-screen content-center">
			<Button>Button</Button>
		</div>
	</body>
</html>
```

### Import Path Convention

```
@/components/ui/button    # UI components (resolves to src/components/ui/)
```

### Special Notes

- The `--template with-tailwindcss --add react` flags are essential -- Astro needs both Tailwind and React integration for shadcn/ui components.
- shadcn/ui components are React components, so they require `client:load` or `client:visible` directives in Astro for interactivity.
- React Server Components (`rsc`) should be set to `false` in `components.json` for Astro.

---

## React Router

### Prerequisites

- Node.js 18+
- React Router 7+

### Step-by-Step Installation

**1. Create a new React Router project:**

```bash
npx create-react-router@latest my-app
```

**2. Run the shadcn CLI:**

```bash
npx shadcn@latest init
```

**3. Add components:**

```bash
npx shadcn@latest add button
```

### First Component Usage

```tsx
// app/routes/home.tsx
import { Button } from "~/components/ui/button"

import type { Route } from "./+types/home"

export function meta({}: Route.MetaArgs) {
  return [
    { title: "New React Router App" },
    { name: "description", content: "Welcome to React Router!" },
  ]
}

export default function Home() {
  return (
    <div className="flex min-h-svh flex-col items-center justify-center">
      <Button>Click me</Button>
    </div>
  )
}
```

### Import Path Convention

```
~/components/ui/button    # UI components (uses ~ alias, NOT @)
~/lib/utils               # Utility functions
```

### Special Notes

- React Router uses the `~` path alias by convention (not `@`). The CLI detects this automatically.
- The `create-react-router` scaffolding tool handles Tailwind and TypeScript configuration automatically.
- This is for React Router v7+. For older Remix projects, see the Remix section.

---

## Remix

### Prerequisites

- Node.js 18+
- Remix 2+

### Step-by-Step Installation

**Note:** For React Router v7+, use the React Router guide instead. This guide is for Remix specifically.

**1. Create a new Remix project:**

```bash
npx create-remix@latest my-app
```

**2. Run the shadcn CLI:**

```bash
npx shadcn@latest init
```

You will be prompted:

```
Which color would you like to use as base color? > Neutral
```

**3. Install Tailwind CSS:**

```bash
npm install -D tailwindcss@latest autoprefixer@latest
```

**4. Create postcss.config.js:**

```js
// postcss.config.js
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
```

**5. Update remix.config.js** -- enable Tailwind and PostCSS:

```js
// remix.config.js
/** @type {import('@remix-run/dev').AppConfig} */
export default {
  ...
  tailwind: true,
  postcss: true,
  ...
};
```

**6. Add tailwind.css to your app** -- import the stylesheet in `app/root.tsx`:

```js
// app/root.tsx
import styles from "./tailwind.css?url"

export const links: LinksFunction = () => [
  { rel: "stylesheet", href: styles },
  ...(cssBundleHref ? [{ rel: "stylesheet", href: cssBundleHref }] : []),
]
```

**7. Add components:**

```bash
npx shadcn@latest add button
```

### App Structure

This structure is a suggestion -- place files wherever you want:

- `app/components/ui/` -- shadcn/ui components
- `app/components/` -- Your own components
- `app/lib/utils.ts` -- Utility functions including the `cn` helper
- `app/tailwind.css` -- Global CSS

### First Component Usage

```tsx
// app/routes/index.tsx
import { Button } from "~/components/ui/button"

export default function Home() {
  return (
    <div>
      <Button>Click me</Button>
    </div>
  )
}
```

### Import Path Convention

```
~/components/ui/button    # UI components (uses ~ alias)
~/lib/utils               # Utility functions
```

### Special Notes

- Remix uses the `~` path alias (not `@`), same as React Router.
- You must enable both `tailwind: true` and `postcss: true` in `remix.config.js`.
- Import the CSS file with `?url` suffix: `import styles from "./tailwind.css?url"`.

---

## Laravel

### Prerequisites

- PHP 8.1+
- Laravel 10+
- Node.js 18+
- Laravel with Inertia.js and React

### Step-by-Step Installation

**1. Create a new Laravel project** with the React stack:

```bash
laravel new my-app --react
```

This sets up Laravel with Inertia.js, React, Tailwind CSS, and TypeScript.

**2. Add components** -- no additional configuration needed:

```bash
npx shadcn@latest add switch
```

### First Component Usage

```tsx
// resources/js/pages/index.tsx
import { Switch } from "@/components/ui/switch"

const MyPage = () => {
  return (
    <div>
      <Switch />
    </div>
  )
}

export default MyPage
```

### Import Path Convention

```
@/components/ui/switch    # UI components (resolves to resources/js/components/ui/)
```

### Special Notes

- The `laravel new --react` command sets up everything needed: Inertia.js, React, Tailwind CSS, TypeScript, and path aliases.
- Components are placed in `resources/js/components/ui/` (not `src/components/ui/`).
- This is the simplest installation after Next.js -- the Laravel installer handles all configuration.

---

## Gatsby

### Prerequisites

- Node.js 18+
- Gatsby 5+

### Step-by-Step Installation

**1. Create a new Gatsby project:**

```bash
npm init gatsby
```

**2. Configure during setup** -- select TypeScript and Tailwind CSS:

```
What would you like to call your site?
> your-app-name
What would you like to name the folder where your site will be created?
> your-app-name
Will you be using JavaScript or TypeScript?
> TypeScript
Will you be using a CMS?
> Choose whatever you want
Would you like to install a styling system?
> Tailwind CSS
Would you like to install additional features with other plugins?
> Choose whatever you want
Shall we do this? (Y/n) > Yes
```

**3. Edit tsconfig.json** -- add path aliases:

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": [
        "./src/*"
      ]
    }
  }
}
```

**4. Create gatsby-node.ts** at the project root for Webpack path resolution:

```ts
// gatsby-node.ts
import * as path from "path"

export const onCreateWebpackConfig = ({ actions }) => {
  actions.setWebpackConfig({
    resolve: {
      alias: {
        "@/components": path.resolve(__dirname, "src/components"),
        "@/lib/utils": path.resolve(__dirname, "src/lib/utils"),
      },
    },
  })
}
```

**5. Run the shadcn CLI:**

```bash
npx shadcn@latest init
```

**6. Configure components.json** when prompted:

```
Would you like to use TypeScript (recommended)? no / yes
Which style would you like to use? > Default
Which color would you like to use as base color? > Slate
Where is your global CSS file? > ./src/styles/globals.css
Do you want to use CSS variables for colors? > no / yes
Where is your tailwind.config.js located? > tailwind.config.js
Configure the import alias for components: > @/components
Configure the import alias for utils: > @/lib/utils
Are you using React Server Components? > no
```

**7. Add components:**

```bash
npx shadcn@latest add button
```

### First Component Usage

```tsx
import { Button } from "@/components/ui/button"

export default function Home() {
  return (
    <div>
      <Button>Click me</Button>
    </div>
  )
}
```

### Import Path Convention

```
@/components/ui/button    # UI components
@/lib/utils               # Utility functions
```

### Special Notes

- Gatsby requires a `gatsby-node.ts` file for Webpack alias resolution -- `tsconfig.json` paths alone are not enough.
- You must explicitly map each alias in `gatsby-node.ts` (`@/components` and `@/lib/utils`).
- Set `rsc` to `false` (React Server Components are not supported in Gatsby).
- Global CSS is typically at `./src/styles/globals.css` in Gatsby projects.

---

## TanStack Start

### Prerequisites

- Node.js 18+
- TanStack Start (latest)

### Step-by-Step Installation

**1. Create a new TanStack Start project** with Tailwind and shadcn/ui:

```bash
npm create @tanstack/start@latest --tailwind --add-ons shadcn
```

This single command sets up the entire project with Tailwind CSS and shadcn/ui pre-configured.

**2. Add components:**

```bash
npx shadcn@latest add button
```

To add all components at once:

```bash
npx shadcn@latest add --all
```

### First Component Usage

```tsx
// app/routes/index.tsx
import { Button } from "@/components/ui/button"

function App() {
  return (
    <div>
      <Button>Click me</Button>
    </div>
  )
}
```

### Import Path Convention

```
@/components/ui/button    # UI components
```

### Special Notes

- The `--tailwind --add-ons shadcn` flags configure everything automatically. No manual setup needed.
- You can install all shadcn/ui components at once with `npx shadcn@latest add --all`.
- For custom themes, use `npx shadcn@latest create` instead for interactive theme selection.

---

## TanStack Router

### Prerequisites

- Node.js 18+
- TanStack Router (latest)

### Step-by-Step Installation

**1. Create a new TanStack Router project:**

```bash
npx create-tsrouter-app@latest my-app --template file-router --tailwind --add-ons shadcn
```

**2. Add components:**

```bash
npx shadcn@latest add button
```

### First Component Usage

```tsx
// src/routes/index.tsx
import { createFileRoute } from "@tanstack/react-router"

import { Button } from "@/components/ui/button"

export const Route = createFileRoute("/")({
  component: App,
})

function App() {
  return (
    <div>
      <Button>Click me</Button>
    </div>
  )
}
```

### Import Path Convention

```
@/components/ui/button    # UI components (resolves to src/components/ui/)
```

### Special Notes

- Use the `--template file-router` flag for file-based routing (recommended).
- The `--tailwind --add-ons shadcn` flags handle all configuration automatically.
- Components live in `src/` by default (same as Vite).

---

## Manual Installation

Use manual installation when the CLI does not support your framework, when you need full control over the setup, or when you are integrating into an existing project with custom build tooling.

### Prerequisites

- A React project with a build system
- Tailwind CSS v4 installed and configured

### Step-by-Step Installation

**1. Add Tailwind CSS** -- follow the official Tailwind CSS installation instructions for your specific build tool:

[https://tailwindcss.com/docs/installation](https://tailwindcss.com/docs/installation)

**2. Add dependencies:**

```bash
npm install class-variance-authority clsx tailwind-merge lucide-react tw-animate-css
```

**3. Configure path aliases** in `tsconfig.json`:

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  }
}
```

The `@` alias is a preference. You can use other aliases if you want.

**4. Configure global styles** -- add the following to your CSS file (e.g., `src/styles/globals.css`). This includes the complete CSS variable system for light and dark themes:

```css
/* src/styles/globals.css */
@import "tailwindcss";
@import "tw-animate-css";

@custom-variant dark (&:is(.dark *));

:root {
  --background: oklch(1 0 0);
  --foreground: oklch(0.145 0 0);
  --card: oklch(1 0 0);
  --card-foreground: oklch(0.145 0 0);
  --popover: oklch(1 0 0);
  --popover-foreground: oklch(0.145 0 0);
  --primary: oklch(0.205 0 0);
  --primary-foreground: oklch(0.985 0 0);
  --secondary: oklch(0.97 0 0);
  --secondary-foreground: oklch(0.205 0 0);
  --muted: oklch(0.97 0 0);
  --muted-foreground: oklch(0.556 0 0);
  --accent: oklch(0.97 0 0);
  --accent-foreground: oklch(0.205 0 0);
  --destructive: oklch(0.577 0.245 27.325);
  --destructive-foreground: oklch(0.577 0.245 27.325);
  --border: oklch(0.922 0 0);
  --input: oklch(0.922 0 0);
  --ring: oklch(0.708 0 0);
  --chart-1: oklch(0.646 0.222 41.116);
  --chart-2: oklch(0.6 0.118 184.704);
  --chart-3: oklch(0.398 0.07 227.392);
  --chart-4: oklch(0.828 0.189 84.429);
  --chart-5: oklch(0.769 0.188 70.08);
  --radius: 0.625rem;
  --sidebar: oklch(0.985 0 0);
  --sidebar-foreground: oklch(0.145 0 0);
  --sidebar-primary: oklch(0.205 0 0);
  --sidebar-primary-foreground: oklch(0.985 0 0);
  --sidebar-accent: oklch(0.97 0 0);
  --sidebar-accent-foreground: oklch(0.205 0 0);
  --sidebar-border: oklch(0.922 0 0);
  --sidebar-ring: oklch(0.708 0 0);
}

.dark {
  --background: oklch(0.145 0 0);
  --foreground: oklch(0.985 0 0);
  --card: oklch(0.145 0 0);
  --card-foreground: oklch(0.985 0 0);
  --popover: oklch(0.145 0 0);
  --popover-foreground: oklch(0.985 0 0);
  --primary: oklch(0.985 0 0);
  --primary-foreground: oklch(0.205 0 0);
  --secondary: oklch(0.269 0 0);
  --secondary-foreground: oklch(0.985 0 0);
  --muted: oklch(0.269 0 0);
  --muted-foreground: oklch(0.708 0 0);
  --accent: oklch(0.269 0 0);
  --accent-foreground: oklch(0.985 0 0);
  --destructive: oklch(0.396 0.141 25.723);
  --destructive-foreground: oklch(0.637 0.237 25.331);
  --border: oklch(0.269 0 0);
  --input: oklch(0.269 0 0);
  --ring: oklch(0.439 0 0);
  --chart-1: oklch(0.488 0.243 264.376);
  --chart-2: oklch(0.696 0.17 162.48);
  --chart-3: oklch(0.769 0.188 70.08);
  --chart-4: oklch(0.627 0.265 303.9);
  --chart-5: oklch(0.645 0.246 16.439);
  --sidebar: oklch(0.205 0 0);
  --sidebar-foreground: oklch(0.985 0 0);
  --sidebar-primary: oklch(0.488 0.243 264.376);
  --sidebar-primary-foreground: oklch(0.985 0 0);
  --sidebar-accent: oklch(0.269 0 0);
  --sidebar-accent-foreground: oklch(0.985 0 0);
  --sidebar-border: oklch(0.269 0 0);
  --sidebar-ring: oklch(0.439 0 0);
}

@theme inline {
  --color-background: var(--background);
  --color-foreground: var(--foreground);
  --color-card: var(--card);
  --color-card-foreground: var(--card-foreground);
  --color-popover: var(--popover);
  --color-popover-foreground: var(--popover-foreground);
  --color-primary: var(--primary);
  --color-primary-foreground: var(--primary-foreground);
  --color-secondary: var(--secondary);
  --color-secondary-foreground: var(--secondary-foreground);
  --color-muted: var(--muted);
  --color-muted-foreground: var(--muted-foreground);
  --color-accent: var(--accent);
  --color-accent-foreground: var(--accent-foreground);
  --color-destructive: var(--destructive);
  --color-destructive-foreground: var(--destructive-foreground);
  --color-border: var(--border);
  --color-input: var(--input);
  --color-ring: var(--ring);
  --color-chart-1: var(--chart-1);
  --color-chart-2: var(--chart-2);
  --color-chart-3: var(--chart-3);
  --color-chart-4: var(--chart-4);
  --color-chart-5: var(--chart-5);
  --radius-sm: calc(var(--radius) - 4px);
  --radius-md: calc(var(--radius) - 2px);
  --radius-lg: var(--radius);
  --radius-xl: calc(var(--radius) + 4px);
  --color-sidebar: var(--sidebar);
  --color-sidebar-foreground: var(--sidebar-foreground);
  --color-sidebar-primary: var(--sidebar-primary);
  --color-sidebar-primary-foreground: var(--sidebar-primary-foreground);
  --color-sidebar-accent: var(--sidebar-accent);
  --color-sidebar-accent-foreground: var(--sidebar-accent-foreground);
  --color-sidebar-border: var(--sidebar-border);
  --color-sidebar-ring: var(--sidebar-ring);
}

@layer base {
  * {
    @apply border-border outline-ring/50;
  }
  body {
    @apply bg-background text-foreground;
  }
}
```

**5. Create the `cn` helper** -- add a utility function for merging class names:

```ts
// lib/utils.ts
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

**6. Create `components.json`** in the project root:

```json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "rsc": false,
  "tsx": true,
  "tailwind": {
    "config": "",
    "css": "src/styles/globals.css",
    "baseColor": "neutral",
    "cssVariables": true,
    "prefix": ""
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "hooks": "@/hooks"
  },
  "iconLibrary": "lucide"
}
```

**7. Start adding components** -- you can now use the CLI:

```bash
npx shadcn@latest add button
```

### Dependencies Breakdown

| Package | Purpose |
|---------|---------|
| `class-variance-authority` | Component variant management (cva) |
| `clsx` | Conditional class name construction |
| `tailwind-merge` | Intelligent Tailwind class merging |
| `lucide-react` | Default icon library |
| `tw-animate-css` | Animation utilities for Tailwind v4 |

### CSS Variables Explained

The CSS variables follow a semantic naming pattern:

- **`--background` / `--foreground`**: Page-level colors
- **`--card` / `--card-foreground`**: Card component colors
- **`--popover` / `--popover-foreground`**: Popover/dropdown colors
- **`--primary` / `--primary-foreground`**: Primary action colors
- **`--secondary` / `--secondary-foreground`**: Secondary action colors
- **`--muted` / `--muted-foreground`**: Subdued/disabled colors
- **`--accent` / `--accent-foreground`**: Accent/highlight colors
- **`--destructive` / `--destructive-foreground`**: Destructive/error action colors
- **`--border`**: Default border color
- **`--input`**: Input field border color
- **`--ring`**: Focus ring color
- **`--chart-1` through `--chart-5`**: Chart/data visualization colors
- **`--radius`**: Base border radius (other radii are computed from this)
- **`--sidebar-*`**: Sidebar-specific color overrides

The `@theme inline` block maps CSS variables to Tailwind utility classes (e.g., `bg-primary`, `text-foreground`).

### Special Notes

- Leave `tailwind.config` blank (empty string) for Tailwind CSS v4.
- Set `rsc: false` unless you are in a Next.js App Router environment.
- The `style` field must be `"new-york"`. The `"default"` style has been deprecated.
- All color values use the `oklch` color space for perceptual uniformity.
- The `@custom-variant dark (&:is(.dark *))` line enables dark mode via a `.dark` class on a parent element.
- The `components.json` file is only required when using the CLI. If you copy-paste components manually, it is optional.

---

## Import Path Quick Reference

| Framework | UI Component Import | Alias |
|-----------|-------------------|-------|
| Next.js | `@/components/ui/button` | `@` |
| Vite | `@/components/ui/button` | `@` |
| Astro | `@/components/ui/button` | `@` |
| React Router | `~/components/ui/button` | `~` |
| Remix | `~/components/ui/button` | `~` |
| Laravel | `@/components/ui/button` | `@` |
| Gatsby | `@/components/ui/button` | `@` |
| TanStack Start | `@/components/ui/button` | `@` |
| TanStack Router | `@/components/ui/button` | `@` |
| Manual | `@/components/ui/button` | `@` (configurable) |

---

## Common CLI Commands

```bash
# Initialize a new project
npx shadcn@latest init

# Interactive project creation with themes
npx shadcn@latest create

# Add a single component
npx shadcn@latest add button

# Add multiple components
npx shadcn@latest add button card dialog

# Add all components
npx shadcn@latest add --all

# Add from a custom registry
npx shadcn@latest add @v0/dashboard
```
