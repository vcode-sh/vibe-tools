# Animation Guide

Base UI components can be animated using CSS transitions, CSS animations, or JavaScript animation libraries (e.g., Motion/Framer Motion). Components provide data attributes to target states for animation.

## CSS Transitions (Recommended)

CSS transitions are recommended because they can be smoothly cancelled midway. If a user closes a popup before it finishes opening, it smoothly animates to its closed state.

Use these Base UI attributes:
- `[data-starting-style]` - Initial style to transition from (applied when component becomes visible)
- `[data-ending-style]` - Final style to transition to (applied before component becomes hidden)

```css
.Popup {
  padding: 1rem 1.5rem;
  background-color: canvas;
  transform-origin: var(--transform-origin);
  transition: transform 150ms, opacity 150ms;

  &[data-starting-style],
  &[data-ending-style] {
    opacity: 0;
    transform: scale(0.9);
  }
}
```

### Important Rule

Always animate `opacity` (even a value close to 1 like `0.9999`) so Base UI can detect animation completion via `element.getAnimations()` before unmounting the component.

## CSS Animations

Use `@keyframes` with these attributes:
- `[data-open]` - Style applied when component becomes visible
- `[data-closed]` - Style applied before component becomes hidden

```css
@keyframes scaleIn {
  from { opacity: 0; transform: scale(0.9); }
  to { opacity: 1; transform: scale(1); }
}

@keyframes scaleOut {
  from { opacity: 1; transform: scale(1); }
  to { opacity: 0; transform: scale(0.9); }
}

.Popup[data-open] {
  animation: scaleIn 250ms ease-out;
}

.Popup[data-closed] {
  animation: scaleOut 250ms ease-in;
}
```

## JavaScript Animations (Motion)

JavaScript animation libraries like [Motion](https://motion.dev) require lifecycle control for exit animations.

### Pattern 1: Unmounted components (default behavior)

Most popup components (Popover, Dialog, Tooltip, Menu) are unmounted from the DOM when closed. To animate with Motion:

1. Make the component controlled with `open` prop
2. Specify `keepMounted` on the `<Portal>` part
3. Use `render` prop to compose `<Popup>` with `motion.div`
4. Wrap with `<AnimatePresence>`

```tsx
'use client';
import * as React from 'react';
import { Popover } from '@base-ui/react/popover';
import { AnimatePresence, motion } from 'motion/react';

function AnimatedPopover() {
  const [open, setOpen] = React.useState(false);

  return (
    <Popover.Root open={open} onOpenChange={setOpen}>
      <Popover.Trigger>Trigger</Popover.Trigger>
      <AnimatePresence>
        {open && (
          <Popover.Portal keepMounted>
            <Popover.Positioner sideOffset={8}>
              <Popover.Popup
                render={
                  <motion.div
                    initial={{ opacity: 0, scale: 0.8 }}
                    animate={{ opacity: 1, scale: 1 }}
                    exit={{ opacity: 0, scale: 0.8 }}
                  />
                }
              >
                Popup content
              </Popover.Popup>
            </Popover.Positioner>
          </Popover.Portal>
        )}
      </AnimatePresence>
    </Popover.Root>
  );
}
```

### Pattern 2: Keep-mounted components

Components that specify `keepMounted` remain in the DOM when closed. Use the `render` function (not `<AnimatePresence>`):

```tsx
import { Popover } from '@base-ui/react/popover';
import { motion, type HTMLMotionProps } from 'motion/react';

function KeptMountedPopover() {
  return (
    <Popover.Root>
      <Popover.Trigger>Trigger</Popover.Trigger>
      <Popover.Portal keepMounted>
        <Popover.Positioner sideOffset={8}>
          <Popover.Popup
            render={(props, state) => (
              <motion.div
                {...(props as HTMLMotionProps<'div'>)}
                initial={false}
                animate={{
                  opacity: state.open ? 1 : 0,
                  scale: state.open ? 1 : 0.8,
                }}
              />
            )}
          >
            Popup content
          </Popover.Popup>
        </Popover.Positioner>
      </Popover.Portal>
    </Popover.Root>
  );
}
```

### Pattern 3: Select component (hybrid)

Select is initially unmounted but stays mounted after first interaction. Requires a hybrid approach:

```tsx
'use client';
import * as React from 'react';
import { Select } from '@base-ui/react/select';
import { AnimatePresence, motion } from 'motion/react';

function AnimatedSelect() {
  const [open, setOpen] = React.useState(false);
  const [mounted, setMounted] = React.useState(false);

  const positionerRef = React.useCallback(() => {
    setMounted(true);
  }, []);

  const portalMounted = open || mounted;

  // Switch animation variant based on whether popup is already mounted
  const motionElement = mounted ? (
    <motion.div
      initial={false}
      animate={{
        opacity: open ? 1 : 0,
        scale: open ? 1 : 0.8,
      }}
    />
  ) : (
    <motion.div
      initial={{ opacity: 0, scale: 0.8 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 0.8 }}
    />
  );

  return (
    <Select.Root items={items} open={open} onOpenChange={setOpen}>
      <Select.Trigger>
        <Select.Value />
      </Select.Trigger>
      <AnimatePresence>
        {portalMounted && (
          <Select.Portal>
            <Select.Positioner sideOffset={8} ref={positionerRef}>
              <Select.Popup render={motionElement}>
                <Select.List>
                  {/* items */}
                </Select.List>
              </Select.Popup>
            </Select.Positioner>
          </Select.Portal>
        )}
      </AnimatePresence>
    </Select.Root>
  );
}
```

### Manual Unmounting

For full control, manually unmount using `actionsRef`:

```tsx
function ManualUnmountPopover() {
  const [open, setOpen] = React.useState(false);
  const actionsRef = React.useRef(null);

  return (
    <Popover.Root open={open} onOpenChange={setOpen} actionsRef={actionsRef}>
      <Popover.Trigger>Trigger</Popover.Trigger>
      <AnimatePresence>
        {open && (
          <Popover.Portal keepMounted>
            <Popover.Positioner>
              <Popover.Popup
                render={
                  <motion.div
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    exit={{ scale: 0 }}
                    onAnimationComplete={() => {
                      if (!open) {
                        actionsRef.current.unmount();
                      }
                    }}
                  />
                }
              >
                Popup
              </Popover.Popup>
            </Popover.Positioner>
          </Popover.Portal>
        )}
      </AnimatePresence>
    </Popover.Root>
  );
}
```

## Animation Data Attributes Summary

| Attribute | Purpose | Used with |
|-----------|---------|-----------|
| `[data-starting-style]` | Initial entry style (CSS transitions) | All popup components |
| `[data-ending-style]` | Final exit style (CSS transitions) | All popup components |
| `[data-open]` | Visible state (CSS animations) | All popup components |
| `[data-closed]` | Hidden state (CSS animations) | All popup components |
| `[data-instant]` | Suppress animation on first open | Tooltip |

## Common CSS Variables for Animation

| Variable | Description | Found on |
|----------|-------------|----------|
| `--transform-origin` | Scale animation origin | Popup components |
| `--accordion-panel-height` | Panel height for slide | Accordion.Panel |
| `--collapsible-panel-height` | Panel height for slide | Collapsible.Panel |
| `--active-tab-left`, `--active-tab-width` | Tab indicator position | Tabs.Indicator |
| `--toast-offset-y` | Toast vertical position | Toast.Root |
| `--toast-swipe-movement-x/y` | Swipe offset during drag | Toast.Root |

### Opacity Detection

Base UI uses `element.getAnimations()` to detect animation completion before unmounting. If your Motion animation doesn't include opacity, add `opacity: 0.9999` so Base UI can detect it.
