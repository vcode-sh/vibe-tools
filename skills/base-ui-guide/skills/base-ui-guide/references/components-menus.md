# Menu and Toast Components Reference

Complete API reference for Base UI toast, menu, and navigation components: Toast, Menu, ContextMenu, NavigationMenu, Menubar, and shared patterns.

---

## Toast

Notification messages that appear temporarily. Supports stacking and swipe-to-dismiss.

```ts
import { Toast } from '@base-ui/react/toast';
```

### Parts

| Part | Renders | Description |
|:-----|:--------|:------------|
| `Toast.Provider` | (none) | Context for managing toasts. |
| `Toast.Viewport` | `<div>` | Container viewport for stacked toasts. |
| `Toast.Portal` | `<div>` | Moves viewport to `<body>`. |
| `Toast.Root` | `<div>` | An individual toast. |
| `Toast.Content` | `<div>` | Container for toast contents. |
| `Toast.Title` | `<h2>` | Toast heading. |
| `Toast.Description` | `<p>` | Toast message text. |
| `Toast.Action` | `<button>` | Action button. |
| `Toast.Close` | `<button>` | Dismiss button. |
| `Toast.Positioner` | `<div>` | Positions toast against an anchor (for anchored toasts). |
| `Toast.Arrow` | `<div>` | Arrow for anchored toasts. |

### Provider Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `limit` | `number` | `3` | Maximum simultaneous toasts. Oldest removed when exceeded. |
| `timeout` | `number` | `5000` | Auto-dismiss delay (ms). `0` disables auto-dismiss. |
| `toastManager` | `ToastManager` | - | Global manager for use outside React components. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `toast` | `Toast.Root.ToastObject<any>` | - | The toast object to render. |
| `swipeDirection` | `'left' \| 'right' \| 'up' \| 'down' \| Array` | `['down', 'right']` | Swipe-to-dismiss direction(s). |

### useToastManager Hook

```tsx
const toastManager = Toast.useToastManager();
```

| Method | Signature | Description |
|:-------|:----------|:------------|
| `add` | `(options) => string` | Create a toast. Returns `toastId`. |
| `close` | `(toastId: string) => void` | Close and remove a toast. |
| `update` | `(toastId: string, options) => void` | Update an existing toast. |
| `promise` | `(promise, options) => Promise` | Async toast with `loading`, `success`, `error` states. |

**Method options:** `title`, `description`, `type`, `timeout`, `priority` (`'low' \| 'high'`), `onClose`, `onRemove`, `actionProps`, `data`.

### Data Attributes

| Part | Attribute | Description |
|:-----|:----------|:------------|
| Viewport | `data-expanded` | Toasts are expanded. |
| Root | `data-expanded` | Toast is expanded. |
| Root | `data-limited` | Removed due to limit. |
| Root | `data-type` | Toast type string. |
| Root | `data-swiping` | Currently being swiped. |
| Root | `data-swipe-direction` | `'up' \| 'down' \| 'left' \| 'right'` |
| Root | `data-starting-style` / `data-ending-style` | Animation states. |
| Content | `data-behind` | Behind the frontmost toast. |
| Content | `data-expanded` | Viewport expanded. |
| Title, Description, Action, Close | `data-type` | Toast type string. |

### CSS Variables

| Variable | Part | Description |
|:---------|:-----|:------------|
| `--toast-frontmost-height` | Viewport | Height of the frontmost toast. |
| `--toast-height` | Root | Measured natural height (px). |
| `--toast-index` | Root | Index in the list. |
| `--toast-offset-y` | Root | Vertical offset when expanded. |
| `--toast-swipe-movement-x` | Root | Horizontal swipe movement. |
| `--toast-swipe-movement-y` | Root | Vertical swipe movement. |

### Example

```tsx
import { Toast } from '@base-ui/react/toast';

function App() {
  return (
    <Toast.Provider>
      <ToastTrigger />
      <Toast.Portal>
        <Toast.Viewport>
          {({ toasts }) =>
            toasts.map((toast) => (
              <Toast.Root key={toast.id} toast={toast}>
                <Toast.Content>
                  <Toast.Title>{toast.title}</Toast.Title>
                  <Toast.Description>{toast.description}</Toast.Description>
                  <Toast.Close>Dismiss</Toast.Close>
                </Toast.Content>
              </Toast.Root>
            ))
          }
        </Toast.Viewport>
      </Toast.Portal>
    </Toast.Provider>
  );
}

function ToastTrigger() {
  const toastManager = Toast.useToastManager();
  return (
    <button onClick={() => toastManager.add({ title: 'Hello', description: 'World' })}>
      Show toast
    </button>
  );
}
```

### Accessibility

- Viewport uses `role="region"` with `aria-live` announcements.
- High-priority toasts are announced assertively; low-priority politely.
- Screen readers announce the `title` and `description` strings passed to `add()`, not the rendered JSX.

### Styled Example (Tailwind)

```tsx
import { Toast } from '@base-ui/react/toast';

function App() {
  return (
    <Toast.Provider timeout={5000}>
      <ToastTrigger />
      <Toast.Portal>
        <Toast.Viewport className="fixed right-4 bottom-4 z-50 flex w-80 flex-col gap-2">
          {({ toasts }) =>
            toasts.map((toast) => (
              <Toast.Root
                key={toast.id}
                toast={toast}
                className="rounded-lg bg-[canvas] p-4 text-gray-900 shadow-lg outline outline-1 outline-gray-200 transition-all data-[ending-style]:translate-x-full data-[ending-style]:opacity-0 data-[starting-style]:translate-x-full data-[starting-style]:opacity-0 dark:outline-gray-300"
              >
                <Toast.Content>
                  <Toast.Title className="text-sm font-medium">{toast.title}</Toast.Title>
                  <Toast.Description className="mt-1 text-sm text-gray-600">
                    {toast.description}
                  </Toast.Description>
                  <Toast.Close className="absolute top-2 right-2 rounded p-1 text-gray-400 hover:text-gray-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-blue-800">
                    &times;
                  </Toast.Close>
                </Toast.Content>
              </Toast.Root>
            ))
          }
        </Toast.Viewport>
      </Toast.Portal>
    </Toast.Provider>
  );
}
```

Key Tailwind patterns:
- **Viewport**: `fixed right-4 bottom-4` for bottom-right positioning
- **Root**: `data-[starting-style]:translate-x-full` / `data-[ending-style]:translate-x-full` for slide-in/out animation
- **Close**: Absolute positioned dismiss button with hover state

---

## Menu

A dropdown menu of actions and options, triggered by a button.

```ts
import { Menu } from '@base-ui/react/menu';
```

### Parts

| Part | Renders | Description |
|:-----|:--------|:------------|
| `Menu.Root` | (none) | Groups all parts. |
| `Menu.Trigger` | `<button>` | Opens the menu. |
| `Menu.Portal` | `<div>` | Moves popup to `<body>`. |
| `Menu.Backdrop` | `<div>` | Optional overlay. |
| `Menu.Positioner` | `<div>` | Positions popup against trigger. |
| `Menu.Popup` | `<div>` | Container for menu items. |
| `Menu.Arrow` | `<div>` | Arrow pointing toward anchor. |
| `Menu.Item` | `<div>` | Interactive menu item. |
| `Menu.Separator` | `<div>` | Visual divider between items. |
| `Menu.Group` | `<div>` | Groups related items. |
| `Menu.GroupLabel` | `<div>` | Label for a group. |
| `Menu.RadioGroup` | `<div>` | Groups radio items. |
| `Menu.RadioItem` | `<div>` | Radio-button menu item. |
| `Menu.RadioItemIndicator` | `<div>` | Indicates radio selection. |
| `Menu.CheckboxItem` | `<div>` | Checkbox menu item. |
| `Menu.CheckboxItemIndicator` | `<div>` | Indicates checkbox state. |
| `Menu.SubmenuRoot` | (none) | Groups submenu parts. |
| `Menu.SubmenuTrigger` | `<div>` | Item that opens a submenu. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultOpen` | `boolean` | `false` | Initially open. |
| `open` | `boolean` | - | Controlled state. |
| `onOpenChange` | `(open, eventDetails) => void` | - | State change callback. |
| `onOpenChangeComplete` | `(open: boolean) => void` | - | After animations. |
| `modal` | `boolean` | `true` | Modal behavior. |
| `loopFocus` | `boolean` | `true` | Loop keyboard focus at list ends. |
| `highlightItemOnHover` | `boolean` | `true` | Highlight items on pointer hover. |
| `closeParentOnEsc` | `boolean` | `false` | Escape closes entire menu chain. |
| `orientation` | `'vertical' \| 'horizontal'` | `'vertical'` | Arrow key direction. |
| `disabled` | `boolean` | `false` | Disable the menu. |
| `handle` | `Menu.Handle<Payload>` | - | For external triggers. |

### Trigger Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `handle` | `Menu.Handle<Payload>` | - | Associates with menu. |
| `payload` | `Payload` | - | Data passed when opened. |
| `openOnHover` | `boolean` | - | Open on hover. |
| `delay` | `number` | `100` | Hover open delay (ms). |
| `closeDelay` | `number` | `0` | Hover close delay (ms). |
| `disabled` | `boolean` | `false` | Disable trigger. |
| `nativeButton` | `boolean` | `true` | Set `false` for non-button render. |

### Item Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `label` | `string` | - | Override text for keyboard typeahead. |
| `onClick` | `MouseEventHandler` | - | Click handler. |
| `closeOnClick` | `boolean` | `true` | Close menu on click. |
| `disabled` | `boolean` | `false` | Disable item. |
| `nativeButton` | `boolean` | `false` | Set `true` if render prop is a button. |

### CheckboxItem Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultChecked` | `boolean` | `false` | Initially checked. |
| `checked` | `boolean` | - | Controlled checked state. |
| `onCheckedChange` | `(checked, eventDetails) => void` | - | Change callback. |
| `closeOnClick` | `boolean` | `false` | Close menu on click. |
| `label` | `string` | - | Typeahead text. |

### RadioGroup Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultValue` | `any` | - | Initial selected value. |
| `value` | `any` | - | Controlled value. |
| `onValueChange` | `(value, eventDetails) => void` | - | Change callback. |

### RadioItem Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `value` | `any` | - | Item value for RadioGroup. |
| `closeOnClick` | `boolean` | `false` | Close menu on click. |
| `label` | `string` | - | Typeahead text. |

### Indicator Props (RadioItemIndicator, CheckboxItemIndicator)

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `keepMounted` | `boolean` | `false` | Keep in DOM when inactive/unchecked. |

### Separator Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `orientation` | `Orientation` | `'horizontal'` | Separator direction. |

### Positioner Props

Same as Popover.Positioner (`side` defaults to `'bottom'`).

### Popup Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `finalFocus` | `boolean \| RefObject \| function` | - | Focus target on close. |

### Data Attributes

| Part | Attribute | Description |
|:-----|:----------|:------------|
| Trigger | `data-popup-open` | Menu is open. |
| Trigger | `data-pressed` | Trigger is pressed. |
| Item | `data-highlighted` | Item is highlighted (keyboard/hover). |
| Item | `data-disabled` | Item is disabled. |
| CheckboxItem | `data-checked` / `data-unchecked` | Checked state. |
| CheckboxItem | `data-highlighted` / `data-disabled` | Interaction state. |
| RadioItem | `data-checked` / `data-unchecked` | Selected state. |
| RadioItem | `data-highlighted` / `data-disabled` | Interaction state. |
| Indicators | `data-checked` / `data-unchecked` / `data-disabled` | State. |
| Indicators | `data-starting-style` / `data-ending-style` | Animation. |
| Popup | `data-open` / `data-closed` | Open state. |
| Popup | `data-side` / `data-align` | Position. |
| Popup | `data-instant` | `'click' \| 'dismiss' \| 'group'` |
| Popup | `data-starting-style` / `data-ending-style` | Animation. |
| SubmenuTrigger | `data-popup-open` / `data-highlighted` / `data-disabled` | State. |

### CSS Variables

Same as Popover Positioner: `--anchor-height`, `--anchor-width`, `--available-height`, `--available-width`, `--transform-origin`.

### Example

```tsx
import { Menu } from '@base-ui/react/menu';

<Menu.Root>
  <Menu.Trigger>Options</Menu.Trigger>
  <Menu.Portal>
    <Menu.Positioner sideOffset={4}>
      <Menu.Popup>
        <Menu.Item onClick={() => console.log('Edit')}>Edit</Menu.Item>
        <Menu.Item onClick={() => console.log('Copy')}>Copy</Menu.Item>
        <Menu.Separator />
        <Menu.Item onClick={() => console.log('Delete')}>Delete</Menu.Item>
      </Menu.Popup>
    </Menu.Positioner>
  </Menu.Portal>
</Menu.Root>
```

### Accessibility

- Renders with `role="menu"` and items with `role="menuitem"`.
- Full keyboard navigation: arrow keys, Home/End, typeahead search.
- Modal by default (traps focus, locks scroll, disables outside interactions).
- RadioItem uses `role="menuitemradio"`; CheckboxItem uses `role="menuitemcheckbox"`.

### Styled Example (Tailwind)

```tsx
import { Menu } from '@base-ui/react/menu';

export default function ExampleMenu() {
  return (
    <Menu.Root>
      <Menu.Trigger className="flex h-10 items-center justify-center gap-1.5 rounded-md border border-gray-200 bg-gray-50 px-3.5 text-base font-medium text-gray-900 select-none hover:bg-gray-100 focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-1 focus-visible:outline-blue-800 data-[popup-open]:bg-gray-100">
        Options
      </Menu.Trigger>
      <Menu.Portal>
        <Menu.Positioner className="outline-none" sideOffset={8}>
          <Menu.Popup className="origin-[var(--transform-origin)] rounded-md bg-[canvas] py-1 text-gray-900 shadow-lg outline outline-1 outline-gray-200 transition-[transform,scale,opacity] data-[ending-style]:scale-90 data-[ending-style]:opacity-0 data-[starting-style]:scale-90 data-[starting-style]:opacity-0 dark:outline-gray-300">
            <Menu.Item className="flex cursor-default py-2 pr-8 pl-4 text-sm leading-4 outline-none select-none data-[highlighted]:relative data-[highlighted]:z-0 data-[highlighted]:text-gray-50 data-[highlighted]:before:absolute data-[highlighted]:before:inset-x-1 data-[highlighted]:before:inset-y-0 data-[highlighted]:before:z-[-1] data-[highlighted]:before:rounded-sm data-[highlighted]:before:bg-gray-900">
              Edit
            </Menu.Item>
            <Menu.Item className="flex cursor-default py-2 pr-8 pl-4 text-sm leading-4 outline-none select-none data-[highlighted]:relative data-[highlighted]:z-0 data-[highlighted]:text-gray-50 data-[highlighted]:before:absolute data-[highlighted]:before:inset-x-1 data-[highlighted]:before:inset-y-0 data-[highlighted]:before:z-[-1] data-[highlighted]:before:rounded-sm data-[highlighted]:before:bg-gray-900">
              Duplicate
            </Menu.Item>
            <Menu.Separator className="mx-3 my-1 h-px bg-gray-200" />
            <Menu.Item className="flex cursor-default py-2 pr-8 pl-4 text-sm leading-4 text-red-600 outline-none select-none data-[highlighted]:relative data-[highlighted]:z-0 data-[highlighted]:text-red-50 data-[highlighted]:before:absolute data-[highlighted]:before:inset-x-1 data-[highlighted]:before:inset-y-0 data-[highlighted]:before:z-[-1] data-[highlighted]:before:rounded-sm data-[highlighted]:before:bg-red-600">
              Delete
            </Menu.Item>
          </Menu.Popup>
        </Menu.Positioner>
      </Menu.Portal>
    </Menu.Root>
  );
}
```

Key Tailwind patterns:
- **Trigger**: `data-[popup-open]:bg-gray-100` for open state
- **Popup**: `origin-[var(--transform-origin)]` + `transition-[transform,scale,opacity]` + `data-[starting-style]:scale-90` for positioned scale animation
- **Item highlight**: `data-[highlighted]:before:*` pseudo-element behind text with `z-[-1]`
- **Destructive item**: Custom text color (`text-red-600`) with matching highlight background

---

## Context Menu

A menu activated by right-clicking or long-pressing an area. Shares the same item parts as Menu.

```ts
import { ContextMenu } from '@base-ui/react/context-menu';
```

### Parts

| Part | Renders | Description |
|:-----|:--------|:------------|
| `ContextMenu.Root` | (none) | Groups all parts. Activated by right-click/long-press. |
| `ContextMenu.Trigger` | `<div>` | Area that activates the context menu. |
| `ContextMenu.Portal` | `<div>` | Moves popup to `<body>`. |
| `ContextMenu.Positioner` | `<div>` | Positions popup at cursor. |
| `ContextMenu.Popup` | `<div>` | Container for items. |
| `ContextMenu.Arrow` | `<div>` | Arrow. |
| `ContextMenu.Item` | `<div>` | Interactive item. |
| `ContextMenu.Separator` | `<div>` | Divider. |
| `ContextMenu.Group` | `<div>` | Groups items. |
| `ContextMenu.GroupLabel` | `<div>` | Group label. |
| `ContextMenu.RadioGroup` | `<div>` | Radio group. |
| `ContextMenu.RadioItem` | `<div>` | Radio item. |
| `ContextMenu.RadioItemIndicator` | `<div>` | Radio indicator. |
| `ContextMenu.CheckboxItem` | `<div>` | Checkbox item. |
| `ContextMenu.CheckboxItemIndicator` | `<div>` | Checkbox indicator. |
| `ContextMenu.SubmenuRoot` | (none) | Submenu container. |
| `ContextMenu.SubmenuTrigger` | `<div>` | Submenu trigger. |

### Root Props

Same as Menu.Root (includes `highlightItemOnHover`, `closeParentOnEsc`, `loopFocus`, `orientation`, `disabled`).

**Key difference:** No `modal` prop (always modal). Triggered by right-click/long-press instead of click.

### Trigger Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| function` | - | CSS class. |
| `render` | `ReactElement \| function` | - | Custom render. |

**Key difference from Menu.Trigger:** No `openOnHover`, `delay`, `nativeButton`, `handle`, `payload`, or `disabled` props. The trigger is simply a container area.

### Trigger Data Attributes

| Attribute | Description |
|:----------|:------------|
| `data-popup-open` | Context menu is open. |
| `data-pressed` | Trigger is pressed (right-click/long-press active). |

All Item, RadioItem, CheckboxItem, Separator, Group, GroupLabel, Indicator, Positioner, Popup, and Arrow parts share the same API as Menu.

### Example

```tsx
import { ContextMenu } from '@base-ui/react/context-menu';

<ContextMenu.Root>
  <ContextMenu.Trigger>
    Right-click this area
  </ContextMenu.Trigger>
  <ContextMenu.Portal>
    <ContextMenu.Positioner>
      <ContextMenu.Popup>
        <ContextMenu.Item onClick={() => console.log('Cut')}>Cut</ContextMenu.Item>
        <ContextMenu.Item onClick={() => console.log('Copy')}>Copy</ContextMenu.Item>
        <ContextMenu.Item onClick={() => console.log('Paste')}>Paste</ContextMenu.Item>
      </ContextMenu.Popup>
    </ContextMenu.Positioner>
  </ContextMenu.Portal>
</ContextMenu.Root>
```

### Accessibility

- Same menu roles and keyboard navigation as Menu.
- Positioned at the cursor location on right-click.
- Long-press support for touch devices.

---

## Navigation Menu

A site-wide navigation component with hover-activated popups for content sections.

```ts
import { NavigationMenu } from '@base-ui/react/navigation-menu';
```

### Parts

| Part | Renders | Description |
|:-----|:--------|:------------|
| `NavigationMenu.Root` | `<nav>` (root) or `<div>` (nested) | Groups all parts. |
| `NavigationMenu.List` | `<ul>` | Contains navigation items. |
| `NavigationMenu.Item` | `<li>` | Individual item. |
| `NavigationMenu.Trigger` | `<button>` | Opens the item's content on hover/click. |
| `NavigationMenu.Icon` | (none) | Indicator icon (e.g., chevron). |
| `NavigationMenu.Content` | `<div>` | Content that moves into the popup when active. |
| `NavigationMenu.Link` | `<a>` | Navigation link within content. |
| `NavigationMenu.Backdrop` | `<div>` | Overlay behind popup. |
| `NavigationMenu.Portal` | `<div>` | Moves popup to `<body>`. |
| `NavigationMenu.Positioner` | `<div>` | Positions popup against active trigger. |
| `NavigationMenu.Popup` | `<nav>` | Container for navigation content. |
| `NavigationMenu.Viewport` | `<div>` | Clipping viewport for current content. |
| `NavigationMenu.Arrow` | `<div>` | Arrow pointing toward anchor. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultValue` | `any` | `null` | Initially active item value. |
| `value` | `any` | `null` | Controlled active item. Non-nullish = open. |
| `onValueChange` | `(value, eventDetails) => void` | - | Value change callback. |
| `onOpenChangeComplete` | `(open: boolean) => void` | - | After animations. |
| `delay` | `number` | `50` | Hover open delay (ms). |
| `closeDelay` | `number` | `50` | Hover close delay (ms). |
| `orientation` | `'horizontal' \| 'vertical'` | `'horizontal'` | Layout orientation. |
| `actionsRef` | `RefObject<NavigationMenu.Root.Actions \| null>` | - | Imperative actions. |

### Item Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `value` | `any` | - | Unique identifier for this item. Auto-generated if omitted. |

### Trigger Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `nativeButton` | `boolean` | `true` | Set `false` for non-button render. |

### Link Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `closeOnClick` | `boolean` | `false` | Close the menu on click. |
| `active` | `boolean` | `false` | Whether this is the current page. |

### Positioner Props

Same as Popover.Positioner (`side` defaults to `'bottom'`). Also includes `--positioner-height` and `--positioner-width` CSS variables.

### Content Data Attributes

| Attribute | Description |
|:----------|:------------|
| `data-open` / `data-closed` | Open state. |
| `data-activation-direction` | Direction another trigger was activated from. |
| `data-starting-style` / `data-ending-style` | Animation states. |

### Link Data Attributes

| Attribute | Description |
|:----------|:------------|
| `data-active` | Present when the link is the current page. |

### Trigger Data Attributes

| Attribute | Description |
|:----------|:------------|
| `data-popup-open` | Navigation menu is open. |
| `data-pressed` | Trigger is pressed. |

### CSS Variables

| Variable | Part | Description |
|:---------|:-----|:------------|
| `--anchor-height` | Positioner | Anchor height. |
| `--anchor-width` | Positioner | Anchor width. |
| `--available-height` | Positioner | Available viewport space. |
| `--available-width` | Positioner | Available viewport space. |
| `--positioner-height` | Positioner | Fixed positioner height. |
| `--positioner-width` | Positioner | Fixed positioner width. |
| `--transform-origin` | Positioner | Anchor coordinates. |
| `--popup-height` | Popup | Fixed popup height. |
| `--popup-width` | Popup | Fixed popup width. |

### Example

```tsx
import { NavigationMenu } from '@base-ui/react/navigation-menu';

<NavigationMenu.Root>
  <NavigationMenu.List>
    <NavigationMenu.Item value="products">
      <NavigationMenu.Trigger>
        Products
        <NavigationMenu.Icon />
      </NavigationMenu.Trigger>
      <NavigationMenu.Content>
        <NavigationMenu.Link href="/products/a">Product A</NavigationMenu.Link>
        <NavigationMenu.Link href="/products/b">Product B</NavigationMenu.Link>
      </NavigationMenu.Content>
    </NavigationMenu.Item>
    <NavigationMenu.Item>
      <NavigationMenu.Link href="/about">About</NavigationMenu.Link>
    </NavigationMenu.Item>
  </NavigationMenu.List>
  <NavigationMenu.Portal>
    <NavigationMenu.Positioner>
      <NavigationMenu.Popup>
        <NavigationMenu.Viewport />
      </NavigationMenu.Popup>
    </NavigationMenu.Positioner>
  </NavigationMenu.Portal>
</NavigationMenu.Root>
```

### Accessibility

- Root renders as `<nav>` with proper navigation landmark semantics.
- Trigger buttons use `aria-expanded` and `aria-controls`.
- Full keyboard navigation with roving tabindex.
- Supports nested sub-navigation menus.

---

## Menubar

A horizontal menu bar that contains multiple Menu components, providing application-level commands.

```ts
import { Menubar } from '@base-ui/react/menubar';
import { Menu } from '@base-ui/react/menu';
```

### Parts

Menubar itself renders a `<div>` element. It wraps multiple `Menu.Root` children.

### Menubar Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `loopFocus` | `boolean` | `true` | Loop keyboard focus between menu triggers. |
| `modal` | `boolean` | `true` | Whether individual menus are modal. |
| `disabled` | `boolean` | `false` | Disable the entire menubar. |
| `orientation` | `'horizontal' \| 'vertical'` | `'horizontal'` | Menubar layout direction. |

### Example

```tsx
import { Menubar } from '@base-ui/react/menubar';
import { Menu } from '@base-ui/react/menu';

<Menubar>
  <Menu.Root>
    <Menu.Trigger>File</Menu.Trigger>
    <Menu.Portal>
      <Menu.Positioner sideOffset={6}>
        <Menu.Popup>
          <Menu.Item onClick={() => {}}>New</Menu.Item>
          <Menu.Item onClick={() => {}}>Open</Menu.Item>
          <Menu.Separator />
          <Menu.Item onClick={() => {}}>Save</Menu.Item>
        </Menu.Popup>
      </Menu.Positioner>
    </Menu.Portal>
  </Menu.Root>
  <Menu.Root>
    <Menu.Trigger>Edit</Menu.Trigger>
    <Menu.Portal>
      <Menu.Positioner sideOffset={6}>
        <Menu.Popup>
          <Menu.Item onClick={() => {}}>Undo</Menu.Item>
          <Menu.Item onClick={() => {}}>Redo</Menu.Item>
        </Menu.Popup>
      </Menu.Positioner>
    </Menu.Portal>
  </Menu.Root>
</Menubar>
```

### Accessibility

- Renders with `role="menubar"`.
- Arrow keys move between menu triggers; Enter/Space opens a menu.
- Once one menu is open, moving to an adjacent trigger opens its menu automatically.
- Individual Menu components within the bar use standard `role="menu"` semantics.

---

## Shared Patterns

### Detached Triggers

All overlay components (Dialog, AlertDialog, Popover, Tooltip, PreviewCard, Menu) support detached triggers via the `createHandle()` pattern:

```tsx
const handle = Component.createHandle();

<Component.Trigger handle={handle}>Open</Component.Trigger>
<Component.Root handle={handle}>
  {/* content */}
</Component.Root>
```

### Payload Pattern

Triggers can pass typed data to the popup using `payload`:

```tsx
const handle = Component.createHandle<{ id: string }>();

<Component.Trigger handle={handle} payload={{ id: '123' }}>Open</Component.Trigger>
<Component.Root handle={handle}>
  {({ payload }) => <div>{payload?.id}</div>}
</Component.Root>
```

### Render Prop

All parts accept a `render` prop to replace the default HTML element:

```tsx
<Dialog.Trigger render={<a href="#" />}>Open</Dialog.Trigger>
```

### Transition Data Attributes

Animate entries and exits using these attributes on supported parts:
- `data-starting-style` -- present during mount animation
- `data-ending-style` -- present during unmount animation

```css
.popup {
  transition: opacity 150ms, transform 150ms;
}
.popup[data-starting-style],
.popup[data-ending-style] {
  opacity: 0;
  transform: scale(0.9);
}
```

### Common Positioner Props (Popover, Tooltip, PreviewCard, Menu, ContextMenu, NavigationMenu, Toast)

All positioned components share the same `Positioner` API:

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `side` | `Side` | varies | `'top' \| 'bottom' \| 'left' \| 'right'` |
| `sideOffset` | `number \| OffsetFunction` | `0` | Distance from anchor. |
| `align` | `Align` | `'center'` | `'start' \| 'center' \| 'end'` |
| `alignOffset` | `number \| OffsetFunction` | `0` | Alignment axis offset. |
| `arrowPadding` | `number` | `5` | Min arrow-to-edge distance. |
| `anchor` | `Element \| RefObject \| VirtualElement \| null` | - | Custom anchor. |
| `collisionAvoidance` | `CollisionAvoidance` | - | Collision strategy. |
| `collisionBoundary` | `Boundary` | `'clipping-ancestors'` | Boundary element. |
| `collisionPadding` | `Padding` | `5` | Edge padding. |
| `sticky` | `boolean` | `false` | Stay visible after anchor scrolls. |
| `positionMethod` | `'fixed' \| 'absolute'` | `'absolute'` | CSS position type. |
| `disableAnchorTracking` | `boolean` | `false` | Disable layout shift tracking. |
