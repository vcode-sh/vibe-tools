---
description: Create a card component for WordPress Greenshift - service, product, team member
argument-hint: [type: service|product|team|testimonial|pricing] [description]
---

# Greenshift Card Component Generator

Generate a card component for various use cases.

## Card types

### Service Card
- Icon on top
- Service title
- Short description
- "Learn more" link
- Hover effect (shadow/scale)

### Product Card
- Product image
- Product name
- Price (optional)
- Rating (optional)
- "Add to cart" button

### Team Card
- Person photo (circle or square)
- Name
- Position
- Social icons
- Bio (optional)

### Testimonial Card
- Quote icon
- Review text
- Author photo
- Name and company
- Rating stars

### Pricing Card
- Plan name
- Price
- Features list (checkmarks)
- CTA button
- Popular badge (optional)

## Arguments

$ARGUMENTS

## Card structure

```
Card Container (hover effects)
├── Image/Icon section
├── Content section
│   ├── Title
│   ├── Subtitle/Meta
│   └── Description
└── Action section
    └── Button/Link
```

## Basic card styles

```json
{
  "styleAttributes": {
    "backgroundColor": ["#fff"],
    "padding": ["var(--wp--preset--spacing--60, 2rem)"],
    "borderRadius": ["var(--wp--custom--border-radius--medium, 15px)"],
    "boxShadow": ["var(--wp--preset--shadow--soft)"],
    "transition": ["var(--wp--custom--transition--ease)"],
    "boxShadow_hover": ["var(--wp--preset--shadow--accent)"],
    "transform_hover": ["translateY(-5px)"]
  }
}
```

## Output

Return ONLY Greenshift card block HTML code.
