# shadcn/ui Configuration Reference

## components.json

The `components.json` file holds configuration for your project. The CLI uses it to understand how your project is set up and how to generate components customized for your project.

Note: The `components.json` file is only required if you use the CLI to add components. If you copy and paste components manually, you do not need this file.

Create a `components.json` file by running:

```bash
npx shadcn@latest init
```

### Complete Schema

A complete `components.json` file with all available fields:

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
    "cssVariables": true,
    "prefix": ""
  },
  "iconLibrary": "lucide",
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "hooks": "@/hooks"
  },
  "registries": {
    "@v0": "https://v0.dev/chat/b/{name}"
  }
}
```

### $schema

Point to the JSON Schema for validation and autocompletion:

```json
{
  "$schema": "https://ui.shadcn.com/schema.json"
}
```

### style

The style for your components. This cannot be changed after initialization.

```json
{
  "style": "new-york"
}
```

The `default` style has been deprecated. Use `new-york` for all new projects.

### rsc

Whether to enable support for React Server Components. When set to `true`, the CLI automatically adds a `"use client"` directive to client components.

```json
{
  "rsc": true
}
```

Set to `false` for non-RSC frameworks like Vite or Remix.

### tsx

Choose between TypeScript or JavaScript components. Setting this to `false` generates components as `.jsx` files instead of `.tsx`.

```json
{
  "tsx": false
}
```

When using JavaScript, configure import aliases in a `jsconfig.json`:

```json
{
  "compilerOptions": {
    "paths": {
      "@/*": ["./*"]
    }
  }
}
```

### tailwind.config

Path to your `tailwind.config.js` file. For Tailwind CSS v4, leave this blank.

```json
{
  "tailwind": {
    "config": "tailwind.config.js"
  }
}
```

Valid values: `"tailwind.config.js"`, `"tailwind.config.ts"`, or `""` (blank for Tailwind v4).

### tailwind.css

Path to the CSS file that imports Tailwind CSS into your project.

```json
{
  "tailwind": {
    "css": "styles/global.css"
  }
}
```

### tailwind.baseColor

The base color palette used to generate the default color palette for your components. This cannot be changed after initialization.

```json
{
  "tailwind": {
    "baseColor": "gray"
  }
}
```

Available values: `"gray"`, `"neutral"`, `"slate"`, `"stone"`, `"zinc"`.

### tailwind.cssVariables

Choose between CSS variables (recommended) or Tailwind CSS utility classes for theming.

```json
{
  "tailwind": {
    "cssVariables": true
  }
}
```

Set to `true` for CSS variables, `false` for utility classes. This cannot be changed after initialization. To switch between approaches, delete and re-install your components.

### tailwind.prefix

A prefix added to all Tailwind CSS utility classes in generated components.

```json
{
  "tailwind": {
    "prefix": "tw-"
  }
}
```

### iconLibrary

The icon library used in generated components.

```json
{
  "iconLibrary": "lucide"
}
```

### aliases.components

Import alias for your components directory.

```json
{
  "aliases": {
    "components": "@/components"
  }
}
```

### aliases.utils

Import alias for your utility functions.

```json
{
  "aliases": {
    "utils": "@/lib/utils"
  }
}
```

### aliases.ui

Import alias for `ui` components. Use this to customize the installation directory for UI components.

```json
{
  "aliases": {
    "ui": "@/app/ui"
  }
}
```

### aliases.lib

Import alias for `lib` functions such as `format-date` or `generate-id`.

```json
{
  "aliases": {
    "lib": "@/lib"
  }
}
```

### aliases.hooks

Import alias for hooks such as `use-media-query` or `use-toast`.

```json
{
  "aliases": {
    "hooks": "@/hooks"
  }
}
```

Important: If you use the `src` directory, make sure it is included under `paths` in your `tsconfig.json` or `jsconfig.json` file. Path aliases must be set up in your `tsconfig.json` or `jsconfig.json` for the CLI to resolve them correctly.

### registries (Basic Configuration)

Configure multiple resource registries. The `{name}` placeholder is replaced with the resource name when installing.

```json
{
  "registries": {
    "@v0": "https://v0.dev/chat/b/{name}",
    "@acme": "https://registry.acme.com/{name}.json",
    "@internal": "https://internal.company.com/{name}.json"
  }
}
```

### registries (Advanced Configuration with Authentication)

For private registries that require authentication, use the object form with `url`, `headers`, and `params`. Environment variables in the format `${VAR_NAME}` are automatically expanded.

```json
{
  "registries": {
    "@private": {
      "url": "https://api.company.com/registry/{name}.json",
      "headers": {
        "Authorization": "Bearer ${REGISTRY_TOKEN}",
        "X-API-Key": "${API_KEY}"
      },
      "params": {
        "version": "latest"
      }
    }
  }
}
```

### registries (Multiple Registry Setup)

```json
{
  "registries": {
    "@shadcn": "https://ui.shadcn.com/r/{name}.json",
    "@company-ui": {
      "url": "https://registry.company.com/ui/{name}.json",
      "headers": {
        "Authorization": "Bearer ${COMPANY_TOKEN}"
      }
    },
    "@team": {
      "url": "https://team.company.com/{name}.json",
      "params": {
        "team": "frontend",
        "version": "${REGISTRY_VERSION}"
      }
    }
  }
}
```

Install from configured registries using namespace syntax:

```bash
# Install from a configured registry
npx shadcn@latest add @v0/dashboard

# Install from private registry
npx shadcn@latest add @private/button

# Install multiple resources
npx shadcn@latest add @acme/header @internal/auth-utils
```

---

## Theming

### CSS Variables Approach (Recommended)

Set `tailwind.cssVariables` to `true` in `components.json`. Components use CSS variable-based classes:

```tsx
<div className="bg-background text-foreground" />
```

```json
{
  "style": "new-york",
  "rsc": true,
  "tailwind": {
    "config": "",
    "css": "app/globals.css",
    "baseColor": "neutral",
    "cssVariables": true
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

### Utility Classes Approach

Set `tailwind.cssVariables` to `false`. Components use direct Tailwind utility classes with dark mode variants:

```tsx
<div className="bg-zinc-950 dark:bg-white" />
```

```json
{
  "style": "new-york",
  "rsc": true,
  "tailwind": {
    "config": "",
    "css": "app/globals.css",
    "baseColor": "neutral",
    "cssVariables": false
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

### Color Convention

shadcn/ui uses a `background` and `foreground` convention. The `background` variable is used for the background color and the `foreground` variable for the text color. The `background` suffix is omitted when the variable is used for the background color.

Given these CSS variables:

```css
--primary: oklch(0.205 0 0);
--primary-foreground: oklch(0.985 0 0);
```

The background color of the component will be `var(--primary)` and the foreground color will be `var(--primary-foreground)`:

```tsx
<div className="bg-primary text-primary-foreground">Hello</div>
```

### Complete List of CSS Variables

All values use OKLCH color format.

#### Light Mode (:root)

```css
:root {
  --radius: 0.625rem;
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
  --destructive-foreground: oklch(0.985 0 0);
  --border: oklch(0.922 0 0);
  --input: oklch(0.922 0 0);
  --ring: oklch(0.708 0 0);
  --chart-1: oklch(0.646 0.222 41.116);
  --chart-2: oklch(0.6 0.118 184.704);
  --chart-3: oklch(0.398 0.07 227.392);
  --chart-4: oklch(0.828 0.189 84.429);
  --chart-5: oklch(0.769 0.188 70.08);
  --sidebar: oklch(0.985 0 0);
  --sidebar-foreground: oklch(0.145 0 0);
  --sidebar-primary: oklch(0.205 0 0);
  --sidebar-primary-foreground: oklch(0.985 0 0);
  --sidebar-accent: oklch(0.97 0 0);
  --sidebar-accent-foreground: oklch(0.205 0 0);
  --sidebar-border: oklch(0.922 0 0);
  --sidebar-ring: oklch(0.708 0 0);
}
```

#### Dark Mode (.dark)

```css
.dark {
  --background: oklch(0.145 0 0);
  --foreground: oklch(0.985 0 0);
  --card: oklch(0.205 0 0);
  --card-foreground: oklch(0.985 0 0);
  --popover: oklch(0.269 0 0);
  --popover-foreground: oklch(0.985 0 0);
  --primary: oklch(0.922 0 0);
  --primary-foreground: oklch(0.205 0 0);
  --secondary: oklch(0.269 0 0);
  --secondary-foreground: oklch(0.985 0 0);
  --muted: oklch(0.269 0 0);
  --muted-foreground: oklch(0.708 0 0);
  --accent: oklch(0.371 0 0);
  --accent-foreground: oklch(0.985 0 0);
  --destructive: oklch(0.704 0.191 22.216);
  --destructive-foreground: oklch(0.985 0 0);
  --border: oklch(1 0 0 / 10%);
  --input: oklch(1 0 0 / 15%);
  --ring: oklch(0.556 0 0);
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
  --sidebar-border: oklch(1 0 0 / 10%);
  --sidebar-ring: oklch(0.439 0 0);
}
```

### Adding New Custom Colors

Add new colors to `:root` and `.dark`, then use `@theme inline` to expose them as Tailwind utilities:

```css
:root {
  --warning: oklch(0.84 0.16 84);
  --warning-foreground: oklch(0.28 0.07 46);
}

.dark {
  --warning: oklch(0.41 0.11 46);
  --warning-foreground: oklch(0.99 0.02 95);
}

@theme inline {
  --color-warning: var(--warning);
  --color-warning-foreground: var(--warning-foreground);
}
```

Use the new color in components:

```tsx
<div className="bg-warning text-warning-foreground" />
```

### Base Color Palettes

Five base color palettes are available. Set via `tailwind.baseColor` in `components.json`.

#### Neutral

Uses pure achromatic values with zero chroma (e.g., `oklch(0.205 0 0)`). Clean, colorless grays.

```css
:root {
  --foreground: oklch(0.145 0 0);
  --primary: oklch(0.205 0 0);
  --primary-foreground: oklch(0.985 0 0);
  --secondary: oklch(0.97 0 0);
  --muted-foreground: oklch(0.556 0 0);
  --border: oklch(0.922 0 0);
}

.dark {
  --background: oklch(0.145 0 0);
  --foreground: oklch(0.985 0 0);
  --primary: oklch(0.922 0 0);
  --primary-foreground: oklch(0.205 0 0);
  --secondary: oklch(0.269 0 0);
  --muted-foreground: oklch(0.708 0 0);
  --border: oklch(1 0 0 / 10%);
}
```

#### Stone

Warm-toned grays with slight yellowish hue (e.g., `oklch(0.216 0.006 56.043)`).

```css
:root {
  --foreground: oklch(0.147 0.004 49.25);
  --primary: oklch(0.216 0.006 56.043);
  --primary-foreground: oklch(0.985 0.001 106.423);
  --secondary: oklch(0.97 0.001 106.424);
  --muted-foreground: oklch(0.553 0.013 58.071);
  --border: oklch(0.923 0.003 48.717);
}

.dark {
  --background: oklch(0.147 0.004 49.25);
  --foreground: oklch(0.985 0.001 106.423);
  --primary: oklch(0.923 0.003 48.717);
  --primary-foreground: oklch(0.216 0.006 56.043);
  --secondary: oklch(0.268 0.007 34.298);
  --muted-foreground: oklch(0.709 0.01 56.259);
  --border: oklch(1 0 0 / 10%);
}
```

#### Zinc

Cool-toned grays with a slight blue hue around 286 degrees (e.g., `oklch(0.21 0.006 285.885)`).

```css
:root {
  --foreground: oklch(0.141 0.005 285.823);
  --primary: oklch(0.21 0.006 285.885);
  --primary-foreground: oklch(0.985 0 0);
  --secondary: oklch(0.967 0.001 286.375);
  --muted-foreground: oklch(0.552 0.016 285.938);
  --border: oklch(0.92 0.004 286.32);
}

.dark {
  --background: oklch(0.141 0.005 285.823);
  --foreground: oklch(0.985 0 0);
  --primary: oklch(0.92 0.004 286.32);
  --primary-foreground: oklch(0.21 0.006 285.885);
  --secondary: oklch(0.274 0.006 286.033);
  --muted-foreground: oklch(0.705 0.015 286.067);
  --border: oklch(1 0 0 / 10%);
}
```

#### Gray

Cool-toned grays with a more noticeable blue hue around 264 degrees (e.g., `oklch(0.21 0.034 264.665)`).

```css
:root {
  --foreground: oklch(0.13 0.028 261.692);
  --primary: oklch(0.21 0.034 264.665);
  --primary-foreground: oklch(0.985 0.002 247.839);
  --secondary: oklch(0.967 0.003 264.542);
  --muted-foreground: oklch(0.551 0.027 264.364);
  --border: oklch(0.928 0.006 264.531);
}

.dark {
  --background: oklch(0.13 0.028 261.692);
  --foreground: oklch(0.985 0.002 247.839);
  --primary: oklch(0.928 0.006 264.531);
  --primary-foreground: oklch(0.21 0.034 264.665);
  --secondary: oklch(0.278 0.033 256.848);
  --muted-foreground: oklch(0.707 0.022 261.325);
  --border: oklch(1 0 0 / 10%);
}
```

#### Slate

The most blue-tinted gray, with highest chroma around 264-265 degrees (e.g., `oklch(0.208 0.042 265.755)`).

```css
:root {
  --foreground: oklch(0.129 0.042 264.695);
  --primary: oklch(0.208 0.042 265.755);
  --primary-foreground: oklch(0.984 0.003 247.858);
  --secondary: oklch(0.968 0.007 247.896);
  --muted-foreground: oklch(0.554 0.046 257.417);
  --border: oklch(0.929 0.013 255.508);
}

.dark {
  --background: oklch(0.129 0.042 264.695);
  --foreground: oklch(0.984 0.003 247.858);
  --primary: oklch(0.929 0.013 255.508);
  --primary-foreground: oklch(0.208 0.042 265.755);
  --secondary: oklch(0.279 0.041 260.031);
  --muted-foreground: oklch(0.704 0.04 256.788);
  --border: oklch(1 0 0 / 10%);
}
```

---

## Tailwind v4 Migration

All components are updated for Tailwind v4 and React 19. HSL colors have been converted to OKLCH. The `default` style is deprecated in favor of `new-york`. The `toast` component is deprecated in favor of `sonner`. Buttons now use the default cursor. Every primitive now has a `data-slot` attribute for styling.

This is non-breaking: existing apps with Tailwind v3 and React 18 continue to work. Only new projects start with Tailwind v4 and React 19.

### Step 1: Follow the Tailwind v4 Upgrade Guide

Upgrade to Tailwind v4 by following the official upgrade guide at https://tailwindcss.com/docs/upgrade-guide. Use the `@tailwindcss/upgrade@next` codemod to remove deprecated utility classes and update the tailwind config.

Important: Read the Tailwind v4 Compatibility Docs at https://tailwindcss.com/docs/compatibility and make sure your project is ready for the upgrade. Tailwind v4 uses bleeding-edge browser features and is designed for modern browsers.

### Step 2: Update CSS Variables

The codemod migrates CSS variables as references under the `@theme` directive:

```css
@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 0 0% 3.9%;
  }
}

@theme {
  --color-background: hsl(var(--background));
  --color-foreground: hsl(var(--foreground));
}
```

This works, but to simplify working with colors and variables, restructure as follows:

1. Move `:root` and `.dark` out of `@layer base`.
2. Wrap the color values in `hsl()`.
3. Add the `inline` option to `@theme` (i.e., `@theme inline`).
4. Remove the `hsl()` wrappers from `@theme`.

After:

```css
:root {
  --background: hsl(0 0% 100%);
  --foreground: hsl(0 0% 3.9%);
}

.dark {
  --background: hsl(0 0% 3.9%);
  --foreground: hsl(0 0% 98%);
}

@theme inline {
  --color-background: var(--background);
  --color-foreground: var(--foreground);
}
```

This makes theme variables accessible in both utility classes and JavaScript.

### Step 3: Update Colors for Charts

Since theme colors now include `hsl()`, remove the wrapper in `chartConfig`:

```diff
const chartConfig = {
  desktop: {
    label: "Desktop",
-    color: "hsl(var(--chart-1))",
+    color: "var(--chart-1)",
  },
  mobile: {
    label: "Mobile",
-   color: "hsl(var(--chart-2))",
+   color: "var(--chart-2)",
  },
} satisfies ChartConfig
```

### Step 4: Use the size-* Utility

The `size-*` utility (added in Tailwind v3.4) is now fully supported by `tailwind-merge`. Replace `w-* h-*` with `size-*`:

```diff
- w-4 h-4
+ size-4
```

### Step 5: Update Dependencies

```bash
pnpm up "@radix-ui/*" cmdk lucide-react recharts tailwind-merge clsx --latest
```

### Step 6: Remove forwardRef

Use the `remove-forward-ref` codemod from https://github.com/reactjs/react-codemod#remove-forward-ref, or update manually:

1. Replace `React.forwardRef<...>` with `React.ComponentProps<...>`.
2. Remove `ref={ref}` from the component.
3. Add a `data-slot` attribute for styling with Tailwind.
4. Optionally convert to a named function and remove the `displayName`.

#### Before

```tsx
const AccordionItem = React.forwardRef<
  React.ElementRef<typeof AccordionPrimitive.Item>,
  React.ComponentPropsWithoutRef<typeof AccordionPrimitive.Item>
>(({ className, ...props }, ref) => (
  <AccordionPrimitive.Item
    ref={ref}
    className={cn("border-b last:border-b-0", className)}
    {...props}
  />
))
AccordionItem.displayName = "AccordionItem"
```

#### After

```tsx
function AccordionItem({
  className,
  ...props
}: React.ComponentProps<typeof AccordionPrimitive.Item>) {
  return (
    <AccordionPrimitive.Item
      data-slot="accordion-item"
      className={cn("border-b last:border-b-0", className)}
      {...props}
    />
  )
}
```

### Deprecating tailwindcss-animate (March 19, 2025)

`tailwindcss-animate` is deprecated in favor of `tw-animate-css`. New projects use `tw-animate-css` by default.

To migrate existing projects:

1. Remove `tailwindcss-animate` from your dependencies.
2. Remove `@plugin 'tailwindcss-animate'` from your globals.css file.
3. Install `tw-animate-css` as a dev dependency.
4. Add `@import "tw-animate-css"` to your globals.css file.

```diff
- @plugin 'tailwindcss-animate';
+ @import "tw-animate-css";
```

---

## React 19 Compatibility

React 19 is supported in the latest Next.js 15 release. Package maintainers need to update their packages to include React 19 as a peer dependency:

```diff
"peerDependencies": {
-  "react": "^16.8 || ^17.0 || ^18.0",
+  "react": "^16.8 || ^17.0 || ^18.0 || ^19.0",
-  "react-dom": "^16.8 || ^17.0 || ^18.0"
+  "react-dom": "^16.8 || ^17.0 || ^18.0 || ^19.0"
},
```

Check if a package lists React 19 as a peer dependency by running `npm info <package> peerDependencies`.

### Peer Dependency Error

If you install a package that does not list React 19 as a peer dependency, npm shows:

```
npm error code ERESOLVE
npm error ERESOLVE unable to resolve dependency tree
npm error
npm error While resolving: my-app@0.1.0
npm error Found: react@19.0.0-rc-69d4b800-20241021
npm error node_modules/react
npm error   react@"19.0.0-rc-69d4b800-20241021" from the root project
```

Note: This is npm only. pnpm and bun show only a silent warning.

### Solution 1: --force or --legacy-peer-deps

Force install the package and ignore peer dependency warnings:

```bash
npm i <package> --force

npm i <package> --legacy-peer-deps
```

- `--force`: Ignores and overrides any dependency conflicts, forcing installation.
- `--legacy-peer-deps`: Skips strict peer dependency checks, allowing installation with unmet peer dependencies.

### Solution 2: Downgrade to React 18

Downgrade `react` and `react-dom` to version 18 and upgrade when dependencies are updated:

```bash
npm i react@18 react-dom@18
```

### Using pnpm, bun, or yarn

Follow the standard installation guide. No flags are needed.

### Using npm

When you run `npx shadcn@latest init -d`, you will be prompted to select an option:

```
It looks like you are using React 19.
Some packages may fail to install due to peer dependency issues (see https://ui.shadcn.com/react-19).

? How would you like to proceed? > - Use arrow-keys. Return to submit.
    Use --force
    Use --legacy-peer-deps
```

### Package Compatibility Table

| Package | Status | Note |
|---|---|---|
| radix-ui | Works | |
| lucide-react | Works | |
| class-variance-authority | Works | Does not list React 19 as a peer dependency |
| tailwindcss-animate | Works | Does not list React 19 as a peer dependency |
| embla-carousel-react | Works | |
| recharts | Works | See Recharts setup below |
| react-hook-form | Works | |
| react-resizable-panels | Works | |
| sonner | Works | |
| react-day-picker | Works | Works with flag for npm. Upgrade to v9 in progress |
| input-otp | Works | |
| vaul | Works | |
| @radix-ui/react-icons | Works | |
| cmdk | Works | |

### Recharts Special Setup

To use recharts with React 19, override the `react-is` dependency.

Step 1: Add the following to your `package.json`:

```json
"overrides": {
  "react-is": "^19.0.0-rc-69d4b800-20241021"
}
```

The `react-is` version must match the version of React 19 you are using.

Step 2: Run the install command:

```bash
npm install --legacy-peer-deps
```

---

## CLI Detailed Reference

### create

Interactive project scaffolding with custom themes, components, and presets. Supports Next.js, Vite, and TanStack Start.

```bash
npx shadcn@latest create
npx shadcn@latest create --template next --rtl
npx shadcn@latest create --template start --rtl
npx shadcn@latest create --template vite --rtl
```

Options: `--template` (`next`, `vite`, `start`), `--rtl` (enable RTL support).

Creates a fully configured app with custom themes, Base UI or Radix, and icon library selection. Recommended for new projects over manual `init`.

### init

Initialize configuration and dependencies for a new project. Installs dependencies, adds the `cn` util, and configures CSS variables.

```bash
npx shadcn@latest init
```

Options:

| Flag | Description |
|------|-------------|
| `-t, --template <template>` | Template to use: `next`, `next-monorepo` |
| `-b, --base-color <color>` | Base color: `neutral`, `gray`, `zinc`, `stone`, `slate` |
| `-y, --yes` | Skip confirmation prompt (default: true) |
| `-f, --force` | Force overwrite of existing configuration |
| `-c, --cwd <cwd>` | Working directory (defaults to current) |
| `-s, --silent` | Mute output |
| `--src-dir` | Use the src directory when creating a new project |
| `--no-src-dir` | Do not use src directory |
| `--css-variables` | Use CSS variables for theming (default: true) |
| `--no-css-variables` | Do not use CSS variables for theming |
| `--no-base-style` | Do not install the base shadcn style |

Arguments: `[components...]` — name, url or local path to component.

### add

Add components and dependencies to your project.

```bash
npx shadcn@latest add [component]
```

Options:

| Flag | Description |
|------|-------------|
| `-y, --yes` | Skip confirmation prompt |
| `-o, --overwrite` | Overwrite existing files |
| `-a, --all` | Add all available components |
| `-p, --path <path>` | Path to add the component to |
| `-c, --cwd <cwd>` | Working directory |
| `-s, --silent` | Mute output |
| `--src-dir` | Use the src directory |
| `--css-variables` | Use CSS variables for theming (default: true) |
| `--no-css-variables` | Do not use CSS variables |

### view

View registry items before installing them.

```bash
npx shadcn@latest view [item]
npx shadcn@latest view button card dialog
npx shadcn@latest view @acme/auth @v0/dashboard
```

Options: `-c, --cwd <cwd>` (working directory).

### search / list

Search for or list items from registries. `list` is an alias for `search`.

```bash
npx shadcn@latest search @shadcn -q "button"
npx shadcn@latest search @shadcn @v0 @acme
npx shadcn@latest list @acme
```

Options:

| Flag | Description |
|------|-------------|
| `-q, --query <query>` | Query string |
| `-l, --limit <number>` | Maximum items to display per registry (default: 100) |
| `-o, --offset <number>` | Number of items to skip (default: 0) |
| `-c, --cwd <cwd>` | Working directory |

### build

Generate registry JSON files from `registry.json`.

```bash
npx shadcn@latest build
npx shadcn@latest build --output ./public/registry
```

Arguments: `[registry]` — path to registry.json file (default: `./registry.json`).

Options:

| Flag | Description |
|------|-------------|
| `-o, --output <path>` | Destination directory for JSON files (default: `./public/r`) |
| `-c, --cwd <cwd>` | Working directory |

### migrate

Run migrations on your project.

```bash
npx shadcn@latest migrate [migration] [path]
```

Available migrations:

| Migration | Description |
|-----------|-------------|
| `icons` | Migrate UI components to a different icon library |
| `radix` | Migrate to unified `radix-ui` package |
| `rtl` | Migrate components to support RTL (right-to-left) |

Options: `-c, --cwd <cwd>`, `-l, --list` (list all migrations), `-y, --yes` (skip confirmation).

`[path]` accepts a specific file or glob pattern. If omitted, migrates all files in the `ui` directory.

### migrate icons

Migrates UI components to a different icon library. Transforms icon imports across all component files.

```bash
npx shadcn@latest migrate icons
npx shadcn@latest migrate icons "src/components/ui/**"
```

### migrate rtl

Transforms components to support RTL:

1. Updates `components.json` to set `rtl: true`
2. Transforms physical CSS properties to logical equivalents (`ml-4` → `ms-4`, `text-left` → `text-start`)
3. Adds `rtl:` variants where needed (`space-x-4` → `space-x-4 rtl:space-x-reverse`)

```bash
npx shadcn@latest migrate rtl
npx shadcn@latest migrate rtl src/components/ui/button.tsx
npx shadcn@latest migrate rtl "src/components/ui/**"
```

### migrate radix

Updates imports from individual `@radix-ui/react-*` packages to unified `radix-ui`:

Before:
```tsx
import * as DialogPrimitive from "@radix-ui/react-dialog"
import * as SelectPrimitive from "@radix-ui/react-select"
```

After:
```tsx
import { Dialog as DialogPrimitive, Select as SelectPrimitive } from "radix-ui"
```

Adds `radix-ui` to `package.json`. After migration, remove unused `@radix-ui/react-*` packages.

```bash
npx shadcn@latest migrate radix
npx shadcn@latest migrate radix "src/components/ui/**"
```
