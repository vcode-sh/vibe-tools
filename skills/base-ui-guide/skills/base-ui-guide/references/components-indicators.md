# Toolbar and Indicator Components Reference

Complete API reference for Base UI toolbar and indicator components: Toolbar, Separator, Progress, Meter, Avatar.

---

## Toolbar

A container for grouping a set of buttons and controls with keyboard navigation.

**Import:** `import { Toolbar } from '@base-ui/react/toolbar';`

**Anatomy:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| `Toolbar.Root` | `<div>` | Container for grouping controls |
| `Toolbar.Button` | `<button>` | A button; can also compose with other component triggers via `render` |
| `Toolbar.Link` | `<a>` | A link component |
| `Toolbar.Input` | `<input>` | A native input with toolbar keyboard integration |
| `Toolbar.Group` | `<div>` | Groups several toolbar items or toggles |
| `Toolbar.Separator` | `<div>` | A separator element accessible to screen readers |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `orientation` | `'horizontal' \| 'vertical'` | `'horizontal'` | The orientation of the toolbar |
| `loopFocus` | `boolean` | `true` | Whether keyboard navigation wraps focus at ends |
| `disabled` | `boolean` | - | Whether the toolbar is disabled |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Root Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Orientation of the toolbar |
| `data-disabled` | - | Present when the toolbar is disabled |

### Button Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `disabled` | `boolean` | `false` | When `true` the item is disabled |
| `focusableWhenDisabled` | `boolean` | `true` | Item remains focusable when disabled |
| `nativeButton` | `boolean` | `true` | Set to `false` if rendered element is not a button |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element or compose with trigger components |

**Button Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Orientation of the toolbar |
| `data-disabled` | - | Present when the button is disabled |
| `data-focusable` | - | Present when the button remains focusable when disabled |

### Link Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Link Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Orientation of the toolbar |

### Input Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultValue` | `string \| number \| string[]` | - | Default value for the input |
| `disabled` | `boolean` | `false` | When `true` the item is disabled |
| `focusableWhenDisabled` | `boolean` | `true` | Item remains focusable when disabled |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Input Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Orientation of the toolbar |
| `data-disabled` | - | Present when the input is disabled |
| `data-focusable` | - | Present when the input remains focusable when disabled |

### Group Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `disabled` | `boolean` | `false` | When `true` all items in the group are disabled |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Group Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Orientation of the toolbar |
| `data-disabled` | - | Present when the group is disabled |

### Separator Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `orientation` | `Orientation` | `'horizontal'` | The orientation of the separator |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Separator Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Orientation of the toolbar |

### Composing with Other Components

Use the `render` prop on `Toolbar.Button` to compose with trigger components:

```tsx
// With Menu
<Menu.Root>
  <Toolbar.Button render={<Menu.Trigger />} />
</Menu.Root>

// With Select
<Select.Root>
  <Toolbar.Button render={<Select.Trigger />}>
    <Select.Value />
  </Toolbar.Button>
</Select.Root>

// With Tooltip (reversed pattern)
<Tooltip.Root>
  <Tooltip.Trigger render={<Toolbar.Button />} />
</Tooltip.Root>

// With NumberField
<NumberField.Root>
  <Toolbar.Input render={<NumberField.Input />} />
</NumberField.Root>
```

### Example

```tsx
import { Toolbar } from '@base-ui/react/toolbar';

<Toolbar.Root>
  <Toolbar.Group aria-label="Formatting">
    <Toolbar.Button aria-label="Bold">B</Toolbar.Button>
    <Toolbar.Button aria-label="Italic">I</Toolbar.Button>
  </Toolbar.Group>
  <Toolbar.Separator />
  <Toolbar.Link href="/help">Help</Toolbar.Link>
</Toolbar.Root>
```

### Accessibility

- Uses `role="toolbar"` with proper `aria-orientation`.
- Arrow keys navigate between controls (left/right for horizontal, up/down for vertical).
- Focus loops by default (`loopFocus`).
- Use inputs sparingly in horizontal toolbars: arrow keys conflict with text cursor movement. Place inputs last and use only one per toolbar.

### Styled Example (Tailwind)

```tsx
import { Toolbar } from '@base-ui/react/toolbar';

export default function ExampleToolbar() {
  return (
    <Toolbar.Root className="flex items-center gap-1 rounded-lg border border-gray-200 bg-gray-50 p-1">
      <Toolbar.Group className="flex items-center gap-1" aria-label="Text formatting">
        <Toolbar.Button className="flex size-9 items-center justify-center rounded-md text-sm font-bold text-gray-700 select-none hover:bg-gray-200 focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-1 focus-visible:outline-blue-800 data-[disabled]:opacity-40">
          B
        </Toolbar.Button>
        <Toolbar.Button className="flex size-9 items-center justify-center rounded-md text-sm italic text-gray-700 select-none hover:bg-gray-200 focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-1 focus-visible:outline-blue-800 data-[disabled]:opacity-40">
          I
        </Toolbar.Button>
      </Toolbar.Group>
      <Toolbar.Separator className="mx-1 h-5 w-px bg-gray-300" />
      <Toolbar.Link
        href="/help"
        className="flex h-9 items-center rounded-md px-2 text-sm text-blue-700 hover:bg-gray-200 focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-1 focus-visible:outline-blue-800"
      >
        Help
      </Toolbar.Link>
    </Toolbar.Root>
  );
}
```

Key Tailwind patterns:
- **Root**: `flex items-center gap-1` with border and padding for toolbar container
- **Button**: Fixed `size-9` for square buttons, `data-[disabled]:opacity-40` for disabled state
- **Separator**: `h-5 w-px` for thin vertical line between groups
- **Group**: `aria-label` for screen reader grouping

---

## Separator

A visual and semantic separator element accessible to screen readers.

**Import:** `import { Separator } from '@base-ui/react/separator';`

This is a single-part component (no subcomponents).

**Renders:** `<div>` element.

### Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `orientation` | `Orientation` | `'horizontal'` | The orientation of the separator |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

### Example

```tsx
import { Separator } from '@base-ui/react/separator';

<div style={{ display: 'flex', gap: '1rem' }}>
  <a href="/">Home</a>
  <a href="/about">About</a>
  <Separator orientation="vertical" />
  <a href="/login">Log in</a>
</div>
```

### Accessibility

- Renders with `role="separator"` and `aria-orientation`.
- Provides a semantic boundary between groups of content for screen readers.

---

## Progress

Displays the status of a task that takes a long time, with determinate or indeterminate states.

**Import:** `import { Progress } from '@base-ui/react/progress';`

**Anatomy:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| `Progress.Root` | `<div>` | Groups all parts; provides task completion status to screen readers |
| `Progress.Track` | `<div>` | Contains the progress bar indicator |
| `Progress.Indicator` | `<div>` | Visualizes the completion status |
| `Progress.Value` | `<span>` | A text label displaying the current value |
| `Progress.Label` | `<span>` | An accessible label for the progress bar |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `value` | `number \| null` | `null` | Current value; `null` for indeterminate state |
| `min` | `number` | `0` | The minimum value |
| `max` | `number` | `100` | The maximum value |
| `aria-valuetext` | `string` | - | User-friendly name for the current value |
| `getAriaValueText` | `(formattedValue: string \| null, value: number \| null) => string` | - | Function returning human-readable text alternative for the value |
| `locale` | `Intl.LocalesArgument` | - | Locale for `Intl.NumberFormat`; defaults to user's runtime locale |
| `format` | `Intl.NumberFormatOptions` | - | Options to format the value |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Root Data Attributes (shared by all subcomponents):**

| Attribute | Description |
|:----------|:------------|
| `data-complete` | Present when the progress has completed |
| `data-indeterminate` | Present when the progress is indeterminate (`value` is `null`) |
| `data-progressing` | Present while the progress is progressing |

### Track Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Track Data Attributes:** `data-complete`, `data-indeterminate`, `data-progressing` (same as Root).

### Indicator Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Indicator Data Attributes:** `data-complete`, `data-indeterminate`, `data-progressing` (same as Root).

### Value Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `children` | `((formattedValue: string \| null, value: number \| null) => ReactNode) \| null` | - | Render function for custom value display |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Value Data Attributes:** `data-complete`, `data-indeterminate`, `data-progressing` (same as Root).

### Label Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Label Data Attributes:** `data-complete`, `data-indeterminate`, `data-progressing` (same as Root).

### Example

```tsx
import { Progress } from '@base-ui/react/progress';

<Progress.Root value={65}>
  <Progress.Label>Uploading...</Progress.Label>
  <Progress.Value />
  <Progress.Track>
    <Progress.Indicator />
  </Progress.Track>
</Progress.Root>
```

### Accessibility

- Uses `role="progressbar"` with `aria-valuenow`, `aria-valuemin`, and `aria-valuemax`.
- `Progress.Label` provides an accessible name.
- Indeterminate state (`value={null}`) removes `aria-valuenow`.
- Use `getAriaValueText` or `aria-valuetext` for human-readable alternatives (e.g. "Step 2 of 5").

### Styled Example (Tailwind)

```tsx
import { Progress } from '@base-ui/react/progress';

export default function ExampleProgress() {
  return (
    <Progress.Root value={65} className="flex w-64 flex-col gap-2">
      <div className="flex justify-between text-sm">
        <Progress.Label className="font-medium text-gray-900">Uploading...</Progress.Label>
        <Progress.Value className="text-gray-600" />
      </div>
      <Progress.Track className="h-2 overflow-hidden rounded-full bg-gray-200">
        <Progress.Indicator className="h-full rounded-full bg-blue-600 transition-[width] duration-500 data-[indeterminate]:animate-pulse" />
      </Progress.Track>
    </Progress.Root>
  );
}
```

Key Tailwind patterns:
- **Track**: `overflow-hidden rounded-full` for pill-shaped container
- **Indicator**: `transition-[width]` for smooth value updates, `data-[indeterminate]:animate-pulse` for loading state
- **Layout**: Label and Value in a `flex justify-between` row above the track

---

## Meter

A graphical display of a numeric value within a known range (not for progress -- use Progress for tasks).

**Import:** `import { Meter } from '@base-ui/react/meter';`

**Anatomy:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| `Meter.Root` | `<div>` | Groups all parts; provides the value for screen readers |
| `Meter.Track` | `<div>` | Contains the meter indicator; represents the entire range |
| `Meter.Indicator` | `<div>` | Visualizes the position of the value along the range |
| `Meter.Value` | `<span>` | A text element displaying the current value |
| `Meter.Label` | `<span>` | An accessible label for the meter |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `value` | `number` | - | The current value (required) |
| `min` | `number` | `0` | The minimum value |
| `max` | `number` | `100` | The maximum value |
| `aria-valuetext` | `string` | - | User-friendly name for the current value |
| `getAriaValueText` | `(formattedValue: string, value: number) => string` | - | Function returning human-readable text alternative for the value |
| `locale` | `Intl.LocalesArgument` | - | Locale for `Intl.NumberFormat`; defaults to user's runtime locale |
| `format` | `Intl.NumberFormatOptions` | - | Options to format the value |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

### Track Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

### Indicator Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

### Value Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `children` | `((formattedValue: string, value: number) => ReactNode) \| null` | - | Render function for custom value display |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

### Label Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

### Example

```tsx
import { Meter } from '@base-ui/react/meter';

<Meter.Root value={24}>
  <Meter.Label>Storage Used</Meter.Label>
  <Meter.Value />
  <Meter.Track>
    <Meter.Indicator />
  </Meter.Track>
</Meter.Root>
```

### Accessibility

- Uses `role="meter"` with `aria-valuenow`, `aria-valuemin`, and `aria-valuemax`.
- `Meter.Label` provides an accessible name.
- Use `getAriaValueText` for human-readable alternatives (e.g. "24 GB of 100 GB used").
- Meter is for static measurements (disk usage, battery); use Progress for task completion.

---

## Avatar

An easily stylable avatar component for displaying user profile pictures with fallback support.

**Import:** `import { Avatar } from '@base-ui/react/avatar';`

**Anatomy:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| `Avatar.Root` | `<span>` | Displays a user's profile picture, initials, or fallback icon |
| `Avatar.Image` | `<img>` | The image to be displayed |
| `Avatar.Fallback` | `<span>` | Rendered when the image fails to load or when no image is provided |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

### Image Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `onLoadingStatusChange` | `(status: ImageLoadingStatus) => void` | - | Callback fired when the loading status changes |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

Standard `<img>` props (`src`, `alt`, `width`, `height`, etc.) are also accepted.

### Fallback Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `delay` | `number` | - | How long to wait (milliseconds) before showing the fallback |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

### Example

```tsx
import { Avatar } from '@base-ui/react/avatar';

{/* With image and fallback */}
<Avatar.Root>
  <Avatar.Image
    src="/profile.jpg"
    alt="Jane Doe"
    width="48"
    height="48"
  />
  <Avatar.Fallback>JD</Avatar.Fallback>
</Avatar.Root>

{/* Initials only (no image) */}
<Avatar.Root>JD</Avatar.Root>
```

### Accessibility

- Provide meaningful `alt` text on `Avatar.Image` for screen readers.
- When using initials-only avatars, ensure surrounding context conveys the user's identity.
- The `delay` prop on `Fallback` prevents a flash of fallback content while the image loads.
