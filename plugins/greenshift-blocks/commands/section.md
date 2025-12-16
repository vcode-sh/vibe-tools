---
description: Create a full WordPress Greenshift section with background, padding, and content
argument-hint: [section description or leave empty]
---

# Greenshift Section Generator

Generate a full WordPress Gutenberg section using Greenshift blocks.

## Instructions

1. Read the `greenshift-blocks` skill documentation in `docs/` for the full block specification
2. Use patterns from `docs/03-layouts.md` for section structures
3. Generate a section according to the user's description: $ARGUMENTS

## Requirements

- Use structure: section wrapper → content area → elements
- Every block must have unique `id` and `localId` (gsbp-XXXXXXX)
- Use CSS variables instead of hardcoded values
- Add AOS animations where appropriate
- Section should be responsive (breakpoints in styleAttributes)

## Critical Styling Rules

**Typography (IMPORTANT):**
- **NO fontSize on headings (h1-h6)** - theme handles heading sizes
- **NO color on headings/paragraphs** - unless text is on dark background
- Only add `marginBottom` for spacing control

**Background colors - use theme palette:**
```json
"backgroundColor": ["var(--wp--preset--color--palette-color-7, var(--theme-palette-color-7, #fafaf9))"]
"backgroundColor": ["var(--wp--preset--color--palette-color-8, var(--theme-palette-color-8, #fffffe))"]
```
NOT generic: `var(--wp--preset--color--white)` or `var(--wp--preset--color--light-grey)`

**Exception - text on dark backgrounds:**
Use `"color":["var(--wp--preset--color--white, #ffffff)"]` for text over dark overlays.

## Output

1. Generate the complete Greenshift block HTML code
2. Ask user for filename or suggest one based on content (e.g., `section-about.html`)
3. **SAVE the code to an HTML file** using the Write tool
4. Confirm the file location to the user

**IMPORTANT:** Always save output to a `.html` file. Never just display the code in chat.

## If no arguments provided

Ask the user about:
- Section type (hero, about, services, gallery, testimonials, contact, CTA)
- Background color
- Content (heading, text, images, buttons)
