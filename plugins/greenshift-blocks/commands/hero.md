---
description: Create a hero section with background, heading, and CTA for WordPress Greenshift
argument-hint: [page title or hero description]
---

# Greenshift Hero Section Generator

Generate an attractive hero section for a WordPress page.

## Instructions

1. Read the `greenshift-blocks` skill documentation in `docs/`
2. Use patterns from `docs/03-layouts.md` and `docs/05-animations.md`
3. Create hero section: $ARGUMENTS

## Hero Structure

```
Section (alignfull, background image/video)
└── Content Container (centered, max-width)
    ├── Subtitle (optional, uppercase, animated)
    ├── Heading (h1, large font, animated with delay)
    ├── Description (optional, max-width for readability)
    └── CTA Buttons (optional, inline-flex)
```

## Elements to include

- **Background**: image (backgroundImage) or video (video parameter)
- **Overlay**: optionally darkened overlay
- **Animations**: clip-right, fade-up, fade with delays
- **Responsiveness**: smaller fonts on mobile, centered text
- **Height**: min 80vh or 100vh on desktop

## Technical requirements

- Section with `align: "full"` and `isVariation: "contentwrapper"`
- Background as `backgroundImage: ["url(...)"]` or `video` object
- Overlay: `overlay: {"color":"#000000","opacity":0.3}`
- Animations with increasing delay (0, 300, 600, 900ms)

## Typography Rules

Hero sections have dark backgrounds - text needs explicit white color.

**Heading (h1):**
- `"color":["var(--wp--preset--color--white, #ffffff)"]`
- **NO fontSize** - theme handles h1 size automatically
- Add `marginBottom` for spacing

**Subtitle/Description:**
- `"color":["rgba(255,255,255,0.9)"]` for softer white
- **NO fontSize** unless non-default size needed

Example heading JSON:
```json
{"textContent":"Title","tag":"h1","styleAttributes":{"color":["var(--wp--preset--color--white, #ffffff)"],"marginBottom":["var(--wp--preset--spacing--50, 1.5rem)"]}}
```

## Output

1. Generate the complete Greenshift block HTML code
2. Ask user for filename or suggest one based on content (e.g., `hero-homepage.html`)
3. **SAVE the code to an HTML file** using the Write tool
4. Confirm the file location to the user

**IMPORTANT:** Always save output to a `.html` file. Never just display the code in chat.
