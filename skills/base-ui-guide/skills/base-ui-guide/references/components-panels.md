# Panel and Container Components Reference

Complete API reference for Base UI panel and container components: Accordion, Collapsible, Tabs, ScrollArea.

---

## Accordion

A set of collapsible panels with headings that can expand and collapse individually or simultaneously.

**Import:** `import { Accordion } from '@base-ui/react/accordion';`

**Anatomy:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| `Accordion.Root` | `<div>` | Groups all parts of the accordion |
| `Accordion.Item` | `<div>` | Groups a header with its corresponding panel |
| `Accordion.Header` | `<h3>` | A heading that labels the corresponding panel |
| `Accordion.Trigger` | `<button>` | A button that opens and closes the corresponding panel |
| `Accordion.Panel` | `<div>` | A collapsible panel with the accordion item contents |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultValue` | `any[]` | - | Uncontrolled value of item(s) that should be initially expanded |
| `value` | `any[]` | - | Controlled value of item(s) that should be expanded |
| `onValueChange` | `(value: any[], eventDetails: ChangeEventDetails) => void` | - | Called when an item is expanded or collapsed |
| `multiple` | `boolean` | `false` | Whether multiple items can be open at the same time |
| `disabled` | `boolean` | `false` | Whether the component should ignore user interaction |
| `orientation` | `Orientation` | `'vertical'` | Visual orientation; controls arrow key direction for roving focus |
| `loopFocus` | `boolean` | `true` | Whether to loop keyboard focus back to first item at end of list |
| `hiddenUntilFound` | `boolean` | `false` | Uses `hidden="until-found"` for browser page search support; overrides `keepMounted` |
| `keepMounted` | `boolean` | `false` | Whether to keep panels in the DOM while closed; ignored when `hiddenUntilFound` is used |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class based on state |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element or compose with another component |

**Root Data Attributes:**

| Attribute | Description |
|:----------|:------------|
| `data-orientation` | Indicates the orientation of the accordion |
| `data-disabled` | Present when the accordion is disabled |

### Item Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `value` | `any` | - | Unique value identifying this item; auto-generated if omitted |
| `onOpenChange` | `(open: boolean, eventDetails: ChangeEventDetails) => void` | - | Called when the panel is opened or closed |
| `disabled` | `boolean` | `false` | Whether the component should ignore user interaction |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Item Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-open` | - | Present when the accordion item is open |
| `data-disabled` | - | Present when the accordion item is disabled |
| `data-index` | `number` | The index of the accordion item |

### Header Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Header Data Attributes:** Same as Item (`data-open`, `data-disabled`, `data-index`).

### Trigger Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `nativeButton` | `boolean` | `true` | Set to `false` if the rendered element via `render` is not a button |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Trigger Data Attributes:**

| Attribute | Description |
|:----------|:------------|
| `data-panel-open` | Present when the accordion panel is open |
| `data-disabled` | Present when the accordion item is disabled |

### Panel Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `hiddenUntilFound` | `boolean` | `false` | Uses `hidden="until-found"` for browser page search; overrides `keepMounted` |
| `keepMounted` | `boolean` | `false` | Whether to keep element in DOM while closed; ignored when `hiddenUntilFound` is used |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Panel Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-open` | - | Present when the panel is open |
| `data-orientation` | - | Indicates accordion orientation |
| `data-disabled` | - | Present when the item is disabled |
| `data-index` | `number` | The index of the accordion item |
| `data-starting-style` | - | Present when the panel is animating in |
| `data-ending-style` | - | Present when the panel is animating out |

**Panel CSS Variables:**

| Variable | Description |
|:---------|:------------|
| `--accordion-panel-height` | The accordion panel's height |
| `--accordion-panel-width` | The accordion panel's width |

### Example

```tsx
import { Accordion } from '@base-ui/react/accordion';

<Accordion.Root defaultValue={['item-1']}>
  <Accordion.Item value="item-1">
    <Accordion.Header>
      <Accordion.Trigger>Section 1</Accordion.Trigger>
    </Accordion.Header>
    <Accordion.Panel>
      <div>Content for section 1</div>
    </Accordion.Panel>
  </Accordion.Item>
  <Accordion.Item value="item-2">
    <Accordion.Header>
      <Accordion.Trigger>Section 2</Accordion.Trigger>
    </Accordion.Header>
    <Accordion.Panel>
      <div>Content for section 2</div>
    </Accordion.Panel>
  </Accordion.Item>
</Accordion.Root>
```

### Accessibility

- Uses WAI-ARIA Accordion pattern with proper `role`, `aria-expanded`, and `aria-controls` attributes.
- Supports keyboard navigation with arrow keys (direction based on `orientation`).
- Focus loops by default (`loopFocus`).
- `hiddenUntilFound` enables browser find-in-page to discover collapsed content.

### Styled Example (Tailwind)

```tsx
import { Accordion } from '@base-ui/react/accordion';

export default function ExampleAccordion() {
  return (
    <Accordion.Root className="flex w-96 max-w-[calc(100vw-8rem)] flex-col justify-center text-gray-900">
      <Accordion.Item className="border-b border-gray-200">
        <Accordion.Header>
          <Accordion.Trigger className="group flex w-full items-baseline justify-between gap-4 bg-gray-50 py-2 pr-1 pl-3 text-left font-medium hover:bg-gray-100 focus-visible:z-1 focus-visible:outline focus-visible:outline-2 focus-visible:outline-blue-800">
            What is Base UI?
            <PlusIcon className="mr-2 size-3 shrink-0 transition-all ease-out group-data-[panel-open]:scale-110 group-data-[panel-open]:rotate-45" />
          </Accordion.Trigger>
        </Accordion.Header>
        <Accordion.Panel className="h-[var(--accordion-panel-height)] overflow-hidden text-base text-gray-600 transition-[height] ease-out data-[ending-style]:h-0 data-[starting-style]:h-0">
          <div className="p-3">
            Base UI is a library of high-quality unstyled React components.
          </div>
        </Accordion.Panel>
      </Accordion.Item>

      <Accordion.Item className="border-b border-gray-200">
        <Accordion.Header>
          <Accordion.Trigger className="group flex w-full items-baseline justify-between gap-4 bg-gray-50 py-2 pr-1 pl-3 text-left font-medium hover:bg-gray-100 focus-visible:z-1 focus-visible:outline focus-visible:outline-2 focus-visible:outline-blue-800">
            How do I get started?
            <PlusIcon className="mr-2 size-3 shrink-0 transition-all ease-out group-data-[panel-open]:scale-110 group-data-[panel-open]:rotate-45" />
          </Accordion.Trigger>
        </Accordion.Header>
        <Accordion.Panel className="h-[var(--accordion-panel-height)] overflow-hidden text-base text-gray-600 transition-[height] ease-out data-[ending-style]:h-0 data-[starting-style]:h-0">
          <div className="p-3">
            Head to the "Quick start" guide in the docs.
          </div>
        </Accordion.Panel>
      </Accordion.Item>
    </Accordion.Root>
  );
}
```

Key Tailwind patterns:
- **Panel height animation**: `h-[var(--accordion-panel-height)]` + `transition-[height]` + `data-[starting-style]:h-0` / `data-[ending-style]:h-0`
- **Trigger icon rotation**: `group` on Trigger + `group-data-[panel-open]:rotate-45` on icon for animated open/close indicator
- **Content wrapper**: Inner `<div>` with padding inside Panel prevents content from being clipped during animation

---

## Collapsible

A single collapsible panel controlled by a button.

**Import:** `import { Collapsible } from '@base-ui/react/collapsible';`

**Anatomy:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| `Collapsible.Root` | `<div>` | Groups all parts of the collapsible |
| `Collapsible.Trigger` | `<button>` | A button that opens and closes the panel |
| `Collapsible.Panel` | `<div>` | A panel with the collapsible contents |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultOpen` | `boolean` | `false` | Whether the panel is initially open (uncontrolled) |
| `open` | `boolean` | - | Whether the panel is currently open (controlled) |
| `onOpenChange` | `(open: boolean, eventDetails: ChangeEventDetails) => void` | - | Called when the panel is opened or closed |
| `disabled` | `boolean` | `false` | Whether the component should ignore user interaction |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

### Trigger Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `nativeButton` | `boolean` | `true` | Set to `false` if the rendered element via `render` is not a button |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Trigger Data Attributes:**

| Attribute | Description |
|:----------|:------------|
| `data-panel-open` | Present when the collapsible panel is open |

### Panel Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `hiddenUntilFound` | `boolean` | `false` | Uses `hidden="until-found"` for browser page search; overrides `keepMounted` |
| `keepMounted` | `boolean` | `false` | Whether to keep element in DOM while hidden; ignored when `hiddenUntilFound` is used |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Panel Data Attributes:**

| Attribute | Description |
|:----------|:------------|
| `data-open` | Present when the panel is open |
| `data-closed` | Present when the panel is closed |
| `data-starting-style` | Present when the panel is animating in |
| `data-ending-style` | Present when the panel is animating out |

**Panel CSS Variables:**

| Variable | Description |
|:---------|:------------|
| `--collapsible-panel-height` | The collapsible panel's height |
| `--collapsible-panel-width` | The collapsible panel's width |

### Example

```tsx
import { Collapsible } from '@base-ui/react/collapsible';

<Collapsible.Root>
  <Collapsible.Trigger>Toggle details</Collapsible.Trigger>
  <Collapsible.Panel>
    <div>Hidden content revealed on toggle</div>
  </Collapsible.Panel>
</Collapsible.Root>
```

### Accessibility

- Trigger uses `aria-expanded` and `aria-controls` to associate with the panel.
- Keyboard activation with Enter/Space.
- `hiddenUntilFound` allows browser find-in-page support.

---

## Tabs

A component for toggling between related panels on the same page.

**Import:** `import { Tabs } from '@base-ui/react/tabs';`

**Anatomy:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| `Tabs.Root` | `<div>` | Groups the tabs and corresponding panels |
| `Tabs.List` | `<div>` | Groups the individual tab buttons |
| `Tabs.Tab` | `<button>` | An individual interactive tab button |
| `Tabs.Indicator` | `<span>` | A visual indicator matching the active tab position |
| `Tabs.Panel` | `<div>` | A panel displayed when the corresponding tab is active |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultValue` | `Tabs.Tab.Value` | `0` | Default active tab value (uncontrolled); `null` for no active tab |
| `value` | `Tabs.Tab.Value` | - | Currently active tab value (controlled); `null` for no active tab |
| `onValueChange` | `(value: Tabs.Tab.Value, eventDetails: ChangeEventDetails) => void` | - | Called when active tab changes |
| `orientation` | `'horizontal' \| 'vertical'` | `'horizontal'` | Layout flow direction |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Root Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Indicates tab orientation |
| `data-activation-direction` | `'left' \| 'right' \| 'up' \| 'down' \| 'none'` | Direction of activation relative to previous tab |

### List Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `activateOnFocus` | `boolean` | `false` | Whether to auto-activate tab on arrow key focus; otherwise requires Enter/Space |
| `loopFocus` | `boolean` | `true` | Whether to loop keyboard focus at the end of the list |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**List Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Indicates tab orientation |
| `data-activation-direction` | `'left' \| 'right' \| 'up' \| 'down' \| 'none'` | Direction of activation |

### Tab Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `value` | `Tabs.Tab.Value` | - | The value of the Tab |
| `disabled` | `boolean` | - | Whether the Tab is disabled |
| `nativeButton` | `boolean` | `true` | Set to `false` if the rendered element is not a button |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**SSR Note:** If the first Tab is disabled, it won't be initially selected during server-side rendering. Always set `defaultValue` or `value` on `<Tabs.Root>` to an enabled Tab's value for SSR compatibility.

**Tab Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Indicates tab orientation |
| `data-disabled` | - | Present when the tab is disabled |
| `data-activation-direction` | `'left' \| 'right' \| 'up' \| 'down' \| 'none'` | Direction of activation |
| `data-active` | - | Present when the tab is active |

### Indicator Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `renderBeforeHydration` | `boolean` | `false` | Whether to render before React hydrates (minimizes SSR flash) |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Indicator Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Indicates tab orientation |
| `data-activation-direction` | `'left' \| 'right' \| 'up' \| 'down' \| 'none'` | Direction of activation |

**Indicator CSS Variables:**

| Variable | Description |
|:---------|:------------|
| `--active-tab-bottom` | Distance from parent bottom edge to active tab |
| `--active-tab-height` | Height of the active tab |
| `--active-tab-left` | Distance from parent left edge to active tab |
| `--active-tab-right` | Distance from parent right edge to active tab |
| `--active-tab-top` | Distance from parent top edge to active tab |
| `--active-tab-width` | Width of the active tab |

### Panel Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `value` | `Tabs.Tab.Value` | - | The value matching the corresponding Tab |
| `keepMounted` | `boolean` | `false` | Whether to keep element in DOM while panel is hidden |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Panel Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Indicates tab orientation |
| `data-activation-direction` | `'left' \| 'right' \| 'up' \| 'down' \| 'none'` | Direction of activation |
| `data-hidden` | - | Present when the panel is hidden |
| `data-index` | - | Index of the tab panel |

### Example

```tsx
import { Tabs } from '@base-ui/react/tabs';

<Tabs.Root defaultValue="overview">
  <Tabs.List>
    <Tabs.Tab value="overview">Overview</Tabs.Tab>
    <Tabs.Tab value="settings">Settings</Tabs.Tab>
    <Tabs.Indicator />
  </Tabs.List>
  <Tabs.Panel value="overview">Overview content</Tabs.Panel>
  <Tabs.Panel value="settings">Settings content</Tabs.Panel>
</Tabs.Root>
```

### Accessibility

- Follows WAI-ARIA Tabs pattern with `role="tablist"`, `role="tab"`, and `role="tabpanel"`.
- Arrow keys navigate between tabs; direction depends on `orientation`.
- `activateOnFocus` controls whether focus automatically activates a tab or requires Enter/Space.
- If first Tab is disabled, the next enabled Tab is selected by default (note: SSR requires explicit `defaultValue`).

---

## Scroll Area

A native scroll container with custom scrollbars.

**Import:** `import { ScrollArea } from '@base-ui/react/scroll-area';`

**Anatomy:**

| Part | Renders | Description |
|:-----|:--------|:------------|
| `ScrollArea.Root` | `<div>` | Groups all parts of the scroll area |
| `ScrollArea.Viewport` | `<div>` | The actual scrollable container |
| `ScrollArea.Content` | `<div>` | A container for the content |
| `ScrollArea.Scrollbar` | `<div>` | A vertical or horizontal scrollbar |
| `ScrollArea.Thumb` | `<div>` | The draggable part indicating current scroll position |
| `ScrollArea.Corner` | `<div>` | Area at the intersection of horizontal and vertical scrollbars |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `overflowEdgeThreshold` | `number \| { xStart, xEnd, yStart, yEnd }` | `0` | Pixel threshold before overflow edge attributes are applied |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Root Data Attributes:**

| Attribute | Description |
|:----------|:------------|
| `data-has-overflow-x` | Content is wider than the viewport |
| `data-has-overflow-y` | Content is taller than the viewport |
| `data-overflow-x-end` | Overflow on the horizontal end side |
| `data-overflow-x-start` | Overflow on the horizontal start side |
| `data-overflow-y-end` | Overflow on the vertical end side |
| `data-overflow-y-start` | Overflow on the vertical start side |

**Root CSS Variables:**

| Variable | Description |
|:---------|:------------|
| `--scroll-area-corner-height` | The scroll area corner height |
| `--scroll-area-corner-width` | The scroll area corner width |

### Viewport Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Viewport Data Attributes:** Same as Root (`data-has-overflow-x`, `data-has-overflow-y`, `data-overflow-x-end`, `data-overflow-x-start`, `data-overflow-y-end`, `data-overflow-y-start`).

**Viewport CSS Variables:**

| Variable | Description |
|:---------|:------------|
| `--scroll-area-overflow-x-end` | Distance from the horizontal end edge (px) |
| `--scroll-area-overflow-x-start` | Distance from the horizontal start edge (px) |
| `--scroll-area-overflow-y-end` | Distance from the vertical end edge (px) |
| `--scroll-area-overflow-y-start` | Distance from the vertical start edge (px) |

**Performance Note:** These CSS variables do not inherit by default. Set each variable to `inherit` on child/pseudo-elements that need them:

```css
.Viewport::before {
  --scroll-area-overflow-y-start: inherit;
}
```

### Content Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

### Scrollbar Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `orientation` | `'horizontal' \| 'vertical'` | `'vertical'` | Whether the scrollbar controls vertical or horizontal scroll |
| `keepMounted` | `boolean` | `false` | Keep in DOM when viewport is not scrollable |
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Scrollbar Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Orientation of the scrollbar |
| `data-has-overflow-x` | - | Content is wider than the viewport |
| `data-has-overflow-y` | - | Content is taller than the viewport |
| `data-hovering` | - | Pointer is over the scroll area |
| `data-overflow-x-end` | - | Overflow on the horizontal end side |
| `data-overflow-x-start` | - | Overflow on the horizontal start side |
| `data-overflow-y-end` | - | Overflow on the vertical end side |
| `data-overflow-y-start` | - | Overflow on the vertical start side |
| `data-scrolling` | - | User is scrolling inside the scroll area |

**Scrollbar CSS Variables:**

| Variable | Description |
|:---------|:------------|
| `--scroll-area-thumb-height` | The scroll area thumb's height |
| `--scroll-area-thumb-width` | The scroll area thumb's width |

### Thumb Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

**Thumb Data Attributes:**

| Attribute | Type | Description |
|:----------|:-----|:------------|
| `data-orientation` | `'horizontal' \| 'vertical'` | Orientation of the scrollbar |

### Corner Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `string \| (state: State) => string` | - | CSS class or function returning a class |
| `style` | `CSSProperties \| (state: State) => CSSProperties` | - | Inline styles or function returning styles |
| `render` | `ReactElement \| (props, state) => ReactElement` | - | Replace the HTML element |

### Example

```tsx
import { ScrollArea } from '@base-ui/react/scroll-area';

<ScrollArea.Root style={{ height: '200px', width: '400px' }}>
  <ScrollArea.Viewport>
    <ScrollArea.Content>
      <p>Scrollable content goes here...</p>
    </ScrollArea.Content>
  </ScrollArea.Viewport>
  <ScrollArea.Scrollbar orientation="vertical">
    <ScrollArea.Thumb />
  </ScrollArea.Scrollbar>
  <ScrollArea.Scrollbar orientation="horizontal">
    <ScrollArea.Thumb />
  </ScrollArea.Scrollbar>
  <ScrollArea.Corner />
</ScrollArea.Root>
```

### Accessibility

- Uses native scroll behavior under the hood; custom scrollbars are purely visual.
- The Viewport is focusable and keyboard-scrollable.
- Scrollbars can be shown/hidden based on `data-hovering` and `data-scrolling` attributes.

