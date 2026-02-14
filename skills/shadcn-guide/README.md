# shadcn/ui Guide Plugin

Build UIs faster with Claude. This plugin teaches Claude everything about shadcn/ui — from installing and theming components to building forms, registries, and complete design systems with the open-code component approach.

## What it does

Instead of switching between docs and code, just describe what you need. Claude will generate correct shadcn/ui code with proper CLI commands, component composition, theming, and framework-specific configuration.

Covers 58+ components in both Base UI and Radix variants, across 10 supported frameworks.

## Installation

```bash
claude install-plugin /path/to/shadcn-guide-plugin
```

Or add the plugin directory to your Claude Code configuration.

## Usage

Once installed, Claude automatically activates this guide when you:

- "Install shadcn/ui in my Next.js project"
- "Add a dialog component with shadcn"
- "Set up dark mode with shadcn/ui"
- "Create a form with react-hook-form and shadcn"
- "Build a custom component registry"
- "Configure shadcn for a monorepo"
- "Set up RTL support for Arabic"
- "Add a data table with sorting and filtering"
- "Theme my shadcn components with custom colors"
- "Set up the shadcn MCP server"

## What's included

| Reference | Coverage |
|-----------|----------|
| Installation | Next.js, Vite, Astro, React Router, Remix, Laravel, Gatsby, TanStack Start/Router, Manual |
| Configuration | components.json, CLI commands, aliases, icon libraries, registries |
| Components - Overlays | Alert Dialog, Command, Dialog, Drawer, Hover Card, Popover, Sheet, Tooltip |
| Components - Navigation | Breadcrumb, Context Menu, Dropdown Menu, Menubar, Navigation Menu, Pagination, Sidebar, Tabs |
| Components - Form Inputs | Combobox, Field, Input, Input Group, Input OTP, Label, Native Select, Select, Textarea |
| Components - Form Controls | Button, Button Group, Calendar, Checkbox, Date Picker, Radio Group, Slider, Switch, Toggle, Toggle Group |
| Components - Data Display | Alert, Avatar, Badge, Card, Carousel, Chart, Data Table, Empty, Item, Table, Typography |
| Components - Layout | Accordion, Aspect Ratio, Collapsible, Direction, Kbd, Progress, Resizable, Scroll Area, Separator, Skeleton, Sonner, Spinner |
| Forms | React Hook Form + Zod, TanStack Form + Zod, Next.js Server Actions, Field component |
| Patterns | Dark mode (per framework), RTL support, monorepo setup |
| Registry Core | Schema, item types, files, dependencies, namespaces, CSS variables |
| Registry Advanced | Authentication, MCP server, blocks, Open in v0, community registries |

## License

MIT
