# Core Block Structure

## 1. Core Block Structure

All Greenshift Element blocks follow this basic structure:

```html
<!-- wp:greenshift-blocks/element {JSON Parameters} -->
<html_tag class="optional classes" ...other_attributes>
  <!-- Inner content (text, other blocks, or empty) -->
</html_tag>
<!-- /wp:greenshift-blocks/element -->
```

### Complete Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-b3c761b","type":"inner","localId":"gsbp-b3c761b","styleAttributes":{"backgroundColor":["#f1f1f1"],"paddingTop":["10px"],"paddingRight":["10px"],"paddingBottom":["10px"],"paddingLeft":["10px"]},"metadata":{"name":"Container"}} -->
<div class="gsbp-b3c761b"><!-- wp:greenshift-blocks/element {"id":"gsbp-e21d5a1","tag":"svg","icon":{"icon":{"svg":"\u003csvg width=\u0022800\u0022 height=\u0022800\u0022 viewBox=\u00220 0 24 24\u0022 fill=\u0022none\u0022 xmlns=\u0022http://www.w3.org/2000/svg\u0022\u003e\u003cpath d=\u0022M16.293 2.293a1 1 0 0 1 1.414 0l4 4a1 1 0 0 1 0 1.414l-13 13A1 1 0 0 1 8 21H4a1 1 0 0 1-1-1v-4a1 1 0 0 1 .293-.707l10-10zM14 7.414l-9 9V19h2.586l9-9zm4 1.172L19.586 7 17 4.414 15.414 6z\u0022 fill=\u0022#0D0D0D\u0022/\u003e\u003c/svg\u003e","image":""},"fill":"currentColor","fillhover":"currentColor","type":"svg"},"localId":"gsbp-e21d5a1","styleAttributes":{"width":["20px"],"height":["20px"]}} -->
<svg viewBox="0 0 24 24" width="800" height="800" class="gsbp-e21d5a1"><path xmlns="http://www.w3.org/2000/svg" d="M16.293 2.293a1 1 0 0 1 1.414 0l4 4a1 1 0 0 1 0 1.414l-13 13A1 1 0 0 1 8 21H4a1 1 0 0 1-1-1v-4a1 1 0 0 1 .293-.707l10-10zM14 7.414l-9 9V19h2.586l9-9zm4 1.172L19.586 7 17 4.414 15.414 6z" fill="#0D0D0D"/></svg>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-ef7ff5f","textContent":"Heading","tag":"h2","className":"gsbp-ef7ff5f","localId":"gsbp-ef7ff5f","styleAttributes":{"marginTop":["0px"]}} -->
<h2 class="gsbp-ef7ff5f gsbp-ef7ff5f">Heading</h2>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-9de47c2","textContent":"My text","className":"gsbp-9de47c2","localId":"gsbp-9de47c2","metadata":{"name":"Text Block"}} -->
<div class="gsbp-9de47c2">My text</div>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-468e94b","textContent":"Simple Link Content","tag":"a","className":"gsbp-468e94b","localId":"gsbp-468e94b","metadata":{"name":"Link"}} -->
<a class="gsbp-468e94b">Simple Link Content</a>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-dc9bea7","tag":"a","type":"inner","localId":"gsbp-dc9bea7","title":"Link as container","metadata":{"name":"Link Element as Container"}} -->
<a title="Link as container"><!-- wp:greenshift-blocks/element {"id":"gsbp-347f4f7","textContent":"Simple text","tag":"span","className":"gsbp-347f4f7","localId":"gsbp-347f4f7"} -->
<span class="gsbp-347f4f7">Simple text</span>
<!-- /wp:greenshift-blocks/element --></a>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-6313bf9","tag":"img","className":"gsbp-6313bf9","localId":"gsbp-6313bf9","src":"https://placehold.co/600x400","alt":"","originalWidth":1024,"originalHeight":1024} -->
<img class="gsbp-6313bf9" src="https://placehold.co/600x400" alt="" width="1024" height="1024" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element -->
```

---

## 2. JSON Parameters

### Block IDs (Required)

-   **`id`**: A unique block identifier (e.g., `"gsbp-b3c761b"`). Starts with `gsbp-` followed by 7 alphanumeric characters.
-   **`localId`**: Must be **identical** to the `id`. Used for internal identification.

### HTML Tag

-   **`tag`**: Specifies the HTML tag for the element (e.g., `"h2"`, `"a"`, `"img"`, `"svg"`).
    -   If omitted, defaults to `"div"`.
    -   For SVG icons, use `tag: "svg"`.
    -   Prefer `tag: "a"` over `tag: "button"` for button-like elements, unless it's part of a form requiring a `<button>`.

Common tags: `"div"`, `"section"`, `"a"`, `"span"`, `"h1"`-`"h6"`, `"p"`, `"img"`, `"svg"`, `"button"`

---

## 3. Block Content (`type`)

Determines how the block's content is handled:

### `type: "text"` - Text Only

For blocks containing only text content.

-   **Requires `textContent` parameter**: The text content must be duplicated in the `textContent` JSON parameter.
-   Allowed HTML within text: `<strong>`, `<em>`.
-   **Example:**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-9de47c2","textContent":"My text","localId":"gsbp-9de47c2"} -->
<div>My text</div>
<!-- /wp:greenshift-blocks/element -->
```

### `type: "inner"` - Container/Nested Blocks

For blocks containing other blocks as children.

-   If a block contains **both** simple text and nested blocks, use `type: "inner"` and wrap the simple text in its own `<span>` element block.
-   **Example:**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-eaf940e","tag":"a","type":"inner","localId":"gsbp-eaf940e"} -->
<a><!-- wp:greenshift-blocks/element {"id":"gsbp-771f6d2","textContent":"Inner block text","tag":"span","localId":"gsbp-771f6d2"} -->
<span>Inner block text</span>
<!-- /wp:greenshift-blocks/element --></a>
<!-- /wp:greenshift-blocks/element -->
```

### `type: "no"` - Empty/Spacer Elements

For blocks with no inner content, typically used as visual spacers or decorative elements defined purely by styles.

-   **Example:**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-e4f5g6h","type":"no","localId":"gsbp-e4f5g6h","styleAttributes":{"height":["1px"],"backgroundColor":["#0000002b"],"width":["100px"]}} -->
<div class="gsbp-e4f5g6h"></div>
<!-- /wp:greenshift-blocks/element -->
```

### `type: "chart"` - Charts

For chart blocks. See [08-variations.md](08-variations.md) for details.

---

## 4. Styling (`styleAttributes`)

### Critical Rules

1. **Never** use inline `style="..."` HTML attribute
2. Property names use **camelCase** (e.g., `backgroundColor`, `paddingTop`)
3. Values are **arrays** for responsive breakpoints
4. If `styleAttributes` exists, `localId` **must** be in HTML `class` attribute

### Define CSS Styles

-   Define CSS styles within the `styleAttributes` object.
-   **Never use the inline `style="..."` HTML attribute.**
-   Property names use **camelCase** (e.g., `backgroundColor`, `paddingTop`).

### Responsive Array Format

Each property is an **array** representing responsive values:

-   `["desktop", "tablet", "mobile_landscape", "mobile_portrait"]`
-   If fewer values are provided, they apply upwards (e.g., `["10px"]` applies to all).
-   If only desktop value provided, use just one value in array, example `["10px"]`. **Do not use** `["10px", null, null, null]` in such cases.

| Values Provided | Behavior |
|-----------------|----------|
| `["10px"]` | Applies to all breakpoints |
| `["20px", "15px"]` | Desktop: 20px, others: 15px |
| `["20px", "15px", "12px", "10px"]` | Each breakpoint specific |

### Pseudo-States

Append suffix to property name:

| Suffix | Purpose |
|--------|---------|
| `_hover` | Hover state |
| `_focus` | Focus state |
| `_active` | Active state |

**Example:**

```json
{
  "styleAttributes": {
    "backgroundColor": ["#000"],
    "backgroundColor_hover": ["#333"],
    "color": ["#fff"],
    "color_hover": ["#ccc"]
  }
}
```

### Required Class

**Required Class**: If a block has `styleAttributes`, its `localId` **must** be added to the HTML element's `class` attribute.

**Example:**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-h456def","textContent":"Welcome","tag":"h2","localId":"gsbp-h456def","styleAttributes":{"fontSize":["24px"],"color":["#333333"]}} -->
<h2 class="gsbp-h456def">Welcome</h2>
<!-- /wp:greenshift-blocks/element -->
```

### Complete Styling Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-h456def","textContent":"Welcome","tag":"h2","localId":"gsbp-h456def","styleAttributes":{"fontSize":["24px","20px","18px","16px"],"color":["#333333"],"marginBottom":["var(--wp--preset--spacing--50, 1.5rem)"]}} -->
<h2 class="gsbp-h456def">Welcome</h2>
<!-- /wp:greenshift-blocks/element -->
```

---

## Other Common Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `className` | String | Custom CSS classes (duplicate in HTML `class`) |
| `anchor` | String | Sets HTML `id` attribute |
| `metadata` | Object | `{"name": "Block Name"}` for editor |
| `align` | String | `"full"`, `"wide"` for alignment |

---

## Example: Full Block

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-abc1234","tag":"section","type":"inner","className":"my-section","localId":"gsbp-abc1234","align":"full","styleAttributes":{"backgroundColor":["#f5f5f5"],"paddingTop":["var(--wp--preset--spacing--80, 5rem)"],"paddingBottom":["var(--wp--preset--spacing--80, 5rem)"]},"metadata":{"name":"Hero Section"}} -->
<section class="my-section gsbp-abc1234 alignfull">
  <!-- nested content -->
</section>
<!-- /wp:greenshift-blocks/element -->
```
