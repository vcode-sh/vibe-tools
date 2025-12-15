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

## Best practices

- Add `marginBlockStart: ["0px"]` to first section
- Use `metadata: {"name": "Section Name"}` for easy navigation
- Apply consistent spacing between sections
- Animations with increasing delay within sections
- Alternate section backgrounds (white/light gray)

## Output

Return ONLY Greenshift block HTML code for the entire page.
