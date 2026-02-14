---
name: base-ui-guide
description: Guide for Base UI (@base-ui/react), an unstyled React component library for building accessible UIs. Use when user asks to "build a component with Base UI", "create a form with Base UI", "style Base UI components", "animate Base UI popover", "use Base UI dialog", "add Base UI select", "implement Base UI tabs", or asks about Base UI accessibility, composition, customization, styling, animation, TypeScript types, or any of its 35+ components. Covers all components (Dialog, Menu, Popover, Select, Combobox, Tabs, Accordion, Toast, Form, Field, Slider, etc.), styling patterns, animations, composition via render props, event customization, form integration, and utilities. Do NOT use for Radix UI (radix-ui), Material UI (MUI @mui/material), or Shadcn/ui - those are separate libraries with different APIs.
metadata:
  author: skill-maker
  version: 1.0.0
  source: documentation-analysis
  source-docs: source/base-ui/
  category: react-ui-library
  tags: [react, ui, components, accessible, unstyled, headless, base-ui, radix, mui]
---

# Base UI Guide

Base UI (`@base-ui/react`) is an unstyled React component library for building accessible user interfaces. From the creators of Radix, Material UI, and Floating UI. Components are headless, composable, and WAI-ARIA compliant. Supports React 17+ and all modern browsers (Baseline Widely Available). Tree-shakable single package.

**Do NOT use this guide** for Radix UI (radix-ui), Material UI (MUI @mui/material), or Shadcn/ui — those are separate libraries with different APIs.

## Quick Start

```bash
npm i @base-ui/react
```

### Setup

1. **Portals** - Add stacking context isolation to prevent z-index conflicts:

```css
.root { isolation: isolate; }
```

```tsx
<body><div className="root">{children}</div></body>
```

2. **iOS 26+ Safari** - For dialog backdrops:

```css
body { position: relative; }
```

## Import Pattern

All components use namespaced compound pattern from a single package:

```tsx
import { Popover } from '@base-ui/react/popover';

<Popover.Root>
  <Popover.Trigger>Open</Popover.Trigger>
  <Popover.Portal>
    <Popover.Positioner sideOffset={8}>
      <Popover.Popup>
        <Popover.Arrow />
        <Popover.Title>Title</Popover.Title>
        <Popover.Description>Content</Popover.Description>
      </Popover.Popup>
    </Popover.Positioner>
  </Popover.Portal>
</Popover.Root>
```

## Core Patterns

### Styling (components are completely unstyled)

**CSS Classes** - static or state-dependent:
```tsx
<Switch.Thumb className="SwitchThumb" />
<Switch.Thumb className={(state) => state.checked ? 'checked' : 'unchecked'} />
```

**Data Attributes** - all components expose state via `data-*` attributes:
```css
.SwitchThumb[data-checked] { background: blue; }
.Popup[data-starting-style] { opacity: 0; transform: scale(0.9); }
```

**CSS Custom Properties** - dynamic values for layout/animation:
```css
.Indicator { width: var(--slider-indicator-width); }
.Popup { transform-origin: var(--transform-origin); }
```

Works with Tailwind CSS, CSS Modules, CSS-in-JS, or plain CSS.

### Composition (render prop)

Replace default elements with custom components or different HTML tags:

```tsx
// Custom component (must forward ref and spread props)
<Dialog.Trigger render={<MyButton size="md" />} />

// Different HTML element
<Menu.Item render={<a href="/profile" />}>Profile</Menu.Item>

// Render function with state access
<Checkbox.Root render={(props, state) => (
  <span {...props}>{state.checked ? <CheckIcon /> : <BoxIcon />}</span>
)} />
```

### Server Components (Next.js / RSC)

All interactive Base UI components require `'use client'` in React Server Component environments. Only static display components (Separator, Avatar without interaction) can be used in server components.

### Combobox List Render Pattern

Combobox and Autocomplete use a unique render-children pattern on `List` — pass a function that receives each filtered item:

```tsx
<Combobox.List>
  {(item) => (
    <Combobox.Item key={item.value} value={item}>
      {item.label}
    </Combobox.Item>
  )}
</Combobox.List>
```

This differs from Select, where you explicitly `.map()` over items inside `Select.List`.

### Controlled vs Uncontrolled

All interactive components support both modes:

```tsx
// Uncontrolled (internal state)
<Dialog.Root defaultOpen={false}>

// Controlled (external state)
<Dialog.Root open={isOpen} onOpenChange={setIsOpen}>
```

### Event Customization

Change handlers receive `(value, eventDetails)`:

```tsx
<Dialog.Root onOpenChange={(open, details) => {
  if (details.reason === 'escape-key') {
    details.cancel(); // Prevent closing
  }
}}>
```

Key `eventDetails` methods: `cancel()`, `allowPropagation()`. Access `reason` for why the change occurred.

### Animation

**CSS Transitions** (recommended - can be cancelled midway):
```css
.Popup {
  transition: transform 150ms, opacity 150ms;
  transform-origin: var(--transform-origin);
}
.Popup[data-starting-style],
.Popup[data-ending-style] {
  opacity: 0;
  transform: scale(0.9);
}
```

**CSS Animations**: Use `[data-open]` / `[data-closed]` with `@keyframes`.

**JavaScript (Motion)**: Use `keepMounted` + `render` prop + `<AnimatePresence>`.

### TypeScript

Types organized by namespace:
```tsx
Tooltip.Root.Props          // Component props
Popover.Positioner.State    // Internal state type
Combobox.Root.ChangeEventDetails  // Event details type
```

## Component Catalog

### Overlay & Navigation
| Component | Parts | Description |
|-----------|-------|-------------|
| **Dialog** | Root, Trigger, Portal, Backdrop, Popup, Title, Description, Close | Modal dialog with focus trap |
| **AlertDialog** | Root, Trigger, Portal, Backdrop, Popup, Title, Description, Close | Confirmation dialog (no pointer dismiss) |
| **Popover** | Root, Trigger, Portal, Positioner, Popup, Arrow, Title, Description | Non-modal floating content |
| **Tooltip** | Provider, Root, Trigger, Portal, Positioner, Popup, Arrow | Hover/focus info popup |
| **PreviewCard** | Root, Trigger, Portal, Positioner, Popup, Arrow | Link hover preview |
| **Toast** | Provider, Portal, Viewport, Root, Title, Description, Action, Close | Notification toasts (stacked or anchored) |
| **Menu** | Root, Trigger, Portal, Positioner, Popup, Arrow, Item, Group, Separator + Radio/Checkbox items | Dropdown menu with submenus |
| **ContextMenu** | Root, Trigger, Portal, Positioner, Popup, Item, Group + submenus | Right-click context menu |
| **NavigationMenu** | Root, List, Item, Trigger, Content, Portal, Positioner, Popup, Link | Site navigation with panels |
| **Menubar** | Wrapper + Menu.Root instances | Horizontal application menu bar |

### Form Controls
| Component | Parts | Description |
|-----------|-------|-------------|
| **Form** | Single wrapper | Form with validation and submission |
| **Field** | Root, Label, Control, Description, Error, Validity | Field wrapper with validation |
| **Fieldset** | Root, Legend | Groups related fields |
| **Input** | Single element | Text input with state data attributes |
| **NumberField** | Root, ScrubArea, Group, Decrement, Input, Increment | Numeric input with stepper |
| **Checkbox** | Root, Indicator | Checkbox with indeterminate support |
| **CheckboxGroup** | Root | Manages multiple checkbox state |
| **Radio** | Root, Indicator + RadioGroup | Radio button group |
| **Select** | Root, Trigger, Value, Portal, Positioner, Popup, List, Item, ItemIndicator | Dropdown select |
| **Combobox** | Root, Input, Trigger, Portal, Positioner, Popup, List, Item + chips | Searchable select with filtering |
| **Autocomplete** | Root, Input, Trigger, Portal, Positioner, Popup, List, Item | Text input with suggestions |
| **Switch** | Root, Thumb | Toggle switch |
| **Slider** | Root, Value, Control, Track, Indicator, Thumb | Range slider (single or multi-thumb) |
| **Toggle** | Single element | Pressable toggle button |
| **ToggleGroup** | Wrapper + Toggle children | Exclusive or multi-select toggles |
| **Button** | Single element | Accessible button |

### Display & Layout
| Component | Parts | Description |
|-----------|-------|-------------|
| **Accordion** | Root, Item, Header, Trigger, Panel | Expandable content sections |
| **Collapsible** | Root, Trigger, Panel | Single expand/collapse |
| **Tabs** | Root, List, Tab, Indicator, Panel | Tabbed interface |
| **ScrollArea** | Root, Viewport, Content, Scrollbar, Thumb, Corner | Custom scrollbars |
| **Toolbar** | Root, Button, Link, Separator, Group, Input | Action toolbar |
| **Separator** | Single element | Visual divider |
| **Progress** | Root, Track, Indicator, Value, Label | Progress bar |
| **Meter** | Root, Track, Indicator, Value, Label | Gauge/meter display |
| **Avatar** | Root, Image, Fallback | Profile image with fallback |

### Utilities
| Utility | Purpose |
|---------|---------|
| **CSPProvider** | Apply nonce to inline styles/scripts for CSP |
| **DirectionProvider** | Enable RTL behavior for components |
| **mergeProps** | Merge React props with special handler/class/style merging |
| **useRender** | Hook to enable render prop pattern in custom components |

## Key Rules

1. **Always use `isolation: isolate`** on app root for portal z-index stacking
2. **Components are unstyled** - you must provide all CSS
3. **Custom components in `render` must forward ref and spread props**
4. **Use data attributes for state-based styling**, not className toggling
5. **CSS transitions > CSS animations** for interruptible open/close effects
6. **Animate opacity** (even 0.9999) so Base UI detects animation completion before unmounting
7. **Form fields need `name` prop** on Field.Root for form submission
8. **Field.Label uses `nativeLabel` prop** - set `false` for button-based controls (Select, Combobox)
9. **Popup components** follow: Root > Trigger > Portal > Positioner > Popup > Arrow pattern
10. **`preventBaseUIHandler()`** on React events to bypass Base UI's internal event handling

## Common Pitfalls

- **Portal z-index issues**: Forgot `isolation: isolate` on app root - popups appear behind content
- **Animation not completing**: Not animating `opacity` - Base UI uses `element.getAnimations()` to detect completion; animate opacity even to `0.9999` if not otherwise needed
- **Select/Combobox label not associating**: Need `nativeLabel={false}` on `Field.Label` for button-based controls (Select, Combobox)
- **Popup appearing behind content**: Missing `Portal` wrapper or stacking context not set up
- **Form values not collected on submit**: Missing `name` prop on `Field.Root`
- **Nested popups all close on Esc**: Default behavior stops propagation; use `eventDetails.allowPropagation()` if you want parent popups to also close
- **Motion exit animations not playing**: Must use `keepMounted` on Portal + controlled `open` state + `<AnimatePresence>` for unmounted components

## Common CSS Variables

Popup/floating components expose:
- `--anchor-width`, `--anchor-height` - Trigger element dimensions
- `--available-width`, `--available-height` - Available space
- `--transform-origin` - Animation origin point

Sizing components expose:
- `--accordion-panel-height`, `--collapsible-panel-height` - Panel dimensions
- `--slider-*`, `--scroll-area-*` - Component-specific sizing
- `--active-tab-left`, `--active-tab-width` - Tab indicator positioning

## Reference Files

- `references/components-dialogs.md` - Dialog, AlertDialog, Popover, Tooltip, PreviewCard
- `references/components-menus.md` - Toast, Menu, ContextMenu, NavigationMenu, Menubar, shared patterns
- `references/components-form-fields.md` - Form, Field, Fieldset, Input, NumberField, Checkbox, CheckboxGroup, Radio
- `references/components-form-controls.md` - Select, Combobox, Autocomplete, Switch, Slider, Toggle, ToggleGroup, Button
- `references/components-panels.md` - Accordion, Collapsible, Tabs, ScrollArea
- `references/components-indicators.md` - Toolbar, Separator, Progress, Meter, Avatar
- `references/styling.md` - Complete styling guide (Tailwind, CSS Modules, CSS-in-JS)
- `references/animation.md` - Animation patterns (CSS transitions, CSS animations, Motion/JS)
- `references/composition.md` - Composition, customization, and event handling
- `references/forms-typescript.md` - Form integration and TypeScript type patterns
- `references/utilities.md` - CSPProvider, DirectionProvider, mergeProps, useRender
- `references/accessibility.md` - Accessibility features, keyboard navigation, focus management, ARIA
