# HTML Attributes & Parameters

## Link Attributes

| Parameter | Type | Description | HTML Output |
|-----------|------|-------------|-------------|
| `href` | String | Link URL | `href="..."` |
| `linkNewWindow` | Boolean | Open in new tab | `target="_blank" rel="noopener"` |
| `linkNoFollow` | Boolean | No follow | `rel="nofollow"` |
| `linkSponsored` | Boolean | Sponsored link | `rel="sponsored"` |
| `title` | String | Title attribute | `title="..."` |

### Link Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-abc123","textContent":"Visit Site","tag":"a","localId":"gsbp-abc123","href":"https://example.com","linkNewWindow":true,"linkNoFollow":true} -->
<a class="gsbp-abc123" href="https://example.com" target="_blank" rel="noopener nofollow">Visit Site</a>
<!-- /wp:greenshift-blocks/element -->
```

---

## Image Attributes

| Parameter | Type | Description |
|-----------|------|-------------|
| `src` | String | Image URL |
| `alt` | String | Alt text (accessibility) |
| `originalWidth` | Number | Width in pixels (JSON only) |
| `originalHeight` | Number | Height in pixels (JSON only) |
| `fetchpriority` | String | `"high"` for LCP images |

### Image Rules

1. **Always** add `loading="lazy"` to HTML
2. Use placeholder URLs: `https://placehold.co/WIDTHxHEIGHT`
3. **Do NOT** add `width`/`height` HTML attributes - use `originalWidth`/`originalHeight` in JSON
4. IMG tag should only have: `class`, `src`, `alt`, `loading="lazy"`, `data-aos-*`

### Image Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-img001","tag":"img","localId":"gsbp-img001","src":"https://placehold.co/800x600","alt":"Hero image","originalWidth":800,"originalHeight":600,"styleAttributes":{"width":["100%"],"height":["auto"],"objectFit":["cover"]}} -->
<img class="gsbp-img001" src="https://placehold.co/800x600" alt="Hero image" loading="lazy"/>
<!-- /wp:greenshift-blocks/element -->
```

---

## Video Attributes

| Parameter | Type | Description |
|-----------|------|-------------|
| `src` | String | Video URL |
| `poster` | String | Poster image URL |
| `loop` | Boolean | Loop video |
| `autoplay` | Boolean | Auto start |
| `muted` | Boolean | Muted audio |
| `playsinline` | Boolean | Inline on mobile |
| `controls` | Boolean | Show controls |

### Video Background Object

For background videos, use the `video` parameter object:

```json
{
  "video": {
    "src": "https://example.com/video.mp4",
    "autoplay": true,
    "loop": true,
    "muted": true,
    "playsinline": true,
    "background": true
  }
}
```

---

## Other HTML Attribute Mapping (JSON Parameters)

| Parameter | Type | Description |
|-----------|------|-------------|
| `className` | String | Add custom CSS classes (duplicate in HTML `class` attribute) |
| `anchor` | String | Sets the HTML `id` attribute |
| `href` | String | For links (`<a>` tags) |
| `linkNewWindow` | Boolean | Sets `target="_blank"` and `rel="noopener"` (automatically adds `noopener`) |
| `linkNoFollow` | Boolean | Adds `rel="nofollow"` |
| `linkSponsored` | Boolean | Adds `rel="sponsored"` |
| `src` | String | URL for `<img>`, `<video>`, etc. |
| `alt` | String | Alt text for `<img>` |
| `title` | String | Title attribute |
| `originalWidth` | Number | Sets `width` attribute for media (`<img>`, `<video>`) |
| `originalHeight` | Number | Sets `height` attribute for media (`<img>`, `<video>`) |
| `fetchpriority` | String | For images/assets (e.g., `"high"`) |
| `loop` | Boolean | Loop video |
| `autoplay` | Boolean | Auto start video |
| `muted` | Boolean | Muted audio |
| `playsinline` | Boolean | Inline video on mobile |
| `controls` | Boolean | Show video controls |
| `poster` | String | URL for video poster image |
| `colSpan` | Number | Column span for `<td>`, `<th>` |
| `rowSpan` | Number | Row span for `<td>`, `<th>` |

---

## Form Attributes (`formAttributes`)

Use for form elements. The `type` attribute must be inside `formAttributes`, not main JSON.

| Parameter | Description |
|-----------|-------------|
| `type` | `"button"`, `"submit"`, `"text"`, `"email"`, etc. |
| `name` | Form field name |
| `placeholder` | Placeholder text |
| `required` | Boolean |

### Form Attributes Rules

- Use the `formAttributes` object for HTML form element attributes.
- Crucially, place the `type` attribute (e.g., `"button"`, `"submit"`) inside this object, not directly in the main JSON parameters.

### Button Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-btn001","textContent":"Submit","tag":"button","localId":"gsbp-btn001","type":"text","formAttributes":{"type":"submit"}} -->
<button type="submit">Submit</button>
<!-- /wp:greenshift-blocks/element -->
```

### Button Example (type="button")

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-68b48e9","textContent":"Go","tag":"button","localId":"gsbp-68b48e9","type":"text","formAttributes":{"type":"button"}} -->
<button type="button">Go</button>
<!-- /wp:greenshift-blocks/element -->
```

---

## Dynamic Attributes (`dynamicAttributes`)

For custom HTML attributes not covered by specific parameters.

### Rules

- For any HTML attributes not covered by specific JSON parameters.
- Use an array of objects, each with `name` and `value`.

### Syntax

```json
{
  "dynamicAttributes": [
    {"name": "data-type", "value": "scroll"},
    {"name": "data-speed", "value": "0.5"},
    {"name": "aria-label", "value": "Navigation"}
  ]
}
```

### Example with Dynamic Attributes

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-nav001","tag":"nav","type":"inner","localId":"gsbp-nav001","dynamicAttributes":[{"name":"data-type","value":"section-component"},{"name":"aria-label","value":"Main navigation"}]} -->
<nav data-type="section-component" aria-label="Main navigation">
  <!-- content -->
</nav>
<!-- /wp:greenshift-blocks/element -->
```

### Additional Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-example","tag":"div","localId":"gsbp-example","dynamicAttributes":[{"name":"data-type","value":"scroll"}]} -->
<div data-type="scroll">
  <!-- content -->
</div>
<!-- /wp:greenshift-blocks/element -->
```

---

## Icons (`icon` Parameter)

Used with `tag: "svg"` for SVG icons.

### Icon Rules

- Used for SVG icons (`tag: "svg"`).
- Contains an `icon` object with the SVG code (`svg`) or font icon class (`font`).
- **Important**: Remove `xmlns` attributes from `<svg>` and `<path>` tags in final HTML output.

### Icon Structure

```json
{
  "tag": "svg",
  "icon": {
    "icon": {
      "svg": "<svg>...</svg>",
      "image": ""
    },
    "fill": "currentColor",
    "fillhover": "currentColor",
    "type": "svg"
  }
}
```

### Icon Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-icon01","tag":"svg","icon":{"icon":{"svg":"<svg viewBox=\"0 0 24 24\"><path d=\"M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5\"/></svg>","image":""},"fill":"currentColor","fillhover":"#ff0000","type":"svg"},"localId":"gsbp-icon01","styleAttributes":{"width":["24px"],"height":["24px"]}} -->
<svg viewBox="0 0 24 24" class="gsbp-icon01"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>
<!-- /wp:greenshift-blocks/element -->
```

### Additional Icon Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-e21d5a1","tag":"svg","icon":{"icon":{"svg":"<svg width=\"24\" height=\"24\" viewBox=\"0 0 48 48\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M0 0h48v48H0z\"/><path d=\"M24 33a9 9 0 1 0 0-18 9 9 0 0 0 0 18Z\" /></svg>","image":""},"fill":"currentColor","fillhover":"currentColor","type":"svg"},"localId":"gsbp-e21d5a1","styleAttributes":{"width":["20px"],"height":["20px"]}} -->
<svg viewBox="0 0 48 48" width="24" height="24" class="gsbp-e21d5a1"><path d="M0 0h48v48H0z"/><path d="M24 33a9 9 0 1 0 0-18 9 9 0 0 0 0 18Z"/></svg>
<!-- /wp:greenshift-blocks/element -->
```

---

## Table Attributes

| Parameter | Type | Description |
|-----------|------|-------------|
| `colSpan` | Number | Column span for `<td>`, `<th>` |
| `rowSpan` | Number | Row span for `<td>`, `<th>` |

---

## Other Common Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `className` | String | Custom CSS classes |
| `anchor` | String | HTML `id` attribute |
| `metadata` | Object | `{"name": "Block Name"}` |
| `align` | String | `"full"`, `"wide"` |
