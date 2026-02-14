# Accessibility Guide

Base UI components handle ARIA attributes, role attributes, pointer interactions, keyboard navigation, and focus management out of the box. All components adhere to WAI-ARIA Authoring Practices.

## Keyboard Navigation

Components support standard keyboard interaction patterns:
- **Arrow keys** - Navigate between items (Menu, Select, Combobox, Tabs, Accordion, Radio, Slider, etc.)
- **Alphanumeric keys** - Typeahead search in lists (Menu, Select, Combobox)
- **Home / End** - Jump to first/last item
- **Enter** - Activate/select focused item
- **Esc** - Close popups (Dialog, Menu, Popover, Tooltip, Select, Combobox)
- **Space** - Toggle state (Checkbox, Switch, Toggle, Accordion)
- **Tab** - Move focus between focusable elements

### Component-Specific Keyboard Behavior

| Component | Keys | Behavior |
|-----------|------|----------|
| Dialog | Esc | Closes dialog. Focus returns to trigger. |
| Menu | Arrow Down/Up | Navigate items. Enter/Space activates. |
| Select | Arrow Down/Up | Navigate items when open. Enter selects. |
| Combobox | Arrow Down/Up | Navigate filtered items. Typing filters list. |
| Tabs | Arrow Left/Right | Switch tabs (horizontal). Arrow Up/Down for vertical. |
| Accordion | Arrow Down/Up | Move between triggers. Enter/Space toggles panel. |
| Slider | Arrow Left/Right | Adjust value by step. Page Up/Down for larger steps. |
| Radio | Arrow keys | Move selection between radio buttons. |

## Focus Management

Components manage focus automatically:
- **Dialog/AlertDialog**: Focus trapped inside modal. Returns to trigger on close.
- **Menu/Select/Combobox**: Focus moves to popup on open, returns to trigger on close.
- **Popover**: Non-modal by default (no focus trap).
- **Tooltip**: Focus stays on trigger.

### Configurable Focus

Some popup components support:
- `initialFocus` - Element or ref to focus when popup opens
- `finalFocus` - Element or ref to focus when popup closes

### Focus Styling

Base UI does **not** provide focus styles. You must style focus indicators:

```css
/* Recommended: only show for keyboard users */
.MyButton:focus-visible {
  outline: 2px solid blue;
  outline-offset: -1px;
}
```

WCAG guidelines recommend a minimum 2px focus indicator with 3:1 contrast ratio against adjacent colors.

## Color Contrast

When styling components, ensure sufficient color contrast:
- **Text**: 4.5:1 ratio against background (WCAG AA)
- **Large text / UI components**: 3:1 ratio (WCAG AA)
- Consider using APCA (Accessible Perceptual Contrast Algorithm) for WCAG 3 compliance

## Accessible Labels

Base UI auto-associates labels with controls:
- `Field.Label` automatically links to `Field.Control` via `htmlFor`/`id`
- `Dialog.Title` and `Dialog.Description` auto-link via `aria-labelledby`/`aria-describedby`
- `Tooltip.Popup` associates with `Tooltip.Trigger` via `aria-describedby`

### When You Need Manual Labels

For custom controls without visible labels:
```tsx
// aria-label for icon-only buttons
<Toggle aria-label="Favorite">
  <HeartIcon />
</Toggle>

// aria-labelledby for external labels
<Slider.Root aria-labelledby="volume-label">
  ...
</Slider.Root>
```

### Button-Based Form Controls

Select and Combobox use button triggers, not native inputs. Use `nativeLabel={false}` on `Field.Label`:

```tsx
<Field.Root>
  <Field.Label nativeLabel={false} render={<div />}>Category</Field.Label>
  <Select.Root>{/* ... */}</Select.Root>
</Field.Root>
```

## ARIA Attributes Applied Automatically

| Component | ARIA Attributes |
|-----------|----------------|
| Dialog | `role="dialog"`, `aria-modal="true"`, `aria-labelledby`, `aria-describedby` |
| AlertDialog | `role="alertdialog"`, `aria-modal="true"` |
| Menu | `role="menu"` on Popup, `role="menuitem"` on Items |
| Select | `role="listbox"` on List, `role="option"` on Items |
| Combobox | `role="combobox"` on Input, `role="listbox"` on List |
| Tabs | `role="tablist"`, `role="tab"`, `role="tabpanel"` |
| Accordion | `aria-expanded`, `aria-controls` on Triggers |
| Switch | `role="switch"`, `aria-checked` |
| Checkbox | `role="checkbox"`, `aria-checked` (supports `"mixed"` for indeterminate) |
| Slider | `role="slider"`, `aria-valuemin`, `aria-valuemax`, `aria-valuenow` |
| Progress | `role="progressbar"`, `aria-valuemin`, `aria-valuemax`, `aria-valuenow` |
| Tooltip | `role="tooltip"` on Popup |
