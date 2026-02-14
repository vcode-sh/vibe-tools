# shadcn/ui Form Input Components

Text inputs, selects, combobox, field layout, and labels.

## Key Variant Differences

| Aspect | Base UI | Radix UI (Default) |
|--------|---------|-------------------|
| Style name | `base-nova` | `new-york` / `radix-nova` |
| Primitive library | `@base-ui/react` | `radix-ui` |
| Composition prop | `render={<Component />}` | `asChild` |
| Accordion API | `defaultValue` array, `multiple` prop | `type="single"\|"multiple"`, `collapsible` |

Most components share identical install commands, imports, and usage patterns. Variant-specific differences are noted per component where applicable.

---

## Combobox

Autocomplete input with a list of suggestions.

```bash
npx shadcn@latest add combobox
```

**Deps:** `@base-ui/react`

```tsx
import {
  Combobox, ComboboxContent, ComboboxEmpty,
  ComboboxInput, ComboboxItem, ComboboxList,
} from "@/components/ui/combobox"
```

```tsx
const frameworks = ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]

<Combobox items={frameworks}>
  <ComboboxInput placeholder="Select a framework" />
  <ComboboxContent>
    <ComboboxEmpty>No items found.</ComboboxEmpty>
    <ComboboxList>
      {(item) => (
        <ComboboxItem key={item} value={item}>{item}</ComboboxItem>
      )}
    </ComboboxList>
  </ComboboxContent>
</Combobox>
```

- **Key props:** `items`, `multiple`, `value`, `onValueChange`, `itemToStringValue`, `showClear`, `autoHighlight`, `disabled`
- **Sub-components:** `Combobox`, `ComboboxInput`, `ComboboxContent`, `ComboboxList`, `ComboboxItem`, `ComboboxEmpty`, `ComboboxGroup`, `ComboboxSeparator`, `ComboboxChips`, `ComboboxChip`, `ComboboxChipsInput`, `ComboboxValue`

---


## Field

Combine labels, controls, and help text to compose accessible form fields.

```bash
npx shadcn@latest add field
```

**Deps:** None (pure component)

```tsx
import {
  Field, FieldContent, FieldDescription, FieldError,
  FieldGroup, FieldLabel, FieldLegend, FieldSeparator,
  FieldSet, FieldTitle,
} from "@/components/ui/field"
```

```tsx
<FieldSet>
  <FieldLegend>Profile</FieldLegend>
  <FieldGroup>
    <Field>
      <FieldLabel htmlFor="name">Full name</FieldLabel>
      <Input id="name" placeholder="Evil Rabbit" />
      <FieldDescription>This appears on invoices.</FieldDescription>
    </Field>
    <Field>
      <FieldLabel htmlFor="username">Username</FieldLabel>
      <Input id="username" aria-invalid />
      <FieldError>Choose another username.</FieldError>
    </Field>
  </FieldGroup>
</FieldSet>
```

- **Key props:** `orientation` (`"vertical"` | `"horizontal"` | `"responsive"`) on `Field`, `data-invalid` on `Field`, `variant` (`"legend"` | `"label"`) on `FieldLegend`
- **Sub-components:** `FieldSet`, `FieldLegend`, `FieldGroup`, `Field`, `FieldContent`, `FieldLabel`, `FieldTitle`, `FieldDescription`, `FieldSeparator`, `FieldError`
- `FieldError` accepts `errors` array (e.g. from react-hook-form) or Standard Schema issues

---


## Input

A text input component for forms and user data entry.

```bash
npx shadcn@latest add input
```

**Deps:** None (pure component)

```tsx
import { Input } from "@/components/ui/input"
```

```tsx
<Input />
```

- **Key props:** All standard HTML input attributes, `type`, `disabled`, `aria-invalid`
- Pair with `Field`, `FieldLabel`, `FieldDescription` for form layout

---


## Input Group

Add addons, buttons, and helper content to inputs.

```bash
npx shadcn@latest add input-group
```

**Deps:** None (pure component)

```tsx
import {
  InputGroup, InputGroupAddon, InputGroupButton,
  InputGroupInput, InputGroupText, InputGroupTextarea,
} from "@/components/ui/input-group"
```

```tsx
<InputGroup>
  <InputGroupInput placeholder="Search..." />
  <InputGroupAddon><SearchIcon /></InputGroupAddon>
</InputGroup>
```

- **Key props:** `align` (`"inline-start"` | `"inline-end"` | `"block-start"` | `"block-end"`) on `InputGroupAddon`
- **Sub-components:** `InputGroup`, `InputGroupAddon`, `InputGroupButton`, `InputGroupInput`, `InputGroupTextarea`, `InputGroupText`
- `InputGroupAddon` must be placed after the input in DOM; use `align` for visual positioning
- For custom inputs, add `data-slot="input-group-control"` attribute

---


## Input OTP

Accessible one-time password component with copy paste functionality.

```bash
npx shadcn@latest add input-otp
```

**Deps:** `input-otp`

```tsx
import { InputOTP, InputOTPGroup, InputOTPSeparator, InputOTPSlot } from "@/components/ui/input-otp"
```

```tsx
<InputOTP maxLength={6}>
  <InputOTPGroup>
    <InputOTPSlot index={0} />
    <InputOTPSlot index={1} />
    <InputOTPSlot index={2} />
  </InputOTPGroup>
  <InputOTPSeparator />
  <InputOTPGroup>
    <InputOTPSlot index={3} />
    <InputOTPSlot index={4} />
    <InputOTPSlot index={5} />
  </InputOTPGroup>
</InputOTP>
```

- **Key props:** `maxLength`, `pattern` (e.g. `REGEXP_ONLY_DIGITS_AND_CHARS`), `value`, `onChange`, `disabled`
- **Sub-components:** `InputOTP`, `InputOTPGroup`, `InputOTPSlot`, `InputOTPSeparator`
- Built on [input-otp](https://github.com/guilhermerodz/input-otp)

---

# shadcn/ui Components Reference (J–Z)

Components from Item to Typography (29 components). See `components-a-i.md` for Accordion through Input OTP.

---


## Label

Renders an accessible label associated with controls.

```bash
npx shadcn@latest add label
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { Label } from "@/components/ui/label"
```

```tsx
<Label htmlFor="email">Your email address</Label>
```

- For form fields, prefer using `Field` with `FieldLabel` instead
- Standard HTML `htmlFor` attribute for associating with inputs

---


## Native Select

A styled native HTML select element with consistent design system integration.

```bash
npx shadcn@latest add native-select
```

**Deps:** None (pure component)

```tsx
import { NativeSelect, NativeSelectOptGroup, NativeSelectOption } from "@/components/ui/native-select"
```

```tsx
<NativeSelect>
  <NativeSelectOption value="">Select a fruit</NativeSelectOption>
  <NativeSelectOption value="apple">Apple</NativeSelectOption>
  <NativeSelectOption value="banana">Banana</NativeSelectOption>
</NativeSelect>
```

- **Sub-components:** `NativeSelect`, `NativeSelectOption`, `NativeSelectOptGroup`
- Use `NativeSelect` for native browser behavior and mobile optimization; use `Select` for custom styling

---


## Select

Displays a list of options for the user to pick from, triggered by a button.

```bash
npx shadcn@latest add select
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import {
  Select, SelectContent, SelectGroup,
  SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select"
```

```tsx
<Select>
  <SelectTrigger className="w-[180px]">
    <SelectValue placeholder="Theme" />
  </SelectTrigger>
  <SelectContent>
    <SelectGroup>
      <SelectItem value="light">Light</SelectItem>
      <SelectItem value="dark">Dark</SelectItem>
      <SelectItem value="system">System</SelectItem>
    </SelectGroup>
  </SelectContent>
</Select>
```

- **Key props:** `aria-invalid` on `SelectTrigger`
- **Sub-components:** `Select`, `SelectTrigger`, `SelectValue`, `SelectContent`, `SelectGroup`, `SelectItem`, `SelectLabel`, `SelectSeparator`
- **Base UI:** `alignItemWithTrigger` on `SelectContent` / **Radix:** `position` (`"item-aligned"` | `"popper"`) on `SelectContent`

---


## Textarea

Displays a form textarea or a component that looks like a textarea.

```bash
npx shadcn@latest add textarea
```

**Deps:** None (pure component)

```tsx
import { Textarea } from "@/components/ui/textarea"
```

```tsx
<Textarea />
```

- **Key props:** All standard HTML textarea attributes, `disabled`, `aria-invalid`
- Pair with `Field`, `FieldLabel`, `FieldDescription` for form layout

---
