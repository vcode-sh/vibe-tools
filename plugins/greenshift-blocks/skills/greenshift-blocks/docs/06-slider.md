# Slider Blocks (Swiper)

Slider blocks use `greenshift-blocks/swiper` and the Swiper.js library. Each slide works as a container and can include other blocks and background images. Slider blocks have extensive configuration options for creating galleries, hero sliders, carousels, and more.

## CRITICAL: Image Gallery Slides

**IMPORTANT:** For image gallery/carousel sliders, use `greenshift-blocks/element` with `tag:"img"` inside the `slider-content-zone`. Do NOT use direct `<img>` in `slider-image-wrapper`.

**WRONG - Do NOT use:**
```html
<!-- wp:greenshift-blocks/swipe {"imageurl":"https://placehold.co/600x400","asImage":true,"id":"gsbp-xxx"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-xxx"><div class="slider-overlaybg"></div><div class="slider-image-wrapper"><img src="https://placehold.co/600x400" alt="" loading="lazy" width="100%" height="100%"/></div><div class="slider-content-zone"></div></div></div>
<!-- /wp:greenshift-blocks/swipe -->
```

**CORRECT - Use this pattern:**
```html
<!-- wp:greenshift-blocks/swipe {"imageurl":"","bgContain":false,"id":"gsbp-xxx"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-xxx"><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-img001","tag":"img","localId":"gsbp-img001","src":"https://placehold.co/600x400","alt":"Image description"} -->
<img src="https://placehold.co/600x400" alt="Image description" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe -->
```

**Key differences:**
- `imageurl` must be empty string `""`
- Remove `slider-overlaybg` and `slider-image-wrapper` divs
- Use `greenshift-blocks/element` with `tag:"img"` inside `slider-content-zone`
- Do NOT use `width="100%" height="100%"` on img tags
- Add `bgContain:false` to swipe JSON

---

## Basic Structure

```html
<!-- wp:greenshift-blocks/swiper {"id":"gsbp-2867323"} -->
<div class="wp-block-greenshift-blocks-swiper gs-swiper gspb_slider-id-gsbp-2867323" style="position:relative"><div class="gs-swiper-init" data-slidesperview="1" data-spacebetween="10" data-spacebetweenmd="10" data-spacebetweensm="10" data-spacebetweenxs="10" data-speed="400" data-loop="false" data-vertical="false" data-verticalheight="500px" data-autoheight="false" data-grabcursor="false" data-freemode="false" data-centered="false" data-autoplay="false" data-autodelay="4000" data-effect="" data-coverflowshadow="false"><div class="swiper"><div class="swiper-wrapper"><!-- Slides go here --></div></div><div class="swiper-pagination"></div><div class="swiper-button-prev"></div><div class="swiper-button-next"></div><div class="swiper-scrollbar"></div></div></div>
<!-- /wp:greenshift-blocks/swiper -->
```

The basic structure includes:
- Outer wrapper with unique ID
- `gs-swiper-init` container with data attributes for configuration
- `swiper` and `swiper-wrapper` divs
- Navigation elements (pagination, arrows, scrollbar)

---

## Slide Structure (greenshift-blocks/swipe)

Each slide uses `greenshift-blocks/swipe`. For image gallery slides, place images inside `slider-content-zone` using `greenshift-blocks/element`:

```html
<!-- wp:greenshift-blocks/swipe {"imageurl":"","bgContain":false,"id":"gsbp-316c7ed"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-316c7ed"><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-2a80cc3","tag":"img","localId":"gsbp-2a80cc3","src":"https://placehold.co/600x400","alt":"Image description"} -->
<img src="https://placehold.co/600x400" alt="Image description" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe -->
```

**Slide Structure Components:**
- `swiper-slide` - Outer slide wrapper
- `swiper-slide-inner` - Inner wrapper with unique ID
- `slider-content-zone` - Container for nested content blocks (images, text, etc.)

---

## Key Slider Parameters

### Essential Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | String | Unique slider ID (e.g., `"gsbp-2867323"`) |
| `tabs` | Number | Number of slides (integer) |
| `slidesPerView` | Array | Responsive slides visible `[desktop, tablet, mobile_landscape, mobile_portrait]` |
| `spaceBetween` | Array | Responsive gap between slides in pixels |
| `speed` | Number | Transition speed in milliseconds (default: 400) |
| `loop` | Boolean | Enable infinite loop |

### Navigation Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `navigationarrows` | Boolean | Show prev/next navigation arrows |
| `bullets` | Boolean | Show pagination dots |
| `scrollbar` | Boolean | Show scrollbar navigation |
| `clicktoslide` | Boolean | Enable click-to-slide functionality |
| `enableKeyboard` | Boolean | Enable keyboard navigation (arrow keys) |
| `enableMousewheel` | Boolean | Enable mousewheel navigation |

### Autoplay Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `autoplay` | Boolean | Enable automatic sliding |
| `autodelay` | Number | Delay between autoplay transitions in milliseconds (default: 4000) |

### Layout Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `centered` | Boolean | Center the active slide |
| `freemode` | Boolean | Enable free mode for momentum-based sliding |
| `vertical` | Boolean | Enable vertical sliding direction |
| `autoHeight` | Boolean | Auto-adjust height based on slide content |

### Effect Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `effect` | String | Slide effect type (fade, cube, coverflow, flip, etc.) |
| `parallax_enable` | Boolean | Enable parallax effects on slide content |
| `kenBurnsEnable` | Boolean | Enable Ken Burns zoom effect on images |
| `coverflowshadow` | Boolean | Enable shadow for coverflow effect |

---

## Slide Parameters (greenshift-blocks/swipe)

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | String | Unique slide ID (e.g., `"gsbp-316c7ed"`) |
| `imageurl` | String | Background image URL |
| `imageid` | Number | WordPress media library ID |
| `imagealt` | String | Image alt text |
| `asImage` | Boolean | Display as background image |

---

## Complete Image Gallery Slider Example

Here's a complete image gallery slider with correct structure:

```html
<!-- wp:greenshift-blocks/swiper {"id":"gsbp-gallery01","tabs":4,"slidesPerView":[4,null,null,null],"slidesPerGroup":[1],"backgroundGradient":null,"loop":true,"autoplay":true,"autoplayRestore":true,"disablePause":true,"autodelay":3000,"arrowsOnHover":true,"navpostopArray":["48%"],"bgContain":false,"navSize":[20,null,null,null],"navSpaceSize":[10,null,null,null],"scaleAmount":80,"navshadow":false,"bullets":false,"effect":"scale","overflow":true,"centered":true,"linearmode":true,"autoHeight":true} -->
<div class="wp-block-greenshift-blocks-swiper gs-swiper gspb_slider-id-gsbp-gallery01" style="position:relative"><div class="gs-swiper-init" data-slidesperview="4" data-slidespergroup="1" data-spacebetween="10" data-spacebetweenmd="10" data-spacebetweensm="10" data-spacebetweenxs="10" data-speed="400" data-disablepause="true" data-loop="true" data-vertical="false" data-verticalheight="500px" data-autoheight="true" data-grabcursor="false" data-freemode="false" data-centered="true" data-autoplay="true" data-autodelay="3000" data-effect="scale" data-coverflowshadow="false" data-autoplayrestore="true"><div class="swiper"><div class="swiper-wrapper"><!-- wp:greenshift-blocks/swipe {"imageurl":"","bgContain":false,"id":"gsbp-slide01"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-slide01"><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-img01","tag":"img","localId":"gsbp-img01","src":"https://placehold.co/600x400","alt":"Gallery image 1"} -->
<img src="https://placehold.co/600x400" alt="Gallery image 1" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe -->

<!-- wp:greenshift-blocks/swipe {"imageurl":"","bgContain":false,"id":"gsbp-slide02"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-slide02"><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-img02","tag":"img","localId":"gsbp-img02","src":"https://placehold.co/600x400","alt":"Gallery image 2"} -->
<img src="https://placehold.co/600x400" alt="Gallery image 2" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe -->

<!-- wp:greenshift-blocks/swipe {"imageurl":"","bgContain":false,"id":"gsbp-slide03"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-slide03"><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-img03","tag":"img","localId":"gsbp-img03","src":"https://placehold.co/600x400","alt":"Gallery image 3"} -->
<img src="https://placehold.co/600x400" alt="Gallery image 3" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe -->

<!-- wp:greenshift-blocks/swipe {"imageurl":"","bgContain":false,"id":"gsbp-slide04"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-slide04"><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-img04","tag":"img","localId":"gsbp-img04","src":"https://placehold.co/600x400","alt":"Gallery image 4"} -->
<img src="https://placehold.co/600x400" alt="Gallery image 4" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe --></div></div><div class="swiper-pagination"></div><div class="swiper-button-prev"></div><div class="swiper-button-next"></div><div class="swiper-scrollbar"></div></div></div>
<!-- /wp:greenshift-blocks/swiper -->
```

**Required JSON Parameters for Gallery Effect:**
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

## Additional Examples

### Simple Image Gallery Slider

A responsive image gallery with navigation and pagination (correct structure):

```html
<!-- wp:greenshift-blocks/swiper {"id":"gsbp-gallery02","tabs":3,"slidesPerView":[3,2,1,1],"spaceBetween":[20,15,10,10],"loop":true,"navigationarrows":true,"bullets":true} -->
<div class="wp-block-greenshift-blocks-swiper gs-swiper gspb_slider-id-gsbp-gallery02" style="position:relative"><div class="gs-swiper-init" data-slidesperview="3" data-slidesperviewmd="2" data-slidesperviewsm="1" data-slidesperviewxs="1" data-spacebetween="20" data-spacebetweenmd="15" data-spacebetweensm="10" data-spacebetweenxs="10" data-loop="true"><div class="swiper"><div class="swiper-wrapper"><!-- wp:greenshift-blocks/swipe {"imageurl":"","bgContain":false,"id":"gsbp-sld01"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-sld01"><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-gimg01","tag":"img","localId":"gsbp-gimg01","src":"https://placehold.co/600x400","alt":"Image 1"} -->
<img src="https://placehold.co/600x400" alt="Image 1" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe -->

<!-- wp:greenshift-blocks/swipe {"imageurl":"","bgContain":false,"id":"gsbp-sld02"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-sld02"><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-gimg02","tag":"img","localId":"gsbp-gimg02","src":"https://placehold.co/600x400","alt":"Image 2"} -->
<img src="https://placehold.co/600x400" alt="Image 2" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe -->

<!-- wp:greenshift-blocks/swipe {"imageurl":"","bgContain":false,"id":"gsbp-sld03"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-sld03"><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-gimg03","tag":"img","localId":"gsbp-gimg03","src":"https://placehold.co/600x400","alt":"Image 3"} -->
<img src="https://placehold.co/600x400" alt="Image 3" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe --></div></div><div class="swiper-pagination"></div><div class="swiper-button-prev"></div><div class="swiper-button-next"></div><div class="swiper-scrollbar"></div></div></div>
<!-- /wp:greenshift-blocks/swiper -->
```

### Hero Slider with Content Overlay

A full-width hero slider with text content and automatic transitions. Note: For hero sliders with background images AND text overlay, you can use the background image approach with content in `slider-content-zone`:

```html
<!-- wp:greenshift-blocks/swiper {"id":"gsbp-hero01","tabs":2,"slidesPerView":[1,1,1,1],"loop":true,"autoplay":true,"autodelay":5000,"navigationarrows":true,"bullets":true} -->
<div class="wp-block-greenshift-blocks-swiper gs-swiper gspb_slider-id-gsbp-hero01" style="position:relative"><div class="gs-swiper-init" data-slidesperview="1" data-autoplay="true" data-autodelay="5000" data-loop="true"><div class="swiper"><div class="swiper-wrapper"><!-- wp:greenshift-blocks/swipe {"imageurl":"","bgContain":false,"id":"gsbp-herosl01"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-herosl01"><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-herobg01","type":"inner","localId":"gsbp-herobg01","styleAttributes":{"position":["relative"],"minHeight":["500px"],"display":["flex"],"alignItems":["center"],"justifyContent":["center"],"backgroundImage":["url(https://placehold.co/1920x1080)"],"backgroundSize":["cover"],"backgroundPosition":["center"]}} -->
<div class="gsbp-herobg01"><!-- wp:greenshift-blocks/element {"id":"gsbp-overlay01","type":"inner","localId":"gsbp-overlay01","styleAttributes":{"position":["absolute"],"top":["0"],"left":["0"],"right":["0"],"bottom":["0"],"backgroundColor":["rgba(0,0,0,0.4)"]}} -->
<div class="gsbp-overlay01"></div>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-herotext01","textContent":"Slide Title","tag":"h2","localId":"gsbp-herotext01","styleAttributes":{"position":["relative"],"zIndex":["1"],"color":["#fff"],"fontSize":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dfont-size\u002d\u002dgiant)"],"textAlign":["center"]}} -->
<h2 class="gsbp-herotext01">Slide Title</h2>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe --></div></div><div class="swiper-pagination"></div><div class="swiper-button-prev"></div><div class="swiper-button-next"></div><div class="swiper-scrollbar"></div></div></div>
<!-- /wp:greenshift-blocks/swiper -->
```

---

## Responsive Configuration

Responsive values are configured as arrays with four breakpoints:
- **Index 0**: Desktop (default)
- **Index 1**: Tablet
- **Index 2**: Mobile landscape
- **Index 3**: Mobile portrait

**Example:**
```json
{
  "slidesPerView": [4, 3, 2, 1],
  "spaceBetween": [30, 20, 15, 10]
}
```

This maps to data attributes:
- `data-slidesperview="4"` (desktop)
- `data-slidesperviewmd="3"` (tablet)
- `data-slidesperviewsm="2"` (mobile landscape)
- `data-slidesperviewxs="1"` (mobile portrait)

---

## Advanced Slider Features

### Centered Slides
Center the active slide in view:
```json
{"centered": true}
```

### Free Mode
Enable momentum-based free sliding:
```json
{"freemode": true}
```

### Vertical Slider
Enable vertical sliding direction:
```json
{"vertical": true}
```

### Auto Height
Automatically adjust slider height to match active slide:
```json
{"autoHeight": true}
```

### Parallax Effects
Enable parallax effects on slide content:
```json
{"parallax_enable": true}
```

### Ken Burns Effect
Enable zoom/pan effect on background images:
```json
{"kenBurnsEnable": true}
```

### Keyboard and Mousewheel Navigation
Enable alternative navigation methods:
```json
{
  "enableKeyboard": true,
  "enableMousewheel": true
}
```

---

## Summary

Slider blocks in Greenshift provide powerful, flexible options for creating image galleries, hero sliders, carousels, and content sliders. Key features include:

- Responsive configuration with breakpoint arrays
- Multiple navigation options (arrows, pagination, scrollbar, keyboard, mousewheel)
- Autoplay with configurable delays
- Advanced effects (parallax, Ken Burns, coverflow)
- Full support for nested content blocks
- Background images with overlay options
- Loop, vertical, centered, and free mode options

Each slide works as a container that can include any Greenshift blocks, making sliders highly customizable for any use case.
