# shadcn/ui Form Patterns

Three form approaches are supported: React Hook Form with Zod, TanStack Form with Zod, and Next.js Server Actions with useActionState. All use the Field component family for accessible, composable layouts.

## Forms

### React Hook Form + Zod

Install dependencies:

```bash
npm install react-hook-form @hookform/resolvers zod
```

#### Create a Form Schema

Define the shape of your form using Zod:

```tsx title="form.tsx"
import * as z from "zod"

const formSchema = z.object({
  title: z
    .string()
    .min(5, "Bug title must be at least 5 characters.")
    .max(32, "Bug title must be at most 32 characters."),
  description: z
    .string()
    .min(20, "Description must be at least 20 characters.")
    .max(100, "Description must be at most 100 characters."),
})
```

#### Setup the Form

Use the `useForm` hook with `zodResolver`:

```tsx title="form.tsx"
import { zodResolver } from "@hookform/resolvers/zod"
import { useForm } from "react-hook-form"
import * as z from "zod"

const formSchema = z.object({
  title: z
    .string()
    .min(5, "Bug title must be at least 5 characters.")
    .max(32, "Bug title must be at most 32 characters."),
  description: z
    .string()
    .min(20, "Description must be at least 20 characters.")
    .max(100, "Description must be at most 100 characters."),
})

export function BugReportForm() {
  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      title: "",
      description: "",
    },
  })

  function onSubmit(data: z.infer<typeof formSchema>) {
    // Do something with the form values.
    console.log(data)
  }

  return (
    <form onSubmit={form.handleSubmit(onSubmit)}>
      {/* ... */}
      {/* Build the form here */}
      {/* ... */}
    </form>
  )
}
```

#### Controller + Field Pattern

Use `Controller` from React Hook Form with `Field` components:

```tsx title="form.tsx"
<Controller
  name="title"
  control={form.control}
  render={({ field, fieldState }) => (
    <Field data-invalid={fieldState.invalid}>
      <FieldLabel htmlFor={field.name}>Bug Title</FieldLabel>
      <Input
        {...field}
        id={field.name}
        aria-invalid={fieldState.invalid}
        placeholder="Login button not working on mobile"
        autoComplete="off"
      />
      <FieldDescription>
        Provide a concise title for your bug report.
      </FieldDescription>
      {fieldState.invalid && <FieldError errors={[fieldState.error]} />}
    </Field>
  )}
/>
```

#### Displaying Errors

Add `data-invalid` to Field and `aria-invalid` to the input:

```tsx title="form.tsx"
<Controller
  name="email"
  control={form.control}
  render={({ field, fieldState }) => (
    <Field data-invalid={fieldState.invalid}>
      <FieldLabel htmlFor={field.name}>Email</FieldLabel>
      <Input
        {...field}
        id={field.name}
        type="email"
        aria-invalid={fieldState.invalid}
      />
      {fieldState.invalid && <FieldError errors={[fieldState.error]} />}
    </Field>
  )}
/>
```

#### Validation Modes

```tsx title="form.tsx"
const form = useForm<z.infer<typeof formSchema>>({
  resolver: zodResolver(formSchema),
  mode: "onChange",
})
```

| Mode          | Description                                              |
| ------------- | -------------------------------------------------------- |
| `"onChange"`  | Validation triggers on every change.                     |
| `"onBlur"`    | Validation triggers on blur.                             |
| `"onSubmit"`  | Validation triggers on submit (default).                 |
| `"onTouched"` | Validation triggers on first blur, then on every change. |
| `"all"`       | Validation triggers on blur and change.                  |

#### Select Field

Use `field.value` and `field.onChange` on Select. Add `aria-invalid` to SelectTrigger:

```tsx title="form.tsx"
<Controller
  name="language"
  control={form.control}
  render={({ field, fieldState }) => (
    <Field orientation="responsive" data-invalid={fieldState.invalid}>
      <FieldContent>
        <FieldLabel htmlFor="form-rhf-select-language">
          Spoken Language
        </FieldLabel>
        <FieldDescription>
          For best results, select the language you speak.
        </FieldDescription>
        {fieldState.invalid && <FieldError errors={[fieldState.error]} />}
      </FieldContent>
      <Select
        name={field.name}
        value={field.value}
        onValueChange={field.onChange}
      >
        <SelectTrigger
          id="form-rhf-select-language"
          aria-invalid={fieldState.invalid}
          className="min-w-[120px]"
        >
          <SelectValue placeholder="Select" />
        </SelectTrigger>
        <SelectContent position="item-aligned">
          <SelectItem value="auto">Auto</SelectItem>
          <SelectItem value="en">English</SelectItem>
        </SelectContent>
      </Select>
    </Field>
  )}
/>
```

#### Checkbox Array

Use array manipulation with `field.value` and `field.onChange`. Add `data-slot="checkbox-group"` to FieldGroup:

```tsx title="form.tsx"
<Controller
  name="tasks"
  control={form.control}
  render={({ field, fieldState }) => (
    <FieldSet>
      <FieldLegend variant="label">Tasks</FieldLegend>
      <FieldDescription>
        Get notified when tasks you've created have updates.
      </FieldDescription>
      <FieldGroup data-slot="checkbox-group">
        {tasks.map((task) => (
          <Field
            key={task.id}
            orientation="horizontal"
            data-invalid={fieldState.invalid}
          >
            <Checkbox
              id={`form-rhf-checkbox-${task.id}`}
              name={field.name}
              aria-invalid={fieldState.invalid}
              checked={field.value.includes(task.id)}
              onCheckedChange={(checked) => {
                const newValue = checked
                  ? [...field.value, task.id]
                  : field.value.filter((value) => value !== task.id)
                field.onChange(newValue)
              }}
            />
            <FieldLabel
              htmlFor={`form-rhf-checkbox-${task.id}`}
              className="font-normal"
            >
              {task.label}
            </FieldLabel>
          </Field>
        ))}
      </FieldGroup>
      {fieldState.invalid && <FieldError errors={[fieldState.error]} />}
    </FieldSet>
  )}
/>
```

#### Radio Group

Use `field.value` and `field.onChange` on RadioGroup:

```tsx title="form.tsx"
<Controller
  name="plan"
  control={form.control}
  render={({ field, fieldState }) => (
    <FieldSet>
      <FieldLegend>Plan</FieldLegend>
      <FieldDescription>
        You can upgrade or downgrade your plan at any time.
      </FieldDescription>
      <RadioGroup
        name={field.name}
        value={field.value}
        onValueChange={field.onChange}
      >
        {plans.map((plan) => (
          <FieldLabel key={plan.id} htmlFor={`form-rhf-radiogroup-${plan.id}`}>
            <Field orientation="horizontal" data-invalid={fieldState.invalid}>
              <FieldContent>
                <FieldTitle>{plan.title}</FieldTitle>
                <FieldDescription>{plan.description}</FieldDescription>
              </FieldContent>
              <RadioGroupItem
                value={plan.id}
                id={`form-rhf-radiogroup-${plan.id}`}
                aria-invalid={fieldState.invalid}
              />
            </Field>
          </FieldLabel>
        ))}
      </RadioGroup>
      {fieldState.invalid && <FieldError errors={[fieldState.error]} />}
    </FieldSet>
  )}
/>
```

#### Switch Field

Use `field.value` (checked) and `field.onChange` (onCheckedChange):

```tsx title="form.tsx"
<Controller
  name="twoFactor"
  control={form.control}
  render={({ field, fieldState }) => (
    <Field orientation="horizontal" data-invalid={fieldState.invalid}>
      <FieldContent>
        <FieldLabel htmlFor="form-rhf-switch-twoFactor">
          Multi-factor authentication
        </FieldLabel>
        <FieldDescription>
          Enable multi-factor authentication to secure your account.
        </FieldDescription>
        {fieldState.invalid && <FieldError errors={[fieldState.error]} />}
      </FieldContent>
      <Switch
        id="form-rhf-switch-twoFactor"
        name={field.name}
        checked={field.value}
        onCheckedChange={field.onChange}
        aria-invalid={fieldState.invalid}
      />
    </Field>
  )}
/>
```

#### Array Fields (useFieldArray)

Use `useFieldArray` for dynamic array fields:

```tsx title="form.tsx"
import { useFieldArray, useForm } from "react-hook-form"

export function ExampleForm() {
  const form = useForm({
    // ... form config
  })

  const { fields, append, remove } = useFieldArray({
    control: form.control,
    name: "emails",
  })
}
```

Array field structure with FieldSet:

```tsx title="form.tsx"
<FieldSet className="gap-4">
  <FieldLegend variant="label">Email Addresses</FieldLegend>
  <FieldDescription>
    Add up to 5 email addresses where we can contact you.
  </FieldDescription>
  <FieldGroup className="gap-4">{/* Array items go here */}</FieldGroup>
</FieldSet>
```

Map over fields using Controller (use `field.id` as the key):

```tsx title="form.tsx"
{fields.map((field, index) => (
  <Controller
    key={field.id}
    name={`emails.${index}.address`}
    control={form.control}
    render={({ field: controllerField, fieldState }) => (
      <Field orientation="horizontal" data-invalid={fieldState.invalid}>
        <FieldContent>
          <InputGroup>
            <InputGroupInput
              {...controllerField}
              id={`form-rhf-array-email-${index}`}
              aria-invalid={fieldState.invalid}
              placeholder="name@example.com"
              type="email"
              autoComplete="email"
            />
            {/* Remove button */}
          </InputGroup>
          {fieldState.invalid && <FieldError errors={[fieldState.error]} />}
        </FieldContent>
      </Field>
    )}
  />
))}
```

Adding items:

```tsx title="form.tsx"
<Button
  type="button"
  variant="outline"
  size="sm"
  onClick={() => append({ address: "" })}
  disabled={fields.length >= 5}
>
  Add Email Address
</Button>
```

Removing items:

```tsx title="form.tsx"
{fields.length > 1 && (
  <InputGroupAddon align="inline-end">
    <InputGroupButton
      type="button"
      variant="ghost"
      size="icon-xs"
      onClick={() => remove(index)}
      aria-label={`Remove email ${index + 1}`}
    >
      <XIcon />
    </InputGroupButton>
  </InputGroupAddon>
)}
```

Array validation with Zod:

```tsx title="form.tsx"
const formSchema = z.object({
  emails: z
    .array(
      z.object({
        address: z.string().email("Enter a valid email address."),
      })
    )
    .min(1, "Add at least one email address.")
    .max(5, "You can add up to 5 email addresses."),
})
```

#### Resetting the Form

```tsx
<Button type="button" variant="outline" onClick={() => form.reset()}>
  Reset
</Button>
```

### TanStack Form

Install dependencies:

```bash
npm install @tanstack/react-form zod
```

#### Create a Schema

```tsx title="form.tsx"
import * as z from "zod"

const formSchema = z.object({
  title: z
    .string()
    .min(5, "Bug title must be at least 5 characters.")
    .max(32, "Bug title must be at most 32 characters."),
  description: z
    .string()
    .min(20, "Description must be at least 20 characters.")
    .max(100, "Description must be at most 100 characters."),
})
```

#### Setup the Form

Use `useForm` from TanStack Form with Zod validation via `validators`:

```tsx title="form.tsx"
import { useForm } from "@tanstack/react-form"
import { toast } from "sonner"
import * as z from "zod"

const formSchema = z.object({
  // ...
})

export function BugReportForm() {
  const form = useForm({
    defaultValues: {
      title: "",
      description: "",
    },
    validators: {
      onSubmit: formSchema,
    },
    onSubmit: async ({ value }) => {
      toast.success("Form submitted successfully")
    },
  })

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault()
        form.handleSubmit()
      }}
    >
      {/* ... */}
    </form>
  )
}
```

#### form.Field + Field Pattern

Use `form.Field` with the `children` render prop:

```tsx title="form.tsx"
<form.Field
  name="title"
  children={(field) => {
    const isInvalid =
      field.state.meta.isTouched && !field.state.meta.isValid
    return (
      <Field data-invalid={isInvalid}>
        <FieldLabel htmlFor={field.name}>Bug Title</FieldLabel>
        <Input
          id={field.name}
          name={field.name}
          value={field.state.value}
          onBlur={field.handleBlur}
          onChange={(e) => field.handleChange(e.target.value)}
          aria-invalid={isInvalid}
          placeholder="Login button not working on mobile"
          autoComplete="off"
        />
        <FieldDescription>
          Provide a concise title for your bug report.
        </FieldDescription>
        {isInvalid && <FieldError errors={field.state.meta.errors} />}
      </Field>
    )
  }}
/>
```

#### Displaying Errors

```tsx title="form.tsx"
<form.Field
  name="email"
  children={(field) => {
    const isInvalid = field.state.meta.isTouched && !field.state.meta.isValid

    return (
      <Field data-invalid={isInvalid}>
        <FieldLabel htmlFor={field.name}>Email</FieldLabel>
        <Input
          id={field.name}
          name={field.name}
          value={field.state.value}
          onBlur={field.handleBlur}
          onChange={(e) => field.handleChange(e.target.value)}
          type="email"
          aria-invalid={isInvalid}
        />
        {isInvalid && <FieldError errors={field.state.meta.errors} />}
      </Field>
    )
  }}
/>
```

#### Validation Modes

TanStack Form supports multiple validators via the `validators` option:

```tsx title="form.tsx"
const form = useForm({
  defaultValues: {
    title: "",
    description: "",
  },
  validators: {
    onSubmit: formSchema,
    onChange: formSchema,
    onBlur: formSchema,
  },
})
```

| Mode         | Description                          |
| ------------ | ------------------------------------ |
| `"onChange"` | Validation triggers on every change. |
| `"onBlur"`   | Validation triggers on blur.         |
| `"onSubmit"` | Validation triggers on submit.       |

#### Select Field

Use `field.state.value` and `field.handleChange` on Select:

```tsx title="form.tsx"
<form.Field
  name="language"
  children={(field) => {
    const isInvalid = field.state.meta.isTouched && !field.state.meta.isValid
    return (
      <Field orientation="responsive" data-invalid={isInvalid}>
        <FieldContent>
          <FieldLabel htmlFor="form-tanstack-select-language">
            Spoken Language
          </FieldLabel>
          <FieldDescription>
            For best results, select the language you speak.
          </FieldDescription>
          {isInvalid && <FieldError errors={field.state.meta.errors} />}
        </FieldContent>
        <Select
          name={field.name}
          value={field.state.value}
          onValueChange={field.handleChange}
        >
          <SelectTrigger
            id="form-tanstack-select-language"
            aria-invalid={isInvalid}
            className="min-w-[120px]"
          >
            <SelectValue placeholder="Select" />
          </SelectTrigger>
          <SelectContent position="item-aligned">
            <SelectItem value="auto">Auto</SelectItem>
            <SelectItem value="en">English</SelectItem>
          </SelectContent>
        </Select>
      </Field>
    )
  }}
/>
```

#### Checkbox Array

Use `mode="array"` and TanStack Form's array helpers (`pushValue`, `removeValue`):

```tsx title="form.tsx"
<form.Field
  name="tasks"
  mode="array"
  children={(field) => {
    const isInvalid = field.state.meta.isTouched && !field.state.meta.isValid
    return (
      <FieldSet>
        <FieldLegend variant="label">Tasks</FieldLegend>
        <FieldDescription>
          Get notified when tasks you've created have updates.
        </FieldDescription>
        <FieldGroup data-slot="checkbox-group">
          {tasks.map((task) => (
            <Field
              key={task.id}
              orientation="horizontal"
              data-invalid={isInvalid}
            >
              <Checkbox
                id={`form-tanstack-checkbox-${task.id}`}
                name={field.name}
                aria-invalid={isInvalid}
                checked={field.state.value.includes(task.id)}
                onCheckedChange={(checked) => {
                  if (checked) {
                    field.pushValue(task.id)
                  } else {
                    const index = field.state.value.indexOf(task.id)
                    if (index > -1) {
                      field.removeValue(index)
                    }
                  }
                }}
              />
              <FieldLabel
                htmlFor={`form-tanstack-checkbox-${task.id}`}
                className="font-normal"
              >
                {task.label}
              </FieldLabel>
            </Field>
          ))}
        </FieldGroup>
        {isInvalid && <FieldError errors={field.state.meta.errors} />}
      </FieldSet>
    )
  }}
/>
```

#### Switch Field

```tsx title="form.tsx"
<form.Field
  name="twoFactor"
  children={(field) => {
    const isInvalid = field.state.meta.isTouched && !field.state.meta.isValid
    return (
      <Field orientation="horizontal" data-invalid={isInvalid}>
        <FieldContent>
          <FieldLabel htmlFor="form-tanstack-switch-twoFactor">
            Multi-factor authentication
          </FieldLabel>
          <FieldDescription>
            Enable multi-factor authentication to secure your account.
          </FieldDescription>
          {isInvalid && <FieldError errors={field.state.meta.errors} />}
        </FieldContent>
        <Switch
          id="form-tanstack-switch-twoFactor"
          name={field.name}
          checked={field.state.value}
          onCheckedChange={field.handleChange}
          aria-invalid={isInvalid}
        />
      </Field>
    )
  }}
/>
```

#### Array Fields (mode="array")

Use `mode="array"` on the parent field:

```tsx title="form.tsx"
<form.Field
  name="emails"
  mode="array"
  children={(field) => {
    return (
      <FieldSet>
        <FieldLegend variant="label">Email Addresses</FieldLegend>
        <FieldDescription>
          Add up to 5 email addresses where we can contact you.
        </FieldDescription>
        <FieldGroup>
          {field.state.value.map((_, index) => (
            // Nested field for each array item
          ))}
        </FieldGroup>
      </FieldSet>
    )
  }}
/>
```

Access nested fields using bracket notation:

```tsx title="form.tsx"
<form.Field
  name={`emails[${index}].address`}
  children={(subField) => {
    const isSubFieldInvalid =
      subField.state.meta.isTouched && !subField.state.meta.isValid
    return (
      <Field orientation="horizontal" data-invalid={isSubFieldInvalid}>
        <FieldContent>
          <InputGroup>
            <InputGroupInput
              id={`form-tanstack-array-email-${index}`}
              name={subField.name}
              value={subField.state.value}
              onBlur={subField.handleBlur}
              onChange={(e) => subField.handleChange(e.target.value)}
              aria-invalid={isSubFieldInvalid}
              placeholder="name@example.com"
              type="email"
            />
            {field.state.value.length > 1 && (
              <InputGroupAddon align="inline-end">
                <InputGroupButton
                  type="button"
                  variant="ghost"
                  size="icon-xs"
                  onClick={() => field.removeValue(index)}
                  aria-label={`Remove email ${index + 1}`}
                >
                  <XIcon />
                </InputGroupButton>
              </InputGroupAddon>
            )}
          </InputGroup>
          {isSubFieldInvalid && (
            <FieldError errors={subField.state.meta.errors} />
          )}
        </FieldContent>
      </Field>
    )
  }}
/>
```

Adding/removing items:

```tsx title="form.tsx"
<Button
  type="button"
  variant="outline"
  size="sm"
  onClick={() => field.pushValue({ address: "" })}
  disabled={field.state.value.length >= 5}
>
  Add Email Address
</Button>
```

#### Resetting the Form

```tsx
<Button type="button" variant="outline" onClick={() => form.reset()}>
  Reset
</Button>
```

### Next.js Server Actions

Build forms using `useActionState` and Server Actions for server-side validation.

#### Create a Form Schema and State Type

Define schema and form state type in a shared file importable by both client and server:

```tsx title="schema.ts"
import { z } from "zod"

export const formSchema = z.object({
  title: z
    .string()
    .min(5, "Bug title must be at least 5 characters.")
    .max(32, "Bug title must be at most 32 characters."),
  description: z
    .string()
    .min(20, "Description must be at least 20 characters.")
    .max(100, "Description must be at most 100 characters."),
})

export type FormState = {
  values?: z.infer<typeof formSchema>
  errors: null | Partial<Record<keyof z.infer<typeof formSchema>, string[]>>
  success: boolean
}
```

#### Create the Server Action

Use `safeParse()` for validation. Return `values` on error to preserve user input. Omit `values` on success to reset the form:

```tsx title="actions.ts"
"use server"

export async function bugReportFormAction(
  _prevState: FormState,
  formData: FormData
) {
  const values = {
    title: formData.get("title") as string,
    description: formData.get("description") as string,
  }

  const result = formSchema.safeParse(values)

  if (!result.success) {
    return {
      values,
      success: false,
      errors: result.error.flatten().fieldErrors,
    }
  }

  return {
    errors: null,
    success: true,
  }
}
```

#### Build the Form with useActionState

```tsx title="form.tsx"
"use client"

import * as React from "react"
import Form from "next/form"

import { Spinner } from "@/components/ui/spinner"

import { bugReportFormAction } from "./actions"

export function BugReportForm() {
  const [formState, formAction, pending] = React.useActionState(
    bugReportFormAction,
    {
      errors: null,
      success: false,
    }
  )

  return (
    <Form action={formAction}>
      <FieldGroup>
        <Field data-invalid={!!formState.errors?.title?.length}>
          <FieldLabel htmlFor="title">Bug Title</FieldLabel>
          <Input
            id="title"
            name="title"
            defaultValue={formState.values?.title}
            disabled={pending}
            aria-invalid={!!formState.errors?.title?.length}
            placeholder="Login button not working on mobile"
            autoComplete="off"
          />
          <FieldDescription>
            Provide a concise title for your bug report.
          </FieldDescription>
          {formState.errors?.title && (
            <FieldError>{formState.errors.title[0]}</FieldError>
          )}
        </Field>
      </FieldGroup>
      <Button type="submit" disabled={pending}>
        {pending && <Spinner />} Submit
      </Button>
    </Form>
  )
}
```

#### Pending and Disabled States

Disable inputs and show spinner during submission:

```tsx
<Field data-disabled={pending}>
  <FieldLabel htmlFor="name">Name</FieldLabel>
  <Input id="name" name="name" disabled={pending} />
</Field>

<Button type="submit" disabled={pending}>
  {pending && <Spinner />} Submit
</Button>
```

#### Displaying Errors

```tsx
<Field data-invalid={!!formState.errors?.email?.length}>
  <FieldLabel htmlFor="email">Email</FieldLabel>
  <Input
    id="email"
    name="email"
    type="email"
    aria-invalid={!!formState.errors?.email?.length}
  />
  {formState.errors?.email && (
    <FieldError>{formState.errors.email[0]}</FieldError>
  )}
</Field>
```

#### Business Logic Validation

Add custom validation in the server action after schema validation:

```tsx title="actions.ts"
"use server"

export async function bugReportFormAction(
  _prevState: FormState,
  formData: FormData
) {
  const values = {
    title: formData.get("title") as string,
    description: formData.get("description") as string,
  }

  const result = formSchema.safeParse(values)

  if (!result.success) {
    return {
      values,
      success: false,
      errors: result.error.flatten().fieldErrors,
    }
  }

  // Check if email already exists in database.
  const existingUser = await db.user.findUnique({
    where: { email: result.data.email },
  })

  if (existingUser) {
    return {
      values,
      success: false,
      errors: {
        email: ["This email is already registered"],
      },
    }
  }

  return {
    errors: null,
    success: true,
  }
}
```

#### Form Reset Behavior

- **Reset on success**: Omit `values` from the return and React automatically resets the form.
- **Preserve on error**: Return `values` in the error case to maintain user input.

### Field Component

The Field component family provides composable, accessible form field layouts.

#### Installation

```bash
npx shadcn@latest add field
```

#### Import

```tsx
import {
  Field,
  FieldContent,
  FieldDescription,
  FieldError,
  FieldGroup,
  FieldLabel,
  FieldLegend,
  FieldSeparator,
  FieldSet,
  FieldTitle,
} from "@/components/ui/field"
```

#### Basic Anatomy

```tsx
<Field>
  <FieldLabel htmlFor="input-id">Label</FieldLabel>
  {/* Input, Select, Switch, etc. */}
  <FieldDescription>Optional helper text.</FieldDescription>
  <FieldError>Validation message.</FieldError>
</Field>
```

#### FieldSet and FieldGroup

Use `FieldSet` with `FieldLegend` for semantic grouping. Use `FieldGroup` to stack fields:

```tsx
<FieldSet>
  <FieldLegend>Profile</FieldLegend>
  <FieldDescription>This appears on invoices and emails.</FieldDescription>
  <FieldGroup>
    <Field>
      <FieldLabel htmlFor="name">Full name</FieldLabel>
      <Input id="name" autoComplete="off" placeholder="Evil Rabbit" />
      <FieldDescription>This appears on invoices and emails.</FieldDescription>
    </Field>
    <Field>
      <FieldLabel htmlFor="username">Username</FieldLabel>
      <Input id="username" autoComplete="off" aria-invalid />
      <FieldError>Choose another username.</FieldError>
    </Field>
    <Field orientation="horizontal">
      <Switch id="newsletter" />
      <FieldLabel htmlFor="newsletter">Subscribe to the newsletter</FieldLabel>
    </Field>
  </FieldGroup>
</FieldSet>
```

#### FieldLegend Variants

`FieldLegend` supports `"legend"` (default) and `"label"` variants:

```tsx
<FieldLegend variant="label">Notification Preferences</FieldLegend>
```

#### FieldContent

Groups label and description when the label sits beside the control:

```tsx
<Field>
  <Checkbox id="notifications" />
  <FieldContent>
    <FieldLabel htmlFor="notifications">Notifications</FieldLabel>
    <FieldDescription>Email, SMS, and push options.</FieldDescription>
  </FieldContent>
</Field>
```

#### FieldTitle

Renders a title with label styling inside FieldContent:

```tsx
<FieldContent>
  <FieldTitle>Enable Touch ID</FieldTitle>
  <FieldDescription>Unlock your device faster.</FieldDescription>
</FieldContent>
```

#### Field Orientations

| Orientation    | Description                                            |
| -------------- | ------------------------------------------------------ |
| `"vertical"`   | Default. Stacks label, control, and helper text.       |
| `"horizontal"` | Aligns label and control side-by-side.                 |
| `"responsive"` | Automatic column layouts inside container-aware parents. |

```tsx
<Field orientation="horizontal">
  <FieldLabel htmlFor="remember">Remember me</FieldLabel>
  <Switch id="remember" />
</Field>
```

For responsive layouts, apply `@container/field-group` on FieldGroup:

```tsx
<FieldGroup className="@container/field-group flex flex-col gap-6">
  <Field orientation="responsive">{/* ... */}</Field>
</FieldGroup>
```

#### FieldSeparator

Visual divider between sections inside a FieldGroup:

```tsx
<FieldSeparator>Or continue with</FieldSeparator>
```

#### FieldError

Accepts children or an `errors` array (compatible with React Hook Form, TanStack Form, and Standard Schema validators like Zod, Valibot, ArkType):

```tsx
<FieldError errors={errors.username} />
```

#### Validation Pattern

Add `data-invalid` to Field and `aria-invalid` to the input:

```tsx
<Field data-invalid>
  <FieldLabel htmlFor="email">Email</FieldLabel>
  <Input id="email" type="email" aria-invalid />
  <FieldError>Enter a valid email address.</FieldError>
</Field>
```

#### Accessibility Notes

- `FieldSet` and `FieldLegend` keep related controls grouped for keyboard and assistive tech users.
- `Field` outputs `role="group"` so nested controls inherit labeling.
- Apply `FieldSeparator` sparingly to ensure screen readers encounter clear section boundaries.
