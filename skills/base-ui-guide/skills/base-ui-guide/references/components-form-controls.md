# Form Control Components Reference

Complete API reference for Base UI form control components: Select, Combobox, Autocomplete, Switch, Slider, Toggle, ToggleGroup, Button, and common patterns.

---

## Select

A dropdown menu for choosing a predefined value.

```ts
import { Select } from '@base-ui/react/select';
```

**Parts:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| Select.Root | (none) | Groups all parts, manages state. |
| Select.Trigger | `<button>` | Opens the popup. |
| Select.Value | `<span>` | Displays selected item text. |
| Select.Icon | `<span>` | Dropdown indicator icon. |
| Select.Portal | `<div>` | Moves popup to document body. |
| Select.Backdrop | `<div>` | Overlay behind popup. |
| Select.Positioner | `<div>` | Positions popup relative to trigger. |
| Select.Popup | `<div>` | Container for the list. |
| Select.List | `<div>` | Container for items. |
| Select.Item | `<div>` | Individual selectable option. |
| Select.ItemText | `<div>` | Text label of an item. |
| Select.ItemIndicator | `<span>` | Selected state indicator. |
| Select.Group | `<div>` | Groups related items. |
| Select.GroupLabel | `<div>` | Label for an item group. |
| Select.Arrow | `<div>` | Arrow pointing to anchor. |
| Select.ScrollUpArrow | `<div>` | Scroll-up indicator. |
| Select.ScrollDownArrow | `<div>` | Scroll-down indicator. |
| Select.Separator | `<div>` | Visual separator between items. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| name | `string` | - | Identifies field on form submission. |
| defaultValue | `Value[] \| Value \| null` | - | Uncontrolled initial value. |
| value | `Value[] \| Value \| null` | - | Controlled value. |
| onValueChange | `(value, eventDetails) => void` | - | Callback on value change. |
| defaultOpen | `boolean` | `false` | Initially open (uncontrolled). |
| open | `boolean` | - | Controlled open state. |
| onOpenChange | `(open, eventDetails) => void` | - | Callback on open/close. |
| highlightItemOnHover | `boolean` | `true` | Highlight items on pointer hover. |
| items | `Record<string, ReactNode> \| { label, value }[]` | - | Item data for value-to-label mapping. |
| multiple | `boolean` | `false` | Allow multiple selections. |
| modal | `boolean` | `true` | Lock scroll and disable outside interactions when open. |
| disabled | `boolean` | `false` | Disables user interaction. |
| readOnly | `boolean` | `false` | Prevents value changes. |
| required | `boolean` | `false` | Requires selection. |
| isItemEqualToValue | `(itemValue, value) => boolean` | - | Custom equality check for object values. |
| itemToStringLabel | `(itemValue) => string` | - | Converts object value to display string. |
| itemToStringValue | `(itemValue) => string` | - | Converts object value to form submission string. |
| onOpenChangeComplete | `(open) => void` | - | Callback after animation completes. |
| inputRef | `Ref<HTMLInputElement>` | - | Ref to hidden input. |

### Trigger Data Attributes

| Attribute | Description |
|:----------|:------------|
| `data-popup-open` | Popup is open. |
| `data-pressed` | Trigger is pressed. |
| `data-disabled` | Select is disabled. |
| `data-readonly` | Select is readonly. |
| `data-placeholder` | No value selected. |
| `data-valid` / `data-invalid` | Validation state (in Field.Root). |
| `data-dirty` / `data-touched` / `data-filled` / `data-focused` | Field state (in Field.Root). |

### Value Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| placeholder | `ReactNode` | - | Placeholder when no value selected. |
| children | `ReactNode \| (value) => ReactNode` | - | Function to format the displayed value. |

### Positioner Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| alignItemWithTrigger | `boolean` | `true` | Overlap trigger to align selected item text with trigger value text. |
| side | `Side` | `'bottom'` | Which side to position against. |
| sideOffset | `number \| OffsetFunction` | `0` | Distance from anchor in px. |
| align | `Align` | `'center'` | Alignment relative to side. |
| alignOffset | `number \| OffsetFunction` | `0` | Offset along alignment axis. |

### Positioner CSS Variables

| Variable | Description |
|:---------|:------------|
| `--anchor-width` | Width of the anchor element. |
| `--anchor-height` | Height of the anchor element. |
| `--available-width` | Available width to edge of viewport. |
| `--available-height` | Available height to edge of viewport. |
| `--transform-origin` | Anchor coordinates for animations. |

### Item Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| value | `any` | `null` | Unique identifying value. |
| label | `string` | - | Text label for keyboard navigation matching. |
| disabled | `boolean` | `false` | Disables this item. |

### Item Data Attributes

| Attribute | Description |
|:----------|:------------|
| `data-selected` | Item is selected. |
| `data-highlighted` | Item is highlighted. |
| `data-disabled` | Item is disabled. |

### Example

```tsx
import { Select } from '@base-ui/react/select';

<Select.Root items={[{ label: 'Light', value: 'light' }, { label: 'Dark', value: 'dark' }]}>
  <Select.Trigger>
    <Select.Value placeholder="Select theme" />
    <Select.Icon />
  </Select.Trigger>
  <Select.Portal>
    <Select.Positioner sideOffset={8}>
      <Select.Popup>
        <Select.List>
          <Select.Item value="light">
            <Select.ItemIndicator><CheckIcon /></Select.ItemIndicator>
            <Select.ItemText>Light</Select.ItemText>
          </Select.Item>
          <Select.Item value="dark">
            <Select.ItemIndicator><CheckIcon /></Select.ItemIndicator>
            <Select.ItemText>Dark</Select.ItemText>
          </Select.Item>
        </Select.List>
      </Select.Popup>
    </Select.Positioner>
  </Select.Portal>
</Select.Root>
```

### Form Integration

Use Field with `nativeLabel={false}` and `render={<div />}` on `Field.Label` to avoid native label behaviors on the button trigger:

```tsx
<Field.Root>
  <Field.Label nativeLabel={false} render={<div />}>Theme</Field.Label>
  <Select.Root>{/* ... */}</Select.Root>
</Field.Root>
```

### Styled Example (Tailwind)

```tsx
import { Select } from '@base-ui/react/select';
import { Field } from '@base-ui/react/field';

const items = [
  { label: 'Gala', value: 'gala' },
  { label: 'Fuji', value: 'fuji' },
  { label: 'Honeycrisp', value: 'honeycrisp' },
];

export default function ExampleSelect() {
  return (
    <Field.Root className="flex flex-col gap-1">
      <Field.Label
        className="cursor-default text-sm leading-5 font-medium text-gray-900"
        nativeLabel={false}
        render={<div />}
      >
        Apple
      </Field.Label>
      <Select.Root items={items}>
        <Select.Trigger className="flex h-10 min-w-40 items-center justify-between gap-3 rounded-md border border-gray-200 pr-3 pl-3.5 text-base bg-[canvas] text-gray-900 select-none hover:bg-gray-100 focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-1 focus-visible:outline-blue-800 data-[popup-open]:bg-gray-100">
          <Select.Value className="data-[placeholder]:opacity-60" placeholder="Select apple" />
          <Select.Icon className="flex">
            <ChevronUpDownIcon />
          </Select.Icon>
        </Select.Trigger>
        <Select.Portal>
          <Select.Positioner className="outline-none select-none z-10" sideOffset={8}>
            <Select.Popup className="group min-w-[var(--anchor-width)] origin-[var(--transform-origin)] rounded-md bg-[canvas] text-gray-900 shadow-lg shadow-gray-200 outline outline-1 outline-gray-200 transition-[transform,scale,opacity] data-[ending-style]:scale-90 data-[ending-style]:opacity-0 data-[starting-style]:scale-90 data-[starting-style]:opacity-0 dark:shadow-none dark:outline-gray-300">
              <Select.ScrollUpArrow className="flex h-4 w-full items-center justify-center rounded-md bg-[canvas] text-xs" />
              <Select.List className="py-1 overflow-y-auto max-h-[var(--available-height)]">
                {items.map(({ label, value }) => (
                  <Select.Item
                    key={value}
                    value={value}
                    className="grid cursor-default grid-cols-[0.75rem_1fr] items-center gap-2 py-2 pr-4 pl-2.5 text-sm leading-4 outline-none select-none data-[highlighted]:text-gray-50 data-[highlighted]:before:absolute data-[highlighted]:before:inset-x-1 data-[highlighted]:before:inset-y-0 data-[highlighted]:before:z-[-1] data-[highlighted]:before:rounded-sm data-[highlighted]:before:bg-gray-900"
                  >
                    <Select.ItemIndicator className="col-start-1">
                      <CheckIcon className="size-3" />
                    </Select.ItemIndicator>
                    <Select.ItemText className="col-start-2">{label}</Select.ItemText>
                  </Select.Item>
                ))}
              </Select.List>
              <Select.ScrollDownArrow className="flex h-4 w-full items-center justify-center rounded-md bg-[canvas] text-xs" />
            </Select.Popup>
          </Select.Positioner>
        </Select.Portal>
      </Select.Root>
    </Field.Root>
  );
}
```

Key Tailwind patterns:
- **Field.Label**: Use `nativeLabel={false}` and `render={<div />}` for button-based controls
- **Trigger**: `data-[popup-open]:bg-gray-100` for open state styling
- **Popup**: `min-w-[var(--anchor-width)]` matches trigger width, `origin-[var(--transform-origin)]` for positioned animations
- **Item highlight**: `data-[highlighted]:before:*` pseudo-element for highlight background behind text
- **Placeholder**: `data-[placeholder]:opacity-60` on Select.Value

---

## Combobox

An input combined with a filterable list of predefined items to select.

```ts
import { Combobox } from '@base-ui/react/combobox';
```

**Parts:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| Combobox.Root | (none) | Groups all parts, manages state. |
| Combobox.Input | `<input>` | Text input for filtering. |
| Combobox.Trigger | `<button>` | Opens the popup. |
| Combobox.Icon | `<span>` | Popup indicator icon. |
| Combobox.Clear | `<button>` | Clears the value. |
| Combobox.Value | (none) | Current selected value (no HTML). |
| Combobox.Chips | `<div>` | Container for multi-select chips. |
| Combobox.Chip | `<div>` | Individual chip. |
| Combobox.ChipRemove | `<button>` | Removes a chip. |
| Combobox.Portal | `<div>` | Moves popup to document body. |
| Combobox.Backdrop | `<div>` | Overlay behind popup. |
| Combobox.Positioner | `<div>` | Positions popup relative to input. |
| Combobox.Popup | `<div>` | Container for the list. |
| Combobox.Arrow | `<div>` | Arrow pointing to anchor. |
| Combobox.Status | `<div>` | Screen reader status message. |
| Combobox.Empty | `<div>` | Shown when no items match filter. |
| Combobox.List | `<div>` | Container for items. |
| Combobox.Collection | (none) | Renders filtered items (no HTML). |
| Combobox.Row | `<div>` | Grid layout row. |
| Combobox.Item | `<div>` | Individual selectable option. |
| Combobox.ItemIndicator | `<span>` | Selected state indicator. |
| Combobox.Group | `<div>` | Groups related items. |
| Combobox.GroupLabel | `<div>` | Label for a group. |
| Combobox.Separator | `<div>` | Visual separator. |

### Root Props (key props)

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| name | `string` | - | Identifies field on form submission. |
| defaultValue | `Value[] \| Value \| null` | - | Uncontrolled initial selected value. |
| value | `Value[] \| Value \| null` | - | Controlled selected value. |
| onValueChange | `(value, eventDetails) => void` | - | Callback on selection change. |
| defaultInputValue | `string` | - | Uncontrolled initial input text. |
| inputValue | `string` | - | Controlled input text. |
| onInputValueChange | `(inputValue, eventDetails) => void` | - | Callback on input text change. |
| items | `any[] \| Group[]` | - | Items to display. |
| filter | `(itemValue, query, itemToString?) => boolean \| null` | - | Custom filter function. Pass `null` to disable filtering. |
| filteredItems | `any[] \| Group[]` | - | Externally filtered items. |
| multiple | `boolean` | `false` | Allow multiple selections. |
| autoHighlight | `boolean` | `false` | Highlight first match automatically. |
| loopFocus | `boolean` | `true` | Loop focus from end back to input. |
| openOnInputClick | `boolean` | `true` | Open popup on input click. |
| disabled | `boolean` | `false` | Disables user interaction. |
| readOnly | `boolean` | `false` | Prevents value changes. |
| required | `boolean` | `false` | Requires value. |
| limit | `number` | `-1` | Max items to display (-1 = unlimited). |

### Item Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| value | `any` | `null` | Unique identifying value. |
| onClick | `MouseEventHandler` | - | Click handler (fires on pointer click and Enter key). |
| index | `number` | - | Performance optimization: explicit index. |
| disabled | `boolean` | `false` | Disables this item. |

### Positioner CSS Variables

| Variable | Description |
|:---------|:------------|
| `--anchor-width` | Width of the anchor element. |
| `--anchor-height` | Height of the anchor element. |
| `--available-width` | Available width to edge of viewport. |
| `--available-height` | Available height to edge of viewport. |
| `--transform-origin` | Anchor coordinates for animations. |

### useFilter Hook

Matches items against a query using `Intl.Collator` for locale-aware string matching. Used for external filtering control.

```tsx
import { useFilter } from '@base-ui/react/combobox';

const filter = useFilter({ locale: 'en' });

// Returns boolean matching functions:
filter.contains(itemValue, query)    // item contains query
filter.startsWith(itemValue, query)  // item starts with query
filter.endsWith(itemValue, query)    // item ends with query
```

### Example

```tsx
import { Combobox } from '@base-ui/react/combobox';

<Combobox.Root items={fruits}>
  <label htmlFor="fruit-input">Choose a fruit</label>
  <Combobox.Input id="fruit-input" placeholder="e.g. Apple" />
  <Combobox.Clear aria-label="Clear" />
  <Combobox.Trigger aria-label="Open" />
  <Combobox.Portal>
    <Combobox.Positioner sideOffset={4}>
      <Combobox.Popup>
        <Combobox.Empty>No items found.</Combobox.Empty>
        <Combobox.List>
          {(item) => (
            <Combobox.Item key={item.value} value={item}>
              <Combobox.ItemIndicator><CheckIcon /></Combobox.ItemIndicator>
              {item.label}
            </Combobox.Item>
          )}
        </Combobox.List>
      </Combobox.Popup>
    </Combobox.Positioner>
  </Combobox.Portal>
</Combobox.Root>
```

### Form Integration

Combobox integrates with Field the same way as Select. Use a `<label>` element or the Field component to provide an accessible name.

---

## Autocomplete

An input that suggests options as you type, allowing free-form text input.

```ts
import { Autocomplete } from '@base-ui/react/autocomplete';
```

**Parts:** Same structure as Combobox (Root, Input, Trigger, Icon, Clear, Value, List, Portal, Backdrop, Positioner, Popup, Arrow, Empty, Item, Group, GroupLabel, Separator, Collection, Row).

### Root Props (key differences from Combobox)

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| defaultValue | `string \| number \| string[]` | - | Uncontrolled input value (not selected item). |
| value | `string \| number \| string[]` | - | Controlled input value. |
| onValueChange | `(value: string, eventDetails) => void` | - | Callback on input value change. |
| mode | `'none' \| 'list' \| 'inline' \| 'both'` | `'list'` | Controls filtering and inline autocompletion behavior. |
| autoHighlight | `boolean \| 'always'` | `false` | Highlight first match. `'always'` = always highlight first item. |
| keepHighlight | `boolean` | `false` | Preserve highlight when pointer leaves list. |
| submitOnItemClick | `boolean` | `false` | Submit owning form when an item is clicked. |

### Combobox vs Autocomplete

- **Combobox**: Input is restricted to predefined selectable items. Use for filterable selection.
- **Autocomplete**: Allows free-form text input. Use for search suggestions where any text is valid.

### Example

```tsx
import { Autocomplete } from '@base-ui/react/autocomplete';

<Autocomplete.Root items={tags}>
  <label>
    Search tags
    <Autocomplete.Input placeholder="e.g. feature" />
  </label>
  <Autocomplete.Portal>
    <Autocomplete.Positioner sideOffset={4}>
      <Autocomplete.Popup>
        <Autocomplete.Empty>No tags found.</Autocomplete.Empty>
        <Autocomplete.List>
          {(tag) => (
            <Autocomplete.Item key={tag.id} value={tag}>
              {tag.value}
            </Autocomplete.Item>
          )}
        </Autocomplete.List>
      </Autocomplete.Popup>
    </Autocomplete.Positioner>
  </Autocomplete.Portal>
</Autocomplete.Root>
```

---

## Switch

A control that indicates whether a setting is on or off.

```ts
import { Switch } from '@base-ui/react/switch';
```

**Parts:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| Switch.Root | `<span>` + hidden `<input>` | The switch itself. |
| Switch.Thumb | `<span>` | Movable part indicating on/off. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| name | `string` | - | Identifies field on form submission. |
| defaultChecked | `boolean` | `false` | Uncontrolled initial state. |
| checked | `boolean` | - | Controlled checked state. |
| onCheckedChange | `(checked: boolean, eventDetails) => void` | - | Callback on state change. |
| value | `string` | - | Value submitted when on (default: "on"). |
| nativeButton | `boolean` | `false` | Set `true` if render prop produces a `<button>`. |
| uncheckedValue | `string` | - | Value submitted when off (default: nothing). |
| disabled | `boolean` | `false` | Disables user interaction. |
| readOnly | `boolean` | `false` | Prevents state changes. |
| required | `boolean` | `false` | Must be active before form submission. |
| inputRef | `Ref<HTMLInputElement>` | - | Ref to hidden input. |
| id | `string` | - | Switch element id. |

### Data Attributes (Root and Thumb)

| Attribute | Description |
|:----------|:------------|
| `data-checked` | Switch is on. |
| `data-unchecked` | Switch is off. |
| `data-disabled` | Switch is disabled. |
| `data-readonly` | Switch is readonly. |
| `data-required` | Switch is required. |
| `data-valid` | Valid state (in Field.Root). |
| `data-invalid` | Invalid state (in Field.Root). |
| `data-dirty` | Value has changed (in Field.Root). |
| `data-touched` | Has been touched (in Field.Root). |
| `data-filled` | Is active (in Field.Root). |
| `data-focused` | Is focused (in Field.Root). |

### Example

```tsx
import { Switch } from '@base-ui/react/switch';

<label>
  <Switch.Root defaultChecked>
    <Switch.Thumb />
  </Switch.Root>
  Notifications
</label>
```

### Form Integration

```tsx
<Form>
  <Field.Root name="notifications">
    <Field.Label>
      <Switch.Root />
      Notifications
    </Field.Label>
  </Field.Root>
</Form>
```

---

## Slider

An easily stylable range input.

```ts
import { Slider } from '@base-ui/react/slider';
```

**Parts:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| Slider.Root | `<div>` | Groups all parts. |
| Slider.Value | `<output>` | Displays current value as text. |
| Slider.Control | `<div>` | The interactive clickable area. |
| Slider.Track | `<div>` | Represents the full range. |
| Slider.Indicator | `<div>` | Visualizes the current value. |
| Slider.Thumb | `<div>` + `<input type="range">` | Draggable thumb. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| name | `string` | - | Identifies field on form submission. |
| defaultValue | `number \| number[]` | - | Uncontrolled initial value. Array for range sliders. |
| value | `number \| number[]` | - | Controlled value. |
| onValueChange | `(value, eventDetails) => void` | - | Callback on value change. `reason`: `'track-press'`, `'drag'`, `'keyboard'`, `'input-change'`, `'none'`. |
| onValueCommitted | `(value, eventDetails) => void` | - | Callback on pointer release. |
| thumbAlignment | `'center' \| 'edge' \| 'edge-client-only'` | `'center'` | How thumbs align at min/max. |
| thumbCollisionBehavior | `'none' \| 'push' \| 'swap'` | `'push'` | How thumbs behave when colliding. |
| step | `number` | `1` | Step granularity. |
| largeStep | `number` | `10` | Step for Page Up/Down or Shift+Arrow. |
| minStepsBetweenValues | `number` | `0` | Min steps between range slider thumbs. |
| min | `number` | `0` | Minimum value. |
| max | `number` | `100` | Maximum value. |
| format | `Intl.NumberFormatOptions` | - | Number formatting options. |
| locale | `Intl.LocalesArgument` | - | Locale for formatting. |
| disabled | `boolean` | `false` | Disables user interaction. |
| orientation | `'horizontal' \| 'vertical'` | `'horizontal'` | Slider orientation. |

### Value Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| children | `(formattedValues: string[], values: number[]) => ReactNode \| null` | - | Custom render function. |

### Thumb Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| getAriaLabel | `(index: number) => string \| null` | - | Dynamic aria-label for the input. |
| getAriaValueText | `(formattedValue, value, index) => string \| null` | - | Dynamic aria-valuetext for screen readers. |
| index | `number` | - | Thumb index (required for SSR with range sliders). |
| disabled | `boolean` | `false` | Disables this thumb. |
| inputRef | `Ref<HTMLInputElement>` | - | Ref to nested input. |

### Data Attributes (shared across all Slider parts)

| Attribute | Description |
|:----------|:------------|
| `data-dragging` | User is dragging. |
| `data-orientation` | `'horizontal'` or `'vertical'`. |
| `data-disabled` | Slider is disabled. |
| `data-valid` | Valid state (in Field.Root). |
| `data-invalid` | Invalid state (in Field.Root). |
| `data-dirty` | Value has changed (in Field.Root). |
| `data-touched` | Has been touched (in Field.Root). |
| `data-focused` | Is focused (in Field.Root). |

Thumb-only: `data-index` indicates the thumb index in range sliders.

### Example

```tsx
import { Slider } from '@base-ui/react/slider';

<Slider.Root defaultValue={25}>
  <Slider.Control>
    <Slider.Track>
      <Slider.Indicator />
      <Slider.Thumb aria-label="Volume" />
    </Slider.Track>
  </Slider.Control>
</Slider.Root>
```

### Range Slider Example

```tsx
<Slider.Root defaultValue={[25, 75]}>
  <Slider.Control>
    <Slider.Track>
      <Slider.Indicator />
      <Slider.Thumb index={0} aria-label="Min price" />
      <Slider.Thumb index={1} aria-label="Max price" />
    </Slider.Track>
  </Slider.Control>
</Slider.Root>
```

### Form Integration

```tsx
<Form>
  <Field.Root name="volume">
    <Field.Label>Volume</Field.Label>
    <Slider.Root>
      <Slider.Control>
        <Slider.Track>
          <Slider.Indicator />
          <Slider.Thumb />
        </Slider.Track>
      </Slider.Control>
    </Slider.Root>
  </Field.Root>
</Form>
```

---

## Toggle

A two-state button that can be on or off.

```ts
import { Toggle } from '@base-ui/react/toggle';
```

**Parts:** `Toggle` renders a `<button>` element (single part component).

### Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| value | `string` | - | Unique identifier when used in a ToggleGroup. |
| defaultPressed | `boolean` | `false` | Uncontrolled initial pressed state. |
| pressed | `boolean` | - | Controlled pressed state. |
| onPressedChange | `(pressed: boolean, eventDetails) => void` | - | Callback on state change. |
| nativeButton | `boolean` | `true` | Set `false` if render prop produces a non-button. |
| disabled | `boolean` | `false` | Disables user interaction. |

### Data Attributes

| Attribute | Description |
|:----------|:------------|
| `data-pressed` | Toggle is pressed/on. |

### Example

```tsx
import { Toggle } from '@base-ui/react/toggle';

<Toggle aria-label="Favorite">
  <HeartIcon />
</Toggle>
```

---

## ToggleGroup

Provides shared state to a series of toggle buttons.

```ts
import { ToggleGroup } from '@base-ui/react/toggle-group';
```

**Parts:** `ToggleGroup` renders a `<div>` element. Contains `Toggle` components.

### Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| defaultValue | `any[]` | - | Initially pressed toggle values (uncontrolled). |
| value | `any[]` | - | Currently pressed toggle values (controlled). |
| onValueChange | `(groupValue: any[], eventDetails) => void` | - | Callback on state change. |
| loopFocus | `boolean` | `true` | Loop keyboard focus at list ends. |
| multiple | `boolean` | `false` | Allow multiple toggles pressed simultaneously. |
| disabled | `boolean` | `false` | Disables all toggles. |
| orientation | `'horizontal' \| 'vertical'` | `'horizontal'` | Group orientation. |

### Data Attributes

| Attribute | Description |
|:----------|:------------|
| `data-orientation` | `'horizontal'` or `'vertical'`. |
| `data-disabled` | Group is disabled. |
| `data-multiple` | Multiple selection allowed. |

### Example

```tsx
import { Toggle } from '@base-ui/react/toggle';
import { ToggleGroup } from '@base-ui/react/toggle-group';

<ToggleGroup defaultValue={['left']}>
  <Toggle aria-label="Align left" value="left"><AlignLeftIcon /></Toggle>
  <Toggle aria-label="Align center" value="center"><AlignCenterIcon /></Toggle>
  <Toggle aria-label="Align right" value="right"><AlignRightIcon /></Toggle>
</ToggleGroup>
```

---

## Button

A button component that can be rendered as another tag or remain focusable when disabled.

```ts
import { Button } from '@base-ui/react/button';
```

**Parts:** `Button` renders a `<button>` element (single part component).

### Button Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| focusableWhenDisabled | `boolean` | `false` | Keep button focusable when disabled. Useful for loading states. |
| nativeButton | `boolean` | `true` | Set `false` if render prop produces a non-button element. |
| disabled | `boolean` | - | Standard HTML disabled. |

### Data Attributes

| Attribute | Description |
|:----------|:------------|
| `data-disabled` | Button is disabled. |

### Example

```tsx
import { Button } from '@base-ui/react/button';

<Button type="submit" disabled={loading} focusableWhenDisabled>
  {loading ? 'Submitting...' : 'Submit'}
</Button>
```

### Rendering as Another Tag

```tsx
<Button render={<div />} nativeButton={false}>
  Complex content button
</Button>
```

---

## Common Patterns

### Shared Props Across All Components

Every component part accepts these common props:

| Prop | Type | Description |
|:-----|:-----|:------------|
| className | `string \| (state) => string` | CSS class or state-based class function. |
| style | `CSSProperties \| (state) => CSSProperties` | Inline styles or state-based style function. |
| render | `ReactElement \| (props, state) => ReactElement` | Replace the rendered HTML element with a different tag or compose with another component. |

### Field Integration Summary

All form controls integrate with Field.Root. The pattern is:

1. Wrap the control in `<Field.Root name="fieldName">`
2. Add `<Field.Label>` for accessible labeling
3. Add `<Field.Error>` for validation messages
4. For groups (RadioGroup, CheckboxGroup), use `<Fieldset.Root render={<GroupComponent />}>` with `<Fieldset.Legend>`

| Component | Field Pattern |
|:----------|:-------------|
| Input, Field.Control | Direct child of Field.Root |
| NumberField | Direct child of Field.Root |
| Checkbox | Wrap in Field.Label (enclosing label pattern) |
| CheckboxGroup | Use Fieldset.Root with render prop |
| RadioGroup | Use Fieldset.Root with render prop |
| Select | Use Field.Label with `nativeLabel={false}` and `render={<div />}` |
| Combobox | Use `<label>` element or Field component |
| Autocomplete | Use `<label>` element or Field component |
| Switch | Wrap in Field.Label (enclosing label pattern) |
| Slider | Direct child of Field.Root; multi-thumb uses Fieldset |
