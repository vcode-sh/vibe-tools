# Layouts & Specific Structures

## Column Layouts

Use nested Elements with specific `isVariation` flags and flexbox `styleAttributes` for creating column-based layouts.

### Two Columns Layout

Use `isVariation: "contentcolumns"` on the outer section and `isVariation: "contentarea"` on the inner flex container. Configure `flexColumns_Extra` and `flexWidths_Extra` to define column behavior.

**Complete Example:**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-42bdb4c","tag":"section","type":"inner","localId":"gsbp-42bdb4c","align":"full","dynamicAttributes":[{"name":"data-type","value":"section-component"}],"styleAttributes":{"display":["flex"],"justifyContent":["center"],"flexDirection":["column"],"alignItems":["center"],"paddingRight":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dside, min(3vw, 20px))"],"paddingLeft":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dside, min(3vw, 20px))"],"paddingTop":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dtop, 0px)"],"paddingBottom":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dbottom, 0px)"],"marginTop":["0px"],"marginBottom":["0px"],"paddingLink_Extra":"lr","position":["relative"]},"isVariation":"contentcolumns"} -->
<section class="gsbp-42bdb4c alignfull" data-type="section-component"><!-- wp:greenshift-blocks/element {"id":"gsbp-67dafe8","type":"inner","localId":"gsbp-67dafe8","dynamicAttributes":[{"name":"data-type","value":"content-area-component"}],"styleAttributes":{"maxWidth":["100%"],"width":["var(\u002d\u002dwp\u002d\u002dstyle\u002d\u002dglobal\u002d\u002dcontent-size, 1290px)"],"display":["flex"],"flexColumns_Extra":2,"flexWidths_Extra":{"desktop":{"name":"50/50","widths":[50,50]},"tablet":{"name":"50/50","widths":[50,50]},"mobile":{"name":"100/100","widths":[100,100]}},"flexDirection":["row"],"columnGap":["25px"],"rowGap":["25px"],"flexWrap":["wrap"]},"isVariation":"contentarea","metadata":{"name":"Content Area"}} -->
<div class="gsbp-67dafe8" data-type="content-area-component"><!-- wp:greenshift-blocks/element {"id":"gsbp-2d5265e","type":"inner","localId":"gsbp-2d5265e"} -->
<div></div>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-92c0862","type":"inner","localId":"gsbp-92c0862"} -->
<div></div>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element --></section>
<!-- /wp:greenshift-blocks/element -->
```

### Column Configuration Parameters

#### Key Flexbox Parameters

The `styleAttributes` object controls the flexbox behavior for column layouts:

```json
{
  "styleAttributes": {
    "display": ["flex"],
    "flexDirection": ["row"],
    "flexWrap": ["wrap"],
    "columnGap": ["var(--wp--preset--spacing--60, 2rem)"],
    "rowGap": ["var(--wp--preset--spacing--60, 2rem)"],
    "flexColumns_Extra": 2,
    "flexWidths_Extra": {
      "desktop": {"name": "50/50", "widths": [50, 50]},
      "tablet": {"name": "50/50", "widths": [50, 50]},
      "mobile": {"name": "100/100", "widths": [100, 100]}
    }
  },
  "isVariation": "contentarea"
}
```

#### Common Column Configurations

**2 Columns (50/50):**

```json
"flexColumns_Extra": 2,
"flexWidths_Extra": {
  "desktop": {"name": "50/50", "widths": [50, 50]},
  "tablet": {"name": "50/50", "widths": [50, 50]},
  "mobile": {"name": "100/100", "widths": [100, 100]}
}
```

**2 Columns (60/40):**

```json
"flexColumns_Extra": 2,
"flexWidths_Extra": {
  "desktop": {"name": "60/40", "widths": [60, 40]},
  "tablet": {"name": "60/40", "widths": [60, 40]},
  "mobile": {"name": "100/100", "widths": [100, 100]}
}
```

**3 Columns (33/33/33):**

```json
"flexColumns_Extra": 3,
"flexWidths_Extra": {
  "desktop": {"name": "33/33/33", "widths": [33.33, 33.33, 33.33]},
  "tablet": {"name": "50/50/100", "widths": [50, 50, 100]},
  "mobile": {"name": "100/100/100", "widths": [100, 100, 100]}
}
```

**4 Columns (25/25/25/25):**

```json
"flexColumns_Extra": 4,
"flexWidths_Extra": {
  "desktop": {"name": "25/25/25/25", "widths": [25, 25, 25, 25]},
  "tablet": {"name": "50/50/50/50", "widths": [50, 50, 50, 50]},
  "mobile": {"name": "100/100/100/100", "widths": [100, 100, 100, 100]}
}
```

---

## Full-Width Section Wrapper

For full-width sections with centered content, use `align: "full"` with the following structure.

### Section Structure

```
Section (alignfull, isVariation: "contentwrapper")
└── Content Area (max-width, isVariation: "nocolumncontent")
    └── Inner content
```

### Complete Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-1c2390f","tag":"section","type":"inner","localId":"gsbp-1c2390f","align":"full","dynamicAttributes":[{"name":"data-type","value":"section-component"}],"styleAttributes":{"display":["flex"],"justifyContent":["center"],"flexDirection":["column"],"alignItems":["center"],"paddingRight":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dside, min(3vw, 20px))"],"paddingLeft":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dside, min(3vw, 20px))"],"paddingTop":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dtop, 0px)"],"paddingBottom":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dbottom, 0px)"],"marginTop":["0px"],"marginBottom":["0px"],"paddingLink_Extra":"lr","position":["relative"]},"isVariation":"contentwrapper"} -->
<section class="gsbp-1c2390f alignfull" data-type="section-component"><!-- wp:greenshift-blocks/element {"id":"gsbp-9a9c9e1","type":"inner","localId":"gsbp-9a9c9e1","dynamicAttributes":[{"name":"data-type","value":"content-area-component"}],"styleAttributes":{"maxWidth":["100%"],"width":["var(\u002d\u002dwp\u002d\u002dstyle\u002d\u002dglobal\u002d\u002dcontent-size, 1290px)"]},"isVariation":"nocolumncontent","metadata":{"name":"Content Area"}} -->
<div class="gsbp-9a9c9e1" data-type="content-area-component"></div>
<!-- /wp:greenshift-blocks/element --></section>
<!-- /wp:greenshift-blocks/element -->
```

### Section Wrapper Template

Use this template for the outer section wrapper:

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-SECTION","tag":"section","type":"inner","localId":"gsbp-SECTION","align":"full","dynamicAttributes":[{"name":"data-type","value":"section-component"}],"styleAttributes":{"display":["flex"],"justifyContent":["center"],"flexDirection":["column"],"alignItems":["center"],"paddingRight":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dside, min(3vw, 20px))"],"paddingLeft":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dside, min(3vw, 20px))"],"paddingTop":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dspacing\u002d\u002d80, 5rem)"],"paddingBottom":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dspacing\u002d\u002d80, 5rem)"],"marginTop":["0px"],"marginBottom":["0px"],"position":["relative"]},"isVariation":"contentwrapper"} -->
<section class="gsbp-SECTION alignfull" data-type="section-component">
  <!-- Content Area here -->
</section>
<!-- /wp:greenshift-blocks/element -->
```

### Content Area Template

Use this template for the inner content area:

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-CONTENT","type":"inner","localId":"gsbp-CONTENT","dynamicAttributes":[{"name":"data-type","value":"content-area-component"}],"styleAttributes":{"maxWidth":["100%"],"width":["var(\u002d\u002dwp\u002d\u002dstyle\u002d\u002dglobal\u002d\u002dcontent-size, 1290px)"]},"isVariation":"nocolumncontent","metadata":{"name":"Content Area"}} -->
<div class="gsbp-CONTENT" data-type="content-area-component">
  <!-- Inner content here -->
</div>
<!-- /wp:greenshift-blocks/element -->
```

---

## Layout Variations (`isVariation`)

These `isVariation` values control the type of layout structure:

| Variation | Purpose | Usage |
|-----------|---------|-------|
| `"contentwrapper"` | Full-width section wrapper | Use on outer section element with `align: "full"` |
| `"nocolumncontent"` | Centered content area (no columns) | Use on inner content div for simple centered layouts |
| `"contentcolumns"` | Section with column layout | Use on outer section element when creating column layouts |
| `"contentarea"` | Flexbox column container | Use on inner flex container with `flexColumns_Extra` and `flexWidths_Extra` |

---

## WordPress Theme Compatibility

### Margin Reset

WordPress themes apply default spacing via `.is-layout-flow` rules:

```css
:root :where(.is-layout-flow) > * {
  margin-block-start: var(--theme-content-spacing);
}
```

To remove gaps between sections, add `marginBlockStart: ["0px"]` to section wrappers:

```json
"styleAttributes": {
  "marginBlockStart": ["0px"]
}
```

**Best practice**: Add `marginBlockStart: ["0px"]` to the first section or wrap multiple sections in a parent div with this reset.

---

## Flexbox Properties Reference

### Display and Direction

| Property | Values | Description |
|----------|--------|-------------|
| `display` | `["flex"]`, `["grid"]`, `["block"]` | Display mode |
| `flexDirection` | `["row"]`, `["column"]`, `["row-reverse"]` | Main axis direction |
| `flexWrap` | `["wrap"]`, `["nowrap"]` | Whether items wrap to new lines |

### Alignment

| Property | Values | Description |
|----------|--------|-------------|
| `justifyContent` | `["center"]`, `["flex-start"]`, `["flex-end"]`, `["space-between"]`, `["space-around"]` | Align along main axis |
| `alignItems` | `["center"]`, `["flex-start"]`, `["flex-end"]`, `["stretch"]` | Align along cross axis |

### Spacing

| Property | Values | Description |
|----------|--------|-------------|
| `gap` | `["1rem"]`, `["var(--wp--preset--spacing--50)"]` | Gap between all items |
| `columnGap` | Same as gap | Gap between columns only |
| `rowGap` | Same as gap | Gap between rows only |

### Responsive Column Widths

The `flexWidths_Extra` parameter defines column widths for each breakpoint:

```json
"flexWidths_Extra": {
  "desktop": {"name": "50/50", "widths": [50, 50]},
  "tablet": {"name": "50/50", "widths": [50, 50]},
  "mobile": {"name": "100/100", "widths": [100, 100]}
}
```

Each breakpoint has:
- `name`: Descriptive name (e.g., "50/50", "60/40")
- `widths`: Array of percentage widths for each column

---

## Two-Column Layout Example

Complete working example with proper structure:

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-cols01","tag":"section","type":"inner","localId":"gsbp-cols01","align":"full","styleAttributes":{"display":["flex"],"justifyContent":["center"],"alignItems":["center"],"paddingTop":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dspacing\u002d\u002d80)"],"paddingBottom":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dspacing\u002d\u002d80)"]},"isVariation":"contentcolumns"} -->
<section class="gsbp-cols01 alignfull"><!-- wp:greenshift-blocks/element {"id":"gsbp-cols02","type":"inner","localId":"gsbp-cols02","styleAttributes":{"maxWidth":["100%"],"width":["var(\u002d\u002dwp\u002d\u002dstyle\u002d\u002dglobal\u002d\u002dcontent-size, 1290px)"],"display":["flex"],"flexColumns_Extra":2,"flexWidths_Extra":{"desktop":{"name":"50/50","widths":[50,50]},"tablet":{"name":"50/50","widths":[50,50]},"mobile":{"name":"100/100","widths":[100,100]}},"flexDirection":["row"],"columnGap":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dspacing\u002d\u002d60)"],"rowGap":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dspacing\u002d\u002d60)"],"flexWrap":["wrap"]},"isVariation":"contentarea"} -->
<div class="gsbp-cols02"><!-- wp:greenshift-blocks/element {"id":"gsbp-col1","type":"inner","localId":"gsbp-col1"} -->
<div>
  <!-- Column 1 content -->
</div>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-col2","type":"inner","localId":"gsbp-col2"} -->
<div>
  <!-- Column 2 content -->
</div>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element --></section>
<!-- /wp:greenshift-blocks/element -->
```
