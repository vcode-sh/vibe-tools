---
description: Create a single Greenshift element (text, image, button, icon, spacer)
argument-hint: [element type: text|image|button|icon|spacer] [description]
---

# Greenshift Element Generator

Generate a single Greenshift element/block.

## Element types

### Text (`type: "text"`)
- Heading (h1-h6)
- Paragraph
- Span
- Link text

### Image (`tag: "img"`)
- Photo with lazy loading
- Responsive dimensions
- Optional border-radius

### Button/Link (`tag: "a"`)
- Primary button
- Secondary/outline button
- Text link
- Icon button

### Icon (`tag: "svg"`)
- SVG icon
- Font icon
- Custom colors

### Spacer (`type: "no"`)
- Visual separator
- Vertical/horizontal spacer

## Arguments

Provide: $ARGUMENTS

## Example usage

```
/gs:element text Heading "About Us"
/gs:element image 800x600 "hero background"
/gs:element button primary "Contact Us"
/gs:element icon arrow-right 24px
/gs:element spacer 50px
```

## Style parameters

### Heading
```json
{
  "textContent": "Your Text",
  "tag": "h2",
  "styleAttributes": {
    "fontSize": ["var(--wp--preset--font-size--grand, 2.8rem)"],
    "fontWeight": ["600"],
    "marginBottom": ["var(--wp--preset--spacing--50, 1.5rem)"]
  }
}
```

### Button
```json
{
  "textContent": "Click Here",
  "tag": "a",
  "href": "#",
  "styleAttributes": {
    "display": ["inline-flex"],
    "padding": ["1rem 2rem"],
    "backgroundColor": ["var(--wp--preset--color--primary, #000)"],
    "color": ["#fff"],
    "borderRadius": ["var(--wp--custom--border-radius--medium, 15px)"],
    "textDecoration": ["none"],
    "transition": ["var(--wp--custom--transition--ease)"],
    "backgroundColor_hover": ["var(--wp--preset--color--secondary)"]
  }
}
```

### Image
```json
{
  "tag": "img",
  "src": "https://placehold.co/800x600",
  "alt": "Description",
  "originalWidth": 800,
  "originalHeight": 600,
  "styleAttributes": {
    "width": ["100%"],
    "height": ["auto"],
    "objectFit": ["cover"]
  }
}
```

## Output

Return ONLY Greenshift block HTML code.
