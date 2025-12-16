---
description: Create a responsive table for WordPress Greenshift with header and data rows
argument-hint: [rows]x[cols] [table topic or leave empty]
---

# Greenshift Table Generator

Generate responsive HTML tables with proper styling for data display, comparison tables, or pricing grids.

## Instructions

1. Read the `greenshift-blocks` skill documentation, specifically `docs/08-variations.md` for table structure
2. Generate table according to: $ARGUMENTS

## Table Types

### Basic Data Table
- Header row with column titles
- Data rows below
- Borders and padding
- Responsive on mobile

### Comparison Table
- Features in first column
- Products/plans in header
- Checkmarks/X for features
- Good for pricing pages

### Striped Table
- Alternating row colors
- Better readability
- Professional look

### Pricing Table
- Plan names in header
- Price row highlighted
- Features with checkmarks
- CTA buttons at bottom

## Basic Table Structure

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-XXXXXXX","tag":"table","type":"inner","localId":"gsbp-XXXXXXX","tableAttributes":{"table":{"responsive":"yes"}},"tableStyles":{...},"styleAttributes":{"width":["100%"]}} -->
<table class="gsbp-XXXXXXX">
  <!-- Rows here -->
</table>
<!-- /wp:greenshift-blocks/element -->
```

## Key Parameters

### Table Element
```json
{
  "tag": "table",
  "type": "inner",
  "tableAttributes": {
    "table": {
      "responsive": "yes"
    }
  },
  "tableStyles": {
    "table": {
      "layout": "fixed",
      "border": "collapse"
    },
    "responsive": "yes",
    "td": {
      "paddingTop": ["6px"],
      "paddingBottom": ["6px"],
      "paddingRight": ["12px"],
      "paddingLeft": ["12px"],
      "borderStyle": "solid",
      "borderWidth": "1px",
      "borderColor": "var(--wp--preset--color--border, #00000012)",
      "fontSize": ["14px"]
    },
    "th": {
      "paddingTop": ["6px"],
      "paddingBottom": ["6px"],
      "paddingRight": ["12px"],
      "paddingLeft": ["12px"],
      "borderStyle": "solid",
      "borderWidth": "1px",
      "borderColor": "var(--wp--preset--color--border, #00000012)",
      "fontSize": ["16px"],
      "backgroundColor": "var(--wp--preset--color--lightbg, #cddceb21)"
    }
  },
  "styleAttributes": {
    "width": ["100%"]
  }
}
```

### Table Row
```json
{
  "tag": "tr",
  "type": "inner"
}
```

### Table Header Cell
```json
{
  "tag": "th",
  "textContent": "Header"
}
```

### Table Data Cell
```json
{
  "tag": "td",
  "textContent": "Data"
}
```

## tableStyles Object

The `tableStyles` object contains styling for different table elements:

### table (Table element)
```json
{
  "layout": "fixed",
  "border": "collapse"
}
```
- `layout`: "fixed" or "auto"
- `border`: "collapse" or "separate"

### td (Data cells)
Supports all styleAttributes properties:
- Padding: `paddingTop`, `paddingBottom`, `paddingLeft`, `paddingRight`
- Border: `borderStyle`, `borderWidth`, `borderColor`
- Typography: `fontSize`, `color`, `textAlign`

### th (Header cells)
Same as td, plus commonly:
- `backgroundColor`: Header background
- `fontWeight`: Text weight

### responsive
Set to `"yes"` to enable mobile responsiveness.

## Complete Table Example

```
table (gsbp-XXXXXXX)
├── tr (header row)
│   ├── th "Feature"
│   ├── th "Basic"
│   ├── th "Pro"
│   └── th "Enterprise"
├── tr (data row 1)
│   ├── td "Storage"
│   ├── td "10 GB"
│   ├── td "100 GB"
│   └── td "Unlimited"
├── tr (data row 2)
│   └── ...
└── tr (data row n)
    └── ...
```

## Styling Variations

### Clean Modern Table
```json
{
  "tableStyles": {
    "td": {
      "paddingTop": ["16px"],
      "paddingBottom": ["16px"],
      "paddingRight": ["20px"],
      "paddingLeft": ["20px"],
      "borderStyle": "none",
      "borderBottomWidth": "1px",
      "borderBottomStyle": "solid",
      "borderBottomColor": "var(--wp--preset--color--border, #e5e5e5)"
    },
    "th": {
      "paddingTop": ["16px"],
      "paddingBottom": ["16px"],
      "paddingRight": ["20px"],
      "paddingLeft": ["20px"],
      "backgroundColor": "transparent",
      "fontWeight": "600",
      "textTransform": "uppercase",
      "fontSize": ["12px"],
      "letterSpacing": "0.05em",
      "borderBottomWidth": "2px",
      "borderBottomStyle": "solid",
      "borderBottomColor": "var(--wp--preset--color--primary, #000)"
    }
  }
}
```

### Bordered Table
```json
{
  "tableStyles": {
    "table": {
      "border": "collapse"
    },
    "td": {
      "borderWidth": "1px",
      "borderStyle": "solid",
      "borderColor": "#ddd",
      "padding": ["12px"]
    },
    "th": {
      "borderWidth": "1px",
      "borderStyle": "solid",
      "borderColor": "#ddd",
      "backgroundColor": "#f8f9fa",
      "padding": ["12px"]
    }
  }
}
```

### Striped Rows
Use dynamicGClasses for alternating colors:
```json
{
  "dynamicGClasses": [{
    "value": "gs_table_XXX",
    "selectors": [{
      "value": " tr:nth-child(even) td",
      "attributes": {
        "styleAttributes": {
          "backgroundColor": ["#f9f9f9"]
        }
      }
    }]
  }]
}
```

## Special Cell Content

### Checkmark Icon
```html
<!-- wp:greenshift-blocks/element {"tag":"svg","icon":{"icon":{"font":"rhicon rhi-check"},"type":"font"},"styleAttributes":{"fill":["#22c55e"],"width":["20px"]}} -->
<svg>...</svg>
<!-- /wp:greenshift-blocks/element -->
```

### X Icon
```html
<!-- wp:greenshift-blocks/element {"tag":"svg","icon":{"icon":{"font":"rhicon rhi-times"},"type":"font"},"styleAttributes":{"fill":["#ef4444"],"width":["20px"]}} -->
<svg>...</svg>
<!-- /wp:greenshift-blocks/element -->
```

## Responsive Behavior

When `responsive: "yes"` is set:
- Table scrolls horizontally on small screens
- Or can stack rows vertically (CSS dependent)

## Common Table Sizes

| Type | Suggested Columns | Rows |
|------|-------------------|------|
| Simple data | 2-4 | Any |
| Comparison | 3-5 | 5-10 |
| Pricing | 3-4 | 6-12 |
| Schedule | 5-7 | 5-10 |

## Output Requirements

- Include tableAttributes and tableStyles
- Each element needs unique ID (gsbp-XXXXXXX)
- Use semantic th for headers, td for data
- Include responsive setting
- Default to 3x3 table if no size specified

## Output

1. Generate the complete Greenshift table block HTML code
2. Ask user for filename or suggest one based on content (e.g., `table-pricing.html`, `table-comparison.html`)
3. **SAVE the code to an HTML file** using the Write tool
4. Confirm the file location to the user

**IMPORTANT:** Always save output to a `.html` file. Never just display the code in chat.
