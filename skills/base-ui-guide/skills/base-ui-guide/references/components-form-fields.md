# Form Field Components Reference

Complete API reference for Base UI form field components: Form, Field, Fieldset, Input, NumberField, Checkbox, CheckboxGroup, Radio.

---

## Form

A native form element with consolidated error handling.

```ts
import { Form } from '@base-ui/react/form';
```

**Parts:** `Form` renders a `<form>` element.

### Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| errors | `Errors` | - | Validation errors from external source (e.g. server). Keys correspond to `name` on `Field.Root`, values are error strings. |
| actionsRef | `RefObject<Form.Actions \| null>` | - | Ref to imperative actions. `validate`: validates all fields or a single field by name. |
| onFormSubmit | `(formValues: Record<string, any>, eventDetails: Form.SubmitEventDetails) => void` | - | Called on submit with form values as a JS object. Calls `preventDefault` on native submit. |
| validationMode | `FormValidationMode` | `'onSubmit'` | When to validate: `'onSubmit'`, `'onBlur'`, or `'onChange'`. Field-level `validationMode` takes precedence. |
| className | `string \| (state: Form.State) => string` | - | CSS class or state-based class function. |
| render | `ReactElement \| (props, state) => ReactElement` | - | Replace the rendered HTML element. |

### Example

```tsx
import { Form } from '@base-ui/react/form';
import { Field } from '@base-ui/react/field';

const [errors, setErrors] = React.useState({});

<Form
  errors={errors}
  onSubmit={async (event) => {
    event.preventDefault();
    const formData = new FormData(event.currentTarget);
    const response = await submitToServer(formData);
    setErrors(response.errors);
  }}
>
  <Field.Root name="email">
    <Field.Label>Email</Field.Label>
    <Field.Control type="email" required />
    <Field.Error />
  </Field.Root>
</Form>
```

### Notes

- Use `onFormSubmit` instead of `onSubmit` to receive form values as a JavaScript object.
- Supports `useActionState` for Server Function submissions via the `action` prop.
- Integrates with Zod: use `z.flattenError(result.error).fieldErrors` to map errors to field names.

---

## Field

A component that provides labeling and validation for form controls.

```ts
import { Field } from '@base-ui/react/field';
```

**Parts:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| Field.Root | `<div>` | Groups all parts of the field. |
| Field.Label | `<label>` | Accessible label, auto-associated with the control. |
| Field.Control | `<input>` | The form control. Can be omitted in favor of other Base UI input components. |
| Field.Description | `<p>` | Additional information paragraph. |
| Field.Item | `<div>` | Groups individual items in checkbox/radio groups with label and description. |
| Field.Error | `<div>` | Error message displayed on validation failure. |
| Field.Validity | - | Render prop that receives field validity state. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| name | `string` | - | Identifies the field on form submission. Takes precedence over `Field.Control` name. |
| actionsRef | `RefObject<Field.Root.Actions \| null>` | - | Ref to imperative actions. `validate`: validates the field. |
| dirty | `boolean` | - | Whether value has changed from initial. For external library control. |
| touched | `boolean` | - | Whether the field has been touched. For external library control. |
| disabled | `boolean` | `false` | Disables user interaction. Takes precedence over `Field.Control` disabled. |
| invalid | `boolean` | - | Whether field is invalid. For external library control. |
| validate | `(value, formValues) => string \| string[] \| Promise<...> \| null` | - | Custom validation function. Return error string(s) or null. |
| validationMode | `Form.ValidationMode` | `'onSubmit'` | When to validate: `'onSubmit'`, `'onBlur'`, `'onChange'`. Takes precedence over Form. |
| validationDebounceTime | `number` | `0` | Debounce delay in ms for `onChange` validation. |
| className | `string \| (state) => string` | - | CSS class or state-based class function. |
| render | `ReactElement \| (props, state) => ReactElement` | - | Replace the rendered HTML element. |

### Label Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| nativeLabel | `boolean` | `true` | Set to `false` when rendered element is not a label (e.g. `<div>`). Avoids inheriting label behaviors on button controls like Select.Trigger. |
| className | `string \| (state) => string` | - | CSS class or state-based class function. |
| render | `ReactElement \| (props, state) => ReactElement` | - | Replace the rendered HTML element. |

### Control Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| defaultValue | `string \| number \| string[]` | - | Uncontrolled default value. |
| onValueChange | `(value: string, eventDetails) => void` | - | Callback when value changes. Use when controlled. |
| className | `string \| (state) => string` | - | CSS class or state-based class function. |
| render | `ReactElement \| (props, state) => ReactElement` | - | Replace the rendered HTML element. |

### Error Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| match | `boolean \| 'valid' \| 'badInput' \| 'customError' \| 'patternMismatch' \| 'rangeOverflow' \| 'rangeUnderflow' \| 'stepMismatch' \| 'tooLong' \| 'tooShort' \| 'typeMismatch' \| 'valueMissing'` | - | Show error based on ValidityState. `true` always shows. |
| className | `string \| (state) => string` | - | CSS class or state-based class function. |

### Item Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| disabled | `boolean` | `false` | Disables the wrapped control. `Field.Root` disabled takes precedence. |

### Validity

Used to display custom messages based on field validity state. Requires `children` to be a function.

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `children` | `(state: Field.Validity.State) => ReactNode` | - | Function receiving validity state. |

```tsx
<Field.Validity>
  {(validity) => validity.valueMissing && <span>Required</span>}
</Field.Validity>
```

### Data Attributes (shared across Root, Label, Control, Description, Error)

| Attribute | Description |
|:----------|:------------|
| `data-disabled` | Field is disabled. |
| `data-valid` | Field is valid. |
| `data-invalid` | Field is invalid. |
| `data-dirty` | Field value has changed. |
| `data-touched` | Field has been touched. |
| `data-filled` | Field is filled. |
| `data-focused` | Field control is focused. |

### Example

```tsx
import { Field } from '@base-ui/react/field';

<Field.Root name="username">
  <Field.Label>Username</Field.Label>
  <Field.Control required placeholder="Enter username" />
  <Field.Description>Must be unique</Field.Description>
  <Field.Error match="valueMissing">Username is required</Field.Error>
  <Field.Error match="customError" />
</Field.Root>
```

---

## Fieldset

A native fieldset element with an easily stylable legend.

```ts
import { Fieldset } from '@base-ui/react/fieldset';
```

**Parts:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| Fieldset.Root | `<fieldset>` | Groups the legend and associated fields. |
| Fieldset.Legend | `<div>` | Accessible label for the fieldset (renders `<div>`, not native `<legend>`). |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| className | `string \| (state) => string` | - | CSS class or state-based class function. |
| render | `ReactElement \| (props, state) => ReactElement` | - | Replace the rendered HTML element. |

### Example

```tsx
import { Fieldset } from '@base-ui/react/fieldset';
import { Field } from '@base-ui/react/field';

<Fieldset.Root>
  <Fieldset.Legend>Billing details</Fieldset.Legend>
  <Field.Root>
    <Field.Label>Company</Field.Label>
    <Field.Control placeholder="Enter company name" />
  </Field.Root>
</Fieldset.Root>
```

---

## Input

A native input element that automatically works with Field.

```ts
import { Input } from '@base-ui/react/input';
```

**Parts:** `Input` renders an `<input>` element (single part component).

### Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| defaultValue | `string \| number \| string[]` | - | Uncontrolled default value. |
| onValueChange | `(value: string, eventDetails) => void` | - | Callback when value changes. |
| className | `string \| (state: Input.State) => string` | - | CSS class or state-based class function. |
| render | `ReactElement \| (props, state) => ReactElement` | - | Replace the rendered HTML element. |

### Data Attributes

| Attribute | Description |
|:----------|:------------|
| `data-disabled` | Input is disabled. |
| `data-valid` | Valid state (in Field.Root). |
| `data-invalid` | Invalid state (in Field.Root). |
| `data-dirty` | Value has changed (in Field.Root). |
| `data-touched` | Has been touched (in Field.Root). |
| `data-filled` | Is filled (in Field.Root). |
| `data-focused` | Is focused (in Field.Root). |

### Example

```tsx
import { Input } from '@base-ui/react/input';

<Field.Root>
  <Field.Label>Name</Field.Label>
  <Input placeholder="Enter your name" />
</Field.Root>
```

### Form Integration

Input automatically integrates with Field.Root when placed inside it. Use Input instead of Field.Control when you want a standalone input component that still works with Field.

---

## NumberField

A numeric input with increment/decrement buttons and a scrub area.

```ts
import { NumberField } from '@base-ui/react/number-field';
```

**Parts:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| NumberField.Root | `<div>` | Groups all parts, manages state. |
| NumberField.ScrubArea | `<span>` | Click-and-drag area to change value. |
| NumberField.ScrubAreaCursor | `<span>` | Custom cursor displayed during scrubbing. |
| NumberField.Group | `<div>` | Groups input with increment/decrement buttons. |
| NumberField.Decrement | `<button>` | Decreases the value. |
| NumberField.Input | `<input>` | The numeric input control. |
| NumberField.Increment | `<button>` | Increases the value. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| name | `string` | - | Identifies field on form submission. |
| defaultValue | `number` | - | Uncontrolled initial value. |
| value | `number \| null` | - | Controlled raw numeric value. |
| onValueChange | `(value: number \| null, eventDetails) => void` | - | Callback on value change. `eventDetails.reason` indicates trigger. |
| onValueCommitted | `(value: number \| null, eventDetails) => void` | - | Callback on value commit (blur, pointer release). |
| locale | `Intl.LocalesArgument` | - | Input locale for formatting. |
| snapOnStep | `boolean` | `false` | Snap to nearest step on increment/decrement. |
| step | `number \| 'any'` | `1` | Step amount for buttons and arrow keys. |
| smallStep | `number` | `0.1` | Step when Meta key is held. |
| largeStep | `number` | `10` | Step when Shift key is held. |
| min | `number` | - | Minimum value. |
| max | `number` | - | Maximum value. |
| allowWheelScrub | `boolean` | `false` | Allow mouse wheel scrubbing while focused. |
| format | `Intl.NumberFormatOptions` | - | Number formatting options. |
| disabled | `boolean` | `false` | Disables user interaction. |
| readOnly | `boolean` | `false` | Prevents value changes. |
| required | `boolean` | `false` | Requires value before form submission. |
| inputRef | `Ref<HTMLInputElement>` | - | Ref to hidden input. |
| id | `string` | - | Input element id. |

### ScrubArea Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| direction | `'horizontal' \| 'vertical'` | `'horizontal'` | Cursor movement direction. |
| pixelSensitivity | `number` | `2` | Pixels of cursor movement before value changes. |
| teleportDistance | `number` | - | Distance before cursor loops back to center. |

### Data Attributes (shared across all NumberField parts)

| Attribute | Description |
|:----------|:------------|
| `data-disabled` | Number field is disabled. |
| `data-readonly` | Number field is readonly. |
| `data-required` | Number field is required. |
| `data-valid` | Valid state (in Field.Root). |
| `data-invalid` | Invalid state (in Field.Root). |
| `data-dirty` | Value has changed (in Field.Root). |
| `data-touched` | Has been touched (in Field.Root). |
| `data-filled` | Is filled (in Field.Root). |
| `data-focused` | Is focused (in Field.Root). |
| `data-scrubbing` | Currently scrubbing. |

### Example

```tsx
import { NumberField } from '@base-ui/react/number-field';

<NumberField.Root defaultValue={100}>
  <NumberField.ScrubArea>
    <label>Amount</label>
    <NumberField.ScrubAreaCursor />
  </NumberField.ScrubArea>
  <NumberField.Group>
    <NumberField.Decrement>-</NumberField.Decrement>
    <NumberField.Input />
    <NumberField.Increment>+</NumberField.Increment>
  </NumberField.Group>
</NumberField.Root>
```

### Form Integration

Wrap in `Field.Root` with a `name` prop. NumberField automatically participates in form validation and submission.

### Styled Example (Tailwind)

```tsx
import { NumberField } from '@base-ui/react/number-field';

export default function ExampleNumberField() {
  return (
    <NumberField.Root defaultValue={1} min={0} max={99}>
      <NumberField.ScrubArea className="cursor-ew-resize">
        <label className="text-sm font-medium text-gray-900">Quantity</label>
      </NumberField.ScrubArea>
      <NumberField.Group className="mt-1 flex">
        <NumberField.Decrement className="flex size-10 items-center justify-center rounded-l-md border border-gray-200 bg-gray-50 text-gray-600 select-none hover:bg-gray-100 focus-visible:z-1 focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-1 focus-visible:outline-blue-800 active:bg-gray-200">
          &minus;
        </NumberField.Decrement>
        <NumberField.Input className="w-16 border-y border-gray-200 bg-[canvas] text-center text-base text-gray-900 outline-none focus-visible:z-1 focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-1 focus-visible:outline-blue-800" />
        <NumberField.Increment className="flex size-10 items-center justify-center rounded-r-md border border-gray-200 bg-gray-50 text-gray-600 select-none hover:bg-gray-100 focus-visible:z-1 focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-1 focus-visible:outline-blue-800 active:bg-gray-200">
          +
        </NumberField.Increment>
      </NumberField.Group>
    </NumberField.Root>
  );
}
```

Key Tailwind patterns:
- **Group**: `flex` to align decrement/input/increment inline
- **Decrement/Increment**: `rounded-l-md` / `rounded-r-md` for pill-shaped edges
- **Input**: `border-y` only (sides covered by buttons), `text-center` for centered value
- **ScrubArea**: `cursor-ew-resize` to hint at drag interaction

---

## Checkbox

An easily stylable checkbox component.

```ts
import { Checkbox } from '@base-ui/react/checkbox';
```

**Parts:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| Checkbox.Root | `<span>` + hidden `<input>` | The checkbox itself. |
| Checkbox.Indicator | `<span>` | Visual indicator of checked state. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| name | `string` | `undefined` | Identifies field on form submission. |
| defaultChecked | `boolean` | `false` | Uncontrolled initial checked state. |
| checked | `boolean` | `undefined` | Controlled checked state. |
| onCheckedChange | `(checked: boolean, eventDetails) => void` | - | Callback when checked state changes. |
| indeterminate | `boolean` | `false` | Mixed state: neither checked nor unchecked. |
| value | `string` | - | Value of the selected checkbox. |
| nativeButton | `boolean` | `false` | Set `true` if render prop produces a `<button>`. |
| parent | `boolean` | `false` | Controls a group of child checkboxes (use in CheckboxGroup). |
| uncheckedValue | `string` | - | Value submitted when unchecked (default: nothing). |
| disabled | `boolean` | `false` | Disables user interaction. |
| readOnly | `boolean` | `false` | Prevents checking/unchecking. |
| required | `boolean` | `false` | Must be checked before form submission. |
| inputRef | `Ref<HTMLInputElement>` | - | Ref to hidden input. |
| id | `string` | - | Input element id. |

### Indicator Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| keepMounted | `boolean` | `false` | Keep in DOM when unchecked. |

### Data Attributes (Root and Indicator)

| Attribute | Description |
|:----------|:------------|
| `data-checked` | Checkbox is checked. |
| `data-unchecked` | Checkbox is not checked. |
| `data-disabled` | Checkbox is disabled. |
| `data-readonly` | Checkbox is readonly. |
| `data-required` | Checkbox is required. |
| `data-indeterminate` | Checkbox is in indeterminate state. |
| `data-valid` | Valid state (in Field.Root). |
| `data-invalid` | Invalid state (in Field.Root). |
| `data-dirty` | Value has changed (in Field.Root). |
| `data-touched` | Has been touched (in Field.Root). |
| `data-filled` | Is checked (in Field.Root). |
| `data-focused` | Is focused (in Field.Root). |

Indicator-only attributes:

| Attribute | Description |
|:----------|:------------|
| `data-starting-style` | Animating in. |
| `data-ending-style` | Animating out. |

### Example

```tsx
import { Checkbox } from '@base-ui/react/checkbox';

<label>
  <Checkbox.Root defaultChecked>
    <Checkbox.Indicator>
      <CheckIcon />
    </Checkbox.Indicator>
  </Checkbox.Root>
  Enable notifications
</label>
```

### Form Integration

```tsx
<Form>
  <Field.Root name="stayLoggedIn">
    <Field.Label>
      <Checkbox.Root />
      Stay logged in for 7 days
    </Field.Label>
  </Field.Root>
</Form>
```

### Styled Example (Tailwind)

```tsx
import { Checkbox } from '@base-ui/react/checkbox';

export default function ExampleCheckbox() {
  return (
    <label className="flex items-center gap-2 text-sm text-gray-900">
      <Checkbox.Root
        defaultChecked
        className="flex size-5 items-center justify-center rounded border border-gray-300 bg-gray-50 data-[checked]:border-blue-800 data-[checked]:bg-blue-800 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-800"
      >
        <Checkbox.Indicator className="text-white">
          <svg className="size-3.5" viewBox="0 0 12 10" fill="none" stroke="currentColor" strokeWidth="2">
            <polyline points="1.5 6 4.5 9 10.5 1" />
          </svg>
        </Checkbox.Indicator>
      </Checkbox.Root>
      Accept terms and conditions
    </label>
  );
}
```

Key Tailwind patterns:
- **Root**: `data-[checked]:bg-blue-800` for checked background color
- **Indicator**: White icon on colored background
- **Focus ring**: `outline-offset-2` for visible separation from checkbox border

---

## CheckboxGroup

Provides shared state to a series of checkboxes.

```ts
import { CheckboxGroup } from '@base-ui/react/checkbox-group';
```

**Parts:** `CheckboxGroup` renders a `<div>` element (single part, wraps Checkbox components).

### Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| defaultValue | `string[]` | - | Initially ticked checkbox values (uncontrolled). |
| value | `string[]` | - | Currently ticked checkbox values (controlled). |
| onValueChange | `(value: string[], eventDetails) => void` | - | Callback when any checkbox is toggled. |
| allValues | `string[]` | - | All checkbox values. Required for parent checkbox feature. |
| disabled | `boolean` | `false` | Disables all checkboxes in the group. |

### Data Attributes

| Attribute | Description |
|:----------|:------------|
| `data-disabled` | Group is disabled. |

### Example

```tsx
import { Checkbox } from '@base-ui/react/checkbox';
import { CheckboxGroup } from '@base-ui/react/checkbox-group';

<CheckboxGroup aria-labelledby="fruits-label" defaultValue={['apple']}>
  <div id="fruits-label">Fruits</div>
  <label>
    <Checkbox.Root name="fruit" value="apple">
      <Checkbox.Indicator><CheckIcon /></Checkbox.Indicator>
    </Checkbox.Root>
    Apple
  </label>
  <label>
    <Checkbox.Root name="fruit" value="banana">
      <Checkbox.Indicator><CheckIcon /></Checkbox.Indicator>
    </Checkbox.Root>
    Banana
  </label>
</CheckboxGroup>
```

### Form Integration

```tsx
<Form>
  <Field.Root name="allowedProtocols">
    <Fieldset.Root render={<CheckboxGroup />}>
      <Fieldset.Legend>Allowed protocols</Fieldset.Legend>
      <Field.Label><Checkbox.Root value="http" /> HTTP</Field.Label>
      <Field.Label><Checkbox.Root value="https" /> HTTPS</Field.Label>
    </Fieldset.Root>
  </Field.Root>
</Form>
```

---

## Radio

An easily stylable radio button component. Always used inside RadioGroup.

```ts
import { Radio } from '@base-ui/react/radio';
import { RadioGroup } from '@base-ui/react/radio-group';
```

**Parts:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| RadioGroup | `<div>` | Shared state for radio buttons. |
| Radio.Root | `<span>` + hidden `<input>` | The radio button itself. |
| Radio.Indicator | `<span>` | Visual indicator of selected state. |

### Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| name | `string` | - | Identifies field on form submission. |
| defaultValue | `any` | - | Initially selected value (uncontrolled). |
| value | `any` | - | Currently selected value (controlled). |
| onValueChange | `(value: any, eventDetails) => void` | - | Callback when selection changes. |
| disabled | `boolean` | `false` | Disables all radio buttons. |
| readOnly | `boolean` | `false` | Prevents selection changes. |
| required | `boolean` | `false` | Requires selection before form submission. |
| inputRef | `Ref<HTMLInputElement>` | - | Ref to hidden input. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| value | `any` | - | Unique identifying value in the group. |
| nativeButton | `boolean` | `false` | Set `true` if render prop produces a `<button>`. |
| disabled | `boolean` | - | Disables this radio button. |
| readOnly | `boolean` | - | Prevents selection. |
| required | `boolean` | - | Requires selection. |
| inputRef | `Ref<HTMLInputElement>` | - | Ref to hidden input. |

### Indicator Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| keepMounted | `boolean` | `false` | Keep in DOM when inactive. |

### Data Attributes (Root and Indicator)

| Attribute | Description |
|:----------|:------------|
| `data-checked` | Radio is selected. |
| `data-unchecked` | Radio is not selected. |
| `data-disabled` | Radio is disabled. |
| `data-readonly` | Radio is readonly. |
| `data-required` | Radio is required. |
| `data-valid` | Valid state (in Field.Root). |
| `data-invalid` | Invalid state (in Field.Root). |
| `data-dirty` | Value has changed (in Field.Root). |
| `data-touched` | Has been touched (in Field.Root). |
| `data-filled` | Is selected (in Field.Root). |
| `data-focused` | Is focused (in Field.Root). |

### Example

```tsx
import { Radio } from '@base-ui/react/radio';
import { RadioGroup } from '@base-ui/react/radio-group';

<RadioGroup aria-labelledby="size-label" defaultValue="medium">
  <div id="size-label">Size</div>
  <label>
    <Radio.Root value="small">
      <Radio.Indicator />
    </Radio.Root>
    Small
  </label>
  <label>
    <Radio.Root value="medium">
      <Radio.Indicator />
    </Radio.Root>
    Medium
  </label>
</RadioGroup>
```

### Form Integration

```tsx
<Form>
  <Field.Root name="storageType">
    <Fieldset.Root render={<RadioGroup />}>
      <Fieldset.Legend>Storage type</Fieldset.Legend>
      <Field.Label><Radio.Root value="ssd" /> SSD</Field.Label>
      <Field.Label><Radio.Root value="hdd" /> HDD</Field.Label>
    </Fieldset.Root>
  </Field.Root>
</Form>
```

