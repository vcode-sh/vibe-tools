# Styling Guide

Base UI components are unstyled, don't bundle CSS, and are compatible with Tailwind, CSS Modules, CSS-in-JS, or any other styling solution. You retain total control of your styling layer.

## Style Hooks

### CSS Classes

Components that render an HTML element accept a `className` prop:

```tsx
// Static class
<Switch.Thumb className="SwitchThumb" />

// Dynamic class based on component state
<Switch.Thumb className={(state) => (state.checked ? 'checked' : 'unchecked')} />
```

### Data Attributes

Components provide data attributes for styling states. Each component documents its own data attributes.

```css
.SwitchThumb[data-checked] {
  background-color: green;
}
```

Common data attributes across components:
- `[data-open]` / `[data-closed]` - Open/close state
- `[data-checked]` / `[data-unchecked]` - Checked state
- `[data-disabled]` - Disabled state
- `[data-highlighted]` - Keyboard/hover highlight (menu items)
- `[data-pressed]` - Toggle pressed state
- `[data-popup-open]` - Trigger element when popup is open
- `[data-starting-style]` / `[data-ending-style]` - Animation entry/exit
- `[data-side]` - Popup position (top/bottom/left/right)
- `[data-orientation]` - Horizontal/vertical
- `[data-valid]` / `[data-invalid]` - Form validation state
- `[data-dirty]` / `[data-touched]` / `[data-filled]` / `[data-focused]` - Form field state

### CSS Variables

Components expose CSS variables for dynamic values:

```css
.Popup {
  max-height: var(--available-height);
  transform-origin: var(--transform-origin);
}
```

Common CSS variables on popup/floating components:
- `--anchor-width`, `--anchor-height` - Trigger element dimensions
- `--available-width`, `--available-height` - Available viewport space
- `--transform-origin` - Origin point for scale animations
- `--popup-width`, `--popup-height` - Popup element dimensions
- `--positioner-width`, `--positioner-height` - Positioner dimensions

Common CSS variables on sizing components:
- `--accordion-panel-height`, `--accordion-panel-width`
- `--collapsible-panel-height`, `--collapsible-panel-width`
- `--active-tab-left`, `--active-tab-width`, `--active-tab-top`, `--active-tab-height`
- `--scroll-area-thumb-height`, `--scroll-area-thumb-width`

### Style Prop

Components also accept a `style` prop (static or state-dependent):

```tsx
<Switch.Thumb style={{ height: '100px' }} />
<Switch.Thumb style={(state) => ({ color: state.checked ? 'red' : 'blue' })} />
```

## Tailwind CSS

Apply Tailwind classes to each part via `className`. Use `data-[attribute]` selectors for states:

```tsx
import { Menu } from '@base-ui/react/menu';

<Menu.Root>
  <Menu.Trigger className="flex h-10 items-center justify-center gap-1.5 rounded-md border border-gray-200 bg-gray-50 px-3.5 text-base font-medium text-gray-900 select-none hover:bg-gray-100 focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-1 focus-visible:outline-blue-800 data-[popup-open]:bg-gray-100">
    Song
  </Menu.Trigger>
  <Menu.Portal>
    <Menu.Positioner className="outline-none" sideOffset={8}>
      <Menu.Popup className="origin-[var(--transform-origin)] rounded-md bg-[canvas] py-1 text-gray-900 shadow-lg outline outline-1 outline-gray-200 transition-[transform,scale,opacity] data-[ending-style]:scale-90 data-[ending-style]:opacity-0 data-[starting-style]:scale-90 data-[starting-style]:opacity-0">
        <Menu.Item className="flex cursor-default py-2 pr-8 pl-4 text-sm leading-4 outline-none select-none data-[highlighted]:relative data-[highlighted]:z-0 data-[highlighted]:text-gray-50 data-[highlighted]:before:absolute data-[highlighted]:before:inset-x-1 data-[highlighted]:before:inset-y-0 data-[highlighted]:before:z-[-1] data-[highlighted]:before:rounded-sm data-[highlighted]:before:bg-gray-900">
          Add to Library
        </Menu.Item>
      </Menu.Popup>
    </Menu.Positioner>
  </Menu.Portal>
</Menu.Root>
```

Key Tailwind patterns:
- Use `data-[popup-open]:bg-gray-100` for trigger active state
- Use `data-[highlighted]:...` for menu item highlight
- Use `data-[starting-style]:opacity-0` for open animations
- Use `origin-[var(--transform-origin)]` for animation origin
- Use `bg-[canvas]` for system-aware background

## CSS Modules

Apply custom CSS classes via `className`, then style in a `.module.css` file:

```tsx
import { Menu } from '@base-ui/react/menu';
import styles from './menu.module.css';

<Menu.Root>
  <Menu.Trigger className={styles.Button}>Song</Menu.Trigger>
  <Menu.Portal>
    <Menu.Positioner className={styles.Positioner} sideOffset={8}>
      <Menu.Popup className={styles.Popup}>
        <Menu.Item className={styles.Item}>Add to Library</Menu.Item>
      </Menu.Popup>
    </Menu.Positioner>
  </Menu.Portal>
</Menu.Root>
```

```css
/* menu.module.css */
.Button {
  /* button styles */
  &[data-popup-open] {
    background-color: var(--color-gray-100);
  }
  &:focus-visible {
    outline: 2px solid var(--color-blue);
    outline-offset: -1px;
  }
}

.Popup {
  transform-origin: var(--transform-origin);
  transition: transform 150ms, opacity 150ms;
  &[data-starting-style],
  &[data-ending-style] {
    opacity: 0;
    transform: scale(0.9);
  }
}

.Item {
  &[data-highlighted] {
    /* highlighted item styles */
  }
}
```

## CSS-in-JS

Wrap each component part with `styled()` and assemble:

```tsx
import { Menu } from '@base-ui/react/menu';
import styled from '@emotion/styled';

const StyledMenuTrigger = styled(Menu.Trigger)`
  /* Button styles */
`;
const StyledMenuItem = styled(Menu.Item)`
  /* Menu item styles */
`;

<Menu.Root>
  <StyledMenuTrigger>Song</StyledMenuTrigger>
  <Menu.Portal>
    <Menu.Positioner>
      <Menu.Popup>
        <StyledMenuItem>Add to Library</StyledMenuItem>
      </Menu.Popup>
    </Menu.Positioner>
  </Menu.Portal>
</Menu.Root>
```

## Common Popup Styling Pattern

Most popup components (Popover, Menu, Dialog, Tooltip, Select, Combobox) follow a consistent styling pattern:

```css
.Positioner {
  /* Optional: constrain sizing */
  max-width: var(--available-width);
}

.Popup {
  /* Base styles */
  background-color: canvas;
  border-radius: 0.5rem;
  transform-origin: var(--transform-origin);

  /* Light/dark mode */
  @media (prefers-color-scheme: light) {
    outline: 1px solid var(--color-gray-200);
    box-shadow: 0 10px 15px -3px var(--color-gray-200);
  }
  @media (prefers-color-scheme: dark) {
    outline: 1px solid var(--color-gray-300);
    outline-offset: -1px;
  }

  /* Entry/exit transitions */
  transition: transform 150ms, opacity 150ms;
  &[data-starting-style],
  &[data-ending-style] {
    opacity: 0;
    transform: scale(0.9);
  }
}

.Arrow {
  &[data-side='top'] { bottom: -8px; rotate: 180deg; }
  &[data-side='bottom'] { top: -8px; rotate: 0deg; }
  &[data-side='left'] { right: -13px; rotate: 90deg; }
  &[data-side='right'] { left: -13px; rotate: -90deg; }
}
```
