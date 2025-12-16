---
description: Create a responsive column layout (2-4 columns) for WordPress Greenshift
argument-hint: [number of columns] [content description]
---

# Greenshift Column Layout Generator

Generate a responsive column layout with flexbox.

## Instructions

1. Read the `greenshift-blocks` skill documentation in `docs/`
2. Use patterns from `docs/03-layouts.md` for column configurations
3. Create layout: $ARGUMENTS

## Available column layouts

### 2 columns
- 50/50 (equal)
- 60/40 (text + image)
- 40/60 (image + text)
- 70/30 (main + sidebar)

### 3 columns
- 33/33/33 (equal)
- 25/50/25 (larger center)

### 4 columns
- 25/25/25/25 (equal)

## Structure

```
Section (alignfull)
└── Content Area (flexbox container)
    ├── Column 1 (flex child)
    ├── Column 2 (flex child)
    └── Column N...
```

## Key parameters

```json
{
  "styleAttributes": {
    "display": ["flex"],
    "flexColumns_Extra": 2,
    "flexWidths_Extra": {
      "desktop": {"name": "50/50", "widths": [50, 50]},
      "tablet": {"name": "50/50", "widths": [50, 50]},
      "mobile": {"name": "100/100", "widths": [100, 100]}
    },
    "flexDirection": ["row"],
    "columnGap": ["var(--wp--preset--spacing--60, 2rem)"],
    "rowGap": ["var(--wp--preset--spacing--60, 2rem)"],
    "flexWrap": ["wrap"]
  },
  "isVariation": "contentarea"
}
```

## Responsiveness

- Desktop: columns side by side
- Tablet: optionally reduce proportions or stack
- Mobile: always 100% width (stack)

## Output

1. Generate the complete Greenshift block HTML code
2. Ask user for filename or suggest one based on content (e.g., `columns-features.html`)
3. **SAVE the code to an HTML file** using the Write tool
4. Confirm the file location to the user

**IMPORTANT:** Always save output to a `.html` file. Never just display the code in chat.
