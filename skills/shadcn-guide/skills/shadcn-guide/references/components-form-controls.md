# shadcn/ui Form Control Components

Buttons, checkboxes, radio groups, toggles, sliders, and date pickers.

## Key Variant Differences

| Aspect | Base UI | Radix UI (Default) |
|--------|---------|-------------------|
| Style name | `base-nova` | `new-york` / `radix-nova` |
| Primitive library | `@base-ui/react` | `radix-ui` |
| Composition prop | `render={<Component />}` | `asChild` |
| Accordion API | `defaultValue` array, `multiple` prop | `type="single"\|"multiple"`, `collapsible` |

Most components share identical install commands, imports, and usage patterns. Variant-specific differences are noted per component where applicable.

---

## Button

Displays a button or a component that looks like a button.

```bash
npx shadcn@latest add button
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { Button } from "@/components/ui/button"
```

```tsx
<Button variant="outline">Button</Button>
```

- **Variant prop:** `"default"` | `"outline"` | `"ghost"` | `"destructive"` | `"secondary"` | `"link"`
- **Size prop:** `"default"` | `"xs"` | `"sm"` | `"lg"` | `"icon"` | `"icon-xs"` | `"icon-sm"` | `"icon-lg"`
- Use `data-icon="inline-start"` or `data-icon="inline-end"` for icons
- **Base UI:** use `render` prop for custom elements; set `nativeButton={false}` for non-button elements / **Radix:** use `asChild`

---


## Button Group

A container that groups related buttons together with consistent styling.

```bash
npx shadcn@latest add button-group
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { ButtonGroup, ButtonGroupSeparator, ButtonGroupText } from "@/components/ui/button-group"
```

```tsx
<ButtonGroup>
  <Button>Button 1</Button>
  <Button>Button 2</Button>
</ButtonGroup>
```

- **Key props:** `orientation` (`"horizontal"` | `"vertical"`)
- **Sub-components:** `ButtonGroup`, `ButtonGroupSeparator`, `ButtonGroupText`
- Use `aria-label` for accessibility; differs from `ToggleGroup` (use `ButtonGroup` for actions, `ToggleGroup` for toggling state)

---


## Calendar

A calendar component that allows users to select a date or a range of dates.

```bash
npx shadcn@latest add calendar
```

**Deps:** `react-day-picker`, `date-fns`

```tsx
import { Calendar } from "@/components/ui/calendar"
```

```tsx
const [date, setDate] = React.useState<Date | undefined>(new Date())

<Calendar
  mode="single"
  selected={date}
  onSelect={setDate}
  className="rounded-lg border"
/>
```

- **Key props:** `mode` (`"single"` | `"range"` | `"multiple"`), `selected`, `onSelect`, `captionLayout` (`"label"` | `"dropdown"`), `timeZone`, `locale`, `showWeekNumber`
- Built on [React DayPicker](https://react-day-picker.js.org); supports Persian/Hijri/Jalali via `react-day-picker/persian`
- Custom cell size via `--cell-size` CSS variable

---


## Checkbox

A control that allows the user to toggle between checked and not checked.

```bash
npx shadcn@latest add checkbox
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { Checkbox } from "@/components/ui/checkbox"
```

```tsx
<Checkbox />
```

- **Key props:** `checked`, `onCheckedChange`, `defaultChecked`, `disabled`
- Use `aria-invalid` for invalid state; pair with `Field` and `FieldLabel` for labels
- Supports indeterminate state

---


## Date Picker

A date picker component with range and presets. **This is a composition pattern, not a standalone component.**

```bash
npx shadcn@latest add popover calendar
```

**Deps:** Composition of `Popover` + `Calendar` (no separate install)

```tsx
import { Calendar } from "@/components/ui/calendar"
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover"
```

```tsx
<Popover>
  <PopoverTrigger asChild>
    <Button variant="outline">
      {date ? format(date, "PPP") : <span>Pick a date</span>}
    </Button>
  </PopoverTrigger>
  <PopoverContent className="w-auto p-0">
    <Calendar mode="single" selected={date} onSelect={setDate} />
  </PopoverContent>
</Popover>
```

- Supports single date, range (`mode="range"`), date of birth (`captionLayout="dropdown"`), input-based, time picker, and natural language parsing with `chrono-node`
- **Base UI:** use `render` on `PopoverTrigger` / **Radix:** use `asChild`

---


## Radio Group

A set of checkable buttons where no more than one can be checked at a time.

```bash
npx shadcn@latest add radio-group
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
```

```tsx
<RadioGroup defaultValue="option-one">
  <div className="flex items-center gap-3">
    <RadioGroupItem value="option-one" id="option-one" />
    <Label htmlFor="option-one">Option One</Label>
  </div>
  <div className="flex items-center gap-3">
    <RadioGroupItem value="option-two" id="option-two" />
    <Label htmlFor="option-two">Option Two</Label>
  </div>
</RadioGroup>
```

- **Key props:** `defaultValue`, `value`, `onValueChange`, `disabled`
- **Sub-components:** `RadioGroup`, `RadioGroupItem`
- Use with `Field`, `FieldSet`, and `FieldLegend` for accessible grouping; supports choice card pattern

---


## Slider

An input where the user selects a value from within a given range.

```bash
npx shadcn@latest add slider
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { Slider } from "@/components/ui/slider"
```

```tsx
<Slider defaultValue={[33]} max={100} step={1} />
```

- **Key props:** `defaultValue` (array), `max`, `min`, `step`, `orientation` (`"horizontal"` | `"vertical"`), `disabled`
- Supports range (two values) and multiple thumbs (array with multiple values)

---


## Switch

A control that allows the user to toggle between checked and not checked.

```bash
npx shadcn@latest add switch
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { Switch } from "@/components/ui/switch"
```

```tsx
<Switch />
```

- **Key props:** `checked`, `onCheckedChange`, `disabled`, `aria-invalid`, `size`
- Pair with `Field` and `FieldLabel` for accessible form layout; supports choice card pattern

---


## Toggle

A two-state button that can be either on or off.

```bash
npx shadcn@latest add toggle
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { Toggle } from "@/components/ui/toggle"
```

```tsx
<Toggle>Toggle</Toggle>
```

- **Key props:** `variant` (`"default"` | `"outline"`), `size`, `disabled`, `pressed`, `onPressedChange`

---


## Toggle Group

A set of two-state buttons that can be toggled on or off.

```bash
npx shadcn@latest add toggle-group
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { ToggleGroup, ToggleGroupItem } from "@/components/ui/toggle-group"
```

```tsx
<ToggleGroup type="single">
  <ToggleGroupItem value="a">A</ToggleGroupItem>
  <ToggleGroupItem value="b">B</ToggleGroupItem>
  <ToggleGroupItem value="c">C</ToggleGroupItem>
</ToggleGroup>
```

- **Key props:** `type` (`"single"` | `"multiple"`), `variant` (`"default"` | `"outline"`), `size`, `spacing`, `orientation` (`"horizontal"` | `"vertical"`)
- **Sub-components:** `ToggleGroup`, `ToggleGroupItem`
- Use `ToggleGroup` for state toggling; use `ButtonGroup` for action buttons

---
