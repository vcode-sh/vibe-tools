## Greenshift/GreenLight Block Creation Instructions

### 1. Core Block Structure

All Greenshift Element blocks follow this basic structure:

```html
<!-- wp:greenshift-blocks/element {JSON Parameters} -->
<html_tag class="optional classes" ...other_attributes>
  <!-- Inner content (text, other blocks, or empty) -->
</html_tag>
<!-- /wp:greenshift-blocks/element -->
```

Example:

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

### 2. JSON Parameters

-   **`id`**: A unique block identifier (e.g., `"gsbp-b3c761b"`). Starts with `gsbp-` followed by 7 alphanumeric characters.
-   **`localId`**: Must be **identical** to the `id`. Used for internal identification.
-   **`tag`**: Specifies the HTML tag for the element (e.g., `"h2"`, `"a"`, `"img"`, `"svg"`).
    -   If omitted, defaults to `"div"`.
    -   For SVG icons, use `tag: "svg"`.
    -   Prefer `tag: "a"` over `tag: "button"` for button-like elements, unless it's part of a form requiring a `<button>`.

### 3. Block Content (`type`)

Determines how the block's content is handled:

-   **`type: "text"`**: For blocks containing only text content.
    -   **Requires `textContent` parameter**: The text content must be duplicated in the `textContent` JSON parameter.
    -   Allowed HTML within text: `<strong>`, `<em>`.
    -   *Example:*
        ```html
        <!-- wp:greenshift-blocks/element {"id":"gsbp-9de47c2","textContent":"My text","localId":"gsbp-9de47c2"} -->
        <div>My text</div>
        <!-- /wp:greenshift-blocks/element -->
        ```

-   **`type: "inner"`**: For blocks containing other blocks as children.
    -   If a block contains *both* simple text and nested blocks, use `type: "inner"` and wrap the simple text in its own `<span>` element block.
    -   *Example:*
        ```html
        <!-- wp:greenshift-blocks/element {"id":"gsbp-eaf940e","tag":"a","type":"inner","localId":"gsbp-eaf940e"} -->
        <a><!-- wp:greenshift-blocks/element {"id":"gsbp-771f6d2","textContent":"Inner block text","tag":"span","localId":"gsbp-771f6d2"} -->
        <span>Inner block text</span>
        <!-- /wp:greenshift-blocks/element --></a>
        <!-- /wp:greenshift-blocks/element -->
        ```

-   **`type: "no"`**: For blocks with no inner content, typically used as visual spacers or decorative elements defined purely by styles.
    -   *Example:*
        ```html
        <!-- wp:greenshift-blocks/element {"id":"gsbp-e4f5g6h","type":"no","localId":"gsbp-e4f5g6h","styleAttributes":{"height":["1px"],"backgroundColor":["#0000002b"],"width":["100px"]}} -->
        <div class="gsbp-e4f5g6h"></div>
        <!-- /wp:greenshift-blocks/element -->
        ```
-   **`type: "chart"`**: For chart blocks.

### 4. Styling (`styleAttributes`)

-   Define CSS styles within the `styleAttributes` object.
-   **Never use the inline `style="..."` HTML attribute.**
-   Property names use **camelCase** (e.g., `backgroundColor`, `paddingTop`).
-   Each property is an **array** representing responsive values:
    -   `["desktop", "tablet", "mobile_landscape", "mobile_portrait"]`
    -   If fewer values are provided, they apply upwards (e.g., `["10px"]` applies to all).
    -   If only desktop value provided, use just one value in array, example `["10px"]`. Do not use `["10px", null, null, null]` in such cases
-   **Pseudo-selectors**: Append `_hover` or `_focus` to the property name (e.g., `backgroundColor_hover`).
-   **Required Class**: If a block has `styleAttributes`, its `localId` **must** be added to the HTML element's `class` attribute.
    -   *Example:*
        ```html
        <!-- wp:greenshift-blocks/element {"id":"gsbp-h456def","textContent":"Welcome","tag":"h2","localId":"gsbp-h456def","styleAttributes":{"fontSize":["24px"],"color":["#333333"]}} -->
        <h2 class="gsbp-h456def">Welcome</h2>
        <!-- /wp:greenshift-blocks/element -->
        ```

### 5. Other HTML Attribute Mapping (JSON Parameters)

-   **`className`**: (String) Add custom CSS classes. Duplicate the classes in the HTML `class` attribute.
-   **`anchor`**: (String) Sets the HTML `id` attribute.
-   **`href`**: (String) For links (`<a>` tags).
-   **`linkNewWindow: true`**: Sets `target="_blank"` and `rel="noopener"` (automatically add `noopener`).
-   **`linkNoFollow: true`**: Adds `rel="nofollow"`.
-   **`linkSponsored: true`**: Adds `rel="sponsored"`.
-   **`src`**: (String) URL for `<img>`, `<video>`, etc.
-   **`alt`**: (String) Alt text for `<img>`.
-   **`title`**: (String) Title attribute.
-   **`originalWidth`, `originalHeight`**: (Number) Sets `width` and `height` attributes for media (`<img>`, `<video>`).
-   **`fetchpriority`**: (String, e.g., `"high"`) For images/assets.
-   **Video Attributes**: `loop`, `autoplay`, `muted`, `playsinline`, `controls` (all boolean).
-   **`poster`**: (String) URL for video poster image.
-   **Table Attributes**: `colSpan`, `rowSpan` (Number) for `<td>`, `<th>`.

### 6. Form Attributes (`formAttributes`)

-   Use the `formAttributes` object for HTML form element attributes.
-   Crucially, place the `type` attribute (e.g., `"button"`, `"submit"`) inside this object, not directly in the main JSON parameters.
    -   *Example (Button):*
        ```html
        <!-- wp:greenshift-blocks/element {"id":"gsbp-68b48e9","textContent":"Go","tag":"button","localId":"gsbp-68b48e9","type":"text","formAttributes":{"type":"button"}} -->
        <button type="button">Go</button>
        <!-- /wp:greenshift-blocks/element -->
        ```

### 7. Dynamic Attributes (`dynamicAttributes`)

-   For any HTML attributes not covered by specific JSON parameters.
-   Use an array of objects, each with `name` and `value`.
    -   *Example:* `dynamicAttributes: [{"name":"data-type","value":"scroll"}]`

### 8. Icons (`icon`)

-   Used for SVG icons (`tag: "svg"`).
-   Contains an `icon` object with the SVG code (`svg`) or font icon class (`font`).
    -   *Example:*
        ```html
        <!-- wp:greenshift-blocks/element {"id":"gsbp-e21d5a1","tag":"svg","icon":{"icon":{"svg":"\u003csvg width=\u002224\u0022 height=\u002224\u0022 viewBox=\u00220 0 48 48\u0022 xmlns=\u0022http://www.w3.org/2000/svg\u0022\u003e\u003cpath d=\u0022M0 0h48v48H0z\u0022/\u003e\u003cpath d=\u0022M24 33a9 9 0 1 0 0-18 9 9 0 0 0 0 18Z\u0022 /\u003e\u003c/svg\u003e","image":""},"fill":"currentColor","fillhover":"currentColor","type":"svg"},"localId":"gsbp-e21d5a1","styleAttributes":{"width":["20px"],"height":["20px"]}} -->
        <svg viewBox="0 0 48 48" width="24" height="24" class="gsbp-e21d5a1"><path xmlns="http://www.w3.org/2000/svg" d="M0 0h48v48H0z"/><path xmlns="http://www.w3.org/2000/svg" d="M24 33a9 9 0 1 0 0-18 9 9 0 0 0 0 18Z"/></svg>
        <!-- /wp:greenshift-blocks/element -->
        ```
-   **Note:** Remove `xmlns` attributes from the `<svg>` and `<path>` tags in the final HTML output.

### 9. Advanced Styling: Local Classes (`dynamicGClasses`)

-   Use only when needing styles for complex sub-selectors (e.g., `.class > .child`, `.class::before`, `.class:hover + .sibling`) or pseudo-elements that cannot be handled by `styleAttributes` with `_hover`/`_focus`.
-   `dynamicGClasses` is an array of class definition objects.
-   Each object contains:
    -   `value`: The class name (e.g., `"hoverinner"`).
    -   `label`: Same as `value`.
    -   `type`: `"local"`.
    -   `localed`: `false`.
    -   `css`: String containing the CSS rules for the base class.
    -   `attributes`: An object containing base styles (like `styleAttributes`).
    -   `originalID`: Same as the block's `localId`.
    -   `originalBlock`: `"greenshift-blocks/element"`.
    -   `selectors`: An array for sub-selector styles. Each object has:
        -   `value`: The sub-selector string (e.g., `" a:hover"`).
        -   `attributes`: Style object for this sub-selector.
        -   `css`: CSS string for this specific sub-selector rule.
-   The class name (`value`) must also be added to the block's `className` parameter and HTML `class` attribute.
    -   *Example:*
        ```html
        <!-- wp:greenshift-blocks/element {"id":"gsbp-d4deafd","dynamicGClasses":[{"value":"hoverinner","type":"local","label":"hoverinner","localed":false,"css":".hoverinner{color:#ff2525;}","attributes":{"styleAttributes":{"color":["#ff2525"]}},"originalID":"gsbp-d4deafd","originalBlock":"greenshift-blocks/element","selectors":[{"value":" a:hover","attributes":{"styleAttributes":{"fontSize":["22px"],"color":["#da2c2c"]}},"css":".hoverinner a:hover{font-size:22px;color:#da2c2c;}"}]}],"type":"inner","className":"hoverinner","localId":"gsbp-d4deafd"} -->
        <div class="hoverinner gsbp-d4deafd"></div>
        <!-- /wp:greenshift-blocks/element -->
        ```

### 10. Layouts & Specific Structures

-   **Columns (e.g., Two Columns):** Use nested Elements with specific `isVariation` flags and flexbox `styleAttributes`.
    -   *Example (Two Columns):* Use `isVariation: "contentcolumns"` on the outer section and `isVariation: "contentarea"` on the inner flex container. Configure `flexColumns_Extra` and `flexWidths_Extra`.

    ```html
    <!-- wp:greenshift-blocks/element {"id":"gsbp-42bdb4c","tag":"section","type":"inner","localId":"gsbp-42bdb4c","align":"full","dynamicAttributes":[{"name":"data-type","value":"section-component"}],"styleAttributes":{"display":["flex"],"justifyContent":["center"],"flexDirection":["column"],"alignItems":["center"],"paddingRight":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dside, min(3vw, 20px))"],"paddingLeft":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dside, min(3vw, 20px))"],"paddingTop":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dtop, 0px)"],"paddingBottom":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dbottom, 0px)"],"marginTop":["0px"],"marginBottom":["0px"],"paddingLink_Extra":"lr","position":["relative"]},"isVariation":"contentcolumns"} -->
    <section class="gsbp-42bdb4c alignfull" data-type="section-component"><!-- wp:greenshift-blocks/element {"id":"gsbp-67dafe8","type":"inner","localId":"gsbp-67dafe8","dynamicAttributes":[{"name":"data-type","value":"content-area-component"}],"styleAttributes":{"maxWidth":["100%"],"width":["var(\u002d\u002dwp\u002d\u002dstyle\u002d\u002dglobal\u002d\u002dwide-size, 1200px)"],"display":["flex"],"flexColumns_Extra":2,"flexWidths_Extra":{"desktop":{"name":"50/50","widths":[50,50]},"tablet":{"name":"50/50","widths":[50,50]},"mobile":{"name":"100/100","widths":[100,100]}},"flexDirection":["row"],"columnGap":["25px"],"rowGap":["25px"],"flexWrap":["wrap"]},"isVariation":"contentarea","metadata":{"name":"Content Area"}} -->
    <div class="gsbp-67dafe8" data-type="content-area-component"><!-- wp:greenshift-blocks/element {"id":"gsbp-2d5265e","type":"inner","localId":"gsbp-2d5265e"} -->
    <div></div>
    <!-- /wp:greenshift-blocks/element -->

    <!-- wp:greenshift-blocks/element {"id":"gsbp-92c0862","type":"inner","localId":"gsbp-92c0862"} -->
    <div></div>
    <!-- /wp:greenshift-blocks/element --></div>
    <!-- /wp:greenshift-blocks/element --></section>
    <!-- /wp:greenshift-blocks/element -->
    ```

 - **Section** For full width sections with centered content use `align: "full"` and next example.
    ```html
    <!-- wp:greenshift-blocks/element {"id":"gsbp-1c2390f","tag":"section","type":"inner","localId":"gsbp-1c2390f","align":"full","dynamicAttributes":[{"name":"data-type","value":"section-component"}],"styleAttributes":{"display":["flex"],"justifyContent":["center"],"flexDirection":["column"],"alignItems":["center"],"paddingRight":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dside, min(3vw, 20px))"],"paddingLeft":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dside, min(3vw, 20px))"],"paddingTop":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dtop, 0px)"],"paddingBottom":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dspacing\u002d\u002dbottom, 0px)"],"marginTop":["0px"],"marginBottom":["0px"],"paddingLink_Extra":"lr","position":["relative"]},"isVariation":"contentwrapper"} -->
    <section class="gsbp-1c2390f alignfull" data-type="section-component"><!-- wp:greenshift-blocks/element {"id":"gsbp-9a9c9e1","type":"inner","localId":"gsbp-9a9c9e1","dynamicAttributes":[{"name":"data-type","value":"content-area-component"}],"styleAttributes":{"maxWidth":["100%"],"width":["var(\u002d\u002dwp\u002d\u002dstyle\u002d\u002dglobal\u002d\u002dwide-size, 1200px)"]},"isVariation":"nocolumncontent","metadata":{"name":"Content Area"}} -->
    <div class="gsbp-9a9c9e1" data-type="content-area-component"></div>
    <!-- /wp:greenshift-blocks/element --></section>
    <!-- /wp:greenshift-blocks/element -->
    ```
    
### 11.Gradients

-   Use `backgroundImage` with `linear-gradient(...)`.
-   Set `imageGradient_Extra: true`.
-   For text gradients, also set `backgroundClip: ["text"]` and `color: ["transparent"]`.
-   *Example (Text Gradient):*
    ```html
    <!-- wp:greenshift-blocks/element {"id":"gsbp-1234567","textContent":"Design Without Limits","tag":"h1","localId":"gsbp-1234567","styleAttributes":{"imageGradient_Extra":true,"backgroundImage":["linear-gradient(135deg,rgb(122,220,180) 0%,rgb(0,208,130) 100%)"],"backgroundClip":["text"],"color":["transparent"]}} -->
    <h1 class="gsbp-1234567">Design Without Limits</h1>
    <!-- /wp:greenshift-blocks/element -->
    ```
-   *Example (Gradient Background):*

  ```html
  <!-- wp:greenshift-blocks/element {"id":"gsbp-72b293e","type":"inner","localId":"gsbp-72b293e","styleAttributes":{"imageGradient_Extra":true,"backgroundImage":["linear-gradient(70deg,rgb(255,145,36) 0%,rgb(255,0,0) 40%,rgb(238,14,189) 100%)"]}} -->
  <div class="gsbp-72b293e"></div>
  <!-- /wp:greenshift-blocks/element -->
  ```

### 12.Scripts

-   If you need to use scripts, use native support for blocks inside attributes `customJs` and `customJsEnabled` parameters.
-   If user asked to make GSAP script, use import gsap from "{{PLUGIN_URL}}/libs/motion/gsap.js";

-   *Example:*
    ```html
    <!-- wp:greenshift-blocks/element {"id":"gsbp-dfc6b73","textContent":"block with some script","localId":"gsbp-dfc6b73","isVariation":"divtext","customJs":"import gsap from \u0022{{PLUGIN_URL}}/libs/motion/gsap.js\u0022;\nconsole.log('test');","customJsEnabled":true} -->
    <div>block with some script</div>
    <!-- /wp:greenshift-blocks/element -->
    ```

### 13.Animations (`styleAttributes`)

-   Define keyframes using `animation_keyframes_Extra`: An array of objects, each with `name` (e.g., `"gs_3450"`) and `code` (CSS keyframe string).
-   Apply animation using `animation`: Array, e.g., `["gs_3450 3s infinite"]`.
-   **Scroll Animations:**
    -   Use `animationTimeline: ["view()"]`.
    -   Optionally use `animationRange: ["entry"]` or define ranges within the keyframe `code` (e.g., `entry 0%`, `exit 100%`).
    -   *Example (Scroll Triggered Fade/Scale):*
        ```html
        <!-- wp:greenshift-blocks/element {"id":"gsbp-2a59759","textContent":"Scroll Animate","tag":"h2","localId":"gsbp-2a59759","styleAttributes":{"animation_keyframes_Extra":[{"name":"gs_9751","code":"0%{opacity: 0;scale:0.7;}100%{opacity: 1;scale:1;}"}],"animation":["gs_9751 linear both"],"animationTimeline":["view()"],"animationRange":["entry"]}} -->
        <h2 class="gsbp-2a59759">Scroll Animate</h2>
        <!-- /wp:greenshift-blocks/element -->
        ```

### 14.Slider Blocks (`greenshift-blocks/swiper`)

Slider blocks use the Swiper.js library and have extensive configuration options. Each slide is working as container and can include other blocks and background image. The basic structure includes:

```html
<!-- wp:greenshift-blocks/swiper {"id":"gsbp-2867323"} -->
<div class="wp-block-greenshift-blocks-swiper gs-swiper gspb_slider-id-gsbp-2867323" style="position:relative"><div class="gs-swiper-init" data-slidesperview="1" data-spacebetween="10" data-spacebetweenmd="10" data-spacebetweensm="10" data-spacebetweenxs="10" data-speed="400" data-loop="false" data-vertical="false" data-verticalheight="500px" data-autoheight="false" data-grabcursor="false" data-freemode="false" data-centered="false" data-autoplay="false" data-autodelay="4000" data-effect="" data-coverflowshadow="false"><div class="swiper"><div class="swiper-wrapper"><!-- wp:greenshift-blocks/swipe {"imageurl":"https://placehold.co/600x400","imageid":14192,"imagealt":"","asImage":true,"id":"gsbp-316c7ed"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-316c7ed"><div class="slider-overlaybg"></div><div class="slider-image-wrapper"><img src="https://placehold.co/600x400" alt="" loading="lazy" class="wp-image-14192" width="100%" height="100%"/></div><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-2a80cc3","textContent":"I am content of slider 1","localId":"gsbp-2a80cc3","isVariation":"divtext"} -->
<div>I am content of slider 1</div>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe -->

<!-- wp:greenshift-blocks/swipe {"imageurl":"https://placehold.co/600x400","imagealt":"","imageid":13743,"asImage":true,"id":"gsbp-719fec0"} -->
<div class="swiper-slide"><div class="wp-block-greenshift-blocks-swipe swiper-slide-inner gspb_sliderinner-id-gsbp-719fec0"><div class="slider-overlaybg"></div><div class="slider-image-wrapper"><img src="https://placehold.co/600x400" alt="" loading="lazy" class="wp-image-13743" width="100%" height="100%"/></div><div class="slider-content-zone"><!-- wp:greenshift-blocks/element {"id":"gsbp-63e9af8","textContent":"I am content of Slider 2","localId":"gsbp-63e9af8","isVariation":"divtext"} -->
<div>I am content of Slider 2</div>
<!-- /wp:greenshift-blocks/element --></div></div></div>
<!-- /wp:greenshift-blocks/swipe --></div></div><div class="swiper-pagination"></div><div class="swiper-button-prev"></div><div class="swiper-button-next"></div><div class="swiper-scrollbar"></div></div></div>
<!-- /wp:greenshift-blocks/swiper -->
```

**Key Slider Parameters:**

-   **`tabs`**: Number of slides (integer)
-   **`slidesPerView`**: Array of responsive values for slides per view `[desktop, tablet, mobile_landscape, mobile_portrait]`
-   **`spaceBetween`**: Array of responsive spacing between slides
-   **`speed`**: Transition speed in milliseconds
-   **`loop`**: Boolean for infinite loop
-   **`autoplay`**: Boolean for automatic sliding
-   **`autodelay`**: Delay between autoplay transitions in milliseconds
-   **`navigationarrows`**: Boolean to show navigation arrows
-   **`bullets`**: Boolean to show pagination bullets

**Additional Slider Features:**

-   **`centered`**: Center the active slide
-   **`freemode`**: Enable free mode for momentum-based sliding
-   **`vertical`**: Vertical sliding direction
-   **`autoHeight`**: Auto-adjust height based on slide content
-   **`parallax_enable`**: Enable parallax effects on slide content
-   **`kenBurnsEnable`**: Enable Ken Burns zoom effect on images
-   **`scrollbar`**: Show scrollbar navigation
-   **`clicktoslide`**: Enable click-to-slide functionality
-   **`enableKeyboard`**: Enable keyboard navigation
-   **`enableMousewheel`**: Enable mousewheel navigation

### 15. Dynamic Blocks

Dynamic blocks allow you to display content that changes based on post data, user information, site data, and more. Dynamic content is wrapped in `<dynamictext></dynamictext>` tags and configured through the `dynamictext` parameter.

#### Basic Dynamic Block Structure

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-example","textContent":"\u003cdynamictext\u003eHello world!\u003c/dynamictext\u003e","dynamictext":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"post_title"},"localId":"gsbp-example"} -->
<div class="gsbp-example"><dynamictext>Hello world!</dynamictext></div>
<!-- /wp:greenshift-blocks/element -->
```

#### Complete Dynamic Query Grid Example

```html
<!-- wp:greenshift-blocks/querygrid {"id":"gsbp-5ca4fa6", "data_source":"query","query_filters":{"post_type":"post"}, "displayStyle":"custom", "styleAttributesWrapper":{"display":["flex"],"columnGap":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dspacing\u002d\u002d50, 1.5rem)"],"rowGap":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dspacing\u002d\u002d50, 1.5rem)"],"flexWrap":["wrap"],"flexColumns_Extra":4,"flexWidths_Extra":{"desktop":{"name":"25/25/25/25","widths":[25,25,25,25]},"tablet":{"name":"50/50/50/50","widths":[50,50,50,50]},"mobile":{"name":"100/100/100/100","widths":[100,100,100,100]}}},"styleAttributesItem":{"borderBottomLeftRadius":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dborder-radius\u002d\u002dsmall, 10px)"],"borderBottomRightRadius":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dborder-radius\u002d\u002dsmall, 10px)"],"borderTopLeftRadius":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dborder-radius\u002d\u002dsmall, 10px)"],"borderTopRightRadius":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dborder-radius\u002d\u002dsmall, 10px)"],"borderRadiusCustom_Extra":false,"borderRadiusLink_Extra":true}} -->
<!-- wp:greenshift-blocks/element {"id":"gsbp-a6342f9","tag":"a","type":"inner","dynamiclink":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"permalink"},"localId":"gsbp-a6342f9"} -->
<a><!-- wp:greenshift-blocks/element {"id":"gsbp-7a5ed66","tag":"img","type":"inner","dynamiclink":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"post_image"},"localId":"gsbp-7a5ed66","styleAttributes":{"width":["100%"],"height":["180px"],"objectFit":["cover"],"borderBottomLeftRadius":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dborder-radius\u002d\u002dsmall, 10px)"],"borderBottomRightRadius":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dborder-radius\u002d\u002dsmall, 10px)"],"borderTopLeftRadius":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dborder-radius\u002d\u002dsmall, 10px)"],"borderTopRightRadius":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dborder-radius\u002d\u002dsmall, 10px)"],"borderRadiusCustom_Extra":false,"borderRadiusLink_Extra":true}} -->
<img class="gsbp-7a5ed66" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></a>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-10a3f57","textContent":"\u003cdynamictext\u003e\u003c/dynamictext\u003e","dynamictext":{"dynamicEnable":true,"dynamicType":"taxonomyvalue","dynamicSource":"latest_item","dynamicPostType":"post","dynamicPostId":0,"dynamicPostData":"post_title","dynamicTaxonomyValue":"category","dynamicTaxonomyLink":true,"dynamicTaxonomyDivider":", "},"localId":"gsbp-10a3f57","styleAttributes":{"fontSize":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dfont-size\u002d\u002dxs, 0.85rem)"],"lineHeight":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dline-height\u002d\u002dxs, 1.15rem)"],"marginTop":["10px"],"opacity":["0.7"]},"isVariation":"divtext","metadata":{"name":"Taxonomy"}} -->
<div class="gsbp-10a3f57"><dynamictext></dynamictext></div>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-6410c04","tag":"a","type":"inner","dynamiclink":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"permalink"},"localId":"gsbp-6410c04","href":"\u003cdynamictext\u003e\u003c/dynamictext\u003e","styleAttributes":{"textDecoration":["none"]}} -->
<a class="gsbp-6410c04" href="<dynamictext&gt;</dynamictext&gt;"><!-- wp:greenshift-blocks/element {"id":"gsbp-2acd12c","textContent":"\u003cdynamictext\u003eHello world!\u003c/dynamictext\u003e","dynamictext":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"post_title"},"localId":"gsbp-2acd12c","styleAttributes":{"fontSize":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dfont-size\u002d\u002dr, 1.2rem)"],"fontWeight":["600"],"lineHeight":["1.4em"],"marginTop":["8px"],"marginBottom":["0px"]},"isVariation":"divtext","metadata":{"name":"Post Title"}} -->
<div class="gsbp-2acd12c"><dynamictext>Hello world!</dynamictext></div>
<!-- /wp:greenshift-blocks/element --></a>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-d0e8cf8","textContent":"\u003cdynamictext\u003eSeptember 28, 2025\u003c/dynamictext\u003e","tag":"span","dynamictext":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"post_modified"},"localId":"gsbp-d0e8cf8","styleAttributes":{"fontSize":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dfont-size\u002d\u002dxs, 0.85rem)"],"lineHeight":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dline-height\u002d\u002dxs, 1.15rem)"],"opacity":[0.5]}} -->
<span class="gsbp-d0e8cf8"><dynamictext>September 28, 2025</dynamictext></span>
<!-- /wp:greenshift-blocks/element -->
<!-- /wp:greenshift-blocks/querygrid -->
```

#### Query Loop Configuration

For arguments, use the same as available in WP Query as json in query_filters. For wrapper styles, use styleAttributesWrapper and for item style use styleAttributesItem. These attributes except the same parameters as styleAttributes in greenshift-blocks/element block.

#### Dynamic Text Configuration (`dynamictext`)

The `dynamictext` parameter contains all dynamic content configuration:

**Core Parameters:**
-   **`dynamicEnable: true`**: Enables dynamic content functionality
-   **`dynamicType`**: Type of dynamic content (see options below)
-   **`dynamicSource`**: Source selection - `"latest_item"` or `"definite_item"`
-   **`dynamicPostType`**: Post type to query (optional, uses current if empty)
-   **`dynamicPostId`**: Specific post ID (for definite_item source)

#### Available Dynamic Types

**1. Post Data (`dynamicType: "postdata"`)**
-   **`dynamicPostData`** options:
    -   `"post_title"` - Post title
    -   `"post_image"` - Featured image
    -   `"ID"` - Post ID
    -   `"post_date"` - Publish date
    -   `"post_modified"` - Last modified date
    -   `"post_excerpt"` - Post excerpt
    -   `"comment_count"` - Number of comments
    -   `"permalink"` - Post URL
    -   `"fullcontent"` - Full content without formatting
    -   `"fullcontentfilters"` - Formatted content
    -   `"post_author"` - Author name
    -   `"post_name"` - Post slug
    -   `"post_parent_title"` - Parent post title
    -   `"post_parent_link"` - Parent post link

**2. Author Data (`dynamicType: "authordata"`)**
-   **`dynamicAuthorData`** options:
    -   `"display_name"` - Author display name
    -   `"description"` - Author bio
    -   `"user_level"` - User level
    -   `"user_registered"` - Registration date
    -   `"user_email"` - Author email
    -   `"user_login"` - Username
    -   `"user_url"` - Author website
    -   `"user_avatar_url"` - Avatar image URL
    -   `"user_status"` - User status
    -   `"ID"` - Author ID
    -   `"meta"` - Custom author meta (requires `dynamicAuthorField`)

**3. Current User Data (`dynamicType: "user_data"`)**
-   Same options as Author Data but for currently logged-in user

**4. Taxonomy Value (`dynamicType: "taxonomyvalue"`)**
-   **`dynamicTaxonomyValue`**: Taxonomy name (e.g., `"category"`, `"post_tag"`)
-   **`dynamicTaxonomyLink: true`**: Show taxonomy terms as links
-   **`dynamicTaxonomyDivider`**: Separator between terms (e.g., `", "`)

**5. Custom Meta Field (`dynamicType: "custom"`)**
-   **`dynamicField`**: Custom field name or meta key

**6. Taxonomy Meta (`dynamicType: "taxonomy"`)**
-   **`dynamicTaxonomy`**: Taxonomy name
-   **`dynamicTaxonomyField`**: Field to retrieve from taxonomy
-   **`dynamicTaxonomyType`**: Data type (`"name"`, `"description"`, or meta)

**7. Site Data (`dynamicType: "sitedata"`)**
-   **`dynamicSiteData`** options:
    -   `"siteoption"` - WordPress option
    -   `"acfsiteoption"` - ACF site option
    -   `"name"` - Site name
    -   `"description"` - Site description
    -   `"year"` - Current year
    -   `"month"` - Current month
    -   `"today"` - Today's date
    -   `"todayplus1"` - Tomorrow
    -   `"todayplus2"` - Day after tomorrow
    -   `"todayplus3"` - 3 days from now
    -   `"todayplus7"` - 1 week from now
    -   `"querystring"` - URL query parameter
    -   `"transient"` - WordPress transient

**8. Repeater (`dynamicType: "repeater"`)**
-   **`repeaterField`**: Repeater field name
-   Works within repeater contexts

#### Dynamic Link Configuration (`dynamiclink`)

dynamiclink attribute supports the same options as dynamictext. Use dynamiclink for link element and images, video elements.

#### Dynamic Placeholders

Dynamic placeholders can be used in query arguments and text content. Available placeholders:

**Basic Placeholders:**
-   `{{POST_ID}}` - Current post ID
-   `{{POST_TITLE}}` - Current post title
-   `{{POST_URL}}` - Current post URL
-   `{{AUTHOR_ID}}` - Post author ID
-   `{{AUTHOR_NAME}}` - Post author name
-   `{{CURRENT_USER_ID}}` - Logged-in user ID
-   `{{CURRENT_USER_NAME}}` - Logged-in user name
-   `{{CURRENT_OBJECT_ID}}` - Current object ID
-   `{{CURRENT_OBJECT_NAME}}` - Current object name
-   `{{CURRENT_DATE_YMD}}` - Current date (YYYY-MM-DD)
-   `{{CURRENT_DATE_YMD_HMS}}` - Current date and time
-   `{{SITE_URL}}` - Site URL

**Advanced Placeholders:**
-   `{{TIMESTRING:today+10days}}` - Date calculations
-   `{{GET:get_name}}` - URL GET parameters
-   `{{SETTING:option_name}}` - WordPress options
-   `{{META:meta_key}}` - Post meta
-   `{{TERM_META:meta_key}}` - Taxonomy term meta
-   `{{TERM_LINKS:taxonomy}}` - List of links for a post's terms
-   `{{USER_META:meta_key}}` - User meta
-   `{{COOKIE:cookie_name}}` - Cookie values
-   `{{RANDOM:0-100}}` - Random numbers
-   `{{RANDOM:red|blue|green}}` - Random selection

#### Data Formatting (`postprocessor`)

This is used for further processing returned data

Available formatting options:
-   `"textformat"` - Use if returned data has WYSIWYG formatting
-   `"mailto"` - Email links
-   `"tel"` - Convert to Phone links
-   `"postlink"` - Post links
-   `"idtofile"` - Convert ID of file to file link
-   `"idtofileurl"` - Convert ID of file to file URL
-   `"idtoimageurl"` - ID to image URL (full size)
-   `"idtoimageurlthumb"` - ID to image URL (thumbnail)
-   `"ymd"` - Date YYYYMMDD to WordPress date
-   `"ytmd"` - Date yyyy-mm-dd to WordPress date
-   `"unixtowp"` - Unix time to WordPress date
-   `"ymdhis"` - Date Y-m-d H:i:s to WordPress date
-   `"ymdtodiff"` - Date difference with current
-   `"datecustom"` - Custom date format (requires `dateformat`)
-   `"numberformat"` - Number formatting
-   `"numberformatenglish"` - English number formatting
-   `"numeric"` - Only numeric values
-   `"json"` - Array to JSON

#### Additional Parameters

-   **`fallbackValue`**: Fallback text when no data is found
-   **`avatarSize`**: Avatar size for user avatars
-   **`dynamicPostImageSize`**: Image size for post images
-   **`dateformat`**: Custom date format string


### Preset / Interactive Blocks (`isVariation`)

There are some special interactive blocks that have additional rules and attributes.

**Video block**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-74e2fe8","tag":"video","localId":"gsbp-74e2fe8","src":"http://example.com/caira.mp4","alt":"","originalWidth":360,"originalHeight":360,"loop":true,"controls":true} -->
<video loop controls><source src="http://wp-test.local/wp-content/uploads/2024/10/caira.mp4" type="video/mp4"/></video>
<!-- /wp:greenshift-blocks/element -->
```

**Audio block**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-cedda2e","dynamicGClasses":[{"value":"gs_audio_171","type":"local","label":"gs_audio_171","localed":false,"css":"","attributes":{"styleAttributes":{}},"originalBlock":"greenshift-blocks/element","selectors":[{"value":"::-webkit-media-controls-panel","attributes":{},"css":""},{"value":"::-webkit-media-controls-mute-button","attributes":{},"css":""},{"value":"::-webkit-media-controls-play-button","attributes":{},"css":""},{"value":"::-webkit-media-controls-timeline-container","attributes":{},"css":""},{"value":"::-webkit-media-controls-current-time-display","attributes":{},"css":""},{"value":"::-webkit-media-controls-time-remaining-display","attributes":{},"css":""},{"value":"::-webkit-media-controls-timeline","attributes":{},"css":""},{"value":"::-webkit-media-controls-volume-slider-container","attributes":{},"css":""},{"value":"::-webkit-media-controls-volume-slider","attributes":{},"css":""},{"value":"::-webkit-media-controls-seek-back-button","attributes":{},"css":""},{"value":"::-webkit-media-controls-seek-forward-button","attributes":{},"css":""},{"value":"::-webkit-media-controls-rewind-button","attributes":{},"css":""},{"value":"::-webkit-media-controls-return-to-realtime-button","attributes":{},"css":""},{"value":"::-webkit-media-controls-toggle-closed-captions-button","attributes":{},"css":""}]}],"tag":"audio","className":"gs_audio_171","localId":"gsbp-cedda2e","controls":true} -->
<audio class="gs_audio_171" controls><source type="audio/undefined"/></audio>
<!-- /wp:greenshift-blocks/element -->
```

**SVG with Text path**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-da307d9","tag":"svg","icon":{"icon":{"font":"rhicon rhi-check","svg":"\u003csvg width=\u0022100\u0022 height=\u0022100\u0022 xmlns=\u0022http://www.w3.org/2000/svg\u0022\u003e\n  \u003cpath d=\u0022M 50,10 A 40,40 0 1,1 49.9,10 Z\u0022  fill=\u0022transparent\u0022 /\u003e\n\u003c/svg\u003e","image":""},"type":"svg"},"localId":"gsbp-da307d9","styleAttributes":{"overflow":["visible"]},"isVariation":"svgtextpath","textPathAttributes":{"enable":true,"text":"GreenLight Element Text Path","lengthAdjust":"spacing","startOffset":null,"textLength":""}} -->
<svg viewBox="0 0 100 100" width="100" height="100" class="gsbp-da307d9">
  <path xmlns="http://www.w3.org/2000/svg" d="M 50,10 A 40,40 0 1,1 49.9,10 Z" fill="transparent" id="textPathgsbp-da307d9"/>
<text xmlns="http://www.w3.org/2000/svg"><textPath href="#textPathgsbp-da307d9" lengthAdjust="spacing">GreenLight Element Text Path</textPath></text></svg>
<!-- /wp:greenshift-blocks/element -->
```

**Counter block**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-bfa10e7","textContent":"10","localId":"gsbp-bfa10e7","styleAttributes":{"fontSize":["50px"],"lineHeight":["50px"],"minHeight":["50px"],"minWidth":["50px"],"display":["inline-block"],"position":["relative"]},"isVariation":"counter","endNumber":20,"durationNumber":2,"offsetNumber":50,"stepNumber":1} -->
<div class="gsbp-bfa10e7" data-gs-counter="{&quot;end&quot;:20,&quot;duration&quot;:2,&quot;offset&quot;:50,&quot;step&quot;:1}">10</div>
<!-- /wp:greenshift-blocks/element -->
```

**Accordion Element**


```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-4893b17","dynamicGClasses":[{"value":"gs_accordion_273","type":"local","label":"gs_accordion_273","localed":false,"css":"","attributes":{"styleAttributes":{}},"originalBlock":"greenshift-blocks/element","selectors":[{"value":" \u003e .gs_item","attributes":{"styleAttributes":{"borderRadiusLink_Extra":true,"borderTopLeftRadius":["8px"],"borderBottomLeftRadius":["8px"],"borderTopRightRadius":["8px"],"borderBottomRightRadius":["8px"],"overflow":["hidden"],"borderWidth":["1px"],"borderStyle":["solid"],"borderColor":["var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dcolor\u002d\u002dborder, #00000012)"],"borderCustom_Extra":false,"borderLink_Extra":false}},"css":".gs_accordion_273 \u003e .gs_item{border-top-left-radius:8px;border-bottom-left-radius:8px;border-top-right-radius:8px;border-bottom-right-radius:8px;overflow:hidden;border-width:1px;border-style:solid;border-color:var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dcolor\u002d\u002dborder, #00000012);}"},{"value":" .gs_title","attributes":{"styleAttributes":{"marginTop":["0px"],"marginRight":["0px"],"marginBottom":["0px"],"marginLeft":["0px"],"paddingTop":["0px"],"paddingRight":["0px"],"paddingBottom":["0px"],"paddingLeft":["0px"]}},"css":".gs_accordion_273 .gs_title{margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px;}"},{"value":" .gs_title button","attributes":{"styleAttributes":{"fontSize":["1rem"],"backgroundColor":["#0000000d"],"borderCustom_Extra":true,"border":["none"],"paddingTop":["1rem"],"paddingBottom":["1rem"],"paddingRight":["1.5rem"],"paddingLeft":["1.5rem"],"fontWeight":["normal"],"textDecoration":["none"],"display":["flex"],"justifyContent":["space-between"],"alignItems":["center"],"width":["100%"],"color":["#000000"],"cursor":["pointer"],"columnGap":["5px"]}},"css":".gs_accordion_273 .gs_title button{font-size:1rem;background-color:#0000000d;border:none;padding-top:1rem;padding-bottom:1rem;padding-right:1.5rem;padding-left:1.5rem;font-weight:normal;text-decoration:none;display:flex;justify-content:space-between;align-items:center;width:100%;color:#000000;cursor:pointer;column-gap:5px;}"},{"value":" .gs_title .gs_icon","attributes":{"styleAttributes":{"width":["17px"],"height":["17px"],"transition":["all 0.5s ease"]}},"css":".gs_accordion_273 .gs_title .gs_icon{width:17px;height:17px;transition:all 0.5s ease;}"},{"value":"\u003e .gs_item \u003e .gs_content","attributes":{"styleAttributes":{"maxHeight":["0px"],"overflow":["hidden"],"transition":["max-height 0.5s cubic-bezier(0.42, 0, 0.58, 1), opacity 0.4s cubic-bezier(0.42, 0, 0.58, 1)"],"opacity":["0"]}},"css":".gs_accordion_273 \u003e .gs_item \u003e .gs_content{max-height:0px;overflow:hidden;transition:max-height 0.5s cubic-bezier(0.42, 0, 0.58, 1), opacity 0.4s cubic-bezier(0.42, 0, 0.58, 1);opacity:0;}"},{"value":" \u003e .gs_item[data-active] \u003e .gs_content","attributes":{"styleAttributes":{"maxHeight":["5000px"],"opacity":["1"]}},"css":".gs_accordion_273 \u003e .gs_item[data-active] \u003e .gs_content{max-height:5000px;opacity:1;}"},{"value":" .gs_content \u003e .gs_content_inner","attributes":{"styleAttributes":{"paddingTop":["25px"],"paddingRight":["25px"],"paddingBottom":["25px"],"paddingLeft":["25px"],"fontSize":["1rem"],"lineHeight":["1.3rem"]}},"css":".gs_accordion_273 .gs_content \u003e .gs_content_inner{padding-top:25px;padding-right:25px;padding-bottom:25px;padding-left:25px;font-size:1rem;line-height:1.3rem;}"},{"value":" \u003e .gs_item[data-active] \u003e .gs_title .gs_icon","attributes":{"styleAttributes":{"transform":["rotate(90deg)"]}},"css":".gs_accordion_273 \u003e .gs_item[data-active] \u003e .gs_title .gs_icon{transform:rotate(90deg);}"}]}],"type":"inner","className":"gs_accordion_273 gs_collapsible","localId":"gsbp-4893b17","dynamicAttributes":[{"name":"data-type","value":"accordion-component"}],"styleAttributes":{"position":["relative"],"display":["flex"],"flexDirection":["column"],"rowGap":["15px"],"columnGap":["15px"],"alignItems":["stretch"],"justifyContent":["flex-start"]},"isVariation":"accordion"} -->
<div class="gs_accordion_273 gs_collapsible gsbp-4893b17" data-type="accordion-component"><!-- wp:greenshift-blocks/element {"id":"gsbp-1d542bc","type":"inner","className":"gs_item","localId":"gsbp-1d542bc","metadata":{"name":"Accordion Item"}} -->
<div class="gs_item"><!-- wp:greenshift-blocks/element {"id":"gsbp-792c75d","tag":"h3","type":"inner","className":"gs_title","localId":"gsbp-792c75d","metadata":{"name":"Accordion Title"}} -->
<h3 class="gs_title"><!-- wp:greenshift-blocks/element {"id":"gsbp-594799c","tag":"button","type":"inner","className":"gs_click_sync","localId":"gsbp-594799c","formAttributes":{"type":"button"},"dynamicAttributes":[{"name":"aria-expanded","value":"false"}]} -->
<button class="gs_click_sync" type="button" aria-expanded="false"><!-- wp:greenshift-blocks/element {"id":"gsbp-26b9872","textContent":"Accordion Title","tag":"span","className":"gs_name","localId":"gsbp-26b9872"} -->
<span class="gs_name">Accordion Title</span>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-d28e742","tag":"svg","icon":{"icon":{"font":"rhicon rhi-chevron-right","svg":"","image":""},"type":"font"},"className":"gs_icon","localId":"gsbp-d28e742"} -->
<svg viewBox="0 0 512 1024" width="512" height="1024" class="gs_icon"><path d="M49.414 76.202l-39.598 39.596c-9.372 9.372-9.372 24.568 0 33.942l361.398 362.26-361.398 362.26c-9.372 9.372-9.372 24.568 0 33.942l39.598 39.598c9.372 9.372 24.568 9.372 33.942 0l418.828-418.828c9.372-9.372 9.372-24.568 0-33.942l-418.828-418.828c-9.374-9.374-24.57-9.374-33.942 0z" /></svg>
<!-- /wp:greenshift-blocks/element --></button>
<!-- /wp:greenshift-blocks/element --></h3>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-b31dbe5","type":"inner","className":"gs_content","localId":"gsbp-b31dbe5","dynamicAttributes":[{"name":"role","value":"region"},{"name":"aria-hidden","value":"true"}],"metadata":{"name":"Accordion Content"}} -->
<div class="gs_content" role="region" aria-hidden="true"><!-- wp:greenshift-blocks/element {"id":"gsbp-8ddb131","type":"inner","className":"gs_content_inner","localId":"gsbp-8ddb131"} -->
<div class="gs_content_inner"></div>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element -->
```

**Tabs Element**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-286838a","dynamicGClasses":[{"value":"gs_tabs_517","type":"local","label":"gs_tabs_517","localed":false,"css":"","attributes":{"styleAttributes":{}},"originalBlock":"greenshift-blocks/element","selectors":[{"value":" .gs_tab","attributes":{"styleAttributes":{"fontSize":["1rem"],"backgroundColor":["#0000000d"],"borderCustom_Extra":true,"border":["none"],"paddingTop":["1rem"],"paddingBottom":["1rem"],"paddingRight":["1.5rem"],"paddingLeft":["1.5rem"],"fontWeight":["normal"],"textDecoration":["none"],"display":["flex"],"justifyContent":["center"],"alignItems":["center"],"color":["#000000"],"cursor":["pointer"],"columnGap":["10px"],"transition":["all 0.5s ease"]}},"css":".gs_tabs_517 .gs_tab{font-size:1rem;background-color:#0000000d;border:none;padding-top:1rem;padding-bottom:1rem;padding-right:1.5rem;padding-left:1.5rem;font-weight:normal;text-decoration:none;display:flex;justify-content:center;align-items:center;color:#000000;cursor:pointer;column-gap:10px;transition:all 0.5s ease;}"},{"value":" .gs_tab.active","attributes":{"styleAttributes":{"backgroundColor":["#000000"],"color":["#fff"]}},"css":".gs_tabs_517 .gs_tab.active{background-color:#000000;color:#fff;}"},{"value":" .gs_tab svg","attributes":{"styleAttributes":{"fill":["currentColor"],"width":["17px"],"height":["17px"]}},"css":".gs_tabs_517 .gs_tab svg{fill:currentColor;width:17px;height:17px;}"},{"value":" .gs_tab.active svg","attributes":{"styleAttributes":{"fill":["currentColor"]}},"css":".gs_tabs_517 .gs_tab.active svg{fill:currentColor;}"},{"value":" .gs_content","attributes":{"styleAttributes":{"overflow":["hidden"],"opacity":["0"],"maxHeight":["0px"],"transition":["opacity 0.5s cubic-bezier(0.42, 0, 0.58, 1), max-height 0.5s cubic-bezier(0.42, 0, 0.58, 1)"]}},"css":".gs_tabs_517 .gs_content{overflow:hidden;opacity:0;max-height:0px;transition:opacity 0.5s cubic-bezier(0.42, 0, 0.58, 1), max-height 0.5s cubic-bezier(0.42, 0, 0.58, 1);}"},{"value":" .gs_content.active","attributes":{"styleAttributes":{"opacity":["1"],"maxHeight":["5000px"]}},"css":".gs_tabs_517 .gs_content.active{opacity:1;max-height:5000px;}"},{"value":" .gs_content \u003e .gs_content_inner","attributes":{"styleAttributes":{"paddingTop":["25px"],"paddingRight":["25px"],"paddingBottom":["25px"],"paddingLeft":["25px"],"fontSize":["1rem"],"lineHeight":["1.3rem"]}},"css":".gs_tabs_517 .gs_content \u003e .gs_content_inner{padding-top:25px;padding-right:25px;padding-bottom:25px;padding-left:25px;font-size:1rem;line-height:1.3rem;}"}]}],"type":"inner","className":"gs_tabs_517 gs_root","localId":"gsbp-286838a","styleAttributes":{"position":["relative"],"display":["flex"],"flexDirection":["column"],"alignItems":["stretch"],"justifyContent":["flex-start"]},"isVariation":"tabs","dynamicAttributes":[{"name": "data-type", "value":"tabs-component"}]} -->
<div class="gs_tabs_517 gs_root gsbp-286838a"><!-- wp:greenshift-blocks/element {"id":"gsbp-bd7643f","type":"inner","className":"gs_tabs_list","localId":"gsbp-bd7643f","dynamicAttributes":[{"name":"role","value":"tablist"}],"styleAttributes":{"display":["flex"],"flexDirection":["row"],"columnGap":["15px"],"rowGap":["15px"],"flexWrap":["wrap"]},"isVariation":"tablist","metadata":{"name":"Tabs List Container"}} -->
<div class="gs_tabs_list gsbp-bd7643f" role="tablist"><!-- wp:greenshift-blocks/element {"id":"gsbp-1cdb7ec","tag":"button","type":"inner","className":"gs_click_sync gs_tab active","localId":"gsbp-1cdb7ec","formAttributes":{"type":"button"},"dynamicAttributes":[{"name":"role","value":"tab"},{"name":"aria-selected","value":"true"}]} -->
<button class="gs_click_sync gs_tab active" type="button" role="tab" aria-selected="true"><!-- wp:greenshift-blocks/element {"id":"gsbp-ffc0456","textContent":"Tab Title 1","tag":"span","className":"gs_name","localId":"gsbp-ffc0456"} -->
<span class="gs_name">Tab Title 1</span>
<!-- /wp:greenshift-blocks/element --></button>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-1b868fa","tag":"button","type":"inner","className":"gs_click_sync gs_tab","localId":"gsbp-1b868fa","formAttributes":{"type":"button"},"dynamicAttributes":[{"name":"role","value":"tab"},{"name":"aria-selected","value":"false"}]} -->
<button class="gs_click_sync gs_tab" type="button" role="tab" aria-selected="false"><!-- wp:greenshift-blocks/element {"id":"gsbp-ef77a6c","textContent":"Tab Title 2","tag":"span","className":"gs_name","localId":"gsbp-ef77a6c"} -->
<span class="gs_name">Tab Title 2</span>
<!-- /wp:greenshift-blocks/element --></button>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-65ad822","tag":"button","type":"inner","className":"gs_click_sync gs_tab","localId":"gsbp-65ad822","formAttributes":{"type":"button"},"dynamicAttributes":[{"name":"role","value":"tab"},{"name":"aria-selected","value":"false"}]} -->
<button class="gs_click_sync gs_tab" type="button" role="tab" aria-selected="false"><!-- wp:greenshift-blocks/element {"id":"gsbp-4fa99e1","textContent":"Tab Title 3","tag":"span","className":"gs_name","localId":"gsbp-4fa99e1"} -->
<span class="gs_name">Tab Title 3</span>
<!-- /wp:greenshift-blocks/element --></button>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-ef872f3","type":"inner","className":"gs_content_area","localId":"gsbp-ef872f3","metadata":{"name":"Tabs Content Area"}} -->
<div class="gs_content_area"><!-- wp:greenshift-blocks/element {"id":"gsbp-e607d98","type":"inner","className":"gs_content active","localId":"gsbp-e607d98","dynamicAttributes":[{"name":"role","value":"tabpanel"},{"name":"aria-hidden","value":"false"}],"metadata":{"name":"Tabs Content Container"}} -->
<div class="gs_content active" role="tabpanel" aria-hidden="false"><!-- wp:greenshift-blocks/element {"id":"gsbp-a03c216","type":"inner","className":"gs_content_inner","localId":"gsbp-a03c216","metadata":{"name":"Tabs Content"}} -->
<div class="gs_content_inner"></div>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-d6a08f5","type":"inner","className":"gs_content","localId":"gsbp-d6a08f5","dynamicAttributes":[{"name":"role","value":"tabpanel"},{"name":"aria-hidden","value":"true"}],"metadata":{"name":"Tabs Content Container"}} -->
<div class="gs_content" role="tabpanel" aria-hidden="true"><!-- wp:greenshift-blocks/element {"id":"gsbp-691e301","type":"inner","className":"gs_content_inner","localId":"gsbp-691e301","metadata":{"name":"Tabs Content"}} -->
<div class="gs_content_inner"></div>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-d281152","type":"inner","className":"gs_content","localId":"gsbp-d281152","dynamicAttributes":[{"name":"role","value":"tabpanel"},{"name":"aria-hidden","value":"true"}],"metadata":{"name":"Tabs Content Container"}} -->
<div class="gs_content" role="tabpanel" aria-hidden="true"><!-- wp:greenshift-blocks/element {"id":"gsbp-2bafc57","type":"inner","className":"gs_content_inner","localId":"gsbp-2bafc57","metadata":{"name":"Tabs Content"}} -->
<div class="gs_content_inner"></div>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element -->
```

**Countdown block**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-f1aff34","dynamicGClasses":[{"value":"gs_countdown_169","type":"local","label":"gs_countdown_169","localed":false,"css":"","attributes":{"styleAttributes":{}},"originalBlock":"greenshift-blocks/element","selectors":[{"value":" .gs_countdown_item","attributes":{"styleAttributes":{"fontSize":["2rem"],"fontWeight":["bold"],"lineHeight":["2.3rem"]}},"css":".gs_countdown_169 .gs_countdown_item{font-size:2rem;font-weight:bold;line-height:2.3rem;}"},{"value":" .gs_date_divider","attributes":{"styleAttributes":{"fontSize":["1.7rem"],"lineHeight":["2.3rem"]}},"css":".gs_countdown_169 .gs_date_divider{font-size:1.7rem;line-height:2.3rem;}"}]}],"type":"inner","className":"gs_countdown_169 gs_countdown","localId":"gsbp-f1aff34","styleAttributes":{"position":["relative"],"display":["flex"],"flexDirection":["row"],"rowGap":["5px"],"columnGap":["5px"],"alignItems":["center"],"justifyContent":["flex-start"]},"isVariation":"countdown","endtime":"2024-12-18T20:53:07"} -->
<div class="gs_countdown_169 gs_countdown gsbp-f1aff34" data-end="2024-12-18T20:53:07"><!-- wp:greenshift-blocks/element {"id":"gsbp-51ed6cd","textContent":"00","tag":"span","className":"gs_days gs_countdown_item","localId":"gsbp-51ed6cd","metadata":{"name":"Countdown Days"}} -->
<span class="gs_days gs_countdown_item">00</span>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-70defd7","textContent":":","tag":"span","className":"gs_date_divider","localId":"gsbp-70defd7","metadata":{"name":"Countdown Divider"}} -->
<span class="gs_date_divider">:</span>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-7dc06fd","textContent":"00","tag":"span","className":"gs_hours gs_countdown_item","localId":"gsbp-7dc06fd","metadata":{"name":"Countdown Hours"}} -->
<span class="gs_hours gs_countdown_item">00</span>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-4369f65","textContent":":","tag":"span","className":"gs_date_divider","localId":"gsbp-4369f65","metadata":{"name":"Countdown Divider"}} -->
<span class="gs_date_divider">:</span>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-98cb8df","textContent":"00","tag":"span","className":"gs_minutes gs_countdown_item","localId":"gsbp-98cb8df","metadata":{"name":"Countdown Minutes"}} -->
<span class="gs_minutes gs_countdown_item">00</span>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-1840d36","textContent":":","tag":"span","className":"gs_date_divider","localId":"gsbp-1840d36","metadata":{"name":"Countdown Divider"}} -->
<span class="gs_date_divider">:</span>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-005157f","textContent":"00","tag":"span","className":"gs_seconds gs_countdown_item","localId":"gsbp-005157f","metadata":{"name":"Countdown Seconds"}} -->
<span class="gs_seconds gs_countdown_item">00</span>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element -->
```

**Table Element**

Tables have extra tableStyles attribute where we have styles for table, td, th elements + responsive attribute to make table responsive.

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-7f2c7b7","tag":"table","type":"inner","localId":"gsbp-7f2c7b7","tableAttributes":{"table":{"responsive":"yes"}},"tableStyles":{"table":{"layout":"fixed","border":"collapse"},"responsive":"yes","td":{"paddingTop":["6px"],"paddingBottom":["6px"],"paddingRight":["12px"],"paddingLeft":["12px"],"borderStyle":"solid","borderWidth":"1px","borderColor":"var(--wp--preset--color--border, #00000012)","fontSize":["14px"]},"th":{"paddingTop":["6px"],"paddingBottom":["6px"],"paddingRight":["12px"],"paddingLeft":["12px"],"borderStyle":"solid","borderWidth":"1px","borderColor":"var(--wp--preset--color--border, #00000012)","fontSize":["16px"],"backgroundColor":"var(\u002d\u002dwp\u002d\u002dpreset\u002d\u002dcolor\u002d\u002dlightbg, #cddceb21)"}},"styleAttributes":{"width":["100%"]}} -->
<table class="gsbp-7f2c7b7"><!-- wp:greenshift-blocks/element {"id":"gsbp-86384cd","tag":"tr","type":"inner","localId":"gsbp-86384cd"} -->
<tr><!-- wp:greenshift-blocks/element {"id":"gsbp-d14108c","textContent":"Header","tag":"th","localId":"gsbp-d14108c"} -->
<th>Header</th>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-537d215","textContent":"Header","tag":"th","localId":"gsbp-537d215"} -->
<th>Header</th>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-243d78a","textContent":"Header","tag":"th","localId":"gsbp-243d78a"} -->
<th>Header</th>
<!-- /wp:greenshift-blocks/element --></tr>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-c811a76","tag":"tr","type":"inner","localId":"gsbp-c811a76"} -->
<tr><!-- wp:greenshift-blocks/element {"id":"gsbp-39de8a7","tag":"td","localId":"gsbp-39de8a7"} -->
<td></td>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-ecb7f59","tag":"td","localId":"gsbp-ecb7f59"} -->
<td></td>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-cce32f2","tag":"td","localId":"gsbp-cce32f2"} -->
<td></td>
<!-- /wp:greenshift-blocks/element --></tr>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-2888a92","tag":"tr","type":"inner","localId":"gsbp-2888a92"} -->
<tr><!-- wp:greenshift-blocks/element {"id":"gsbp-1d361d1","tag":"td","localId":"gsbp-1d361d1"} -->
<td></td>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-afa96ae","tag":"td","localId":"gsbp-afa96ae"} -->
<td></td>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-5eb9d0b","tag":"td","localId":"gsbp-5eb9d0b"} -->
<td></td>
<!-- /wp:greenshift-blocks/element --></tr>
<!-- /wp:greenshift-blocks/element --></table>
<!-- /wp:greenshift-blocks/element -->
```

**Button Component Element**

If user don't have specific requirement for button, use next button component.

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-b65d91f","inlineCssStyles":".gs_button{text-decoration:none;display:inline-block;position:relative;overflow:hidden;border-bottom-left-radius:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dborder-radius, var(\u002d\u002dwp-custom\u002d\u002dborder-radius\u002d\u002dmedium, 15px));border-bottom-right-radius:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dborder-radius, var(\u002d\u002dwp-custom\u002d\u002dborder-radius\u002d\u002dmedium, 15px));border-top-left-radius:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dborder-radius, var(\u002d\u002dwp-custom\u002d\u002dborder-radius\u002d\u002dmedium, 15px));border-top-right-radius:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dborder-radius, var(\u002d\u002dwp-custom\u002d\u002dborder-radius\u002d\u002dmedium, 15px));padding-top:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dspacing\u002d\u002dvertical, var(\u002d\u002dwp-preset\u002d\u002dspacing\u002d\u002d40, 1rem));padding-bottom:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dspacing\u002d\u002dvertical, var(\u002d\u002dwp-preset\u002d\u002dspacing\u002d\u002d40, 1rem));padding-right:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dspacing\u002d\u002dhorizontal, var(\u002d\u002dwp-preset\u002d\u002dspacing\u002d\u002d60, 2.25rem));padding-left:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dspacing\u002d\u002dhorizontal, var(\u002d\u002dwp-preset\u002d\u002dspacing\u002d\u002d60, 2.25rem));background-color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dbackground, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dbrand, #33EFAB));color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dtext, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dtext-on-brand, #000002));}.gs_button:hover{color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dtext-hover, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dtext-on-brand-hover, #000003));background-color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dbackground-hover, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dbrand-hover, #7AFFCE));}.gs_button.gs_button_secondary{background-color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dsecondary-background, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dsecondary, #340fa0));color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dsecondary-text, #ffffff);}.gs_button.gs_button_secondary:hover{background-color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dsecondary-background-hover, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dsecondary-hover, #441999)); color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dsecondary-text-hover, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dtext-on-secondary-hover, #fffffd));}.gs_button.gs_button_custom_color{background-color:#1A3138;color:#ffffff;}.gs_button.gs_button_custom_color:hover{background-color:#000000;}","dynamicGClasses":[{"value":"gs-parent-hover","type":"preset","label":"gs-parent-hover"},{"value":"gs_button","type":"local","label":"gs_button","localed":false,"css":".gs_button{text-decoration:none;display:inline-block;position:relative;overflow:hidden;border-bottom-left-radius:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dborder-radius, var(\u002d\u002dwp-custom\u002d\u002dborder-radius\u002d\u002dmedium, 15px));border-bottom-right-radius:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dborder-radius, var(\u002d\u002dwp-custom\u002d\u002dborder-radius\u002d\u002dmedium, 15px));border-top-left-radius:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dborder-radius, var(\u002d\u002dwp-custom\u002d\u002dborder-radius\u002d\u002dmedium, 15px));border-top-right-radius:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dborder-radius, var(\u002d\u002dwp-custom\u002d\u002dborder-radius\u002d\u002dmedium, 15px));padding-top:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dspacing\u002d\u002dvertical, var(\u002d\u002dwp-preset\u002d\u002dspacing\u002d\u002d40, 1rem));padding-bottom:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dspacing\u002d\u002dvertical, var(\u002d\u002dwp-preset\u002d\u002dspacing\u002d\u002d40, 1rem));padding-right:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dspacing\u002d\u002dhorizontal, var(\u002d\u002dwp-preset\u002d\u002dspacing\u002d\u002d60, 2.25rem));padding-left:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dspacing\u002d\u002dhorizontal, var(\u002d\u002dwp-preset\u002d\u002dspacing\u002d\u002d60, 2.25rem));background-color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dbackground, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dbrand, #33EFAB));color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dtext, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dtext-on-brand, #000002));}.gs_button:hover{color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dtext-hover, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dtext-on-brand-hover, #000003));background-color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dbackground-hover, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dbrand-hover, #7AFFCE));}","attributes":{"styleAttributes":{"textDecoration":["none"],"display":["inline-block"],"position":["relative"],"overflow":["hidden"],"color_hover":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dtext-hover, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dtext-on-brand-hover, #000003))"],"borderBottomLeftRadius":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dborder-radius, var(\u002d\u002dwp-custom\u002d\u002dborder-radius\u002d\u002dmedium, 15px))"],"borderBottomRightRadius":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dborder-radius, var(\u002d\u002dwp-custom\u002d\u002dborder-radius\u002d\u002dmedium, 15px))"],"borderTopLeftRadius":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dborder-radius, var(\u002d\u002dwp-custom\u002d\u002dborder-radius\u002d\u002dmedium, 15px))"],"borderTopRightRadius":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dborder-radius, var(\u002d\u002dwp-custom\u002d\u002dborder-radius\u002d\u002dmedium, 15px))"],"borderRadiusCustom_Extra":false,"borderRadiusLink_Extra":true,"paddingTop":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dspacing\u002d\u002dvertical, var(\u002d\u002dwp-preset\u002d\u002dspacing\u002d\u002d40, 1rem))"],"paddingBottom":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dspacing\u002d\u002dvertical, var(\u002d\u002dwp-preset\u002d\u002dspacing\u002d\u002d40, 1rem))"],"paddingRight":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dspacing\u002d\u002dhorizontal, var(\u002d\u002dwp-preset\u002d\u002dspacing\u002d\u002d60, 2.25rem))"],"paddingLeft":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dspacing\u002d\u002dhorizontal, var(\u002d\u002dwp-preset\u002d\u002dspacing\u002d\u002d60, 2.25rem))"],"backgroundColor":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dbackground, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dbrand, #33EFAB))"],"backgroundColor_hover":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dbackground-hover, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dbrand-hover, #7AFFCE))"],"color":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dtext, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dtext-on-brand, #000002))"]}},"originalBlock":"greenshift-blocks/element","selectors":[{"value":".gs_button_secondary","attributes":{"styleAttributes":{"backgroundColor":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dsecondary-background, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dsecondary, #340fa0))"],"color":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dsecondary-text, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dtext-on-secondary, #fffffc))"],"backgroundColor_hover":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dsecondary-background-hover, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dsecondary-hover, #340fa0))"],"color_hover":["var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dsecondary-text-hover, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dtext-on-secondary-hover, #fffffd))"]}},"css":".gs_button.gs_button_secondary{background-color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dsecondary-background, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dsecondary, #340fa0));color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dsecondary-text, #ffffff);}.gs_button.gs_button_secondary:hover{background-color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dsecondary-background-hover, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dsecondary-hover, #441999)); color:var(\u002d\u002dwp\u002d\u002dcustom\u002d\u002dbutton\u002d\u002dsecondary-text-hover, var(\u002d\u002dwp-preset\u002d\u002dcolor\u002d\u002dtext-on-secondary-hover, #fffffd));}"},{"value":".gs_button_custom_color","attributes":{"styleAttributes":{"backgroundColor":["#1A3138"],"color":["#ffffff"],"backgroundColor_hover":["#000000"]}},"css":".gs_button.gs_button_custom_color{background-color:#1A3138;color:#ffffff;}.gs_button.gs_button_custom_color:hover{background-color:#000000;}"}]}],"textContent":"Download for Free!","tag":"a","className":"gs-parent-hover gs_button","localId":"gsbp-b65d91f","href":"#","dynamicAttributes":[{"name":"data-type","value":"button-component"}],"isVariation":"buttoncomponent"} -->
<a class="gs-parent-hover gs_button" href="#" data-type="button-component">Download for Free!</a>
<!-- /wp:greenshift-blocks/element -->
```

**Inline Youtube Video block**

This block is used primarly for Video backgrounds from Youtube links. It has muted autoplay and loop

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-c1db4cc","tag":"iframe","localId":"gsbp-c1db4cc","src":"https://www.youtube.com/watch?v=PpGeRu0mZy0","dynamicAttributes":[{"name":"allow","value":"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"},{"name":"allowfullscreen","value":"true"}],"styleAttributes":{"aspectRatio":["16/9"],"display":["block"],"objectFit":["cover"],"width":["100%"],"pointerEvents":["none"]},"isVariation":"youtubeplay"} -->
<iframe class="gsbp-c1db4cc" src="https://www.youtube.com/watch?v=PpGeRu0mZy0" frameborder="0" loading="lazy" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
<!-- /wp:greenshift-blocks/element -->
```

**Inline Vimeo Video block**

This block is used primarly for Video backgrounds from Vimeo links. It has muted autoplay and loop

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-add38f7","tag":"iframe","localId":"gsbp-add38f7","src":"https://vimeo.com/863362136","dynamicAttributes":[{"name":"allow","value":"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"},{"name":"allowfullscreen","value":"true"}],"styleAttributes":{"aspectRatio":["16/9"],"display":["block"],"objectFit":["cover"],"width":["100%"],"pointerEvents":["none"]},"isVariation":"vimeoplay"} -->
<iframe class="gsbp-add38f7" src="https://vimeo.com/863362136" frameborder="0" loading="lazy" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
<!-- /wp:greenshift-blocks/element -->
```

**Video LightBox Block**

This block is used for lightboxes with video and play button

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-fc481da","dynamicGClasses":[{"value":"gs_videolightbox_853","type":"local","label":"gs_videolightbox_853","localed":false,"css":"","attributes":{"styleAttributes":{}},"originalBlock":"greenshift-blocks/element","selectors":[{"value":" .play_button_pulse","attributes":{"styleAttributes":{"position":["absolute"],"width":["80px"],"height":["80px"],"borderRadius":["50%"],"backgroundColor":["#ff0000"],"border":["none"],"cursor":["pointer"],"display":["flex"],"alignItems":["center"],"justifyContent":["center"],"zIndex":["1"]}},"css":".gs_videolightbox_853 .play_button_pulse{position:absolute;width:80px;height:80px;border-radius:50%;background-color:#ff0000;border:none;cursor:pointer;display:flex;align-items:center;justify-content:center;z-index:1;}"},{"value":" .play_button_pulse::before","attributes":{"styleAttributes":{"content":["\u0022\u0022"],"borderRadius":["50%"],"animation":["pulse-ring 2s cubic-bezier(0.215, 0.61, 0.355, 1) infinite"],"position":["absolute"],"left":["0px"],"top":["0px"],"bottom":["0px"],"right":["0px"],"borderWidth":["1px"],"borderStyle":["solid"],"borderColor":["#ff0000"],"animation_keyframes_Extra":[{"name":"pulse-ring","code":["from{\nscale:1;\nopacity:1;\n}\nto{\nscale:1.5;\nopacity:0;\n}","","",""]}]}},"css":".gs_videolightbox_853 .play_button_pulse::before{content:\u0022\u0022;border-radius:50%;animation:pulse-ring 2s cubic-bezier(0.215, 0.61, 0.355, 1) infinite;position:absolute;left:0px;top:0px;bottom:0px;right:0px;border-width:1px;border-style:solid;border-color:#ff0000;}\n@keyframes pulse-ring {\nfrom{\nscale:1;\nopacity:1;\n}\nto{\nscale:1.5;\nopacity:0;\n}\n}\n@media (prefers-reduced-motion) {\n.gs_videolightbox_00000 .play_button_pulse::before {\nanimation: none !important;\n}\n}"},{"value":" .play_button_pulse::after","attributes":{"styleAttributes":{"content":["\u0022\u0022"],"position":["absolute"],"borderRadius":["50%"],"animation":["pulse-ring 2s cubic-bezier(0.215, 0.61, 0.355, 1) infinite 0.5s"],"top":["0px"],"left":["0px"],"bottom":["0px"],"right":["0px"],"borderWidth":["1px"],"borderStyle":["solid"],"borderColor":["#ff0000"]}},"css":".gs_videolightbox_853 .play_button_pulse::after{content:\u0022\u0022;position:absolute;border-radius:50%;animation:pulse-ring 2s cubic-bezier(0.215, 0.61, 0.355, 1) infinite 0.5s;top:0px;left:0px;bottom:0px;right:0px;border-width:1px;border-style:solid;border-color:#ff0000;}"}]}],"interactionLayers":[{"actions":[{"actionname":"lightbox"}],"env":"no-action","triggerData":{"trigger":"click"}}],"type":"inner","className":"gs_videolightbox_853","localId":"gsbp-fc481da","styleAttributes":{"position":["relative"],"display":["flex"],"flexDirection":["column"],"justifyContent":["center"],"alignItems":["center"]},"isVariation":"videolightbox","dynamicAttributes":[{"name":"data-type","value":"video-lightbox-component"}]} -->
<div data-gspbactions="[{&quot;actions&quot;:[{&quot;actionname&quot;:&quot;lightbox&quot;}],&quot;env&quot;:&quot;no-action&quot;,&quot;triggerData&quot;:{&quot;trigger&quot;:&quot;click&quot;}}]" class="gs_videolightbox_853 gsbp-fc481da" data-type="video-lightbox-component"><!-- wp:greenshift-blocks/element {"id":"gsbp-2f4769b","tag":"button","type":"inner","className":"play_button_pulse","localId":"gsbp-2f4769b","formAttributes":{"type":"button"},"metadata":{"name":"Play Button"}} -->
<button class="play_button_pulse" type="button"><!-- wp:greenshift-blocks/element {"id":"gsbp-89c9513","tag":"svg","icon":{"icon":{"svg":"\u003csvg width=\u0022100\u0022 height=\u0022100\u0022 viewBox=\u00220 0 100 100\u0022 xmlns=\u0022http://www.w3.org/2000/svg\u0022\u003e\u003cpolygon points=\u002230,20 30,80 70,50\u0022 fill=\u0022#ffffff\u0022/\u003e\u003c/svg\u003e","image":""},"fill":"currentColor","type":"svg"},"localId":"gsbp-89c9513","styleAttributes":{"width":["30px"],"height":["30px"],"color":["#ffffff"]}} -->
<svg viewBox="0 0 100 100" width="100" height="100" class="gsbp-89c9513"><polygon xmlns="http://www.w3.org/2000/svg" points="30,20 30,80 70,50" fill="#ffffff"/></svg>
<!-- /wp:greenshift-blocks/element --></button>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-745540d","tag":"img","localId":"gsbp-745540d","src":"https://placehold.co/1280x720","alt":"","styleAttributes":{"aspectRatio":["16/9"],"objectFit":["cover"]},"metadata":{"name":"Video Thumbnail"}} -->
<img class="gsbp-745540d" src="https://placehold.co/1280x720" alt="" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element -->
```

**Marquee block**

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-ee95a85","type":"inner","localId":"gsbp-ee95a85","marqueeSpeed":12,"isVariation":"marquee"} -->
<div class="gsbp-ee95a85"><div class="gspb_marquee_content"><!-- wp:greenshift-blocks/element {"id":"gsbp-a7ca8ce","textContent":"Add Scroll Elements Here","tag":"span","localId":"gsbp-a7ca8ce","styleAttributes":{"fontSize":"30px"}} -->
<span class="gsbp-a7ca8ce">Add Scroll Elements Here</span>
<!-- /wp:greenshift-blocks/element --><span class="gspb_marquee_content_end"></span></div></div>
<!-- /wp:greenshift-blocks/element -->
```

**Charts Elements**

It's possible also to create Chart block, it's based on ApexCharts.js and uses specific data. Charts have special extra attribute chartData where data related to chart is stored. Make sure that chartData has options parameter like chartData:{options: {chart: {...}}}. Make sure that you do not have double slash in options.

There are several types of charts. Here are examples, follow them when you do conversion: 

*Line chart*

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-6a376a3","type":"chart","localId":"gsbp-6a376a3","styleAttributes":{"height":["350px"]},"chartData":{"options":"{\n  \u0022chart\u0022: {\n    \u0022height\u0022: \u0022350px\u0022,\n    \u0022type\u0022: \u0022line\u0022,\n    \u0022stacked\u0022: false\n  },\n  \u0022colors\u0022: [\n    \u0022#FF1654\u0022,\n    \u0022#247BA0\u0022\n  ],\n  \u0022series\u0022: [\n    {\n      \u0022name\u0022: \u0022Series A\u0022,\n      \u0022data\u0022: [\n        14,\n        20,\n        25,\n        15,\n        25,\n        28,\n        38,\n        46\n      ]\n    },\n    {\n      \u0022name\u0022: \u0022Series B\u0022,\n      \u0022data\u0022: [\n        20,\n        29,\n        37,\n        36,\n        44,\n        45,\n        50,\n        58\n      ]\n    }\n  ],\n  \u0022stroke\u0022: {\n    \u0022width\u0022: [\n      4,\n      4\n    ]\n  },\n  \u0022plotOptions\u0022: {\n    \u0022bar\u0022: {\n      \u0022columnWidth\u0022: \u002220%\u0022\n    }\n  },\n  \u0022xaxis\u0022: {\n    \u0022categories\u0022: [\n      2009,\n      2010,\n      2011,\n      2012,\n      2013,\n      2014,\n      2015,\n      2016\n    ]\n  }\n}"},"isVariation":"chart"} -->
<div class="gsbp-6a376a3" data-chart-data="&quot;{\n  \&quot;chart\&quot;: {\n    \&quot;height\&quot;: \&quot;350px\&quot;,\n    \&quot;type\&quot;: \&quot;line\&quot;,\n    \&quot;stacked\&quot;: false\n  },\n  \&quot;colors\&quot;: [\n    \&quot;#FF1654\&quot;,\n    \&quot;#247BA0\&quot;\n  ],\n  \&quot;series\&quot;: [\n    {\n      \&quot;name\&quot;: \&quot;Series A\&quot;,\n      \&quot;data\&quot;: [\n        14,\n        20,\n        25,\n        15,\n        25,\n        28,\n        38,\n        46\n      ]\n    },\n    {\n      \&quot;name\&quot;: \&quot;Series B\&quot;,\n      \&quot;data\&quot;: [\n        20,\n        29,\n        37,\n        36,\n        44,\n        45,\n        50,\n        58\n      ]\n    }\n  ],\n  \&quot;stroke\&quot;: {\n    \&quot;width\&quot;: [\n      4,\n      4\n    ]\n  },\n  \&quot;plotOptions\&quot;: {\n    \&quot;bar\&quot;: {\n      \&quot;columnWidth\&quot;: \&quot;20%\&quot;\n    }\n  },\n  \&quot;xaxis\&quot;: {\n    \&quot;categories\&quot;: [\n      2009,\n      2010,\n      2011,\n      2012,\n      2013,\n      2014,\n      2015,\n      2016\n    ]\n  }\n}&quot;" data-chart-id="gsbp-6a376a3"></div>
<!-- /wp:greenshift-blocks/element -->
```

*Area chart*

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-6a376a3","type":"chart","localId":"gsbp-6a376a3","dynamicAttributes":[{"name":"data-series-0","value":"","dynamicEnable":false},{"name":"data-series","value":"","dynamicEnable":false},{"name":"data-xaxis-categories","value":"","dynamicEnable":false}],"styleAttributes":{"height":["350px"]},"chartData":{"options":"{\n  \u0022chart\u0022: {\n    \u0022height\u0022: \u0022350px\u0022,\n    \u0022type\u0022: \u0022area\u0022\n  },\n  \u0022dataLabels\u0022: {\n    \u0022enabled\u0022: false\n  },\n  \u0022series\u0022: [\n    {\n      \u0022name\u0022: \u0022Series 1\u0022,\n      \u0022data\u0022: [\n        45,\n        52,\n        38,\n        45,\n        19,\n        23,\n        2\n      ]\n    }\n  ],\n  \u0022fill\u0022: {\n    \u0022type\u0022: \u0022gradient\u0022,\n    \u0022gradient\u0022: {\n      \u0022shadeIntensity\u0022: 1,\n      \u0022opacityFrom\u0022: 0.7,\n      \u0022opacityTo\u0022: 0.9,\n      \u0022stops\u0022: [\n        0,\n        90,\n        100\n      ]\n    }\n  },\n  \u0022xaxis\u0022: {\n    \u0022categories\u0022: [\n      \u002201 Jan\u0022,\n      \u002202 Jan\u0022,\n      \u002203 Jan\u0022,\n      \u002204 Jan\u0022,\n      \u002205 Jan\u0022,\n      \u002206 Jan\u0022,\n      \u002207 Jan\u0022\n    ]\n  }\n}","init":true},"isVariation":"chart"} -->
<div class="gsbp-6a376a3" data-chart-data="&quot;{\n  \&quot;chart\&quot;: {\n    \&quot;height\&quot;: \&quot;350px\&quot;,\n    \&quot;type\&quot;: \&quot;area\&quot;\n  },\n  \&quot;dataLabels\&quot;: {\n    \&quot;enabled\&quot;: false\n  },\n  \&quot;series\&quot;: [\n    {\n      \&quot;name\&quot;: \&quot;Series 1\&quot;,\n      \&quot;data\&quot;: [\n        45,\n        52,\n        38,\n        45,\n        19,\n        23,\n        2\n      ]\n    }\n  ],\n  \&quot;fill\&quot;: {\n    \&quot;type\&quot;: \&quot;gradient\&quot;,\n    \&quot;gradient\&quot;: {\n      \&quot;shadeIntensity\&quot;: 1,\n      \&quot;opacityFrom\&quot;: 0.7,\n      \&quot;opacityTo\&quot;: 0.9,\n      \&quot;stops\&quot;: [\n        0,\n        90,\n        100\n      ]\n    }\n  },\n  \&quot;xaxis\&quot;: {\n    \&quot;categories\&quot;: [\n      \&quot;01 Jan\&quot;,\n      \&quot;02 Jan\&quot;,\n      \&quot;03 Jan\&quot;,\n      \&quot;04 Jan\&quot;,\n      \&quot;05 Jan\&quot;,\n      \&quot;06 Jan\&quot;,\n      \&quot;07 Jan\&quot;\n    ]\n  }\n}&quot;" data-chart-id="gsbp-6a376a3" data-series-0="" data-series="" data-xaxis-categories=""></div>
<!-- /wp:greenshift-blocks/element -->
```

*Bar chart*

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-9413efa","inlineCssStyles":".gsbp-9413efa{height:350px;}","type":"chart","localId":"gsbp-9413efa","dynamicAttributes":[{"name":"data-series-0","value":"","dynamicEnable":false},{"name":"data-series","value":"","dynamicEnable":false},{"name":"data-xaxis-categories","value":"","dynamicEnable":false},{"name":"data-series-1","value":"","dynamicEnable":false},{"name":"data-series-2","value":"","dynamicEnable":false}],"styleAttributes":{"height":["350px"]},"chartData":{"options":"{\n  \u0022series\u0022: [\n    {\n      \u0022name\u0022: \u0022Inflation\u0022,\n      \u0022data\u0022: [\n        2.3,\n        3.1,\n        4,\n        10.1\n      ]\n    }\n  ],\n  \u0022chart\u0022: {\n    \u0022height\u0022: \u0022350px\u0022,\n    \u0022type\u0022: \u0022bar\u0022\n  },\n  \u0022plotOptions\u0022: {\n    \u0022bar\u0022: {\n      \u0022borderRadius\u0022: 10,\n      \u0022dataLabels\u0022: {\n        \u0022position\u0022: \u0022top\u0022\n      }\n    }\n  },\n  \u0022dataLabels\u0022: {\n    \u0022enabled\u0022: true,\n    \u0022offsetY\u0022: -20,\n    \u0022style\u0022: {\n      \u0022fontSize\u0022: \u002212px\u0022,\n      \u0022colors\u0022: [\n        \u0022#304758\u0022\n      ]\n    }\n  },\n  \u0022xaxis\u0022: {\n    \u0022categories\u0022: [\n      \u0022Jan\u0022,\n      \u0022Feb\u0022,\n      \u0022Mar\u0022,\n      \u0022Apr\u0022\n    ],\n    \u0022position\u0022: \u0022top\u0022,\n    \u0022axisBorder\u0022: {\n      \u0022show\u0022: false\n    },\n    \u0022axisTicks\u0022: {\n      \u0022show\u0022: false\n    },\n    \u0022crosshairs\u0022: {\n      \u0022fill\u0022: {\n        \u0022type\u0022: \u0022gradient\u0022,\n        \u0022gradient\u0022: {\n          \u0022colorFrom\u0022: \u0022#D8E3F0\u0022,\n          \u0022colorTo\u0022: \u0022#BED1E6\u0022,\n          \u0022stops\u0022: [\n            0,\n            100\n          ],\n          \u0022opacityFrom\u0022: 0.4,\n          \u0022opacityTo\u0022: 0.5\n        }\n      }\n    },\n    \u0022tooltip\u0022: {\n      \u0022enabled\u0022: true\n    }\n  },\n  \u0022yaxis\u0022: {\n    \u0022axisBorder\u0022: {\n      \u0022show\u0022: false\n    },\n    \u0022axisTicks\u0022: {\n      \u0022show\u0022: false\n    }\n  },\n  \u0022title\u0022: {\n    \u0022text\u0022: \u0022Monthly Inflation in Argentina, 2002\u0022,\n    \u0022floating\u0022: true,\n    \u0022offsetY\u0022: 330,\n    \u0022align\u0022: \u0022center\u0022,\n    \u0022style\u0022: {\n      \u0022color\u0022: \u0022#444\u0022\n    }\n  }\n}","init":false},"isVariation":"chart"} -->
<div class="gsbp-9413efa" data-chart-data="&quot;{\n  \&quot;series\&quot;: [\n    {\n      \&quot;name\&quot;: \&quot;Inflation\&quot;,\n      \&quot;data\&quot;: [\n        2.3,\n        3.1,\n        4,\n        10.1\n      ]\n    }\n  ],\n  \&quot;chart\&quot;: {\n    \&quot;height\&quot;: \&quot;350px\&quot;,\n    \&quot;type\&quot;: \&quot;bar\&quot;\n  },\n  \&quot;plotOptions\&quot;: {\n    \&quot;bar\&quot;: {\n      \&quot;borderRadius\&quot;: 10,\n      \&quot;dataLabels\&quot;: {\n        \&quot;position\&quot;: \&quot;top\&quot;\n      }\n    }\n  },\n  \&quot;dataLabels\&quot;: {\n    \&quot;enabled\&quot;: true,\n    \&quot;offsetY\&quot;: -20,\n    \&quot;style\&quot;: {\n      \&quot;fontSize\&quot;: \&quot;12px\&quot;,\n      \&quot;colors\&quot;: [\n        \&quot;#304758\&quot;\n      ]\n    }\n  },\n  \&quot;xaxis\&quot;: {\n    \&quot;categories\&quot;: [\n      \&quot;Jan\&quot;,\n      \&quot;Feb\&quot;,\n      \&quot;Mar\&quot;,\n      \&quot;Apr\&quot;\n    ],\n    \&quot;position\&quot;: \&quot;top\&quot;,\n    \&quot;axisBorder\&quot;: {\n      \&quot;show\&quot;: false\n    },\n    \&quot;axisTicks\&quot;: {\n      \&quot;show\&quot;: false\n    },\n    \&quot;crosshairs\&quot;: {\n      \&quot;fill\&quot;: {\n        \&quot;type\&quot;: \&quot;gradient\&quot;,\n        \&quot;gradient\&quot;: {\n          \&quot;colorFrom\&quot;: \&quot;#D8E3F0\&quot;,\n          \&quot;colorTo\&quot;: \&quot;#BED1E6\&quot;,\n          \&quot;stops\&quot;: [\n            0,\n            100\n          ],\n          \&quot;opacityFrom\&quot;: 0.4,\n          \&quot;opacityTo\&quot;: 0.5\n        }\n      }\n    },\n    \&quot;tooltip\&quot;: {\n      \&quot;enabled\&quot;: true\n    }\n  },\n  \&quot;yaxis\&quot;: {\n    \&quot;axisBorder\&quot;: {\n      \&quot;show\&quot;: false\n    },\n    \&quot;axisTicks\&quot;: {\n      \&quot;show\&quot;: false\n    }\n  },\n  \&quot;title\&quot;: {\n    \&quot;text\&quot;: \&quot;Monthly Inflation in Argentina, 2002\&quot;,\n    \&quot;floating\&quot;: true,\n    \&quot;offsetY\&quot;: 330,\n    \&quot;align\&quot;: \&quot;center\&quot;,\n    \&quot;style\&quot;: {\n      \&quot;color\&quot;: \&quot;#444\&quot;\n    }\n  }\n}&quot;" data-chart-id="gsbp-9413efa" data-series-0="" data-series="" data-xaxis-categories="" data-series-1="" data-series-2=""></div>
<!-- /wp:greenshift-blocks/element -->
```

*Horizontal Bar chart*

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-3c4d5e6","inlineCssStyles":".gsbp-3c4d5e6{height:350px;}","type":"chart","localId":"gsbp-3c4d5e6","dynamicAttributes":[{"name":"data-series-0","value":"","dynamicEnable":false},{"name":"data-series","value":"","dynamicEnable":false},{"name":"data-xaxis-categories","value":"","dynamicEnable":false},{"name":"data-series-1","value":"","dynamicEnable":false},{"name":"data-series-2","value":"","dynamicEnable":false}],"styleAttributes":{"height":["350px"]},"chartData":{"options":"{\n  \u0022series\u0022: [\n    {\n      \u0022data\u0022: [\n        400,\n        430,\n        448\n      ]\n    }\n  ],\n  \u0022chart\u0022: {\n    \u0022type\u0022: \u0022bar\u0022,\n    \u0022height\u0022: \u0022350px\u0022\n  },\n  \u0022plotOptions\u0022: {\n    \u0022bar\u0022: {\n      \u0022borderRadius\u0022: 4,\n      \u0022borderRadiusApplication\u0022: \u0022end\u0022,\n      \u0022horizontal\u0022: true\n    }\n  },\n  \u0022dataLabels\u0022: {\n    \u0022enabled\u0022: false\n  },\n  \u0022xaxis\u0022: {\n    \u0022categories\u0022: [\n      \u0022South Korea\u0022,\n      \u0022Canada\u0022,\n      \u0022United Kingdom\u0022\n    ]\n  }\n}","init":true},"isVariation":"chart"} -->
<div class="gsbp-3c4d5e6" data-chart-data="&quot;{\n  \&quot;series\&quot;: [\n    {\n      \&quot;data\&quot;: [\n        400,\n        430,\n        448\n      ]\n    }\n  ],\n  \&quot;chart\&quot;: {\n    \&quot;type\&quot;: \&quot;bar\&quot;,\n    \&quot;height\&quot;: \&quot;350px\&quot;\n  },\n  \&quot;plotOptions\&quot;: {\n    \&quot;bar\&quot;: {\n      \&quot;borderRadius\&quot;: 4,\n      \&quot;borderRadiusApplication\&quot;: \&quot;end\&quot;,\n      \&quot;horizontal\&quot;: true\n    }\n  },\n  \&quot;dataLabels\&quot;: {\n    \&quot;enabled\&quot;: false\n  },\n  \&quot;xaxis\&quot;: {\n    \&quot;categories\&quot;: [\n      \&quot;South Korea\&quot;,\n      \&quot;Canada\&quot;,\n      \&quot;United Kingdom\&quot;\n    ]\n  }\n}&quot;" data-chart-id="gsbp-3c4d5e6" data-series-0="" data-series="" data-xaxis-categories="" data-series-1="" data-series-2=""></div>
<!-- /wp:greenshift-blocks/element -->
```

*Pie chart*

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-6a376a3","type":"chart","localId":"gsbp-6a376a3","dynamicAttributes":[{"name":"data-series-0","value":"","dynamicEnable":false},{"name":"data-series","value":"","dynamicEnable":false},{"name":"data-xaxis-categories","value":"","dynamicEnable":false},{"name":"data-series-1","value":"","dynamicEnable":false},{"name":"data-series-2","value":"","dynamicEnable":false},{"name":"data-series-numbers","value":"","dynamicEnable":false},{"name":"data-labels","value":"","dynamicEnable":false}],"styleAttributes":{"height":["350px"]},"chartData":{"options":"{\n  \u0022series\u0022: [\n    44,\n    55,\n    13,\n    43,\n    22\n  ],\n  \u0022chart\u0022: {\n    \u0022type\u0022: \u0022pie\u0022\n  },\n  \u0022labels\u0022: [\n    \u0022Team A\u0022,\n    \u0022Team B\u0022,\n    \u0022Team C\u0022,\n    \u0022Team D\u0022,\n    \u0022Team E\u0022\n  ],\n  \u0022responsive\u0022: [\n    {\n      \u0022breakpoint\u0022: 480,\n      \u0022options\u0022: {\n        \u0022chart\u0022: {\n          \u0022width\u0022: 300\n        },\n        \u0022legend\u0022: {\n          \u0022position\u0022: \u0022bottom\u0022\n        }\n      }\n    }\n  ]\n}","init":false},"isVariation":"chart"} -->
<div class="gsbp-6a376a3" data-chart-data="&quot;{\n  \&quot;series\&quot;: [\n    44,\n    55,\n    13,\n    43,\n    22\n  ],\n  \&quot;chart\&quot;: {\n    \&quot;type\&quot;: \&quot;pie\&quot;\n  },\n  \&quot;labels\&quot;: [\n    \&quot;Team A\&quot;,\n    \&quot;Team B\&quot;,\n    \&quot;Team C\&quot;,\n    \&quot;Team D\&quot;,\n    \&quot;Team E\&quot;\n  ],\n  \&quot;responsive\&quot;: [\n    {\n      \&quot;breakpoint\&quot;: 480,\n      \&quot;options\&quot;: {\n        \&quot;chart\&quot;: {\n          \&quot;width\&quot;: 300\n        },\n        \&quot;legend\&quot;: {\n          \&quot;position\&quot;: \&quot;bottom\&quot;\n        }\n      }\n    }\n  ]\n}&quot;" data-chart-id="gsbp-6a376a3" data-series-0="" data-series="" data-xaxis-categories="" data-series-1="" data-series-2="" data-series-numbers="" data-labels=""></div>
<!-- /wp:greenshift-blocks/element -->
```

*Radar chart*

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-6a376a3","type":"chart","localId":"gsbp-6a376a3","dynamicAttributes":[{"name":"data-series-0","value":"","dynamicEnable":false},{"name":"data-series","value":"","dynamicEnable":false},{"name":"data-xaxis-categories","value":"","dynamicEnable":false},{"name":"data-series-1","value":"","dynamicEnable":false},{"name":"data-series-2","value":"","dynamicEnable":false},{"name":"data-series-numbers","value":"","dynamicEnable":false},{"name":"data-labels","value":"","dynamicEnable":false}],"styleAttributes":{"height":["350px"]},"chartData":{"options":"{\n  \u0022series\u0022: [\n    {\n      \u0022name\u0022: \u0022Series 1\u0022,\n      \u0022data\u0022: [\n        80,\n        50,\n        30,\n        40,\n        100,\n        20\n      ]\n    }\n  ],\n  \u0022chart\u0022: {\n    \u0022height\u0022: \u0022350px\u0022,\n    \u0022type\u0022: \u0022radar\u0022\n  },\n  \u0022title\u0022: {\n    \u0022text\u0022: \u0022Basic Radar Chart\u0022\n  },\n  \u0022yaxis\u0022: {\n    \u0022stepSize\u0022: 20\n  },\n  \u0022xaxis\u0022: {\n    \u0022categories\u0022: [\n      \u0022January\u0022,\n      \u0022February\u0022,\n      \u0022March\u0022,\n      \u0022April\u0022,\n      \u0022May\u0022,\n      \u0022June\u0022\n    ]\n  }\n}","init":false},"isVariation":"chart"} -->
<div class="gsbp-6a376a3" data-chart-data="&quot;{\n  \&quot;series\&quot;: [\n    {\n      \&quot;name\&quot;: \&quot;Series 1\&quot;,\n      \&quot;data\&quot;: [\n        80,\n        50,\n        30,\n        40,\n        100,\n        20\n      ]\n    }\n  ],\n  \&quot;chart\&quot;: {\n    \&quot;height\&quot;: \&quot;350px\&quot;,\n    \&quot;type\&quot;: \&quot;radar\&quot;\n  },\n  \&quot;title\&quot;: {\n    \&quot;text\&quot;: \&quot;Basic Radar Chart\&quot;\n  },\n  \&quot;yaxis\&quot;: {\n    \&quot;stepSize\&quot;: 20\n  },\n  \&quot;xaxis\&quot;: {\n    \&quot;categories\&quot;: [\n      \&quot;January\&quot;,\n      \&quot;February\&quot;,\n      \&quot;March\&quot;,\n      \&quot;April\&quot;,\n      \&quot;May\&quot;,\n      \&quot;June\&quot;\n    ]\n  }\n}&quot;" data-chart-id="gsbp-6a376a3" data-series-0="" data-series="" data-xaxis-categories="" data-series-1="" data-series-2="" data-series-numbers="" data-labels=""></div>
<!-- /wp:greenshift-blocks/element -->
```

*Candlestick chart*

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-6a376a3","type":"chart","localId":"gsbp-6a376a3","dynamicAttributes":[{"name":"data-series-0","value":"","dynamicEnable":false},{"name":"data-series","value":"","dynamicEnable":false},{"name":"data-xaxis-categories","value":"","dynamicEnable":false},{"name":"data-series-1","value":"","dynamicEnable":false},{"name":"data-series-2","value":"","dynamicEnable":false},{"name":"data-series-numbers","value":"","dynamicEnable":false},{"name":"data-labels","value":"","dynamicEnable":false}],"styleAttributes":{"height":["350px"]},"chartData":{"options":"{\n  \u0022series\u0022: [\n    {\n      \u0022data\u0022: [\n        {\n          \u0022x\u0022: \u00222018-10-05 20:30:00\u0022,\n          \u0022y\u0022: [\n            6629.81,\n            6650.5,\n            6623.04,\n            6633.33\n          ]\n        },\n        {\n          \u0022x\u0022: \u00222018-10-05 21:00:00\u0022,\n          \u0022y\u0022: [\n            6632.01,\n            6643.59,\n            6620,\n            6630.11\n          ]\n        },\n        {\n          \u0022x\u0022: \u00222018-10-05 21:30:00\u0022,\n          \u0022y\u0022: [\n            6630.71,\n            6648.95,\n            6623.34,\n            6635.65\n          ]\n        },\n        {\n          \u0022x\u0022: \u00222018-10-05 22:00:00\u0022,\n          \u0022y\u0022: [\n            6635.65,\n            6651,\n            6629.67,\n            6638.24\n          ]\n        },\n        {\n          \u0022x\u0022: \u00222018-10-05 22:30:00\u0022,\n          \u0022y\u0022: [\n            6638.24,\n            6640,\n            6620,\n            6624.47\n          ]\n        },\n        {\n          \u0022x\u0022: \u00222018-10-05 23:00:00\u0022,\n          \u0022y\u0022: [\n            6624.53,\n            6636.03,\n            6621.68,\n            6624.31\n          ]\n        },\n        {\n          \u0022x\u0022: \u00222018-10-05 23:30:00\u0022,\n          \u0022y\u0022: [\n            6624.61,\n            6632.2,\n            6617,\n            6626.02\n          ]\n        },\n        {\n          \u0022x\u0022: \u00222018-10-06 00:00:00\u0022,\n          \u0022y\u0022: [\n            6627,\n            6627.62,\n            6584.22,\n            6603.02\n          ]\n        },\n        {\n          \u0022x\u0022: \u00222018-10-06 00:30:00\u0022,\n          \u0022y\u0022: [\n            6605,\n            6608.03,\n            6598.95,\n            6604.01\n          ]\n        },\n        {\n          \u0022x\u0022: \u00222018-10-06 01:00:00\u0022,\n          \u0022y\u0022: [\n            6604.5,\n            6614.4,\n            6602.26,\n            6608.02\n          ]\n        },\n        {\n          \u0022x\u0022: \u00222018-10-06 01:30:00\u0022,\n          \u0022y\u0022: [\n            6608.02,\n            6610.68,\n            6601.99,\n            6608.91\n          ]\n        },\n        {\n          \u0022x\u0022: \u00222018-10-06 02:00:00\u0022,\n          \u0022y\u0022: [\n            6608.91,\n            6618.99,\n            6608.01,\n            6612\n          ]\n        },\n        {\n          \u0022x\u0022: \u00222018-10-06 02:30:00\u0022,\n          \u0022y\u0022: [\n            6612,\n            6615.13,\n            6605.09,\n            6612\n          ]\n        }\n      ]\n    }\n  ],\n  \u0022chart\u0022: {\n    \u0022type\u0022: \u0022candlestick\u0022,\n    \u0022height\u0022: \u0022350px\u0022\n  },\n  \u0022title\u0022: {\n    \u0022text\u0022: \u0022CandleStick Chart\u0022,\n    \u0022align\u0022: \u0022left\u0022\n  },\n  \u0022xaxis\u0022: {\n    \u0022type\u0022: \u0022datetime\u0022\n  },\n  \u0022yaxis\u0022: {\n    \u0022tooltip\u0022: {\n      \u0022enabled\u0022: true\n    }\n  }\n}","init":true},"isVariation":"chart"} -->
<div class="gsbp-6a376a3" data-chart-data="&quot;{\n  \&quot;series\&quot;: [\n    {\n      \&quot;data\&quot;: [\n        {\n          \&quot;x\&quot;: \&quot;2018-10-05 20:30:00\&quot;,\n          \&quot;y\&quot;: [\n            6629.81,\n            6650.5,\n            6623.04,\n            6633.33\n          ]\n        },\n        {\n          \&quot;x\&quot;: \&quot;2018-10-05 21:00:00\&quot;,\n          \&quot;y\&quot;: [\n            6632.01,\n            6643.59,\n            6620,\n            6630.11\n          ]\n        },\n        {\n          \&quot;x\&quot;: \&quot;2018-10-05 21:30:00\&quot;,\n          \&quot;y\&quot;: [\n            6630.71,\n            6648.95,\n            6623.34,\n            6635.65\n          ]\n        },\n        {\n          \&quot;x\&quot;: \&quot;2018-10-05 22:00:00\&quot;,\n          \&quot;y\&quot;: [\n            6635.65,\n            6651,\n            6629.67,\n            6638.24\n          ]\n        },\n        {\n          \&quot;x\&quot;: \&quot;2018-10-05 22:30:00\&quot;,\n          \&quot;y\&quot;: [\n            6638.24,\n            6640,\n            6620,\n            6624.47\n          ]\n        },\n        {\n          \&quot;x\&quot;: \&quot;2018-10-05 23:00:00\&quot;,\n          \&quot;y\&quot;: [\n            6624.53,\n            6636.03,\n            6621.68,\n            6624.31\n          ]\n        },\n        {\n          \&quot;x\&quot;: \&quot;2018-10-05 23:30:00\&quot;,\n          \&quot;y\&quot;: [\n            6624.61,\n            6632.2,\n            6617,\n            6626.02\n          ]\n        },\n        {\n          \&quot;x\&quot;: \&quot;2018-10-06 00:00:00\&quot;,\n          \&quot;y\&quot;: [\n            6627,\n            6627.62,\n            6584.22,\n            6603.02\n          ]\n        },\n        {\n          \&quot;x\&quot;: \&quot;2018-10-06 00:30:00\&quot;,\n          \&quot;y\&quot;: [\n            6605,\n            6608.03,\n            6598.95,\n            6604.01\n          ]\n        },\n        {\n          \&quot;x\&quot;: \&quot;2018-10-06 01:00:00\&quot;,\n          \&quot;y\&quot;: [\n            6604.5,\n            6614.4,\n            6602.26,\n            6608.02\n          ]\n        },\n        {\n          \&quot;x\&quot;: \&quot;2018-10-06 01:30:00\&quot;,\n          \&quot;y\&quot;: [\n            6608.02,\n            6610.68,\n            6601.99,\n            6608.91\n          ]\n        },\n        {\n          \&quot;x\&quot;: \&quot;2018-10-06 02:00:00\&quot;,\n          \&quot;y\&quot;: [\n            6608.91,\n            6618.99,\n            6608.01,\n            6612\n          ]\n        },\n        {\n          \&quot;x\&quot;: \&quot;2018-10-06 02:30:00\&quot;,\n          \&quot;y\&quot;: [\n            6612,\n            6615.13,\n            6605.09,\n            6612\n          ]\n        }\n      ]\n    }\n  ],\n  \&quot;chart\&quot;: {\n    \&quot;type\&quot;: \&quot;candlestick\&quot;,\n    \&quot;height\&quot;: \&quot;350px\&quot;\n  },\n  \&quot;title\&quot;: {\n    \&quot;text\&quot;: \&quot;CandleStick Chart\&quot;,\n    \&quot;align\&quot;: \&quot;left\&quot;\n  },\n  \&quot;xaxis\&quot;: {\n    \&quot;type\&quot;: \&quot;datetime\&quot;\n  },\n  \&quot;yaxis\&quot;: {\n    \&quot;tooltip\&quot;: {\n      \&quot;enabled\&quot;: true\n    }\n  }\n}&quot;" data-chart-id="gsbp-6a376a3" data-series-0="" data-series="" data-xaxis-categories="" data-series-1="" data-series-2="" data-series-numbers="" data-labels=""></div>
<!-- /wp:greenshift-blocks/element -->
```

### General Rules & Best Practices

-   **Images (`<img>`):**
    -   Always add `loading="lazy"`.
    -   Use placeholder URLs like `https://placehold.co/WIDTHxHEIGHT` (e.g., `https://placehold.co/600x400`).
    -   Include `alt`, `width`, `height`, `src`.
-   **Links (`<a>`):** If using `target="_blank"` (via `linkNewWindow: true`), ensure `rel="noopener"` is present.
-   **SVG:** Remove `xmlns="..."` attributes from `<svg>` and `<path>` tags in the final HTML.
-   **Buttons:** Prefer `<a>` tags styled as buttons unless a `<button>` element is functionally required (e.g., form submit/reset).


#### Available CSS Variables

The plugin includes a comprehensive set of predefined CSS variables organized by categories. When setting values in `styleAttributes`, prioritize using these variables over hardcoded values:

**Font Sizes:**
- `var(--wp--preset--font-size--mini, 11px)` = 11px
- `var(--wp--preset--font-size--xs, 0.85rem)` = 0.85rem
- `var(--wp--preset--font-size--s, 1rem)` = 1rem
- `var(--wp--preset--font-size--r, 1.2rem)` = 1.2rem
- `var(--wp--preset--font-size--m, 1.35rem)` = 1.35rem
- `var(--wp--preset--font-size--l, 1.55rem)` = 1.55rem
- `var(--wp--preset--font-size--xl, clamp(1.6rem, 2.75vw, 1.9rem))` = clamp(1.6rem, 2.75vw, 1.9rem)
- `var(--wp--preset--font-size--xxl, clamp(1.75rem, 3vw, 2.2rem))` = clamp(1.75rem, 3vw, 2.2rem)
- `var(--wp--preset--font-size--high, clamp(1.9rem, 3.2vw, 2.4rem))` = clamp(1.9rem, 3.2vw, 2.4rem)
- `var(--wp--preset--font-size--grand, clamp(2.2rem, 4vw, 2.8rem))` = clamp(2.2rem, 4vw, 2.8rem)
- `var(--wp--preset--font-size--giga, clamp(3rem, 5vw, 4.5rem))` = clamp(3rem, 5vw, 4.5rem)
- `var(--wp--preset--font-size--giant, clamp(3.2rem, 6.2vw, 6.5rem))` = clamp(3.2rem, 6.2vw, 6.5rem)
- `var(--wp--preset--font-size--colossal, clamp(3.4rem, 9vw, 12rem))` = clamp(3.4rem, 9vw, 12rem)
- `var(--wp--preset--font-size--god, clamp(3.5rem, 12vw, 15rem))` = clamp(3.5rem, 12vw, 15rem)

**Line Heights:**
- `var(--wp--custom--line-height--mini, 14px)` = 14px
- `var(--wp--custom--line-height--xs, 1.15rem)` = 1.15rem
- `var(--wp--custom--line-height--s, 1.4rem)` = 1.4rem
- `var(--wp--custom--line-height--r, 1.9rem)` = 1.9rem
- `var(--wp--custom--line-height--m, 2.1rem)` = 2.1rem
- `var(--wp--custom--line-height--l, 2.37rem)` = 2.37rem
- `var(--wp--custom--line-height--xl, clamp(2.3rem, 3.45vw, 2.6rem))` = clamp(2.3rem, 3.45vw, 2.6rem)
- `var(--wp--custom--line-height--xxl, clamp(2.4rem, 3.55vw, 2.75rem))` = clamp(2.4rem, 3.55vw, 2.75rem)
- `var(--wp--custom--line-height--high, clamp(2.5rem, 3.7vw, 3rem))` = clamp(2.5rem, 3.7vw, 3rem)
- `var(--wp--custom--line-height--grand, clamp(2.75rem, 4.7vw, 3.5rem))` = clamp(2.75rem, 4.7vw, 3.5rem)
- `var(--wp--custom--line-height--giga, clamp(4rem, 6vw, 5rem))` = clamp(4rem, 6vw, 5rem)
- `var(--wp--custom--line-height--giant, clamp(4.2rem, 6.2vw, 7rem))` = clamp(4.2rem, 6.2vw, 7rem)
- `var(--wp--custom--line-height--colossal, clamp(4.1rem, 9.35vw, 17rem))` = clamp(4.1rem, 9.35vw, 17rem)
- `var(--wp--custom--line-height--god, clamp(4.2rem, 12.2vw, 20rem))` = clamp(4.2rem, 12.2vw, 20rem)

**Spacing:**
- `var(--wp--preset--spacing--20, 0.44rem)` = 0.44rem
- `var(--wp--preset--spacing--30, 0.67rem)` = 0.67rem
- `var(--wp--preset--spacing--40, 1rem)` = 1rem
- `var(--wp--preset--spacing--50, 1.5rem)` = 1.5rem
- `var(--wp--preset--spacing--60, 2.25rem)` = 2.25rem
- `var(--wp--preset--spacing--70, 3.38rem)` = 3.38rem
- `var(--wp--preset--spacing--80, 5.06rem)` = 5.06rem
- `var(--wp--preset--spacing--90, 7.59rem)` = 7.59rem
- `var(--wp--preset--spacing--100, 11.39rem)` = 11.39rem
- `var(--wp--preset--spacing--110, 17.09rem)` = 17.09rem
- `var(--wp--preset--spacing--110, 17.09rem)` = 17.09rem
- `var(--wp--custom--button--spacing--horizontal, 2.25rem)` = 2.25rem
- `var(--wp--custom--button--spacing--vertical, 1rem)` = 1rem


**Shadows:**
- `var(--wp--preset--shadow--accent, 0px 15px 25px 0px rgba(0, 0, 0, 0.1))` = 0px 15px 25px 0px rgba(0, 0, 0, 0.1)
- `var(--wp--preset--shadow--mild, 0px 5px 20px 0px rgba(0, 0, 0, 0.03))` = 0px 5px 20px 0px rgba(0, 0, 0, 0.03)
- `var(--wp--preset--shadow--soft, 0px 15px 30px 0px rgba(119, 123, 146, 0.1))` = 0px 15px 30px 0px rgba(119, 123, 146, 0.1)
- `var(--wp--preset--shadow--elegant, 0px 5px 23px 0px rgba(188, 207, 219, 0.35))` = 0px 5px 23px 0px rgba(188, 207, 219, 0.35)
- `var(--wp--preset--shadow--focus, 0px 2px 4px 0px rgba(0, 0, 0, 0.07))` = 0px 2px 4px 0px rgba(0, 0, 0, 0.07)
- `var(--wp--preset--shadow--highlight, 0px 32px 48px 0px rgba(0, 0, 0, 0.15))` = 0px 32px 48px 0px rgba(0, 0, 0, 0.15)

**Border Radius:**
- `var(--wp--custom--border-radius--mini, 5px)` = 5px
- `var(--wp--custom--border-radius--small, 10px)` = 10px
- `var(--wp--custom--border-radius--medium, 15px)` = 15px
- `var(--wp--custom--border-radius--large, 20px)` = 20px
- `var(--wp--custom--border-radius--xlarge, 35px)` = 35px
- `var(--wp--custom--border-radius--circle, 50%)` = 50%
- `var(--wp--custom--button--border-radius, 15px)` = 15px


**Transitions:**
- `var(--wp--custom--transition--ease, all 0.5s ease)` = all 0.5s ease
- `var(--wp--custom--transition--ease-in-out, all 0.3s ease-in-out)` = all 0.3s ease-in-out
- `var(--wp--custom--transition--creative, all 0.5s cubic-bezier(0.165, 0.84, 0.44, 1))` = all 0.5s cubic-bezier(0.165, 0.84, 0.44, 1)
- `var(--wp--custom--transition--soft, all 0.5s cubic-bezier(0.215, 0.61, 0.355, 1))` = all 0.5s cubic-bezier(0.215, 0.61, 0.355, 1)
- `var(--wp--custom--transition--mild, all 0.5s cubic-bezier(0.47, 0, 0.07, 1))` = all 0.5s cubic-bezier(0.47, 0, 0.07, 1)
- `var(--wp--custom--transition--elegant, all 0.5s cubic-bezier(0.35, 0.11, 0.22, 1.16))` = all 0.5s cubic-bezier(0.35, 0.11, 0.22, 1.16)
- `var(--wp--custom--transition--smooth, all 1s cubic-bezier(0.66,0,0.34,1))` = all 1s cubic-bezier(0.66,0,0.34,1)
- `var(--wp--custom--transition--accent, all 1s cubic-bezier(0.48,0.04,0.52,0.96))` = all 1s cubic-bezier(0.48,0.04,0.52,0.96)
- `var(--wp--custom--transition--motion, all 1s cubic-bezier(0.84,0,0.16,1))` = all 1s cubic-bezier(0.84,0,0.16,1)
- `var(--wp--custom--transition--light, all 1s cubic-bezier(0.4,0.8,0.74,1))` = all 1s cubic-bezier(0.4,0.8,0.74,1)

**Animation:**
- `var(--gs-root-animation-easing, cubic-bezier(0.42, 0, 0.58, 1))` = cubic-bezier(0.42, 0, 0.58, 1)

**Width/Height Sizes:**
- `var(--wp--custom--size--dot, 6px)` = 6px
- `var(--wp--custom--size--mini, 11px)` = 11px
- `var(--wp--custom--size--xs, 17px)` = 17px
- `var(--wp--custom--size--s, 26px)` = 26px
- `var(--wp--custom--size--r, 40px)` = 40px
- `var(--wp--custom--size--m, 56px)` = 56px
- `var(--wp--custom--size--l, 74px)` = 74px
- `var(--wp--custom--size--xl, 100px)` = 100px
- `var(--wp--custom--size--xxl, 150px)` = 150px
- `var(--wp--custom--size--high, 220px)` = 220px
- `var(--wp--custom--size--grand, 300px)` = 300px
- `var(--wp--custom--size--huge, 385px)` = 385px
- `var(--wp--custom--size--giant, 500px)` = 500px
- `var(--wp--custom--size--colossal, 700px)` = 700px
- `var(--wp--custom--size--god, 1000px)` = 1000px


**Usage Example:**
```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-example","textContent":"Variable Example","localId":"gsbp-example","styleAttributes":{"fontSize":["var(--wp--preset--font-size--l, 1.55rem)"],"lineHeight":["var(--wp--custom--line-height--l, 2.37rem)"],"paddingTop":["var(--wp--preset--spacing--50, 1.5rem)"],"backgroundColor":["var(--wp--preset--color--brand, #33EFAB)"]}} -->
<div class="gsbp-example">Variable Example</div>
<!-- /wp:greenshift-blocks/element -->
```

### Output Requirements

-   **Return only the generated block code.**
-   **Make sure that name of blocks are wp:greenshift-blocks/element.**
-   No surrounding explanations, comments, or introductory/concluding text.
-   The format must be exactly as shown in the examples, ready to be pasted into the WordPress Gutenberg code editor.