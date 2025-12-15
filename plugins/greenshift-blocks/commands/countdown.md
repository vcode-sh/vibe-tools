---
description: Create a countdown timer for WordPress Greenshift counting down to a specific date
argument-hint: [target date YYYY-MM-DD] [event name or leave empty]
---

# Greenshift Countdown Generator

Generate countdown timers that count down to a specific date/time. Perfect for product launches, events, sales, or deadlines.

## Instructions

1. Read the `greenshift-blocks` skill documentation, specifically `docs/08-variations.md` for countdown structure
2. Generate countdown according to: $ARGUMENTS

## Countdown Types

### Simple Countdown
- Days, hours, minutes, seconds
- Colon separators
- Inline display

### Box Countdown
- Each unit in separate box
- Labels below each box
- Good for hero sections

### Flip Countdown
- Card flip animation style
- More visual impact
- Event pages

### Minimal Countdown
- Numbers only, no labels
- Small and compact
- Sidebar or header use

## Basic Countdown Structure

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-XXXXXXX","type":"inner","className":"gs_countdown_XXX gs_countdown","localId":"gsbp-XXXXXXX","styleAttributes":{...},"isVariation":"countdown","endtime":"2024-12-31T23:59:59"} -->
<div class="gs_countdown_XXX gs_countdown gsbp-XXXXXXX" data-end="2024-12-31T23:59:59">
  <!-- Time units here -->
</div>
<!-- /wp:greenshift-blocks/element -->
```

## Key Parameters

### Countdown Container
```json
{
  "isVariation": "countdown",
  "className": "gs_countdown_XXX gs_countdown",
  "endtime": "2024-12-31T23:59:59",
  "styleAttributes": {
    "display": ["flex"],
    "flexDirection": ["row"],
    "rowGap": ["5px"],
    "columnGap": ["5px"],
    "alignItems": ["center"],
    "justifyContent": ["flex-start"]
  }
}
```

### Time Unit (Days, Hours, Minutes, Seconds)
```json
{
  "tag": "span",
  "textContent": "00",
  "className": "gs_days gs_countdown_item"
}
```

### Divider (Colon)
```json
{
  "tag": "span",
  "textContent": ":",
  "className": "gs_date_divider"
}
```

## CSS Classes

| Class | Element | Purpose |
|-------|---------|---------|
| `.gs_countdown` | Container | Main countdown wrapper |
| `.gs_countdown_item` | All units | Common styling for numbers |
| `.gs_days` | Span | Days value |
| `.gs_hours` | Span | Hours value |
| `.gs_minutes` | Span | Minutes value |
| `.gs_seconds` | Span | Seconds value |
| `.gs_date_divider` | Span | Separator (colon) |

## data-end Attribute

The countdown uses ISO date format:

```html
data-end="2024-12-31T23:59:59"
```

**Format**: `YYYY-MM-DDTHH:mm:ss`

## Complete Structure with Labels

```
Countdown Container (gs_countdown)
├── Days Box
│   ├── Number (gs_days gs_countdown_item)
│   └── Label "Days"
├── Divider ":"
├── Hours Box
│   ├── Number (gs_hours gs_countdown_item)
│   └── Label "Hours"
├── Divider ":"
├── Minutes Box
│   ├── Number (gs_minutes gs_countdown_item)
│   └── Label "Minutes"
├── Divider ":"
└── Seconds Box
    ├── Number (gs_seconds gs_countdown_item)
    └── Label "Seconds"
```

## dynamicGClasses for Styling

```json
{
  "dynamicGClasses": [{
    "value": "gs_countdown_XXX",
    "type": "local",
    "selectors": [
      {
        "value": " .gs_countdown_item",
        "attributes": {
          "styleAttributes": {
            "fontSize": ["2rem"],
            "fontWeight": ["bold"],
            "lineHeight": ["2.3rem"]
          }
        }
      },
      {
        "value": " .gs_date_divider",
        "attributes": {
          "styleAttributes": {
            "fontSize": ["1.7rem"],
            "lineHeight": ["2.3rem"]
          }
        }
      }
    ]
  }]
}
```

## Box Style Countdown

Each unit in a styled box:

```json
{
  "styleAttributes": {
    "display": ["flex"],
    "flexDirection": ["column"],
    "alignItems": ["center"],
    "justifyContent": ["center"],
    "backgroundColor": ["var(--wp--preset--color--lightbg, #f5f5f5)"],
    "borderRadius": ["var(--wp--custom--border-radius--small, 10px)"],
    "padding": ["var(--wp--preset--spacing--50, 1.5rem)"],
    "minWidth": ["80px"]
  }
}
```

## Styling Recommendations

### Large Hero Countdown
```json
{
  "styleAttributes": {
    "fontSize": ["var(--wp--preset--font-size--giant, 4rem)", "var(--wp--preset--font-size--giga, 3rem)", "var(--wp--preset--font-size--grand, 2rem)", "var(--wp--preset--font-size--xl, 1.5rem)"],
    "fontWeight": ["700"],
    "columnGap": ["var(--wp--preset--spacing--50, 1.5rem)"]
  }
}
```

### Compact Header Countdown
```json
{
  "styleAttributes": {
    "fontSize": ["var(--wp--preset--font-size--m, 1.2rem)"],
    "columnGap": ["var(--wp--preset--spacing--30, 0.5rem)"]
  }
}
```

### Label Styling
```json
{
  "styleAttributes": {
    "fontSize": ["var(--wp--preset--font-size--xs, 0.85rem)"],
    "textTransform": ["uppercase"],
    "letterSpacing": ["0.05em"],
    "opacity": ["0.7"],
    "marginTop": ["var(--wp--preset--spacing--30, 0.5rem)"]
  }
}
```

## Full Section Example

```
Section (alignfull, dark background)
└── Content Area (centered)
    ├── Heading "Event Starts In"
    ├── Countdown Timer
    └── CTA Button "Register Now"
```

## Date Handling

- **Future date**: Countdown runs normally
- **Past date**: Shows 00:00:00:00
- **Timezone**: Uses browser's local time

## Common Use Cases

| Use Case | Recommended Style |
|----------|-------------------|
| Product launch | Box style, hero placement |
| Sale ending | Inline, header/banner |
| Event countdown | Large, centered with CTA |
| Limited offer | Compact, near CTA button |

## Output Requirements

- Return ONLY Greenshift block HTML code
- Include data-end attribute with ISO date format
- Use "00" as initial textContent for all units
- Each element needs unique ID (gsbp-XXXXXXX)
- Include all four time units (days, hours, minutes, seconds)
- Add dividers between units
- Include dynamicGClasses for consistent styling
