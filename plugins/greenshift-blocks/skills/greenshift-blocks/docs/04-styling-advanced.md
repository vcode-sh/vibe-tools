# Advanced Styling

## Local Classes (`dynamicGClasses`)

Use only when needing styles for complex sub-selectors (e.g., `.class > .child`, `.class::before`, `.class:hover + .sibling`) or pseudo-elements that cannot be handled by `styleAttributes` with `_hover`/`_focus`.

### What are Local Classes?

`dynamicGClasses` is an array of class definition objects that allow you to create complex CSS selectors and styles that go beyond what `styleAttributes` can handle.

### Structure

Each `dynamicGClasses` object contains:

- `value`: The class name (e.g., `"hoverinner"`).
- `label`: Same as `value`.
- `type`: `"local"`.
- `localed`: `false`.
- `css`: String containing the CSS rules for the base class.
- `attributes`: An object containing base styles (like `styleAttributes`).
- `originalID`: Same as the block's `localId`.
- `originalBlock`: `"greenshift-blocks/element"`.
- `selectors`: An array for sub-selector styles. Each object has:
  - `value`: The sub-selector string (e.g., `" a:hover"`).
  - `attributes`: Style object for this sub-selector.
  - `css`: CSS string for this specific sub-selector rule.

### Important Rules

1. The class name (`value`) must also be added to the block's `className` parameter
2. The class name must be added to HTML `class` attribute
3. Include `originalID` matching block's `localId`

### Example: Basic Local Class with Sub-Selector

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-d4deafd","dynamicGClasses":[{"value":"hoverinner","type":"local","label":"hoverinner","localed":false,"css":".hoverinner{color:#ff2525;}","attributes":{"styleAttributes":{"color":["#ff2525"]}},"originalID":"gsbp-d4deafd","originalBlock":"greenshift-blocks/element","selectors":[{"value":" a:hover","attributes":{"styleAttributes":{"fontSize":["22px"],"color":["#da2c2c"]}},"css":".hoverinner a:hover{font-size:22px;color:#da2c2c;}"}]}],"type":"inner","className":"hoverinner","localId":"gsbp-d4deafd"} -->
<div class="hoverinner gsbp-d4deafd"></div>
<!-- /wp:greenshift-blocks/element -->
```

**Generated CSS:**
```css
.hoverinner {
  color: #ff2525;
}

.hoverinner a:hover {
  font-size: 22px;
  color: #da2c2c;
}
```

### Example: Card Hover Effect on Child Elements

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-hover01","dynamicGClasses":[{"value":"card-hover","type":"local","label":"card-hover","localed":false,"css":".card-hover{transition:all 0.3s ease;}","attributes":{"styleAttributes":{"transition":["all 0.3s ease"]}},"originalID":"gsbp-hover01","originalBlock":"greenshift-blocks/element","selectors":[{"value":":hover .card-image","attributes":{"styleAttributes":{"transform":["scale(1.05)"]}},"css":".card-hover:hover .card-image{transform:scale(1.05);}"},{"value":":hover .card-title","attributes":{"styleAttributes":{"color":["#ff0000"]}},"css":".card-hover:hover .card-title{color:#ff0000;}"}]}],"type":"inner","className":"card-hover","localId":"gsbp-hover01"} -->
<div class="card-hover gsbp-hover01">
  <!-- card content with .card-image and .card-title classes -->
</div>
<!-- /wp:greenshift-blocks/element -->
```

**Generated CSS:**
```css
.card-hover {
  transition: all 0.3s ease;
}

.card-hover:hover .card-image {
  transform: scale(1.05);
}

.card-hover:hover .card-title {
  color: #ff0000;
}
```

### Use Cases for Local Classes

Use `dynamicGClasses` when you need:
- `.class > .child` - Direct child selectors
- `.class::before`, `.class::after` - Pseudo-elements
- `.class:hover + .sibling` - Adjacent sibling selectors
- Complex pseudo-elements
- Multiple sub-selectors with different hover states

---

## Gradients

Use `backgroundImage` with `linear-gradient(...)` and set `imageGradient_Extra: true`. For text gradients, also set `backgroundClip: ["text"]` and `color: ["transparent"]`.

### Background Gradient

Apply gradient to element background:

```json
{
  "styleAttributes": {
    "imageGradient_Extra": true,
    "backgroundImage": ["linear-gradient(135deg, #667eea 0%, #764ba2 100%)"]
  }
}
```

**Example:**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-72b293e","type":"inner","localId":"gsbp-72b293e","styleAttributes":{"imageGradient_Extra":true,"backgroundImage":["linear-gradient(70deg,rgb(255,145,36) 0%,rgb(255,0,0) 40%,rgb(238,14,189) 100%)"]}} -->
<div class="gsbp-72b293e"></div>
<!-- /wp:greenshift-blocks/element -->
```

**Full Example with Padding:**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-grad01","type":"inner","localId":"gsbp-grad01","styleAttributes":{"imageGradient_Extra":true,"backgroundImage":["linear-gradient(70deg, rgb(255,145,36) 0%, rgb(255,0,0) 40%, rgb(238,14,189) 100%)"],"padding":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dspacing\u002d\u002d80)"]}} -->
<div class="gsbp-grad01">
  <!-- content -->
</div>
<!-- /wp:greenshift-blocks/element -->
```

### Text Gradient

Apply gradient to text (clipped to text shape):

```json
{
  "styleAttributes": {
    "imageGradient_Extra": true,
    "backgroundImage": ["linear-gradient(135deg, rgb(122,220,180) 0%, rgb(0,208,130) 100%)"],
    "backgroundClip": ["text"],
    "color": ["transparent"]
  }
}
```

**Example:**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-1234567","textContent":"Design Without Limits","tag":"h1","localId":"gsbp-1234567","styleAttributes":{"imageGradient_Extra":true,"backgroundImage":["linear-gradient(135deg,rgb(122,220,180) 0%,rgb(0,208,130) 100%)"],"backgroundClip":["text"],"color":["transparent"]}} -->
<h1 class="gsbp-1234567">Design Without Limits</h1>
<!-- /wp:greenshift-blocks/element -->
```

**Full Example with Font Size:**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-grad02","textContent":"Gradient Text","tag":"h1","localId":"gsbp-grad02","styleAttributes":{"imageGradient_Extra":true,"backgroundImage":["linear-gradient(135deg, #667eea 0%, #764ba2 100%)"],"backgroundClip":["text"],"color":["transparent"],"fontSize":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dfont-size\u002d\u002dgiant)"]}} -->
<h1 class="gsbp-grad02">Gradient Text</h1>
<!-- /wp:greenshift-blocks/element -->
```

### Gradient Syntax

**Linear Gradient:**
```css
linear-gradient(angle, color stop%, color stop%, ...)
```

**Common Angles:**
- `0deg` - Bottom to top
- `90deg` - Left to right
- `180deg` - Top to bottom
- `135deg` - Diagonal
- `70deg` - Custom angle

**Color Stops:**
- Use RGB: `rgb(255,145,36)`
- Use HEX: `#667eea`
- Add percentage positions: `0%`, `40%`, `100%`

---

## Background Image

Use `styleAttributes` for all background image configurations. **Do NOT use the old `background` parameter.**

```json
{
  "styleAttributes": {
    "backgroundImage": ["url(https://example.com/image.jpg)"],
    "backgroundPosition": ["center center"],
    "backgroundSize": ["cover"],
    "backgroundRepeat": ["no-repeat"]
  }
}
```

### Background Properties Reference

| Property | Values | Description |
|----------|--------|-------------|
| `backgroundImage` | `["url(...)"]` | Image URL wrapped in `url()` function |
| `backgroundRepeat` | `["repeat"]`, `["no-repeat"]`, `["repeat-x"]`, `["repeat-y"]` | How background repeats |
| `backgroundSize` | `["cover"]`, `["contain"]`, `["200px"]`, `["100% auto"]` | Background size |
| `backgroundAttachment` | `["fixed"]`, `["scroll"]`, `["local"]` | `fixed` = parallax effect |
| `backgroundPosition` | `["center center"]`, `["top left"]`, etc. | Background position |

---

## Background with Parallax Effect

To create a parallax scrolling effect, use `backgroundAttachment: ["fixed"]` in `styleAttributes`:

```json
{
  "styleAttributes": {
    "backgroundImage": ["url(https://example.com/bg.webp)"],
    "backgroundRepeat": ["repeat"],
    "backgroundSize": ["200px"],
    "backgroundAttachment": ["fixed"]
  }
}
```

### Full Section with Parallax Background

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-parallax1","tag":"section","type":"inner","localId":"gsbp-parallax1","align":"full","styleAttributes":{"display":["flex"],"justifyContent":["center"],"flexDirection":["column"],"alignItems":["center"],"paddingRight":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dside, min(3vw, 20px))"],"paddingLeft":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dside, min(3vw, 20px))"],"paddingTop":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dspacing\u002d\u002d80, 5rem)"],"paddingBottom":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dspacing\u002d\u002d80, 5rem)"],"marginBlockStart":["0px"],"backgroundImage":["url(https://example.com/pattern.webp)"],"backgroundRepeat":["repeat"],"backgroundSize":["200px"],"backgroundAttachment":["fixed"]},"isVariation":"contentwrapper"} -->
<section class="gsbp-parallax1 alignfull">
  <!-- Content Area -->
</section>
<!-- /wp:greenshift-blocks/element -->
```

### Important Notes

- **DO NOT** use the old `background` parameter with `parallax: true`
- Always use `styleAttributes` for background configuration
- `backgroundAttachment: ["fixed"]` creates the parallax effect
- Works best with repeating patterns or large cover images

---

## Overlay

### WARNING: Avoid the `overlay` parameter

The `overlay` parameter generates **inline styles** which violates Greenshift best practices:

```html
<!-- BAD - generates inline style -->
<div class="gspb_backgroundOverlay" style="background-color:#000000;opacity:0.4"></div>
```

### Recommended: Use CSS-based overlay

Instead, create overlays using a positioned child element with `styleAttributes`:

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-section1","tag":"section","type":"inner","localId":"gsbp-section1","align":"full","styleAttributes":{"position":["relative"],"backgroundImage":["url(https://example.com/bg.jpg)"],"backgroundSize":["cover"]}} -->
<section class="gsbp-section1 alignfull">
  <!-- Overlay element -->
  <!-- wp:greenshift-blocks/element {"id":"gsbp-overlay1","type":"no","localId":"gsbp-overlay1","styleAttributes":{"position":["absolute"],"top":["0"],"left":["0"],"right":["0"],"bottom":["0"],"backgroundColor":["rgba(0,0,0,0.5)"],"zIndex":["1"]}} -->
  <div class="gsbp-overlay1"></div>
  <!-- /wp:greenshift-blocks/element -->

  <!-- Content on top -->
  <!-- wp:greenshift-blocks/element {"id":"gsbp-content1","type":"inner","localId":"gsbp-content1","styleAttributes":{"position":["relative"],"zIndex":["2"]}} -->
  <div class="gsbp-content1">
    <!-- Your content here -->
  </div>
  <!-- /wp:greenshift-blocks/element -->
</section>
<!-- /wp:greenshift-blocks/element -->
```

### Alternative: Simple background with opacity

For simpler cases, use `backgroundColor` with `rgba()`:

```json
{
  "styleAttributes": {
    "backgroundColor": ["rgba(0, 0, 0, 0.5)"]
  }
}
```

---

## Border Styling

### Individual Borders

```json
{
  "styleAttributes": {
    "borderTopWidth": ["1px"],
    "borderTopStyle": ["solid"],
    "borderTopColor": ["#e0e0e0"],
    "borderBottomWidth": ["2px"],
    "borderBottomStyle": ["solid"],
    "borderBottomColor": ["#000"]
  }
}
```

### Border Radius

```json
{
  "styleAttributes": {
    "borderRadius": ["var(--wp--custom--border-radius--medium, 15px)"]
  }
}
```

Or individual corners:
```json
{
  "styleAttributes": {
    "borderTopLeftRadius": ["20px"],
    "borderTopRightRadius": ["20px"],
    "borderBottomLeftRadius": ["0px"],
    "borderBottomRightRadius": ["0px"],
    "borderRadiusLink_Extra": false
  }
}
```

---

## Box Shadow

```json
{
  "styleAttributes": {
    "boxShadow": ["var(--wp--preset--shadow--soft)"],
    "boxShadow_hover": ["var(--wp--preset--shadow--accent)"]
  }
}
```

Custom shadow:
```json
{
  "styleAttributes": {
    "boxShadow": ["0 10px 40px rgba(0,0,0,0.1)"]
  }
}
```

---

## Transform

```json
{
  "styleAttributes": {
    "transform": ["translateY(0)"],
    "transform_hover": ["translateY(-10px)"]
  }
}
```

---

## Filter Effects

```json
{
  "styleAttributes": {
    "filter": ["blur(0px)"],
    "filter_hover": ["blur(2px)"]
  }
}
```

---

## Transition

```json
{
  "styleAttributes": {
    "transition": ["var(--wp--custom--transition--ease, all 0.5s ease)"]
  }
}
```
