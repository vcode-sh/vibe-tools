# Composition & Customization Guide

## Composition via render Prop

The `render` prop lets you compose Base UI parts with custom React components, change the rendered HTML element, or access component state for conditional rendering.

### Composing Custom React Components

Replace the default element with your own component. The custom component **must forward ref and spread all received props** on its underlying DOM node.

```tsx
<Menu.Trigger render={<MyButton size="md" />}>
  Open menu
</Menu.Trigger>
```

### Composing Multiple Components

Render props can be nested as deeply as necessary:

```tsx
<Dialog.Root>
  <Tooltip.Root>
    <Tooltip.Trigger
      render={
        <Dialog.Trigger
          render={
            <Menu.Trigger render={<MyButton size="md" />}>
              Open menu
            </Menu.Trigger>
          }
        />
      }
    />
    <Tooltip.Portal>...</Tooltip.Portal>
  </Tooltip.Root>
  <Dialog.Portal>...</Dialog.Portal>
</Dialog.Root>
```

### Changing the Default Rendered Element

Override the HTML element type:

```tsx
// Menu.Item renders <div> by default, render as <a> instead
<Menu.Item render={<a href="base-ui.com" />}>
  Add to Library
</Menu.Item>
```

Each Base UI component renders the most appropriate element by default. Only change when needed.

### Render Function (Performance & State Access)

Pass a function to `render` for complete control over prop spreading and access to component state:

```tsx
<Switch.Thumb
  render={(props, state) => (
    <span {...props}>
      {state.checked ? <CheckedIcon /> : <UncheckedIcon />}
    </span>
  )}
/>
```

Function signature: `(props: ComponentProps, state: ComponentState) => ReactElement`

---

## Event Customization

### Base UI Change Events

Custom events like `onOpenChange`, `onValueChange`, `onPressedChange` can be emitted by DOM events, effects, or during rendering.

Signature: `(value, eventDetails) => void`

### EventDetails Object

```tsx
interface BaseUIChangeEventDetails {
  reason: string;           // Why the change occurred (IDE autocomplete shows options)
  event: Event;             // Native DOM event that caused the change
  cancel: () => void;       // Stop the component from changing its internal state
  allowPropagation: () => void; // Allow DOM event to propagate (Base UI stops some by default)
  isCanceled: boolean;      // Whether change was canceled
  isPropagationAllowed: boolean; // Whether DOM event is allowed to propagate
}
```

### Canceling Events

Prevent a state change with `cancel()`:

```tsx
<Tooltip.Root
  onOpenChange={(open, eventDetails) => {
    if (eventDetails.reason === 'trigger-press') {
      eventDetails.cancel(); // Prevent tooltip from closing
    }
  }}
>
```

This keeps the component uncontrolled - its internal state won't update. Alternative to controlling the component with external state.

### Allowing Propagation

By default, Esc key stops propagation (parent popups don't close). Override with `allowPropagation()`:

```tsx
<Tooltip.Root
  onOpenChange={(open, eventDetails) => {
    if (eventDetails.reason === 'escape-key') {
      eventDetails.allowPropagation(); // Let parent popups close too
    }
  }}
>
```

### Preventing Base UI Handler

Stop Base UI from handling a React event entirely:

```tsx
<NumberField.Input
  onPaste={(event) => {
    event.preventBaseUIHandler(); // Escape hatch for edge cases
  }}
/>
```

Only works with React synthetic events, not native events.

---

## Controlled vs Uncontrolled Components

### Uncontrolled (default)

Components manage their own state internally:

```tsx
<Dialog.Root>
  <Dialog.Trigger /> {/* Opens dialog on click */}
</Dialog.Root>
```

### Controlled

Pass external state + change handler:

```tsx
const [open, setOpen] = React.useState(false);

React.useEffect(() => {
  const timeout = setTimeout(() => setOpen(true), 1000);
  return () => clearTimeout(timeout);
}, []);

<Dialog.Root open={open} onOpenChange={setOpen}>
  {/* No trigger needed - controlled externally */}
</Dialog.Root>
```

### Common Controlled Props

| Component | State Prop | Change Handler |
|-----------|-----------|----------------|
| Dialog, AlertDialog | `open` | `onOpenChange` |
| Popover, Tooltip | `open` | `onOpenChange` |
| Menu, ContextMenu | `open` | `onOpenChange` |
| Select, Combobox | `value`, `open` | `onValueChange`, `onOpenChange` |
| Checkbox | `checked` | `onCheckedChange` |
| Switch | `checked` | `onCheckedChange` |
| Toggle | `pressed` | `onPressedChange` |
| Tabs | `value` | `onValueChange` |
| Accordion | `value` | `onValueChange` |
| Slider | `value` | `onValueChange` |
| RadioGroup | `value` | `onValueChange` |
| NumberField | `value` | `onValueChange` |

### Default Values

Use `defaultOpen`, `defaultValue`, `defaultChecked` for uncontrolled components with initial state:

```tsx
<Accordion.Root defaultValue={['item-1']}>
<Tabs.Root defaultValue={0}>
<Switch.Root defaultChecked>
<Slider.Root defaultValue={50}>
<Slider.Root defaultValue={[20, 80]}> {/* Range slider */}
```

---

## Migrating from Radix UI

Base UI uses a `render` prop instead of Radix UI's `asChild` pattern:

```tsx
// Radix UI (asChild)
import { Slot } from 'radix-ui';

function Button({ asChild, ...props }) {
  const Comp = asChild ? Slot.Root : 'button';
  return <Comp {...props} />;
}

<Button asChild>
  <a href="/contact">Contact</a>
</Button>
```

```tsx
// Base UI (render prop)
import { useRender } from '@base-ui/react/use-render';

function Button({ render, ...props }) {
  return useRender({ defaultTagName: 'button', render, props });
}

<Button render={<a href="/contact" />}>Contact</Button>
```

Key differences:
- `asChild` wraps child → `render` receives element or function
- `Slot` component → `useRender` hook
- Child element passed as children → element passed to `render` prop
- No equivalent of Radix `Slot.Slottable` - use render function for complex cases
