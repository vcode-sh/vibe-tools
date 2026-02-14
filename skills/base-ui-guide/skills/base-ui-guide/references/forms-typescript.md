# Forms & TypeScript Guide

## Forms

Base UI form control components extend the native [constraint validation API](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#the-constraint-validation-api). They integrate with third-party libraries like React Hook Form and TanStack Form.

### Core Form Architecture

```
Form                          → <form> wrapper with validation & submission
  Field.Root name="fieldName" → Field wrapper with name for form submission
    Field.Label               → Label associated with control
    Field.Control             → Native <input> with constraints
    Field.Description         → Help text
    Field.Error               → Validation error message
  Fieldset.Root               → Groups related fields
    Fieldset.Legend            → Group label
```

### Basic Form Example

```tsx
import { Form } from '@base-ui/react/form';
import { Field } from '@base-ui/react/field';

<Form
  onFormSubmit={(formValues) => {
    console.log(formValues); // { serverName: "api-01", region: "us-east-1" }
  }}
>
  <Field.Root name="serverName">
    <Field.Label>Server name</Field.Label>
    <Field.Control
      defaultValue=""
      placeholder="e.g. api-server-01"
      required
      minLength={3}
      pattern=".*[A-Za-z].*"
    />
    <Field.Description>Must be 3 or more characters</Field.Description>
    <Field.Error />
  </Field.Root>

  <button type="submit">Submit</button>
</Form>
```

### Form Control Integration Patterns

Each Base UI form component integrates with `Field.Root` differently:

**Text Input:**
```tsx
<Field.Root name="email">
  <Field.Label>Email</Field.Label>
  <Field.Control type="email" required />
  <Field.Error />
</Field.Root>
```

**Select (button-based - needs `nativeLabel={false}`):**
```tsx
<Field.Root name="serverType">
  <Field.Label nativeLabel={false} render={<div />}>Server type</Field.Label>
  <Select.Root items={types} required>
    <Select.Trigger>
      <Select.Value />
      <Select.Icon><ChevronDown /></Select.Icon>
    </Select.Trigger>
    <Select.Portal>
      <Select.Positioner>
        <Select.Popup>
          <Select.List>
            {types.map(({ label, value }) => (
              <Select.Item key={value} value={value}>
                <Select.ItemIndicator><Check /></Select.ItemIndicator>
                <Select.ItemText>{label}</Select.ItemText>
              </Select.Item>
            ))}
          </Select.List>
        </Select.Popup>
      </Select.Positioner>
    </Select.Portal>
  </Select.Root>
  <Field.Error />
</Field.Root>
```

**Combobox:**
```tsx
<Field.Root name="region">
  <Combobox.Root items={regions} required>
    <Field.Label>Region</Field.Label>
    <Combobox.Input placeholder="e.g. eu-central-1" />
    <Combobox.Trigger><ChevronDown /></Combobox.Trigger>
    <Combobox.Portal>
      <Combobox.Positioner>
        <Combobox.Popup>
          <Combobox.List>
            {(region) => (
              <Combobox.Item key={region} value={region}>
                <Combobox.ItemIndicator><Check /></Combobox.ItemIndicator>
                {region}
              </Combobox.Item>
            )}
          </Combobox.List>
        </Combobox.Popup>
      </Combobox.Positioner>
    </Combobox.Portal>
  </Combobox.Root>
  <Field.Error />
</Field.Root>
```

**NumberField:**
```tsx
<Field.Root name="instances">
  <NumberField.Root defaultValue={undefined} min={1} max={64} required>
    <Field.Label>Number of instances</Field.Label>
    <NumberField.Group>
      <NumberField.Decrement><Minus /></NumberField.Decrement>
      <NumberField.Input />
      <NumberField.Increment><Plus /></NumberField.Increment>
    </NumberField.Group>
  </NumberField.Root>
  <Field.Error />
</Field.Root>
```

**Radio Group (with Fieldset):**
```tsx
<Field.Root name="storageType">
  <Fieldset.Root render={<RadioGroup defaultValue="ssd" />}>
    <Fieldset.Legend>Storage type</Fieldset.Legend>
    <Field.Item>
      <Field.Label>
        <Radio.Root value="ssd"><Radio.Indicator /></Radio.Root>
        SSD
      </Field.Label>
    </Field.Item>
    <Field.Item>
      <Field.Label>
        <Radio.Root value="hdd"><Radio.Indicator /></Radio.Root>
        HDD
      </Field.Label>
    </Field.Item>
  </Fieldset.Root>
</Field.Root>
```

**Checkbox Group (with Fieldset):**
```tsx
<Field.Root name="protocols">
  <Fieldset.Root render={<CheckboxGroup defaultValue={[]} />}>
    <Fieldset.Legend>Allowed protocols</Fieldset.Legend>
    {['http', 'https', 'ssh'].map((val) => (
      <Field.Item key={val}>
        <Field.Label>
          <Checkbox.Root value={val}>
            <Checkbox.Indicator><Check /></Checkbox.Indicator>
          </Checkbox.Root>
          {val}
        </Field.Label>
      </Field.Item>
    ))}
  </Fieldset.Root>
</Field.Root>
```

**Switch:**
```tsx
<Field.Root name="restartOnFailure">
  <Field.Label>
    Restart on failure
    <Switch.Root defaultChecked>
      <Switch.Thumb />
    </Switch.Root>
  </Field.Label>
</Field.Root>
```

**Slider (with Fieldset):**
```tsx
<Field.Root name="threshold">
  <Fieldset.Root
    render={
      <Slider.Root defaultValue={[0.2, 0.8]} min={0} max={1} step={0.01}
        format={{ style: 'percent' }} thumbAlignment="edge" />
    }
  >
    <Fieldset.Legend>Scaling threshold</Fieldset.Legend>
    <Slider.Value />
    <Slider.Control>
      <Slider.Track>
        <Slider.Indicator />
        <Slider.Thumb index={0} />
        <Slider.Thumb index={1} />
      </Slider.Track>
    </Slider.Control>
  </Fieldset.Root>
</Field.Root>
```

### Validation

**Built-in constraints** (on Field.Control):
- `required` - Must have value
- `minLength` / `maxLength` - Text length limits
- `min` / `max` - Numeric range
- `pattern` - Regex pattern
- `type` - Input type validation (email, url, etc.)

**Custom validation** (on Field.Root):
```tsx
<Field.Root
  name="email"
  validate={(value) => {
    if (!value.includes('@')) return 'Must be a valid email';
    return null; // null = valid
  }}
  validationMode="onBlur" // 'onSubmit' | 'onBlur' | 'onChange'
  validationDebounceTime={300}
>
```

**Error matching:**
```tsx
<Field.Error match="valueMissing">This field is required</Field.Error>
<Field.Error match="typeMismatch">Invalid email format</Field.Error>
<Field.Error match="tooShort">Too short</Field.Error>
<Field.Error /> {/* Catches all other errors */}
```

**Server-side errors:**
```tsx
<Form errors={{ email: 'Already taken', password: 'Too weak' }}>
```

### Field Data Attributes (for styling validation state)

All form controls within `Field.Root` get these data attributes:
- `data-valid` / `data-invalid` - Validation state
- `data-dirty` - Value has been modified
- `data-touched` - Field has been focused and blurred
- `data-filled` - Field has a value
- `data-focused` - Field currently has focus
- `data-disabled` - Field is disabled

---

## TypeScript

### Type Namespaces

Every component organizes types by namespace: `ComponentName.Part.Type`

### Props Type

Use for wrapper components:

```tsx
import { Tooltip } from '@base-ui/react/tooltip';

function MyTooltip(props: Tooltip.Root.Props) {
  return <Tooltip.Root {...props} />;
}
```

### State Type

Internal state, available in render function callbacks:

```tsx
<Popover.Positioner
  render={(props: Popover.Positioner.Props, state: Popover.Positioner.State) => (
    <div {...props}>
      <p>The popover is {state.open ? 'open' : 'closed'}</p>
      <p>Side: {state.side}</p>
      <p>Align: {state.align}</p>
      <p>Anchor is {state.anchorHidden ? 'hidden' : 'visible'}</p>
      {props.children}
    </div>
  )}
/>
```

### Event Types

```tsx
import { Combobox } from '@base-ui/react/combobox';

// ChangeEventDetails - full event details object
function onValueChange(
  value: string,
  eventDetails: Combobox.Root.ChangeEventDetails
) {
  console.log(eventDetails.reason);
}

// ChangeEventReason - union of possible reason strings
const reason: Combobox.Root.ChangeEventReason = 'item-click';
```

### Other Exported Types

| Type Pattern | Description |
|-------------|-------------|
| `ComponentName.Part.Props` | Component props type |
| `ComponentName.Part.State` | Internal state type |
| `ComponentName.Root.ChangeEventDetails` | Event details object |
| `ComponentName.Root.ChangeEventReason` | Union of reason strings |
| `ComponentName.Root.Actions` | Shape of `actionsRef` object |
| `Toast.Root.ToastObject` | Toast item interface |
| `useRender.ComponentProps<'tag'>` | External props with render prop |
| `useRender.ElementProps<'tag'>` | Internal element props |

### Common Patterns

**Wrapper component with custom props:**
```tsx
interface MyDialogProps extends Dialog.Root.Props {
  customProp?: string;
}

function MyDialog({ customProp, ...props }: MyDialogProps) {
  return <Dialog.Root {...props} />;
}
```

**Typed render function:**
```tsx
<Popover.Popup
  render={(props, state) => {
    // state is typed as Popover.Popup.State
    // props is typed as Popover.Popup.Props
    return <div {...props}>{state.open ? 'Open' : 'Closed'}</div>;
  }}
/>
```
