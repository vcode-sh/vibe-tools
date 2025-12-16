---
description: Create a tabbed interface for WordPress Greenshift with multiple content panels
argument-hint: [number of tabs] [tab titles comma-separated or leave empty]
---

# Greenshift Tabs Generator

Generate a tabbed content interface with smooth transitions between panels.

## Instructions

1. Read the `greenshift-blocks` skill documentation, specifically `docs/08-variations.md` for tabs structure
2. Use the dynamicGClasses pattern for styling tabs
3. Generate tabs according to: $ARGUMENTS

## Tab Variations

### Horizontal Tabs (Default)
- Tabs aligned horizontally above content
- Active tab highlighted
- Smooth panel transitions

### Vertical Tabs
- Tabs stacked vertically on left
- Content panel on right
- Good for sidebar navigation

### Pill Tabs
- Rounded tab buttons
- No visible panel borders
- Modern, minimal style

### Underlined Tabs
- Border-bottom indicator
- Clean, professional look
- Common in dashboards

## Structure

```
.gs_root (container, isVariation: "tabs")
├── .gs_tabs_list (tablist container, isVariation: "tablist")
│   ├── button.gs_tab.active (first tab)
│   ├── button.gs_tab (other tabs)
│   └── ...
└── .gs_content_area
    ├── .gs_content.active (first panel, visible)
    ├── .gs_content (other panels, hidden)
    └── ...
```

## Key Parameters

### Main Container
```json
{
  "isVariation": "tabs",
  "className": "gs_tabs_XXX gs_root",
  "dynamicAttributes": [{"name": "data-type", "value": "tabs-component"}],
  "styleAttributes": {
    "display": ["flex"],
    "flexDirection": ["column"]
  }
}
```

### Tabs List Container
```json
{
  "isVariation": "tablist",
  "className": "gs_tabs_list",
  "dynamicAttributes": [{"name": "role", "value": "tablist"}],
  "styleAttributes": {
    "display": ["flex"],
    "flexDirection": ["row"],
    "columnGap": ["15px"],
    "rowGap": ["15px"],
    "flexWrap": ["wrap"]
  }
}
```

### Tab Button (Active)
```json
{
  "tag": "button",
  "className": "gs_click_sync gs_tab active",
  "formAttributes": {"type": "button"},
  "dynamicAttributes": [
    {"name": "role", "value": "tab"},
    {"name": "aria-selected", "value": "true"}
  ]
}
```

### Tab Button (Inactive)
```json
{
  "tag": "button",
  "className": "gs_click_sync gs_tab",
  "formAttributes": {"type": "button"},
  "dynamicAttributes": [
    {"name": "role", "value": "tab"},
    {"name": "aria-selected", "value": "false"}
  ]
}
```

### Content Panel (Active)
```json
{
  "className": "gs_content active",
  "dynamicAttributes": [
    {"name": "role", "value": "tabpanel"},
    {"name": "aria-hidden", "value": "false"}
  ]
}
```

### Content Panel (Hidden)
```json
{
  "className": "gs_content",
  "dynamicAttributes": [
    {"name": "role", "value": "tabpanel"},
    {"name": "aria-hidden", "value": "true"}
  ]
}
```

## dynamicGClasses Selectors Required

1. **` .gs_tab`** - Tab button styling (background, padding, layout, transition)
2. **` .gs_tab.active`** - Active tab state (different background/color)
3. **` .gs_tab svg`** - Optional SVG icons in tabs
4. **` .gs_tab.active svg`** - SVG icons in active tabs
5. **` .gs_content`** - Hidden panel state (max-height: 0, opacity: 0)
6. **` .gs_content.active`** - Visible panel state (max-height: 5000px, opacity: 1)
7. **` .gs_content > .gs_content_inner`** - Inner content padding

## Styling Defaults

### Tab Button
- Background: `#0000000d`
- Active background: `#000000`
- Padding: 1rem vertical, 1.5rem horizontal
- Color: `#000000` / Active: `#fff`
- Cursor: pointer
- Transition: `all 0.5s ease`

### Content Panel
- Hidden: `max-height: 0px`, `opacity: 0`
- Visible: `max-height: 5000px`, `opacity: 1`
- Transition: `opacity 0.5s, max-height 0.5s cubic-bezier(0.42, 0, 0.58, 1)`
- Inner padding: 25px

## Adding Icons to Tabs

Include SVG icon before tab title span:

```html
<!-- wp:greenshift-blocks/element {"tag":"svg","icon":{"icon":{"font":"rhicon rhi-home"},"type":"font"},"className":"gs_icon"} -->
<svg>...</svg>
<!-- /wp:greenshift-blocks/element -->
```

## Output Requirements

- Include complete dynamicGClasses for styling
- First tab must have `.active` class
- First panel must have `.active` class and `aria-hidden="false"`
- Each element needs unique IDs (gsbp-XXXXXXX)
- Include proper ARIA attributes for accessibility
- Default to 3 tabs if no number specified

## Output

1. Generate the complete Greenshift tabs block HTML code
2. Ask user for filename or suggest one based on content (e.g., `tabs-features.html`)
3. **SAVE the code to an HTML file** using the Write tool
4. Confirm the file location to the user

**IMPORTANT:** Always save output to a `.html` file. Never just display the code in chat.
