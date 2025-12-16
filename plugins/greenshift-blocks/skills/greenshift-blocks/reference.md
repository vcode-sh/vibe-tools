# Greenshift Blocks Quick Reference

## JSON Parameters Cheatsheet

### Essential Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | string | Unique ID: `gsbp-` + 7 chars |
| `localId` | string | Must match `id` |
| `tag` | string | HTML tag (default: `div`) |
| `type` | string | `text`, `inner`, `no`, `chart` |
| `textContent` | string | Text for `type: "text"` |
| `className` | string | Additional CSS classes |
| `styleAttributes` | object | All styling |
| `animation` | object | AOS animation config |
| `isVariation` | string | Block variation type |
| `metadata` | object | Editor info |

### Link Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `href` | string | URL |
| `linkNewWindow` | boolean | Opens in new tab |
| `linkNoFollow` | boolean | Adds nofollow |
| `linkSponsored` | boolean | Adds sponsored |
| `title` | string | Title attribute |

### Image Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `src` | string | Image URL |
| `alt` | string | Alt text |
| `originalWidth` | number | Width in pixels |
| `originalHeight` | number | Height in pixels |
| `fetchpriority` | string | `"high"` for LCP |

**IMPORTANT:** When using `originalWidth` and `originalHeight` in JSON, you MUST also add matching `width` and `height` HTML attributes to the `<img>` tag. WordPress expects these to match.

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-img001","tag":"img","localId":"gsbp-img001","src":"https://placehold.co/800x600","alt":"Description","originalWidth":800,"originalHeight":600} -->
<img class="gsbp-img001" src="https://placehold.co/800x600" alt="Description" width="800" height="600" loading="lazy"/>
<!-- /wp:greenshift-blocks/element -->
```

### Video Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `video.src` | string | Video URL |
| `video.autoplay` | boolean | Auto start |
| `video.loop` | boolean | Loop video |
| `video.muted` | boolean | Muted |
| `video.playsinline` | boolean | Inline on mobile |
| `video.background` | boolean | Background mode |
| `poster` | string | Poster image URL |

### Animation Parameters

```json
"animation": {
  "type": "fade-up",
  "duration": 800,
  "delay": 0,
  "easing": "ease",
  "onlyonce": true,
  "infinite": false
}
```

### Icon Parameters

```json
"icon": {
  "icon": {
    "svg": "<svg>...</svg>",
    "image": ""
  },
  "fill": "currentColor",
  "fillhover": "currentColor",
  "type": "svg"
}
```

**IMPORTANT SVG RULES:**
- WordPress STRIPS stroke/fill attributes from outer `<svg>` element
- For stroke-based icons (Lucide/Feather), put stroke on `<path>` elements:
```json
"icon": {"icon": {"svg": "<svg viewBox=\"0 0 24 24\"><path d=\"...\" stroke=\"currentColor\" stroke-width=\"2\" fill=\"none\"/></svg>"}, "fill": "currentColor", "type": "svg"}
```
- Control icon color via `styleAttributes.color` (inherits to currentColor)
- For solid icons, use `fill="currentColor"` in icon parameter

## styleAttributes Properties

### Sizing
- `width`, `height`, `minWidth`, `minHeight`, `maxWidth`, `maxHeight`
- Values: `["100%"]`, `["500px"]`, `["auto"]`

### Spacing
- `padding`, `paddingTop`, `paddingRight`, `paddingBottom`, `paddingLeft`
- `margin`, `marginTop`, `marginRight`, `marginBottom`, `marginLeft`
- `marginBlockStart` (for removing WordPress default margins)
- `gap`, `columnGap`, `rowGap`

### Flexbox
- `display: ["flex"]`
- `flexDirection: ["row"]` or `["column"]`
- `justifyContent: ["center"]`, `["flex-start"]`, `["flex-end"]`, `["space-between"]`
- `alignItems: ["center"]`, `["flex-start"]`, `["flex-end"]`, `["stretch"]`
- `flexWrap: ["wrap"]`
- `flexColumns_Extra`: number of columns
- `flexWidths_Extra`: responsive width configuration

### Typography
- `fontSize`, `fontWeight`, `fontFamily`, `fontStyle`
- `lineHeight`, `letterSpacing`
- `textAlign: ["center"]`, `["left"]`, `["right"]`
- `textTransform: ["uppercase"]`, `["lowercase"]`, `["capitalize"]`
- `textDecoration: ["none"]`, `["underline"]`

### Colors & Background
- `color`, `backgroundColor`
- `backgroundImage: ["url(...)"]` or `["linear-gradient(...)"]`
- `backgroundPosition`, `backgroundSize`, `backgroundRepeat`
- `imageGradient_Extra: true` (for gradients)
- `backgroundClip: ["text"]` (for text gradients)

### Borders
- `borderRadius`, `borderTopLeftRadius`, etc.
- `borderRadiusLink_Extra: true` (link all corners)
- `borderWidth`, `borderStyle`, `borderColor`

### Effects
- `boxShadow`, `boxShadow_hover`
- `opacity`
- `transform`, `transform_hover`
- `transition`
- `filter`

### Position
- `position: ["relative"]`, `["absolute"]`, `["fixed"]`
- `top`, `right`, `bottom`, `left`
- `zIndex`

### Visual
- `overflow: ["hidden"]`
- `objectFit: ["cover"]`, `["contain"]`
- `objectPosition`
- `aspectRatio: ["16/9"]`, `["4/3"]`, `["1/1"]`

### Pseudo States (add suffix)
- `_hover`: `backgroundColor_hover`, `color_hover`
- `_focus`: `borderColor_focus`
- `_active`: `transform_active`

## Common isVariation Values

| Variation | Use Case |
|-----------|----------|
| `contentwrapper` | Full-width section |
| `nocolumncontent` | Centered content area |
| `contentcolumns` | Section with columns |
| `contentarea` | Flex column container |
| `accordion` | Collapsible content |
| `tabs` | Tab interface |
| `counter` | Animated counter |
| `countdown` | Timer |
| `marquee` | Scrolling text |
| `buttoncomponent` | Styled button |
| `videolightbox` | Video popup |
| `divtext` | Simple text div |

## Responsive Array Order

```json
["desktop", "tablet", "mobile_landscape", "mobile_portrait"]
```

Examples:
```json
"fontSize": ["3rem", "2.5rem", "2rem", "1.5rem"]
"width": ["50%", "50%", "100%", "100%"]
"display": ["flex", "flex", "none", "none"]
```

## Unicode Escapes for JSON

- `--` = `\u002d\u002d`
- `<` = `\u003c`
- `>` = `\u003e`
- `"` = `\u0022`

Example:
```json
"paddingTop": ["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dspacing\u002d\u002d60)"]
```

## WordPress Auto-Modifications

WordPress/Greenshift automatically modifies output:

| What | Behavior |
|------|----------|
| `<img>` width/height | Must match `originalWidth`/`originalHeight` JSON |
| `<svg>` stroke/fill | STRIPPED from outer `<svg>` (put on `<path>`) |
| `<svg>` fill="none" | STRIPPED from outer `<svg>` element |
| HTML comments | STRIPPED (don't use `<!-- comments -->`) |
| JSON param order | Reordered (non-functional) |

**Don't rely on HTML comments for organization - they will be removed. Use `metadata:{"name":"Section Name"}` instead.**

---

## Slider Block Warnings (CRITICAL)

### Image Gallery Slides - Correct Structure

**WRONG - Do NOT use direct images in `slider-image-wrapper`:**
```html
<!-- wp:greenshift-blocks/swipe {"imageurl":"https://placehold.co/600x400","asImage":true,"id":"gsbp-xxx"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-xxx"><div class="slider-overlaybg"></div><div class="slider-image-wrapper"><img src="..." width="100%" height="100%"/></div><div class="slider-content-zone"></div></div></div>
<!-- /wp:greenshift-blocks/swipe -->
```

**CORRECT - Use `greenshift-blocks/element` with `tag:"img"` in `slider-content-zone`:**
```html
<!-- wp:greenshift-blocks/swipe {"imageurl":"","bgContain":false,"id":"gsbp-xxx"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-xxx"><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-img001","tag":"img","localId":"gsbp-img001","src":"https://placehold.co/600x400","alt":"Image description"} -->
<img src="https://placehold.co/600x400" alt="Image description" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe -->
```

### Key Slider Rules

| Rule | Explanation |
|------|-------------|
| `imageurl` must be `""` | Empty string, not actual URL |
| No `slider-overlaybg` div | Remove from HTML structure |
| No `slider-image-wrapper` div | Remove from HTML structure |
| Add `bgContain:false` to swipe JSON | Required parameter |
| Use element block for images | `greenshift-blocks/element` with `tag:"img"` |
| No `width="100%" height="100%"` | Don't use percentage dimensions on slide images |

### Required Swiper JSON Parameters for Gallery Effect

```json
{
  "slidesPerView": [4, null, null, null],
  "slidesPerGroup": [1],
  "backgroundGradient": null,
  "autoplayRestore": true,
  "disablePause": true,
  "arrowsOnHover": true,
  "navpostopArray": ["48%"],
  "bgContain": false,
  "navSize": [20, null, null, null],
  "navSpaceSize": [10, null, null, null],
  "scaleAmount": 80,
  "navshadow": false,
  "effect": "scale",
  "overflow": true,
  "linearmode": true,
  "autoHeight": true
}
```

---

## Page Structure Requirements

### Page Wrapper (Required for Multi-Section Pages)

All multi-section pages MUST be wrapped in a single outer container:

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-page001","type":"inner","localId":"gsbp-page001","align":"full","styleAttributes":{"marginBlockStart":["0px"]},"metadata":{"name":"Page Wrapper"}} -->
<div class="gsbp-page001 alignfull">
  <!-- All sections go here -->
</div>
<!-- /wp:greenshift-blocks/element -->
```

**Why this matters:**
- Eliminates unwanted gaps between sections
- Prevents theme interference with block margins
- Provides unified spacing control

### Section Naming (Instead of HTML Comments)

**WRONG:**
```html
<!-- HERO SECTION -->
<!-- wp:greenshift-blocks/element ... -->
```

**CORRECT:**
```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-hero01","metadata":{"name":"Hero Section"}...} -->
