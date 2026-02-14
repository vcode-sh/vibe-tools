# Utilities Reference

## CSPProvider

Applies a nonce to inline `<style>` and `<script>` tags rendered by Base UI components for Content Security Policy compliance.

```tsx
import { CSPProvider } from '@base-ui/react/csp-provider';
```

### Usage

```tsx
<CSPProvider nonce={nonce}>
  {/* Your app */}
</CSPProvider>
```

### Setup

1. Generate a random nonce per request on the server
2. Include it in your CSP header
3. Pass the same nonce to CSPProvider

```ts
const nonce = crypto.randomUUID();

const csp = [
  `default-src 'self'`,
  `script-src 'self' 'nonce-${nonce}'`,
  `style-src-elem 'self' 'nonce-${nonce}'`,
].join('; ');
```

### Disabling Inline Styles

Instead of using a nonce, disable inline `<style>` elements entirely and add the CSS manually:

```tsx
<CSPProvider disableStyleElements>{/* ... */}</CSPProvider>
```

You must add this CSS yourself when disabling style elements:

```css
.base-ui-disable-scrollbar {
  scrollbar-width: none;
}
.base-ui-disable-scrollbar::-webkit-scrollbar {
  display: none;
}
```

Affected components: `ScrollArea.Viewport`, `Select.Popup`/`Select.List` (when `alignItemWithTrigger` is enabled).

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `disableStyleElements` | `boolean` | `false` | Disable inline `<style>` elements |
| `nonce` | `string` | - | Nonce value for inline `<style>` and `<script>` tags |
| `children` | `ReactNode` | - | Child components |

### Note on Inline Style Attributes

CSPProvider covers inline `<style>` and `<script>` **tags**, but not inline `style=""` **attributes**. If your CSP blocks style attributes:
1. Relax CSP with `'unsafe-inline'` in `style-src-attr` directive
2. Render affected components only on the client
3. Manually unset inline styles: `<ScrollArea.Viewport style={{ overflow: undefined }}>`

---

## DirectionProvider

Enables right-to-left (RTL) behavior for Base UI components. Does not affect HTML/CSS directly - you must also set `dir="rtl"` on the HTML element.

```tsx
import { DirectionProvider } from '@base-ui/react/direction-provider';
```

### Usage

```tsx
<div dir="rtl">
  <DirectionProvider direction="rtl">
    <Slider.Root defaultValue={25}>
      <Slider.Control>
        <Slider.Track>
          <Slider.Indicator />
          <Slider.Thumb />
        </Slider.Track>
      </Slider.Control>
    </Slider.Root>
  </DirectionProvider>
</div>
```

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `direction` | `TextDirection` (`'ltr'` \| `'rtl'`) | `'ltr'` | Reading direction |
| `children` | `ReactNode` | - | Child components |

### useDirection Hook

Read the current text direction (useful for portaled components outside the app root):

```tsx
import { useDirection } from '@base-ui/react/direction-provider';

const { direction } = useDirection(); // 'ltr' | 'rtl'
```

---

## mergeProps

Merges multiple sets of React props with intelligent handling of event handlers, className, and style.

```tsx
import { mergeProps } from '@base-ui/react/merge-props';
```

### Merging Rules

| Prop Type | Behavior |
|-----------|----------|
| Most props | Rightmost wins (`Object.assign`) |
| `ref` | Rightmost only (not merged) |
| `className` | Concatenated right-to-left (rightmost first) |
| `style` | Merged, rightmost keys overwrite |
| Event handlers | Merged, executed right-to-left |

### Examples

```ts
mergeProps({ id: 'a', dir: 'ltr' }, { id: 'b' });
// → { id: 'b', dir: 'ltr' }

mergeProps({ className: 'a' }, { className: 'b' });
// → className: 'b a'

mergeProps({ onClick: a }, { onClick: b });
// → b runs before a
```

### Preventing Base UI Default Behavior

In a render function callback, use `mergeProps` + `preventBaseUIHandler()`:

```tsx
const getToggleProps = (props: React.ComponentProps<'button'>) =>
  mergeProps<'button'>(props, {
    onClick(event) {
      if (locked) {
        event.preventBaseUIHandler();
      }
    },
  });

<Toggle
  render={(props, state) => (
    <button type="button" {...getToggleProps(props)}>
      {state.pressed ? <FilledIcon /> : <OutlineIcon />}
    </button>
  )}
/>
```

### Function Arguments

Each argument can be an object or a function receiving merged props so far:

```tsx
const merged = mergeProps(
  { onClick: a },
  (props) => ({
    onClick(event) {
      props.onClick?.(event); // Manually chain previous handler
      // Your logic here
    },
  }),
);
```

### API

**mergeProps** - accepts up to 5 arguments:

| Parameter | Type | Description |
|-----------|------|-------------|
| `a` | `InputProps<ElementType>` | Props object or function |
| `b` | `InputProps<ElementType>` | Overwrites conflicting props from `a` |
| `c?` | `InputProps<ElementType>` | Optional |
| `d?` | `InputProps<ElementType>` | Optional |
| `e?` | `InputProps<ElementType>` | Optional |

**mergePropsN** - accepts an array (slightly less efficient, use for >5 sets):

```tsx
import { mergePropsN } from '@base-ui/react/merge-props';
mergePropsN([props1, props2, props3, props4, props5, props6]);
```

### Common Pattern: mergeProps in Render Callbacks

When using the function form of `render`, props are NOT merged automatically. Use `mergeProps` to add your own styles:

```tsx
import { mergeProps } from '@base-ui/react/merge-props';

<Menu.Item
  render={(props, state) => (
    <a
      href="/profile"
      {...mergeProps<'a'>(props, {
        className: styles.Link,
        onClick() { trackNavigation('/profile'); },
      })}
    >
      Profile
    </a>
  )}
/>
```

---

## useRender

Hook for enabling a `render` prop in custom components. Lets consumers override the default rendered element.

```tsx
import { useRender } from '@base-ui/react/use-render';
```

### Basic Usage

```tsx
interface TextProps extends useRender.ComponentProps<'p'> {}

function Text(props: TextProps) {
  const { render, ...otherProps } = props;

  const element = useRender({
    defaultTagName: 'p',
    render,
    props: mergeProps<'p'>({ className: styles.Text }, otherProps),
  });

  return element;
}

// Usage
<Text>Paragraph text</Text>
<Text render={<strong />}>Strong text</Text>
```

### With Component State

```tsx
interface CounterState { odd: boolean; }
interface CounterProps extends useRender.ComponentProps<'button', CounterState> {}

function Counter(props: CounterProps) {
  const { render, ...otherProps } = props;
  const [count, setCount] = React.useState(0);
  const state = React.useMemo(() => ({ odd: count % 2 === 1 }), [count]);

  const element = useRender({
    defaultTagName: 'button',
    render,
    state,
    props: mergeProps<'button'>({
      type: 'button',
      children: `Counter: ${count}`,
      onClick: () => setCount((prev) => prev + 1),
    }, otherProps),
  });

  return element;
}

// Usage with render callback
<Counter
  render={(props, state) => (
    <button {...props}>
      {props.children} {state.odd ? '👎' : '👍'}
    </button>
  )}
/>
```

### Merging Refs

**React 19:**
```tsx
function Text({ render, ...props }: TextProps) {
  const internalRef = React.useRef<HTMLElement | null>(null);
  return useRender({
    defaultTagName: 'p',
    ref: internalRef, // Merged with props.ref automatically
    props,
    render,
  });
}
```

**React 17/18 (with forwardRef):**
```tsx
const Text = React.forwardRef(function Text(
  { render, ...props }: TextProps,
  forwardedRef: React.ForwardedRef<HTMLElement>,
) {
  const internalRef = React.useRef<HTMLElement | null>(null);
  return useRender({
    defaultTagName: 'p',
    ref: [forwardedRef, internalRef], // Array of refs
    props,
    render,
  });
});
```

### Migrating from Radix UI

Radix `asChild` → Base UI `render`:

```tsx
// Radix UI
<Button asChild>
  <a href="/contact">Contact</a>
</Button>

// Base UI
<Button render={<a href="/contact" />}>Contact</Button>
```

### API

**Input Parameters:**

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `defaultTagName` | `keyof JSX.IntrinsicElements` | - | Default tag when `render` not provided |
| `render` | `RenderProp<State>` | - | Element or function to override default |
| `props` | `Record<string, unknown>` | - | Props to spread on rendered element |
| `ref` | `Ref \| Ref[]` | - | Refs to apply to rendered element |
| `state` | `State` | - | State passed to render callback |
| `stateAttributesMapping` | `StateAttributesMapping<State>` | - | Custom state → data-attribute mapping |

**Return:** `React.ReactElement`

**TypeScript Types:**

| Type | Description |
|------|-------------|
| `useRender.ComponentProps<'tag'>` | External props (includes `render` prop) |
| `useRender.ComponentProps<'tag', State>` | External props with custom state |
| `useRender.ElementProps<'tag'>` | Internal element props (no `render`) |
