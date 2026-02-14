# Dialog and Popup Components Reference

Complete API reference for Base UI dialog, popup, and floating content components: Dialog, AlertDialog, Popover, Tooltip, PreviewCard.

---

## Dialog

A popup that opens on top of the entire page.

```ts
import { Dialog } from '@base-ui/react/dialog';
```

### Parts

| Part | Renders | Description |
|:-----|:--------|:------------|
| `Dialog.Root` | (none) | Groups all parts. Does not render its own HTML element. |
| `Dialog.Trigger` | `<button>` | A button that opens the dialog. |
| `Dialog.Portal` | `<div>` | Moves the popup to a different part of the DOM (appended to `<body>` by default). |
| `Dialog.Backdrop` | `<div>` | An overlay displayed beneath the popup. |
| `Dialog.Viewport` | `<div>` | A positioning container that can be made scrollable. |
| `Dialog.Popup` | `<div>` | A container for the dialog contents. |
| `Dialog.Title` | `<h2>` | A heading that labels the dialog. |
| `Dialog.Description` | `<p>` | A paragraph with additional information. |
| `Dialog.Close` | `<button>` | A button that closes the dialog. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultOpen` | `boolean` | `false` | Whether the dialog is initially open. |
| `open` | `boolean` | - | Controlled open state. |
| `onOpenChange` | `(open: boolean, eventDetails: ChangeEventDetails) => void` | - | Called when opened or closed. |
| `onOpenChangeComplete` | `(open: boolean) => void` | - | Called after animations complete. |
| `modal` | `boolean \| 'trap-focus'` | `true` | `true`: focus trapped, scroll locked, outside interactions disabled. `false`: normal. `'trap-focus'`: focus trapped only. |
| `disablePointerDismissal` | `boolean` | `false` | Whether to prevent closing on outside clicks. |
| `handle` | `Dialog.Handle<Payload>` | - | Associates the dialog with external triggers via `Dialog.createHandle()`. |
| `actionsRef` | `RefObject<Dialog.Root.Actions \| null>` | - | Ref to imperative `unmount` and `close` actions. |
| `triggerId` | `string \| null` | - | Active trigger ID for controlled mode. |
| `defaultTriggerId` | `string \| null` | - | Initial trigger ID for uncontrolled mode. |
| `children` | `ReactNode \| PayloadChildRenderFunction<Payload>` | - | Content or render function receiving trigger payload. |

### Trigger Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `handle` | `Dialog.Handle<Payload>` | - | Associates with a dialog via `Dialog.createHandle()`. |
| `payload` | `Payload` | - | Data passed to the dialog when opened. |
| `id` | `string` | - | Trigger ID for controlled multi-trigger use. |
| `nativeButton` | `boolean` | `true` | Set `false` when render prop replaces with non-button. |

### Portal Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `container` | `HTMLElement \| ShadowRoot \| RefObject \| null` | - | Custom portal target. |
| `keepMounted` | `boolean` | `false` | Keep in DOM while hidden. |

### Backdrop Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `forceRender` | `boolean` | `false` | Force render even when nested (nested backdrops are hidden by default). |

### Popup Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `initialFocus` | `boolean \| RefObject \| (openType => HTMLElement \| boolean \| void)` | - | Element to focus on open. `false` skips. |
| `finalFocus` | `boolean \| RefObject \| (closeType => HTMLElement \| boolean \| void)` | - | Element to focus on close. |

### Close Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `nativeButton` | `boolean` | `true` | Set `false` when render prop replaces with non-button. |

### Data Attributes

| Part | Attribute | Description |
|:-----|:----------|:------------|
| Trigger | `data-popup-open` | Present when dialog is open. |
| Trigger | `data-disabled` | Present when disabled. |
| Backdrop, Viewport, Popup | `data-open` | Open state. |
| Backdrop, Viewport, Popup | `data-closed` | Closed state. |
| Backdrop, Viewport, Popup | `data-starting-style` | Animating in. |
| Backdrop, Viewport, Popup | `data-ending-style` | Animating out. |
| Viewport, Popup | `data-nested` | Nested within another dialog. |
| Viewport, Popup | `data-nested-dialog-open` | Has nested dialogs open within it. |
| Close | `data-disabled` | Present when disabled. |

### CSS Variables

| Variable | Part | Description |
|:---------|:-----|:------------|
| `--nested-dialogs` | Popup | Number of nested dialogs (use for stacking transforms). |

### Example

```tsx
import { Dialog } from '@base-ui/react/dialog';

<Dialog.Root>
  <Dialog.Trigger>Open</Dialog.Trigger>
  <Dialog.Portal>
    <Dialog.Backdrop />
    <Dialog.Popup>
      <Dialog.Title>Title</Dialog.Title>
      <Dialog.Description>Description text.</Dialog.Description>
      <Dialog.Close>Close</Dialog.Close>
    </Dialog.Popup>
  </Dialog.Portal>
</Dialog.Root>
```

### Accessibility

- Renders with `role="dialog"` and `aria-modal="true"` by default.
- Title and Description are automatically associated via `aria-labelledby` and `aria-describedby`.
- Focus is trapped inside the modal by default; pressing Escape closes it.
- Supports nested dialogs; child backdrop is suppressed automatically.

### Detached Triggers (createHandle)

Use `Dialog.createHandle()` to link triggers outside `<Dialog.Root>`:

```tsx
const demoDialog = Dialog.createHandle();

<Dialog.Trigger handle={demoDialog}>Open</Dialog.Trigger>

<Dialog.Root handle={demoDialog}>
  <Dialog.Portal>
    <Dialog.Popup>...</Dialog.Popup>
  </Dialog.Portal>
</Dialog.Root>
```

**With typed payload** for different content per trigger:

```tsx
const demoDialog = Dialog.createHandle<{ text: string }>();

<Dialog.Trigger handle={demoDialog} payload={{ text: 'From trigger 1' }}>
  Trigger 1
</Dialog.Trigger>

<Dialog.Root handle={demoDialog}>
  {({ payload }) => (
    <Dialog.Portal>
      <Dialog.Popup>
        <Dialog.Title>{payload?.text}</Dialog.Title>
      </Dialog.Popup>
    </Dialog.Portal>
  )}
</Dialog.Root>
```

**Multiple triggers**: Use same handle for several detached triggers, or place multiple `<Dialog.Trigger>` inside a single `<Dialog.Root>`.

### Styled Example (Tailwind)

```tsx
import { Dialog } from '@base-ui/react/dialog';

export default function ExampleDialog() {
  return (
    <Dialog.Root>
      <Dialog.Trigger className="flex h-10 items-center justify-center rounded-md border border-gray-200 bg-gray-50 px-3.5 text-base font-medium text-gray-900 select-none hover:bg-gray-100 focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-1 focus-visible:outline-blue-800 active:bg-gray-100">
        View notifications
      </Dialog.Trigger>
      <Dialog.Portal>
        <Dialog.Backdrop className="fixed inset-0 min-h-dvh bg-black opacity-20 transition-all duration-150 data-[ending-style]:opacity-0 data-[starting-style]:opacity-0 dark:opacity-70" />
        <Dialog.Popup className="fixed top-1/2 left-1/2 -mt-8 w-96 max-w-[calc(100vw-3rem)] -translate-x-1/2 -translate-y-1/2 rounded-lg bg-gray-50 p-6 text-gray-900 outline outline-1 outline-gray-200 transition-all duration-150 data-[ending-style]:scale-90 data-[ending-style]:opacity-0 data-[starting-style]:scale-90 data-[starting-style]:opacity-0 dark:outline-gray-300">
          <Dialog.Title className="-mt-1.5 mb-1 text-lg font-medium">
            Notifications
          </Dialog.Title>
          <Dialog.Description className="mb-6 text-base text-gray-600">
            You are all caught up. Good job!
          </Dialog.Description>
          <div className="flex justify-end gap-4">
            <Dialog.Close className="flex h-10 items-center justify-center rounded-md border border-gray-200 bg-gray-50 px-3.5 text-base font-medium text-gray-900 select-none hover:bg-gray-100 focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-1 focus-visible:outline-blue-800 active:bg-gray-100">
              Close
            </Dialog.Close>
          </div>
        </Dialog.Popup>
      </Dialog.Portal>
    </Dialog.Root>
  );
}
```

Key Tailwind patterns:
- **Backdrop**: `fixed inset-0` + `transition-all` + `data-[starting-style]:opacity-0` / `data-[ending-style]:opacity-0`
- **Popup**: `fixed top-1/2 left-1/2 -translate-x/y-1/2` for centering + `data-[starting-style]:scale-90` / `data-[ending-style]:scale-90` for animation
- **Buttons**: `focus-visible:outline focus-visible:outline-2 focus-visible:-outline-offset-1` for keyboard focus ring

---

## Alert Dialog

A dialog that requires a user response to proceed. Unlike Dialog, it cannot be dismissed by clicking outside or pressing Escape (only explicit close actions work).

```ts
import { AlertDialog } from '@base-ui/react/alert-dialog';
```

### Parts

| Part | Renders | Description |
|:-----|:--------|:------------|
| `AlertDialog.Root` | (none) | Groups all parts. |
| `AlertDialog.Trigger` | `<button>` | Opens the alert dialog. |
| `AlertDialog.Portal` | `<div>` | Moves popup to `<body>`. |
| `AlertDialog.Backdrop` | `<div>` | Overlay beneath the popup. |
| `AlertDialog.Viewport` | `<div>` | Scrollable positioning container. |
| `AlertDialog.Popup` | `<div>` | Container for contents. |
| `AlertDialog.Title` | `<h2>` | Heading label. |
| `AlertDialog.Description` | `<p>` | Additional information. |
| `AlertDialog.Close` | `<button>` | Closes the alert dialog. |

### Root Props

Same as Dialog.Root with these key differences:

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultOpen` | `boolean` | `false` | Initially open. |
| `open` | `boolean` | - | Controlled state. |
| `onOpenChange` | `(open, eventDetails) => void` | - | State change callback. |
| `onOpenChangeComplete` | `(open: boolean) => void` | - | After animations. |
| `handle` | `AlertDialog.Handle<Payload>` | - | For external triggers via `AlertDialog.createHandle()`. |
| `actionsRef` | `RefObject<AlertDialog.Root.Actions \| null>` | - | Imperative `unmount`/`close`. |
| `triggerId` | `string \| null` | - | Active trigger for controlled mode. |
| `children` | `ReactNode \| PayloadChildRenderFunction<Payload>` | - | Content or render function. |

Alert dialog does NOT have `modal` or `disablePointerDismissal` props -- it is always modal and cannot be dismissed by outside pointer interactions.

### Trigger Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `handle` | `DialogHandle<Payload>` | - | Associates with alert dialog. |
| `payload` | `Payload` | - | Data passed when opened. |
| `id` | `string` | - | Trigger ID for controlled mode. |
| `nativeButton` | `boolean` | `true` | Set `false` for non-button render. |

### Data Attributes and CSS Variables

Identical to Dialog (see above).

### Example

```tsx
import { AlertDialog } from '@base-ui/react/alert-dialog';

<AlertDialog.Root>
  <AlertDialog.Trigger>Delete item</AlertDialog.Trigger>
  <AlertDialog.Portal>
    <AlertDialog.Backdrop />
    <AlertDialog.Popup>
      <AlertDialog.Title>Are you sure?</AlertDialog.Title>
      <AlertDialog.Description>This action cannot be undone.</AlertDialog.Description>
      <AlertDialog.Close>Cancel</AlertDialog.Close>
      <AlertDialog.Close>Confirm</AlertDialog.Close>
    </AlertDialog.Popup>
  </AlertDialog.Portal>
</AlertDialog.Root>
```

### Accessibility

- Renders with `role="alertdialog"` and `aria-modal="true"`.
- Cannot be dismissed by clicking outside or pressing Escape -- user must interact with an explicit action.
- Focus is trapped; screen readers announce it as an alert dialog requiring action.

---

## Popover

An accessible popup anchored to a trigger button, positioned using the anchor positioning engine.

```ts
import { Popover } from '@base-ui/react/popover';
```

### Parts

| Part | Renders | Description |
|:-----|:--------|:------------|
| `Popover.Root` | (none) | Groups all parts. |
| `Popover.Trigger` | `<button>` | Opens the popover. |
| `Popover.Portal` | `<div>` | Moves popup to `<body>`. |
| `Popover.Backdrop` | `<div>` | Optional overlay. |
| `Popover.Positioner` | `<div>` | Positions popup against trigger. |
| `Popover.Popup` | `<div>` | Container for contents. |
| `Popover.Arrow` | `<div>` | Arrow pointing toward anchor. |
| `Popover.Viewport` | `<div>` | Viewport for animated content transitions. |
| `Popover.Title` | `<h2>` | Heading label. |
| `Popover.Description` | `<p>` | Additional information. |
| `Popover.Close` | `<button>` | Closes the popover. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultOpen` | `boolean` | `false` | Initially open. |
| `open` | `boolean` | - | Controlled state. |
| `onOpenChange` | `(open, eventDetails) => void` | - | State change callback. |
| `onOpenChangeComplete` | `(open: boolean) => void` | - | After animations. |
| `modal` | `boolean \| 'trap-focus'` | `false` | Modal behavior (default non-modal). |
| `handle` | `Popover.Handle<Payload>` | - | For external triggers. |
| `actionsRef` | `RefObject<Popover.Root.Actions \| null>` | - | Imperative actions. |
| `triggerId` | `string \| null` | - | Active trigger for controlled mode. |
| `children` | `ReactNode \| PayloadChildRenderFunction<Payload>` | - | Content. |

### Trigger Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `handle` | `Popover.Handle<Payload>` | - | Associates with popover. |
| `payload` | `Payload` | - | Data passed when opened. |
| `openOnHover` | `boolean` | `false` | Open on hover instead of click. |
| `delay` | `number` | `300` | Hover open delay (ms). Requires `openOnHover`. |
| `closeDelay` | `number` | `0` | Hover close delay (ms). Requires `openOnHover`. |
| `id` | `string` | - | Trigger ID for controlled mode. |
| `nativeButton` | `boolean` | `true` | Set `false` for non-button render. |

### Positioner Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `side` | `Side` | `'bottom'` | Which side of anchor to align against. |
| `sideOffset` | `number \| OffsetFunction` | `0` | Distance from anchor (px). |
| `align` | `Align` | `'center'` | Alignment relative to side. |
| `alignOffset` | `number \| OffsetFunction` | `0` | Alignment axis offset (px). |
| `arrowPadding` | `number` | `5` | Min distance between arrow and popup edges. |
| `anchor` | `Element \| RefObject \| VirtualElement \| (() => Element) \| null` | - | Custom anchor element. |
| `collisionAvoidance` | `CollisionAvoidance` | - | Collision handling strategy. |
| `collisionBoundary` | `Boundary` | `'clipping-ancestors'` | Collision boundary element. |
| `collisionPadding` | `Padding` | `5` | Space from collision boundary edge. |
| `sticky` | `boolean` | `false` | Keep in viewport after anchor scrolls out. |
| `positionMethod` | `'fixed' \| 'absolute'` | `'absolute'` | CSS position property. |
| `disableAnchorTracking` | `boolean` | `false` | Disable anchor layout shift tracking. |

### Popup Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `initialFocus` | `boolean \| RefObject \| function` | - | Focus target on open. |
| `finalFocus` | `boolean \| RefObject \| function` | - | Focus target on close. |

### Data Attributes

| Part | Attribute | Description |
|:-----|:----------|:------------|
| Trigger | `data-popup-open` | Popover is open. |
| Trigger | `data-pressed` | Trigger is pressed. |
| Positioner, Popup, Arrow | `data-open` / `data-closed` | Open state. |
| Positioner, Popup, Arrow | `data-side` | `'top' \| 'bottom' \| 'left' \| 'right' \| 'inline-end' \| 'inline-start'` |
| Positioner, Popup, Arrow | `data-align` | `'start' \| 'center' \| 'end'` |
| Positioner | `data-anchor-hidden` | Anchor is hidden. |
| Popup | `data-instant` | `'click' \| 'dismiss'` -- skip animations. |
| Popup | `data-starting-style` / `data-ending-style` | Animation states. |
| Arrow | `data-uncentered` | Arrow cannot be centered. |

### CSS Variables

| Variable | Part | Description |
|:---------|:-----|:------------|
| `--anchor-height` | Positioner | Anchor height. |
| `--anchor-width` | Positioner | Anchor width. |
| `--available-height` | Positioner | Space between anchor and viewport edge. |
| `--available-width` | Positioner | Space between anchor and viewport edge. |
| `--positioner-height` | Positioner | Positioner element height. |
| `--positioner-width` | Positioner | Positioner element width. |
| `--transform-origin` | Positioner | Anchor coordinates for animations. |
| `--popup-height` | Popup | Popup height. |
| `--popup-width` | Popup | Popup width. |

### Example

```tsx
import { Popover } from '@base-ui/react/popover';

<Popover.Root>
  <Popover.Trigger>Open</Popover.Trigger>
  <Popover.Portal>
    <Popover.Positioner sideOffset={8}>
      <Popover.Popup>
        <Popover.Arrow />
        <Popover.Title>Title</Popover.Title>
        <Popover.Description>Content here.</Popover.Description>
        <Popover.Close>Close</Popover.Close>
      </Popover.Popup>
    </Popover.Positioner>
  </Popover.Portal>
</Popover.Root>
```

### Accessibility

- Non-modal by default (does not trap focus or lock scroll).
- Trigger is associated with popup via `aria-haspopup` and `aria-expanded`.
- Title and Description linked via `aria-labelledby` / `aria-describedby`.

---

## Tooltip

A popup label that appears on hover/focus, providing supplementary information.

```ts
import { Tooltip } from '@base-ui/react/tooltip';
```

### Parts

| Part | Renders | Description |
|:-----|:--------|:------------|
| `Tooltip.Provider` | (none) | Shared delay/grouping context for multiple tooltips. |
| `Tooltip.Root` | (none) | Groups all parts of a single tooltip. |
| `Tooltip.Trigger` | `<button>` | Element that shows the tooltip on hover/focus. |
| `Tooltip.Portal` | `<div>` | Moves popup to `<body>`. |
| `Tooltip.Positioner` | `<div>` | Positions popup against trigger. |
| `Tooltip.Popup` | `<div>` | Container for tooltip contents. |
| `Tooltip.Arrow` | `<div>` | Arrow pointing toward anchor. |

### Provider Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `delay` | `number` | - | Open delay (ms) for all child tooltips. |
| `closeDelay` | `number` | - | Close delay (ms) for all child tooltips. |
| `timeout` | `number` | `400` | Grouping timeout -- next tooltip opens instantly if previous closed within this time. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultOpen` | `boolean` | `false` | Initially open. |
| `open` | `boolean` | - | Controlled state. |
| `onOpenChange` | `(open, eventDetails) => void` | - | State change callback. |
| `onOpenChangeComplete` | `(open: boolean) => void` | - | After animations. |
| `trackCursorAxis` | `'none' \| 'both' \| 'x' \| 'y'` | `'none'` | Track cursor position on given axis. |
| `disabled` | `boolean` | `false` | Disable the tooltip. |
| `disableHoverablePopup` | `boolean` | `false` | Prevent hovering the popup from keeping it open. |
| `handle` | `Tooltip.Handle<Payload>` | - | For external triggers. |
| `children` | `ReactNode \| PayloadChildRenderFunction<Payload>` | - | Content. |

### Trigger Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `handle` | `Tooltip.Handle<Payload>` | - | Associates with tooltip. |
| `payload` | `Payload` | - | Data passed when opened. |
| `delay` | `number` | `600` | Open delay (ms). |
| `closeDelay` | `number` | `0` | Close delay (ms). |

### Positioner Props

Same as Popover.Positioner with `side` defaulting to `'top'`.

### Data Attributes

| Part | Attribute | Description |
|:-----|:----------|:------------|
| Trigger | `data-popup-open` | Tooltip is open. |
| Popup | `data-open` / `data-closed` | Open state. |
| Popup | `data-side` | Position side. |
| Popup | `data-align` | Alignment. |
| Popup | `data-instant` | `'delay' \| 'dismiss' \| 'focus'` -- skip animations. |
| Popup | `data-starting-style` / `data-ending-style` | Animation states. |
| Arrow | `data-open` / `data-closed` | Open state. |
| Arrow | `data-side` / `data-align` | Position info. |
| Arrow | `data-uncentered` | Arrow is off-center. |
| Arrow | `data-instant` | `'delay' \| 'dismiss' \| 'focus'` |

### CSS Variables

| Variable | Part | Description |
|:---------|:-----|:------------|
| `--anchor-height` | Positioner | Anchor height. |
| `--anchor-width` | Positioner | Anchor width. |
| `--available-height` | Positioner | Available viewport space. |
| `--available-width` | Positioner | Available viewport space. |
| `--transform-origin` | Positioner | Anchor coordinates. |

### Example

```tsx
import { Tooltip } from '@base-ui/react/tooltip';

<Tooltip.Provider>
  <Tooltip.Root>
    <Tooltip.Trigger>Hover me</Tooltip.Trigger>
    <Tooltip.Portal>
      <Tooltip.Positioner sideOffset={8}>
        <Tooltip.Popup>
          <Tooltip.Arrow />
          Tooltip text
        </Tooltip.Popup>
      </Tooltip.Positioner>
    </Tooltip.Portal>
  </Tooltip.Root>
</Tooltip.Provider>
```

### Accessibility

- Renders with `role="tooltip"`.
- Trigger linked via `aria-describedby`.
- Opens on hover and keyboard focus.
- Provider enables grouped delay so adjacent tooltips open instantly.

---

## Preview Card

A rich popup that appears on hover over a link, showing a preview of the linked content.

```ts
import { PreviewCard } from '@base-ui/react/preview-card';
```

### Parts

| Part | Renders | Description |
|:-----|:--------|:------------|
| `PreviewCard.Root` | (none) | Groups all parts. |
| `PreviewCard.Trigger` | `<a>` | A link that opens the preview card on hover. |
| `PreviewCard.Portal` | `<div>` | Moves popup to `<body>`. |
| `PreviewCard.Backdrop` | `<div>` | Optional overlay. |
| `PreviewCard.Positioner` | `<div>` | Positions popup against trigger. |
| `PreviewCard.Popup` | `<div>` | Container for contents. |
| `PreviewCard.Viewport` | `<div>` | Content transition container. |
| `PreviewCard.Arrow` | `<div>` | Arrow pointing toward anchor. |

### Root Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `defaultOpen` | `boolean` | `false` | Initially open. |
| `open` | `boolean` | - | Controlled state. |
| `onOpenChange` | `(open, eventDetails) => void` | - | State change callback. |
| `onOpenChangeComplete` | `(open: boolean) => void` | - | After animations. |
| `handle` | `PreviewCard.Handle<Payload>` | - | For external triggers. |
| `children` | `ReactNode \| PayloadChildRenderFunction<Payload>` | - | Content. |

### Trigger Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `handle` | `PreviewCard.Handle<Payload>` | - | Associates with preview card. |
| `payload` | `Payload` | - | Data passed when opened. |
| `delay` | `number` | `600` | Hover open delay (ms). |
| `closeDelay` | `number` | `300` | Hover close delay (ms). |

### Positioner Props

Same as Popover.Positioner with `side` defaulting to `'bottom'`.

### Data Attributes

Same pattern as Popover -- `data-open`, `data-closed`, `data-side`, `data-align`, `data-starting-style`, `data-ending-style`, `data-anchor-hidden`, `data-uncentered` on relevant parts.

### CSS Variables

Same as Popover Positioner: `--anchor-height`, `--anchor-width`, `--available-height`, `--available-width`, `--transform-origin`.

### Example

```tsx
import { PreviewCard } from '@base-ui/react/preview-card';

<PreviewCard.Root>
  <PreviewCard.Trigger href="https://example.com">
    Hover this link
  </PreviewCard.Trigger>
  <PreviewCard.Portal>
    <PreviewCard.Positioner sideOffset={8}>
      <PreviewCard.Popup>
        <PreviewCard.Arrow />
        <p>Preview content for the linked page.</p>
      </PreviewCard.Popup>
    </PreviewCard.Positioner>
  </PreviewCard.Portal>
</PreviewCard.Root>
```

### Accessibility

- Trigger renders as `<a>` (link), not a button.
- Opens on hover; the popup can be hovered without closing.
- Does not trap focus (non-modal).

