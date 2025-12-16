---
description: Create an accordion/FAQ component for WordPress Greenshift with collapsible sections
argument-hint: [number of items] [topic or leave empty for FAQ]
---

# Greenshift Accordion Generator

Generate a collapsible accordion component for FAQ sections, expandable content, or any collapsible interface.

## Instructions

1. Read the `greenshift-blocks` skill documentation, specifically `docs/08-variations.md` for accordion structure
2. Use the dynamicGClasses pattern for styling accordion items
3. Generate accordion according to: $ARGUMENTS

## Accordion Types

### FAQ Accordion
- Question/Answer format
- Single item open at a time (default)
- Common for support pages

### Multi-Section Accordion
- Multiple items can be open
- Good for documentation or lengthy content
- Uses `data-type="accordion-component"`

### Styled Accordion
- Custom colors and borders
- Icon rotation on open
- Smooth height transitions

## Structure

```
.gs_accordion (container, isVariation: "accordion")
└── .gs_item (accordion item)
    ├── .gs_title (h3)
    │   └── button.gs_click_sync
    │       ├── .gs_name (title text)
    │       └── .gs_icon (chevron SVG)
    └── .gs_content
        └── .gs_content_inner (content)
```

## Key Parameters

### Container
```json
{
  "isVariation": "accordion",
  "className": "gs_accordion_XXX gs_collapsible",
  "dynamicAttributes": [{"name": "data-type", "value": "accordion-component"}],
  "styleAttributes": {
    "display": ["flex"],
    "flexDirection": ["column"],
    "rowGap": ["15px"]
  }
}
```

### Accordion Item
```json
{
  "className": "gs_item",
  "type": "inner"
}
```

### Title Button
```json
{
  "tag": "button",
  "className": "gs_click_sync",
  "formAttributes": {"type": "button"},
  "dynamicAttributes": [{"name": "aria-expanded", "value": "false"}]
}
```

### Content Area
```json
{
  "className": "gs_content",
  "dynamicAttributes": [
    {"name": "role", "value": "region"},
    {"name": "aria-hidden", "value": "true"}
  ]
}
```

## Chevron Icon SVG

```html
<svg viewBox="0 0 512 1024" width="512" height="1024" class="gs_icon">
  <path d="M49.414 76.202l-39.598 39.596c-9.372 9.372-9.372 24.568 0 33.942l361.398 362.26-361.398 362.26c-9.372 9.372-9.372 24.568 0 33.942l39.598 39.598c9.372 9.372 24.568 9.372 33.942 0l418.828-418.828c9.372-9.372 9.372-24.568 0-33.942l-418.828-418.828c-9.374-9.374-24.57-9.374-33.942 0z" />
</svg>
```

## dynamicGClasses Selectors Required

1. **` > .gs_item`** - Item borders and radius
2. **` .gs_title`** - Title reset (margins/padding to 0)
3. **` .gs_title button`** - Button styling (background, padding, layout)
4. **` .gs_title .gs_icon`** - Icon size and transition
5. **`> .gs_item > .gs_content`** - Hidden state (max-height: 0, opacity: 0)
6. **` > .gs_item[data-active] > .gs_content`** - Open state (max-height: 5000px, opacity: 1)
7. **` .gs_content > .gs_content_inner`** - Content padding
8. **` > .gs_item[data-active] > .gs_title .gs_icon`** - Rotated icon (90deg)

## Styling Defaults

- Item border: 1px solid `var(--wp--preset--color--border, #00000012)`
- Item radius: 8px
- Button background: `#0000000d`
- Button padding: 1rem vertical, 1.5rem horizontal
- Content padding: 25px
- Transition: `max-height 0.5s cubic-bezier(0.42, 0, 0.58, 1)`

## Output Requirements

- Include complete dynamicGClasses for styling
- Each item must have unique IDs (gsbp-XXXXXXX)
- Include proper ARIA attributes for accessibility
- Default to 3 items if no number specified

## Output

1. Generate the complete Greenshift accordion block HTML code
2. Ask user for filename or suggest one based on content (e.g., `accordion-faq.html`)
3. **SAVE the code to an HTML file** using the Write tool
4. Confirm the file location to the user

**IMPORTANT:** Always save output to a `.html` file. Never just display the code in chat.
