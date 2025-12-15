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
