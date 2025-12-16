---
description: Create a complete WordPress page with multiple Greenshift sections
argument-hint: [page type: landing|about|services|contact|portfolio]
---

# Greenshift Full Page Generator

Generate a complete WordPress page with multiple sections.

## Page types

### Landing Page
1. Hero section (full-screen, background image/video, CTA)
2. Features/Benefits (3-4 columns with icons)
3. About section (text + image)
4. Services/Products (grid or columns)
5. Testimonials (slider or grid)
6. CTA section (call to action)
7. Contact/Footer info

### About Page
1. Hero banner (smaller)
2. Story section (text + image)
3. Team section (member grid)
4. Values/Mission (icons + text)
5. Timeline (optional)

### Services Page
1. Hero with title
2. Service items (alternating left/right)
3. Process section
4. Pricing (optional)
5. CTA

### Portfolio Page
1. Hero
2. Filter tabs (optional)
3. Gallery grid
4. CTA

### Contact Page
1. Hero
2. Contact info (icons + text)
3. Map placeholder
4. Form placeholder
5. Social links

## Arguments

$ARGUMENTS

## Instructions

1. Read the `greenshift-blocks` skill documentation in `docs/`
2. Use `docs/03-layouts.md` for section structures
3. Check templates in `templates/` directory for examples
4. Generate all sections with appropriate animations
5. Use consistent color palette (CSS variables)
6. Ensure responsiveness for each section

## Critical Requirements

### Page Wrapper (REQUIRED)

All pages MUST be wrapped in a single outer container element:

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-page001","type":"inner","localId":"gsbp-page001","align":"full","styleAttributes":{"marginBlockStart":["0px"]},"metadata":{"name":"Page Wrapper"}} -->
<div class="gsbp-page001 alignfull">
  <!-- All sections go here -->
</div>
<!-- /wp:greenshift-blocks/element -->
```

### No HTML Comments

Do NOT use HTML comments like `<!-- HERO SECTION -->` - WordPress strips them.
Use `metadata:{"name":"Hero Section"}` in the JSON instead.

## Best practices

- **Page wrapper required** - Wrap ALL sections in one outer alignfull element
- Add `marginBlockStart: ["0px"]` to page wrapper
- Use `metadata: {"name": "Section Name"}` for organization (NOT HTML comments)
- Apply consistent spacing between sections
- Animations with increasing delay within sections
- Alternate section backgrounds (white/light gray)

## Output

1. Generate the complete Greenshift block HTML code for all sections
2. Ask user for filename or suggest one based on page type (e.g., `landing-page.html`, `about-page.html`)
3. **SAVE the code to an HTML file** using the Write tool
4. Confirm the file location to the user

**IMPORTANT:** Always save output to a `.html` file. Never just display the code in chat.
