# shadcn/ui Patterns — Dark Mode, RTL & Monorepo

Setup guides for dark mode (per framework), RTL support, and monorepo configuration.

## Dark Mode

### Next.js (next-themes)

#### Install next-themes

```bash
npm install next-themes
```

#### Create a Theme Provider

```tsx title="components/theme-provider.tsx"
"use client"

import * as React from "react"
import { ThemeProvider as NextThemesProvider } from "next-themes"

export function ThemeProvider({
  children,
  ...props
}: React.ComponentProps<typeof NextThemesProvider>) {
  return <NextThemesProvider {...props}>{children}</NextThemesProvider>
}
```

#### Wrap Your Root Layout

Add `suppressHydrationWarning` to the `html` tag:

```tsx title="app/layout.tsx"
import { ThemeProvider } from "@/components/theme-provider"

export default function RootLayout({ children }: RootLayoutProps) {
  return (
    <>
      <html lang="en" suppressHydrationWarning>
        <head />
        <body>
          <ThemeProvider
            attribute="class"
            defaultTheme="system"
            enableSystem
            disableTransitionOnChange
          >
            {children}
          </ThemeProvider>
        </body>
      </html>
    </>
  )
}
```

#### Add a Mode Toggle

The ModeToggle component uses Sun/Moon icons with CSS transitions:

```tsx title="components/mode-toggle.tsx"
import { Moon, Sun } from "lucide-react"

import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { useTheme } from "next-themes"

export function ModeToggle() {
  const { setTheme } = useTheme()

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="outline" size="icon">
          <Sun className="h-[1.2rem] w-[1.2rem] scale-100 rotate-0 transition-all dark:scale-0 dark:-rotate-90" />
          <Moon className="absolute h-[1.2rem] w-[1.2rem] scale-0 rotate-90 transition-all dark:scale-100 dark:rotate-0" />
          <span className="sr-only">Toggle theme</span>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuItem onClick={() => setTheme("light")}>
          Light
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => setTheme("dark")}>
          Dark
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => setTheme("system")}>
          System
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
```

### Vite (Custom ThemeProvider)

#### Create a Theme Provider

Custom provider using React Context and localStorage:

```tsx title="components/theme-provider.tsx"
import { createContext, useContext, useEffect, useState } from "react"

type Theme = "dark" | "light" | "system"

type ThemeProviderProps = {
  children: React.ReactNode
  defaultTheme?: Theme
  storageKey?: string
}

type ThemeProviderState = {
  theme: Theme
  setTheme: (theme: Theme) => void
}

const initialState: ThemeProviderState = {
  theme: "system",
  setTheme: () => null,
}

const ThemeProviderContext = createContext<ThemeProviderState>(initialState)

export function ThemeProvider({
  children,
  defaultTheme = "system",
  storageKey = "vite-ui-theme",
  ...props
}: ThemeProviderProps) {
  const [theme, setTheme] = useState<Theme>(
    () => (localStorage.getItem(storageKey) as Theme) || defaultTheme
  )

  useEffect(() => {
    const root = window.document.documentElement

    root.classList.remove("light", "dark")

    if (theme === "system") {
      const systemTheme = window.matchMedia("(prefers-color-scheme: dark)")
        .matches
        ? "dark"
        : "light"

      root.classList.add(systemTheme)
      return
    }

    root.classList.add(theme)
  }, [theme])

  const value = {
    theme,
    setTheme: (theme: Theme) => {
      localStorage.setItem(storageKey, theme)
      setTheme(theme)
    },
  }

  return (
    <ThemeProviderContext.Provider {...props} value={value}>
      {children}
    </ThemeProviderContext.Provider>
  )
}

export const useTheme = () => {
  const context = useContext(ThemeProviderContext)

  if (context === undefined)
    throw new Error("useTheme must be used within a ThemeProvider")

  return context
}
```

#### Wrap Your Root Layout

```tsx title="App.tsx"
import { ThemeProvider } from "@/components/theme-provider"

function App() {
  return (
    <ThemeProvider defaultTheme="dark" storageKey="vite-ui-theme">
      {children}
    </ThemeProvider>
  )
}

export default App
```

#### Add a Mode Toggle

Import `useTheme` from your custom provider instead of next-themes:

```tsx title="components/mode-toggle.tsx"
import { Moon, Sun } from "lucide-react"

import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { useTheme } from "@/components/theme-provider"

export function ModeToggle() {
  const { setTheme } = useTheme()

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="outline" size="icon">
          <Sun className="h-[1.2rem] w-[1.2rem] scale-100 rotate-0 transition-all dark:scale-0 dark:-rotate-90" />
          <Moon className="absolute h-[1.2rem] w-[1.2rem] scale-0 rotate-90 transition-all dark:scale-100 dark:rotate-0" />
          <span className="sr-only">Toggle theme</span>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuItem onClick={() => setTheme("light")}>
          Light
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => setTheme("dark")}>
          Dark
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => setTheme("system")}>
          System
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
```

### Remix (remix-themes)

#### Modify Your tailwind.css

Add `:root[class~="dark"]` selector:

```css title="app/tailwind.css"
.dark,
:root[class~="dark"] {
  ...;
}
```

#### Install remix-themes

```bash
npm install remix-themes
```

#### Create a Session Storage and Theme Session Resolver

```tsx title="app/sessions.server.tsx"
import { createThemeSessionResolver } from "remix-themes"

// You can default to 'development' if process.env.NODE_ENV is not set
const isProduction = process.env.NODE_ENV === "production"

const sessionStorage = createCookieSessionStorage({
  cookie: {
    name: "theme",
    path: "/",
    httpOnly: true,
    sameSite: "lax",
    secrets: ["s3cr3t"],
    // Set domain and secure only if in production
    ...(isProduction
      ? { domain: "your-production-domain.com", secure: true }
      : {}),
  },
})

export const themeSessionResolver = createThemeSessionResolver(sessionStorage)
```

#### Set Up Remix Themes in Root

```tsx title="app/root.tsx"
import clsx from "clsx"
import { PreventFlashOnWrongTheme, ThemeProvider, useTheme } from "remix-themes"

import { themeSessionResolver } from "./sessions.server"

// Return the theme from the session storage using the loader
export async function loader({ request }: LoaderFunctionArgs) {
  const { getTheme } = await themeSessionResolver(request)
  return {
    theme: getTheme(),
  }
}
// Wrap your app with ThemeProvider.
// `specifiedTheme` is the stored theme in the session storage.
// `themeAction` is the action name that's used to change the theme in the session storage.
export default function AppWithProviders() {
  const data = useLoaderData<typeof loader>()
  return (
    <ThemeProvider specifiedTheme={data.theme} themeAction="/action/set-theme">
      <App />
    </ThemeProvider>
  )
}

export function App() {
  const data = useLoaderData<typeof loader>()
  const [theme] = useTheme()
  return (
    <html lang="en" className={clsx(theme)}>
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <Meta />
        <PreventFlashOnWrongTheme ssrTheme={Boolean(data.theme)} />
        <Links />
      </head>
      <body>
        <Outlet />
        <ScrollRestoration />
        <Scripts />
        <LiveReload />
      </body>
    </html>
  )
}
```

#### Add an Action Route

```tsx title="app/routes/action.set-theme.ts"
import { createThemeAction } from "remix-themes"

import { themeSessionResolver } from "./sessions.server"

export const action = createThemeAction(themeSessionResolver)
```

#### Add a Mode Toggle

```tsx title="components/mode-toggle.tsx"
import { Moon, Sun } from "lucide-react"
import { Theme, useTheme } from "remix-themes"

import { Button } from "./ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "./ui/dropdown-menu"

export function ModeToggle() {
  const [, setTheme] = useTheme()

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" size="icon">
          <Sun className="h-[1.2rem] w-[1.2rem] scale-100 rotate-0 transition-all dark:scale-0 dark:-rotate-90" />
          <Moon className="absolute h-[1.2rem] w-[1.2rem] scale-0 rotate-90 transition-all dark:scale-100 dark:rotate-0" />
          <span className="sr-only">Toggle theme</span>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuItem onClick={() => setTheme(Theme.LIGHT)}>
          Light
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => setTheme(Theme.DARK)}>
          Dark
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
```

### Astro

#### Create an Inline Theme Script

Add a script with `is:inline` to prevent flash of wrong theme:

```astro title="src/pages/index.astro"
---
import '../styles/globals.css'
---

<script is:inline>
	const getThemePreference = () => {
		if (typeof localStorage !== 'undefined' && localStorage.getItem('theme')) {
			return localStorage.getItem('theme');
		}
		return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
	};
	const isDark = getThemePreference() === 'dark';
	document.documentElement.classList[isDark ? 'add' : 'remove']('dark');

	if (typeof localStorage !== 'undefined') {
		const observer = new MutationObserver(() => {
			const isDark = document.documentElement.classList.contains('dark');
			localStorage.setItem('theme', isDark ? 'dark' : 'light');
		});
		observer.observe(document.documentElement, { attributes: true, attributeFilter: ['class'] });
	}
</script>

<html lang="en">
	<body>
      <h1>Astro</h1>
	</body>
</html>
```

#### Add a Mode Toggle Component

```tsx title="src/components/ModeToggle.tsx"
import * as React from "react"
import { Moon, Sun } from "lucide-react"

import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"

export function ModeToggle() {
  const [theme, setThemeState] = React.useState<
    "theme-light" | "dark" | "system"
  >("theme-light")

  React.useEffect(() => {
    const isDarkMode = document.documentElement.classList.contains("dark")
    setThemeState(isDarkMode ? "dark" : "theme-light")
  }, [])

  React.useEffect(() => {
    const isDark =
      theme === "dark" ||
      (theme === "system" &&
        window.matchMedia("(prefers-color-scheme: dark)").matches)
    document.documentElement.classList[isDark ? "add" : "remove"]("dark")
  }, [theme])

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="outline" size="icon">
          <Sun className="h-[1.2rem] w-[1.2rem] scale-100 rotate-0 transition-all dark:scale-0 dark:-rotate-90" />
          <Moon className="absolute h-[1.2rem] w-[1.2rem] scale-0 rotate-90 transition-all dark:scale-100 dark:rotate-0" />
          <span className="sr-only">Toggle theme</span>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuItem onClick={() => setThemeState("theme-light")}>
          Light
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => setThemeState("dark")}>
          Dark
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => setThemeState("system")}>
          System
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
```

#### Display the Mode Toggle

Use `client:load` directive in Astro templates:

```astro title="src/pages/index.astro"
---
import '../styles/globals.css'
import { ModeToggle } from '@/components/ModeToggle';
---

<!-- Inline script -->

<html lang="en">
	<body>
      <h1>Astro</h1>
      <ModeToggle client:load />
	</body>
</html>
```

---

## RTL (Right-to-Left)

shadcn/ui components have first-class support for right-to-left (RTL) layouts. Text alignment, positioning, and directional styles automatically adapt for languages like Arabic, Hebrew, and Persian.

### How It Works

When you install components with `rtl: true` set in your `components.json`, the shadcn CLI automatically transforms classes and props:

- Physical positioning classes like `left-*` and `right-*` are converted to logical equivalents like `start-*` and `end-*`.
- Directional props are updated to use logical values.
- Text alignment and spacing classes are adjusted accordingly.
- Supported icons are automatically flipped using `rtl:rotate-180`.
- Animation classes like `slide-in-from-right` become `slide-in-from-end`.

Automatic RTL transformation via the CLI is only available for projects created using `shadcn create` with the new styles (`base-nova`, `radix-nova`, etc.).

### Next.js Setup

Create a project with RTL support:

```bash
npx shadcn@latest create --template next --rtl
```

This creates a `components.json` with:

```json title="components.json"
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "base-nova",
  "rtl": true
}
```

Add `DirectionProvider` to your root layout with `dir="rtl"` and `lang="ar"` on the `html` tag:

```tsx title="app/layout.tsx"
import { DirectionProvider } from "@/components/ui/direction"

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="ar" dir="rtl">
      <body>
        <DirectionProvider direction="rtl">{children}</DirectionProvider>
      </body>
    </html>
  )
}
```

Add an RTL font (Noto Sans Arabic recommended):

```tsx title="app/layout.tsx"
import { Noto_Sans_Arabic } from "next/font/google"

import { DirectionProvider } from "@/components/ui/direction"

const fontSans = Noto_Sans_Arabic({
  subsets: ["arabic"],
  variable: "--font-sans",
})

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="ar" dir="rtl" className={fontSans.variable}>
      <body>
        <DirectionProvider direction="rtl">{children}</DirectionProvider>
      </body>
    </html>
  )
}
```

### TanStack Start Setup

Create a project:

```bash
npx shadcn@latest create --template start --rtl
```

Add `DirectionProvider` in `__root.tsx`:

```tsx title="src/routes/__root.tsx"
import { DirectionProvider } from "@/components/ui/direction"

export const Route = createRootRoute({
  component: RootComponent,
})

function RootComponent() {
  return (
    <html lang="ar" dir="rtl">
      <head>
        <Meta />
      </head>
      <body>
        <DirectionProvider direction="rtl">{children}</DirectionProvider>
        <Scripts />
      </body>
    </html>
  )
}
```

Install the font using Fontsource and import in CSS:

```bash
npm install @fontsource-variable/noto-sans-arabic
```

```css title="src/styles.css"
@import "tailwindcss";
@import "tw-animate-css";
@import "shadcn/tailwind.css";
@import "@fontsource-variable/noto-sans-arabic";

@theme inline {
  --font-sans: "Noto Sans Arabic Variable", sans-serif;
}
```

### Vite Setup

Create a project:

```bash
npx shadcn@latest create --template vite --rtl
```

Add `dir="rtl"` and `lang="ar"` to the `html` tag in `index.html`:

```html title="index.html"
<!doctype html>
<html lang="ar" dir="rtl">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Vite App</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

Wrap your app with `DirectionProvider` in `main.tsx`:

```tsx title="src/main.tsx"
import { StrictMode } from "react"
import { createRoot } from "react-dom/client"

import { DirectionProvider } from "@/components/ui/direction"

import App from "./App"

import "./index.css"

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <DirectionProvider direction="rtl">
      <App />
    </DirectionProvider>
  </StrictMode>
)
```

Install font via Fontsource and import in CSS:

```bash
npm install @fontsource-variable/noto-sans-arabic
```

```css title="src/index.css"
@import "tailwindcss";
@import "tw-animate-css";
@import "shadcn/tailwind.css";
@import "@fontsource-variable/noto-sans-arabic";

@theme inline {
  --font-sans: "Noto Sans Arabic Variable", sans-serif;
}
```

### Portal Elements (dir="rtl")

There is a known issue with `tw-animate-css` where logical slide utilities do not work as expected. Pass the `dir` prop to portal elements:

```tsx
<Popover>
  <PopoverTrigger>Open</PopoverTrigger>
  <PopoverContent dir="rtl">
    <div>Content</div>
  </PopoverContent>
</Popover>
```

```tsx
<Tooltip>
  <TooltipTrigger>Open</TooltipTrigger>
  <TooltipContent dir="rtl">
    <div>Content</div>
  </TooltipContent>
</Tooltip>
```

### Migrating Existing Components

Run the migrate command to convert existing components to RTL:

```bash
npx shadcn@latest migrate rtl [path]
```

`[path]` accepts a path or glob pattern. If omitted, it migrates all files in the `ui` directory.

The following components require manual migration:
- Calendar
- Pagination
- Sidebar

### Icon Flipping

Some directional icons need the `rtl:rotate-180` class:

```tsx
<ArrowRightIcon className="rtl:rotate-180" />
```

### Adding the Direction Component

```bash
npx shadcn@latest add direction
```

### Font Recommendations

Noto is recommended for RTL languages and pairs well with Inter and Geist:
- Arabic: `Noto_Sans_Arabic` (Next.js) or `@fontsource-variable/noto-sans-arabic` (Vite/TanStack)
- Hebrew: `Noto_Sans_Hebrew` or `@fontsource-variable/noto-sans-hebrew`

---

## Monorepo Setup

shadcn/ui CLI has built-in monorepo support. The CLI understands the monorepo structure and installs components, dependencies, and registry dependencies to the correct paths, handling imports automatically.

### Create a Monorepo Project

```bash
npx shadcn@latest init
```

Select the `Next.js (Monorepo)` option:

```
? Would you like to start a new project?
    Next.js
>   Next.js (Monorepo)
```

This creates a monorepo with Turborepo as the build system, using React 19 and Tailwind CSS v4.

### File Structure

```
apps
+-- web                 # Your app goes here.
|   +-- app
|   |   +-- page.tsx
|   +-- components
|   |   +-- login-form.tsx
|   +-- components.json
|   +-- package.json
packages
+-- ui                  # Your components and dependencies are installed here.
|   +-- src
|   |   +-- components
|   |   |   +-- button.tsx
|   |   +-- hooks
|   |   +-- lib
|   |   |   +-- utils.ts
|   |   +-- styles
|   |       +-- globals.css
|   +-- components.json
|   +-- package.json
package.json
turbo.json
```

### Adding Components

Run the `add` command from the app directory:

```bash
cd apps/web
npx shadcn@latest add [COMPONENT]
```

The CLI automatically determines where to install:
- UI components (e.g., `button`) go to `packages/ui`
- Block components (e.g., `login-01`) install their UI dependencies in `packages/ui` and the block component in `apps/web/components`

### Import Patterns

```tsx
import { Button } from "@workspace/ui/components/button"
```

Hooks and utilities:

```tsx
import { useTheme } from "@workspace/ui/hooks/use-theme"
import { cn } from "@workspace/ui/lib/utils"
```

### Configuration (components.json)

Both workspaces require a `components.json` file.

App workspace (`apps/web/components.json`):

```json title="apps/web/components.json"
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "",
    "css": "../../packages/ui/src/styles/globals.css",
    "baseColor": "zinc",
    "cssVariables": true
  },
  "iconLibrary": "lucide",
  "aliases": {
    "components": "@/components",
    "hooks": "@/hooks",
    "lib": "@/lib",
    "utils": "@workspace/ui/lib/utils",
    "ui": "@workspace/ui/components"
  }
}
```

UI package (`packages/ui/components.json`):

```json title="packages/ui/components.json"
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "",
    "css": "src/styles/globals.css",
    "baseColor": "zinc",
    "cssVariables": true
  },
  "iconLibrary": "lucide",
  "aliases": {
    "components": "@workspace/ui/components",
    "utils": "@workspace/ui/lib/utils",
    "hooks": "@workspace/ui/hooks",
    "lib": "@workspace/ui/lib",
    "ui": "@workspace/ui/components"
  }
}
```

### Key Requirements

1. Every workspace must have a `components.json` file. A `package.json` tells npm how to install dependencies; a `components.json` tells the CLI how and where to install components.
2. The `components.json` file must properly define aliases for the workspace so the CLI knows how to import components, hooks, and utilities.
3. Ensure the same `style`, `iconLibrary`, and `baseColor` in both `components.json` files.
4. For Tailwind CSS v4, leave the `tailwind` config empty in the `components.json` file.
