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
/greenshift-blocks:element text Heading "About Us"
/greenshift-blocks:element image 800x600 "hero background"
/greenshift-blocks:element button primary "Contact Us"
/greenshift-blocks:element icon arrow-right 24px
/greenshift-blocks:element spacer 50px
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

1. Generate the complete Greenshift block HTML code
2. Ask user for filename or suggest one based on element type (e.g., `button-primary.html`, `heading-hero.html`)
3. **SAVE the code to an HTML file** using the Write tool
4. Confirm the file location to the user

**IMPORTANT:** Always save output to a `.html` file. Never just display the code in chat.
