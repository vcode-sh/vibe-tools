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

## Slider (Swiper) Block - CORRECT STRUCTURE

**CRITICAL:** For image gallery sliders, use `greenshift-blocks/element` with `tag:"img"` inside `slider-content-zone`. Do NOT use direct `<img>` in `slider-image-wrapper`.

```html
<!-- wp:greenshift-blocks/swiper {"id":"gsbp-gallery01","tabs":4,"slidesPerView":[4,null,null,null],"slidesPerGroup":[1],"loop":true,"autoplay":true,"autoplayRestore":true,"disablePause":true,"autodelay":3000,"arrowsOnHover":true,"bgContain":false,"effect":"scale","overflow":true,"centered":true,"autoHeight":true} -->
<div class="wp-block-greenshift-blocks-swiper gs-swiper gspb_slider-id-gsbp-gallery01" style="position:relative"><div class="gs-swiper-init" data-slidesperview="4" data-slidespergroup="1" data-spacebetween="10" data-loop="true" data-autoplay="true" data-autodelay="3000" data-effect="scale" data-centered="true" data-autoheight="true"><div class="swiper"><div class="swiper-wrapper"><!-- wp:greenshift-blocks/swipe {"imageurl":"","bgContain":false,"id":"gsbp-slide01"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-slide01"><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-img01","tag":"img","localId":"gsbp-img01","src":"https://placehold.co/600x400","alt":"Gallery image 1"} -->
<img src="https://placehold.co/600x400" alt="Gallery image 1" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe -->
<!-- Additional slides follow same pattern... -->
</div></div><div class="swiper-pagination"></div><div class="swiper-button-prev"></div><div class="swiper-button-next"></div><div class="swiper-scrollbar"></div></div></div>
<!-- /wp:greenshift-blocks/swiper -->
```

### Key Slider Rules

- `imageurl` must be empty string `""`
- Add `bgContain:false` to swipe JSON
- No `slider-overlaybg` or `slider-image-wrapper` divs
- Images go inside `slider-content-zone` as `greenshift-blocks/element` blocks
- Do NOT use `width="100%" height="100%"` on slide images

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
