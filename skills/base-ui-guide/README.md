# Base UI Guide Plugin

Build accessible React interfaces faster with Claude. This plugin teaches Claude everything about Base UI (`@base-ui/react`) — from component APIs and styling patterns to animation, form integration, and accessibility best practices.

## What it does

Instead of searching docs, just describe what you need. Claude will generate correct, accessible Base UI code with proper component composition, styling, and TypeScript types.

Covers all 35+ components: Dialog, Menu, Popover, Select, Combobox, Tabs, Accordion, Toast, Form, Slider, and more.

## Installation

```bash
claude install-plugin /path/to/base-ui-guide-plugin
```

Or add the plugin directory to your Claude Code configuration.

## Usage

Once installed, Claude automatically activates this guide when you:

- "Build a dialog with Base UI"
- "Create a searchable select with Combobox"
- "Style Base UI components with Tailwind"
- "Animate a Base UI popover"
- "Add form validation with Base UI Field"
- "Implement accessible tabs"

## What's included

| Reference | Coverage |
|-----------|----------|
| Components - Dialogs | Dialog, AlertDialog, Popover, Tooltip, PreviewCard |
| Components - Menus | Toast, Menu, ContextMenu, NavigationMenu, Menubar |
| Components - Form Fields | Form, Field, Fieldset, Input, NumberField, Checkbox, Radio |
| Components - Form Controls | Select, Combobox, Autocomplete, Switch, Slider, Toggle, Button |
| Components - Panels | Accordion, Collapsible, Tabs, ScrollArea |
| Components - Indicators | Toolbar, Separator, Progress, Meter, Avatar |
| Styling | Tailwind CSS, CSS Modules, CSS-in-JS, data attributes |
| Animation | CSS transitions, CSS animations, Motion/JS integration |
| Composition | Render props, event customization, custom components |
| Forms & TypeScript | Form integration, validation, TypeScript type patterns |
| Utilities | CSPProvider, DirectionProvider, mergeProps, useRender |
| Accessibility | Keyboard navigation, focus management, ARIA patterns |

## License

MIT
