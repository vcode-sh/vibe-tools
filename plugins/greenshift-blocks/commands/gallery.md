---
description: Create an image gallery for WordPress Greenshift (grid, masonry, slider)
argument-hint: [type: grid|masonry|slider] [number of images]
---

# Greenshift Gallery Generator

Generate an image gallery in various layouts.

## Gallery types

### Grid Gallery
- Regular image grid
- Equal dimensions or aspect-ratio
- Responsive columns (4→2→1)

### Masonry Gallery
- Varied heights
- Pinterest-style layout
- CSS columns or flexbox

### Slider Gallery
- Image carousel (Swiper.js)
- Optional autoplay
- Navigation arrows and dots

### 3-Image Layout
- Special 3-image arrangement
- Left small, center large, right small
- Fade-in animations

## Arguments

$ARGUMENTS

## Grid Gallery Structure

```
Section (alignfull)
└── Content Area
    └── Gallery Container (flexbox/grid)
        ├── Image Wrapper 1
        │   └── Image
        ├── Image Wrapper 2
        │   └── Image
        └── ...
```

## Key Grid parameters

```json
{
  "styleAttributes": {
    "display": ["flex"],
    "flexWrap": ["wrap"],
    "gap": ["var(--wp--preset--spacing--50, 1.5rem)"],
    "flexColumns_Extra": 4,
    "flexWidths_Extra": {
      "desktop": {"widths": [25, 25, 25, 25]},
      "tablet": {"widths": [50, 50, 50, 50]},
      "mobile": {"widths": [100, 100, 100, 100]}
    }
  }
}
```

## Image Wrapper

```json
{
  "type": "inner",
  "styleAttributes": {
    "overflow": ["hidden"],
    "borderRadius": ["var(--wp--custom--border-radius--small, 10px)"]
  }
}
```

## Image Parameters

```json
{
  "tag": "img",
  "src": "https://placehold.co/600x600",
  "alt": "",
  "styleAttributes": {
    "width": ["100%"],
    "height": ["auto"],
    "aspectRatio": ["1/1"],
    "objectFit": ["cover"],
    "transition": ["var(--wp--custom--transition--ease)"],
    "scale_hover": ["1.05"]
  }
}
```

## Slider (Swiper) Block

```html
<!-- wp:greenshift-blocks/swiper {"id":"gsbp-XXXXXXX","slidesPerView":[3,2,1,1],"spaceBetween":[20,20,15,15],"loop":true,"navigationarrows":true,"bullets":true} -->
...slides...
<!-- /wp:greenshift-blocks/swiper -->
```

## Animations

- `fade-up` with delay for each image (0, 100, 200, 300...)
- `zoom-in` on hover
- `fade-right`/`fade-left` for 3-image layout

## Output

1. Generate the complete Greenshift block HTML code with placeholder images
2. Ask user for filename or suggest one based on gallery type (e.g., `gallery-grid.html`, `gallery-slider.html`)
3. **SAVE the code to an HTML file** using the Write tool
4. Confirm the file location to the user

**IMPORTANT:** Always save output to a `.html` file. Never just display the code in chat.
