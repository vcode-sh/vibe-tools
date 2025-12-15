# Block Variations (`isVariation`)

Special interactive blocks with additional rules and attributes.

## Quick Reference

| Variation | Description |
|-----------|-------------|
| `contentwrapper` | Full-width section wrapper |
| `nocolumncontent` | Centered content area |
| `contentcolumns` | Section with columns |
| `contentarea` | Flexbox container |
| `accordion` | Collapsible accordion |
| `tabs` | Tab interface |
| `counter` | Animated number counter |
| `countdown` | Countdown timer |
| `marquee` | Scrolling marquee |
| `buttoncomponent` | Styled button |
| `videolightbox` | Video with lightbox |
| `youtubeplay` / `vimeoplay` | Video backgrounds |
| `svgtextpath` | SVG with text path |
| `divtext` | Simple text div |
| `tablist` | Tabs list container |

---

## Video Block

Native video element with standard HTML5 video attributes.

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-74e2fe8","tag":"video","localId":"gsbp-74e2fe8","src":"http://example.com/caira.mp4","alt":"","originalWidth":360,"originalHeight":360,"loop":true,"controls":true} -->
<video loop controls><source src="http://wp-test.local/wp-content/uploads/2024/10/caira.mp4" type="video/mp4"/></video>
<!-- /wp:greenshift-blocks/element -->
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `src` | String | Video URL |
| `loop` | Boolean | Loop video |
| `controls` | Boolean | Show controls |
| `autoplay` | Boolean | Auto start |
| `muted` | Boolean | Muted |
| `playsinline` | Boolean | Inline on mobile |
| `originalWidth` | Number | Original video width |
| `originalHeight` | Number | Original video height |

---

## Audio Block

Native audio player.

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-audio01","tag":"audio","localId":"gsbp-audio01","src":"https://example.com/audio.mp3","controls":true} -->
<audio controls><source src="https://example.com/audio.mp3" type="audio/mpeg"/></audio>
<!-- /wp:greenshift-blocks/element -->
```

---

## SVG Text Path

Text following an SVG path for curved text effects.

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-da307d9","tag":"svg","localId":"gsbp-da307d9","icon":{"icon":{"font":"","svg":"\u003csvg viewBox=\u00220 0 100 100\u0022 width=\u0022100\u0022 height=\u0022100\u0022\u003e\n  \u003cpath xmlns=\u0022http://www.w3.org/2000/svg\u0022 d=\u0022M 50,10 A 40,40 0 1,1 49.9,10 Z\u0022 fill=\u0022transparent\u0022 id=\u0022textPathgsbp-da307d9\u0022/\u003e\n\u003ctext xmlns=\u0022http://www.w3.org/2000/svg\u0022\u003e\u003ctextPath href=\u0022#textPathgsbp-da307d9\u0022 lengthAdjust=\u0022spacing\u0022\u003eGreenLight Element Text Path\u003c/textPath\u003e\u003c/text\u003e\u003c/svg\u003e","image":""},"type":"svg"},"textPathAttributes":{"enable":true,"text":"GreenLight Element Text Path","lengthAdjust":"spacing","startOffset":null},"isVariation":"svgtextpath"} -->
<svg viewBox="0 0 100 100" width="100" height="100" class="gsbp-da307d9">
  <path xmlns="http://www.w3.org/2000/svg" d="M 50,10 A 40,40 0 1,1 49.9,10 Z" fill="transparent" id="textPathgsbp-da307d9"/>
<text xmlns="http://www.w3.org/2000/svg"><textPath href="#textPathgsbp-da307d9" lengthAdjust="spacing">GreenLight Element Text Path</textPath></text></svg>
<!-- /wp:greenshift-blocks/element -->
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `textPathAttributes.enable` | Boolean | Enable text path |
| `textPathAttributes.text` | String | Text to display on path |
| `textPathAttributes.lengthAdjust` | String | How to adjust text spacing (`"spacing"` or `"spacingAndGlyphs"`) |
| `textPathAttributes.startOffset` | String/Number | Offset position of text on path |

---

## Counter Block

Animated number counter with scroll trigger.

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-bfa10e7","textContent":"10","localId":"gsbp-bfa10e7","styleAttributes":{"fontSize":["50px"],"lineHeight":["50px"],"minHeight":["50px"],"minWidth":["50px"],"display":["inline-block"],"position":["relative"]},"isVariation":"counter","endNumber":20,"durationNumber":2,"offsetNumber":50,"stepNumber":1} -->
<div class="gsbp-bfa10e7" data-gs-counter="{&quot;end&quot;:20,&quot;duration&quot;:2,&quot;offset&quot;:50,&quot;step&quot;:1}">10</div>
<!-- /wp:greenshift-blocks/element -->
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `endNumber` | Number | Target number to count to |
| `durationNumber` | Number | Animation duration (seconds) |
| `offsetNumber` | Number | Scroll offset trigger (percentage) |
| `stepNumber` | Number | Increment step size |
| `textContent` | String | Initial number display |

### Data Attribute

The counter uses `data-gs-counter` attribute with JSON configuration containing the end, duration, offset, and step values.

---

## Accordion Block

Collapsible content sections with smooth animations.

### Complete Example with dynamicGClasses

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-4893b17","dynamicGClasses":[{"value":"gs_accordion_273","type":"local","label":"gs_accordion_273","localed":false,"css":"","attributes":{"styleAttributes":{}},"originalBlock":"greenshift-blocks/element","selectors":[{"value":" > .gs_item","attributes":{"styleAttributes":{"borderRadiusLink_Extra":true,"borderTopLeftRadius":["8px"],"borderBottomLeftRadius":["8px"],"borderTopRightRadius":["8px"],"borderBottomRightRadius":["8px"],"overflow":["hidden"],"borderWidth":["1px"],"borderStyle":["solid"],"borderColor":["var(--wp--preset--color--border, #00000012)"],"borderCustom_Extra":false,"borderLink_Extra":false}},"css":".gs_accordion_273 > .gs_item{border-top-left-radius:8px;border-bottom-left-radius:8px;border-top-right-radius:8px;border-bottom-right-radius:8px;overflow:hidden;border-width:1px;border-style:solid;border-color:var(--wp--preset--color--border, #00000012);}"},{"value":" .gs_title","attributes":{"styleAttributes":{"marginTop":["0px"],"marginRight":["0px"],"marginBottom":["0px"],"marginLeft":["0px"],"paddingTop":["0px"],"paddingRight":["0px"],"paddingBottom":["0px"],"paddingLeft":["0px"]}},"css":".gs_accordion_273 .gs_title{margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px;}"},{"value":" .gs_title button","attributes":{"styleAttributes":{"fontSize":["1rem"],"backgroundColor":["#0000000d"],"borderCustom_Extra":true,"border":["none"],"paddingTop":["1rem"],"paddingBottom":["1rem"],"paddingRight":["1.5rem"],"paddingLeft":["1.5rem"],"fontWeight":["normal"],"textDecoration":["none"],"display":["flex"],"justifyContent":["space-between"],"alignItems":["center"],"width":["100%"],"color":["#000000"],"cursor":["pointer"],"columnGap":["5px"]}},"css":".gs_accordion_273 .gs_title button{font-size:1rem;background-color:#0000000d;border:none;padding-top:1rem;padding-bottom:1rem;padding-right:1.5rem;padding-left:1.5rem;font-weight:normal;text-decoration:none;display:flex;justify-content:space-between;align-items:center;width:100%;color:#000000;cursor:pointer;column-gap:5px;}"},{"value":" .gs_title .gs_icon","attributes":{"styleAttributes":{"width":["17px"],"height":["17px"],"transition":["all 0.5s ease"]}},"css":".gs_accordion_273 .gs_title .gs_icon{width:17px;height:17px;transition:all 0.5s ease;}"},{"value":"> .gs_item > .gs_content","attributes":{"styleAttributes":{"maxHeight":["0px"],"overflow":["hidden"],"transition":["max-height 0.5s cubic-bezier(0.42, 0, 0.58, 1), opacity 0.4s cubic-bezier(0.42, 0, 0.58, 1)"],"opacity":["0"]}},"css":".gs_accordion_273 > .gs_item > .gs_content{max-height:0px;overflow:hidden;transition:max-height 0.5s cubic-bezier(0.42, 0, 0.58, 1), opacity 0.4s cubic-bezier(0.42, 0, 0.58, 1);opacity:0;}"},{"value":" > .gs_item[data-active] > .gs_content","attributes":{"styleAttributes":{"maxHeight":["5000px"],"opacity":["1"]}},"css":".gs_accordion_273 > .gs_item[data-active] > .gs_content{max-height:5000px;opacity:1;}"},{"value":" .gs_content > .gs_content_inner","attributes":{"styleAttributes":{"paddingTop":["25px"],"paddingRight":["25px"],"paddingBottom":["25px"],"paddingLeft":["25px"],"fontSize":["1rem"],"lineHeight":["1.3rem"]}},"css":".gs_accordion_273 .gs_content > .gs_content_inner{padding-top:25px;padding-right:25px;padding-bottom:25px;padding-left:25px;font-size:1rem;line-height:1.3rem;}"},{"value":" > .gs_item[data-active] > .gs_title .gs_icon","attributes":{"styleAttributes":{"transform":["rotate(90deg)"]}},"css":".gs_accordion_273 > .gs_item[data-active] > .gs_title .gs_icon{transform:rotate(90deg);}"}]}],"type":"inner","className":"gs_accordion_273 gs_collapsible","localId":"gsbp-4893b17","dynamicAttributes":[{"name":"data-type","value":"accordion-component"}],"styleAttributes":{"position":["relative"],"display":["flex"],"flexDirection":["column"],"rowGap":["15px"],"columnGap":["15px"],"alignItems":["stretch"],"justifyContent":["flex-start"]},"isVariation":"accordion"} -->
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

### Structure

```
.gs_accordion (container, isVariation: "accordion")
└── .gs_item (accordion item)
    ├── .gs_title (h3)
    │   └── button.gs_click_sync
    │       ├── .gs_name (title text)
    │       └── .gs_icon (chevron icon)
    └── .gs_content
        └── .gs_content_inner (content)
```

### Key Classes

- `.gs_accordion` or `.gs_collapsible` - Main container
- `.gs_item` - Individual accordion item
- `.gs_item[data-active]` - Open item state
- `.gs_click_sync` - Click handler button
- `.gs_title` - Title container (h3)
- `.gs_name` - Title text span
- `.gs_icon` - Chevron SVG icon
- `.gs_content` - Content wrapper
- `.gs_content_inner` - Inner content padding area

### dynamicGClasses Selectors

The accordion uses complex CSS selectors via `dynamicGClasses`:

1. **` > .gs_item`** - Styles individual accordion items (borders, radius)
2. **` .gs_title`** - Resets margins/padding on title
3. **` .gs_title button`** - Styles the clickable button (background, padding, layout)
4. **` .gs_title .gs_icon`** - Icon size and transition
5. **`> .gs_item > .gs_content`** - Hidden state (max-height: 0, opacity: 0)
6. **` > .gs_item[data-active] > .gs_content`** - Visible state (max-height: 5000px, opacity: 1)
7. **` .gs_content > .gs_content_inner`** - Inner content padding and typography
8. **` > .gs_item[data-active] > .gs_title .gs_icon`** - Rotates icon when open

---

## Tabs Block

Tabbed content interface with smooth transitions.

### Complete Example with dynamicGClasses

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-286838a","dynamicGClasses":[{"value":"gs_tabs_517","type":"local","label":"gs_tabs_517","localed":false,"css":"","attributes":{"styleAttributes":{}},"originalBlock":"greenshift-blocks/element","selectors":[{"value":" .gs_tab","attributes":{"styleAttributes":{"fontSize":["1rem"],"backgroundColor":["#0000000d"],"borderCustom_Extra":true,"border":["none"],"paddingTop":["1rem"],"paddingBottom":["1rem"],"paddingRight":["1.5rem"],"paddingLeft":["1.5rem"],"fontWeight":["normal"],"textDecoration":["none"],"display":["flex"],"justifyContent":["center"],"alignItems":["center"],"color":["#000000"],"cursor":["pointer"],"columnGap":["10px"],"transition":["all 0.5s ease"]}},"css":".gs_tabs_517 .gs_tab{font-size:1rem;background-color:#0000000d;border:none;padding-top:1rem;padding-bottom:1rem;padding-right:1.5rem;padding-left:1.5rem;font-weight:normal;text-decoration:none;display:flex;justify-content:center;align-items:center;color:#000000;cursor:pointer;column-gap:10px;transition:all 0.5s ease;}"},{"value":" .gs_tab.active","attributes":{"styleAttributes":{"backgroundColor":["#000000"],"color":["#fff"]}},"css":".gs_tabs_517 .gs_tab.active{background-color:#000000;color:#fff;}"},{"value":" .gs_tab svg","attributes":{"styleAttributes":{"fill":["currentColor"],"width":["17px"],"height":["17px"]}},"css":".gs_tabs_517 .gs_tab svg{fill:currentColor;width:17px;height:17px;}"},{"value":" .gs_tab.active svg","attributes":{"styleAttributes":{"fill":["currentColor"]}},"css":".gs_tabs_517 .gs_tab.active svg{fill:currentColor;}"},{"value":" .gs_content","attributes":{"styleAttributes":{"overflow":["hidden"],"opacity":["0"],"maxHeight":["0px"],"transition":["opacity 0.5s cubic-bezier(0.42, 0, 0.58, 1), max-height 0.5s cubic-bezier(0.42, 0, 0.58, 1)"]}},"css":".gs_tabs_517 .gs_content{overflow:hidden;opacity:0;max-height:0px;transition:opacity 0.5s cubic-bezier(0.42, 0, 0.58, 1), max-height 0.5s cubic-bezier(0.42, 0, 0.58, 1);}"},{"value":" .gs_content.active","attributes":{"styleAttributes":{"opacity":["1"],"maxHeight":["5000px"]}},"css":".gs_tabs_517 .gs_content.active{opacity:1;max-height:5000px;}"},{"value":" .gs_content > .gs_content_inner","attributes":{"styleAttributes":{"paddingTop":["25px"],"paddingRight":["25px"],"paddingBottom":["25px"],"paddingLeft":["25px"],"fontSize":["1rem"],"lineHeight":["1.3rem"]}},"css":".gs_tabs_517 .gs_content > .gs_content_inner{padding-top:25px;padding-right:25px;padding-bottom:25px;padding-left:25px;font-size:1rem;line-height:1.3rem;}"}]}],"type":"inner","className":"gs_tabs_517 gs_root","localId":"gsbp-286838a","styleAttributes":{"position":["relative"],"display":["flex"],"flexDirection":["column"],"alignItems":["stretch"],"justifyContent":["flex-start"]},"isVariation":"tabs","dynamicAttributes":[{"name": "data-type", "value":"tabs-component"}]} -->
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

### Structure

```
.gs_root (container, isVariation: "tabs")
├── .gs_tabs_list (tablist container, isVariation: "tablist")
│   ├── button.gs_tab.active (first tab)
│   └── button.gs_tab (other tabs)
└── .gs_content_area
    ├── .gs_content.active (first panel)
    └── .gs_content (other panels)
```

### Key Classes

- `.gs_root` - Main tabs container
- `.gs_tabs_list` - Tab buttons container (with `role="tablist"`)
- `.gs_tab` - Individual tab button
- `.gs_tab.active` - Active tab state
- `.gs_click_sync` - Click handler
- `.gs_name` - Tab title text
- `.gs_content_area` - Content panels container
- `.gs_content` - Content panel (with `role="tabpanel"`)
- `.gs_content.active` - Visible panel
- `.gs_content_inner` - Inner content padding area

### dynamicGClasses Selectors

The tabs use complex CSS selectors via `dynamicGClasses`:

1. **` .gs_tab`** - Styles all tab buttons (background, padding, layout)
2. **` .gs_tab.active`** - Active tab state (different background/color)
3. **` .gs_tab svg`** - SVG icons in tabs
4. **` .gs_tab.active svg`** - SVG icons in active tabs
5. **` .gs_content`** - Hidden panel state (max-height: 0, opacity: 0)
6. **` .gs_content.active`** - Visible panel state (max-height: 5000px, opacity: 1)
7. **` .gs_content > .gs_content_inner`** - Inner content padding and typography

---

## Countdown Block

Timer counting down to a specific date.

### Complete Example with dynamicGClasses

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

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `endtime` | String | ISO date format `YYYY-MM-DDTHH:mm:ss` |

### CSS Classes

- `.gs_countdown` - Main countdown container
- `.gs_days`, `.gs_hours`, `.gs_minutes`, `.gs_seconds` - Time unit spans
- `.gs_countdown_item` - Common styling for all time units
- `.gs_date_divider` - Separator styling (typically ":")

### dynamicGClasses Selectors

1. **` .gs_countdown_item`** - Styles the time unit numbers (font size, weight)
2. **` .gs_date_divider`** - Styles the divider separators

### Data Attribute

The countdown uses `data-end` attribute with the target date/time in ISO format.

---

## Button Component

Styled button using CSS variables for consistent theming.

### Complete Example with dynamicGClasses

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-b65d91f","inlineCssStyles":".gs_button{text-decoration:none;display:inline-block;position:relative;overflow:hidden;border-bottom-left-radius:var(--wp--custom--button--border-radius, var(--wp-custom--border-radius--medium, 15px));border-bottom-right-radius:var(--wp--custom--button--border-radius, var(--wp-custom--border-radius--medium, 15px));border-top-left-radius:var(--wp--custom--button--border-radius, var(--wp-custom--border-radius--medium, 15px));border-top-right-radius:var(--wp--custom--button--border-radius, var(--wp-custom--border-radius--medium, 15px));padding-top:var(--wp--custom--button--spacing--vertical, var(--wp-preset--spacing--40, 1rem));padding-bottom:var(--wp--custom--button--spacing--vertical, var(--wp-preset--spacing--40, 1rem));padding-right:var(--wp--custom--button--spacing--horizontal, var(--wp-preset--spacing--60, 2.25rem));padding-left:var(--wp--custom--button--spacing--horizontal, var(--wp-preset--spacing--60, 2.25rem));background-color:var(--wp--custom--button--background, var(--wp-preset--color--brand, #33EFAB));color:var(--wp--custom--button--text, var(--wp-preset--color--text-on-brand, #000002));}.gs_button:hover{color:var(--wp--custom--button--text-hover, var(--wp-preset--color--text-on-brand-hover, #000003));background-color:var(--wp--custom--button--background-hover, var(--wp-preset--color--brand-hover, #7AFFCE));}.gs_button.gs_button_secondary{background-color:var(--wp--custom--button--secondary-background, var(--wp-preset--color--secondary, #340fa0));color:var(--wp--custom--button--secondary-text, #ffffff);}.gs_button.gs_button_secondary:hover{background-color:var(--wp--custom--button--secondary-background-hover, var(--wp-preset--color--secondary-hover, #441999)); color:var(--wp--custom--button--secondary-text-hover, var(--wp-preset--color--text-on-secondary-hover, #fffffd));}.gs_button.gs_button_custom_color{background-color:#1A3138;color:#ffffff;}.gs_button.gs_button_custom_color:hover{background-color:#000000;}","dynamicGClasses":[{"value":"gs-parent-hover","type":"preset","label":"gs-parent-hover"},{"value":"gs_button","type":"local","label":"gs_button","localed":false,"css":".gs_button{text-decoration:none;display:inline-block;position:relative;overflow:hidden;border-bottom-left-radius:var(--wp--custom--button--border-radius, var(--wp-custom--border-radius--medium, 15px));border-bottom-right-radius:var(--wp--custom--button--border-radius, var(--wp-custom--border-radius--medium, 15px));border-top-left-radius:var(--wp--custom--button--border-radius, var(--wp-custom--border-radius--medium, 15px));border-top-right-radius:var(--wp--custom--button--border-radius, var(--wp-custom--border-radius--medium, 15px));padding-top:var(--wp--custom--button--spacing--vertical, var(--wp-preset--spacing--40, 1rem));padding-bottom:var(--wp--custom--button--spacing--vertical, var(--wp-preset--spacing--40, 1rem));padding-right:var(--wp--custom--button--spacing--horizontal, var(--wp-preset--spacing--60, 2.25rem));padding-left:var(--wp--custom--button--spacing--horizontal, var(--wp-preset--spacing--60, 2.25rem));background-color:var(--wp--custom--button--background, var(--wp-preset--color--brand, #33EFAB));color:var(--wp--custom--button--text, var(--wp-preset--color--text-on-brand, #000002));}.gs_button:hover{color:var(--wp--custom--button--text-hover, var(--wp-preset--color--text-on-brand-hover, #000003));background-color:var(--wp--custom--button--background-hover, var(--wp-preset--color--brand-hover, #7AFFCE));}","attributes":{"styleAttributes":{"textDecoration":["none"],"display":["inline-block"],"position":["relative"],"overflow":["hidden"],"color_hover":["var(--wp--custom--button--text-hover, var(--wp-preset--color--text-on-brand-hover, #000003))"],"borderBottomLeftRadius":["var(--wp--custom--button--border-radius, var(--wp-custom--border-radius--medium, 15px))"],"borderBottomRightRadius":["var(--wp--custom--button--border-radius, var(--wp-custom--border-radius--medium, 15px))"],"borderTopLeftRadius":["var(--wp--custom--button--border-radius, var(--wp-custom--border-radius--medium, 15px))"],"borderTopRightRadius":["var(--wp--custom--button--border-radius, var(--wp-custom--border-radius--medium, 15px))"],"borderRadiusCustom_Extra":false,"borderRadiusLink_Extra":true,"paddingTop":["var(--wp--custom--button--spacing--vertical, var(--wp-preset--spacing--40, 1rem))"],"paddingBottom":["var(--wp--custom--button--spacing--vertical, var(--wp-preset--spacing--40, 1rem))"],"paddingRight":["var(--wp--custom--button--spacing--horizontal, var(--wp-preset--spacing--60, 2.25rem))"],"paddingLeft":["var(--wp--custom--button--spacing--horizontal, var(--wp-preset--spacing--60, 2.25rem))"],"backgroundColor":["var(--wp--custom--button--background, var(--wp-preset--color--brand, #33EFAB))"],"backgroundColor_hover":["var(--wp--custom--button--background-hover, var(--wp-preset--color--brand-hover, #7AFFCE))"],"color":["var(--wp--custom--button--text, var(--wp-preset--color--text-on-brand, #000002))"]}},"originalBlock":"greenshift-blocks/element","selectors":[{"value":".gs_button_secondary","attributes":{"styleAttributes":{"backgroundColor":["var(--wp--custom--button--secondary-background, var(--wp-preset--color--secondary, #340fa0))"],"color":["var(--wp--custom--button--secondary-text, var(--wp-preset--color--text-on-secondary, #fffffc))"],"backgroundColor_hover":["var(--wp--custom--button--secondary-background-hover, var(--wp-preset--color--secondary-hover, #340fa0))"],"color_hover":["var(--wp--custom--button--secondary-text-hover, var(--wp-preset--color--text-on-secondary-hover, #fffffd))"]}},"css":".gs_button.gs_button_secondary{background-color:var(--wp--custom--button--secondary-background, var(--wp-preset--color--secondary, #340fa0));color:var(--wp--custom--button--secondary-text, #ffffff);}.gs_button.gs_button_secondary:hover{background-color:var(--wp--custom--button--secondary-background-hover, var(--wp-preset--color--secondary-hover, #441999)); color:var(--wp--custom--button--secondary-text-hover, var(--wp-preset--color--text-on-secondary-hover, #fffffd));}"},{"value":".gs_button_custom_color","attributes":{"styleAttributes":{"backgroundColor":["#1A3138"],"color":["#ffffff"],"backgroundColor_hover":["#000000"]}},"css":".gs_button.gs_button_custom_color{background-color:#1A3138;color:#ffffff;}.gs_button.gs_button_custom_color:hover{background-color:#000000;}"}]}],"textContent":"Download for Free!","tag":"a","className":"gs-parent-hover gs_button","localId":"gsbp-b65d91f","href":"#","dynamicAttributes":[{"name":"data-type","value":"button-component"}],"isVariation":"buttoncomponent"} -->
<a class="gs-parent-hover gs_button" href="#" data-type="button-component">Download for Free!</a>
<!-- /wp:greenshift-blocks/element -->
```

### CSS Variables Used

The button component uses theme CSS variables for consistency:

**Primary Button:**
- `--wp--custom--button--background` - Background color
- `--wp--custom--button--text` - Text color
- `--wp--custom--button--background-hover` - Hover background
- `--wp--custom--button--text-hover` - Hover text color
- `--wp--custom--button--spacing--vertical` - Top/bottom padding
- `--wp--custom--button--spacing--horizontal` - Left/right padding
- `--wp--custom--button--border-radius` - Border radius

**Secondary Button:**
- `--wp--custom--button--secondary-background`
- `--wp--custom--button--secondary-text`
- `--wp--custom--button--secondary-background-hover`
- `--wp--custom--button--secondary-text-hover`

### Button Variants

The button component supports multiple variants through additional classes:

1. **Primary Button** - `.gs_button` (default)
2. **Secondary Button** - `.gs_button.gs_button_secondary`
3. **Custom Color Button** - `.gs_button.gs_button_custom_color`

### dynamicGClasses Selectors

1. **`.gs_button`** (base class) - All button styles including hover
2. **`.gs_button_secondary`** - Secondary button variant with hover
3. **`.gs_button_custom_color`** - Custom colored button with hover

---

## Inline YouTube Video Block

Used primarily for video backgrounds from YouTube links. Features muted autoplay and loop.

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-c1db4cc","tag":"iframe","localId":"gsbp-c1db4cc","src":"https://www.youtube.com/watch?v=PpGeRu0mZy0","dynamicAttributes":[{"name":"allow","value":"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"},{"name":"allowfullscreen","value":"true"}],"styleAttributes":{"aspectRatio":["16/9"],"display":["block"],"objectFit":["cover"],"width":["100%"],"pointerEvents":["none"]},"isVariation":"youtubeplay"} -->
<iframe class="gsbp-c1db4cc" src="https://www.youtube.com/watch?v=PpGeRu0mZy0" frameborder="0" loading="lazy" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
<!-- /wp:greenshift-blocks/element -->
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `src` | String | YouTube video URL |
| `isVariation` | String | Must be `"youtubeplay"` |
| `styleAttributes.aspectRatio` | Array | Video aspect ratio (e.g., `["16/9"]`) |
| `styleAttributes.pointerEvents` | Array | Set to `["none"]` to disable interaction |

---

## Inline Vimeo Video Block

Used primarily for video backgrounds from Vimeo links. Features muted autoplay and loop.

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-add38f7","tag":"iframe","localId":"gsbp-add38f7","src":"https://vimeo.com/863362136","dynamicAttributes":[{"name":"allow","value":"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"},{"name":"allowfullscreen","value":"true"}],"styleAttributes":{"aspectRatio":["16/9"],"display":["block"],"objectFit":["cover"],"width":["100%"],"pointerEvents":["none"]},"isVariation":"vimeoplay"} -->
<iframe class="gsbp-add38f7" src="https://vimeo.com/863362136" frameborder="0" loading="lazy" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
<!-- /wp:greenshift-blocks/element -->
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `src` | String | Vimeo video URL |
| `isVariation` | String | Must be `"vimeoplay"` |
| `styleAttributes.aspectRatio` | Array | Video aspect ratio (e.g., `["16/9"]`) |
| `styleAttributes.pointerEvents` | Array | Set to `["none"]` to disable interaction |

---

## Video Lightbox Block

Video with popup lightbox and animated play button.

### Complete Example with dynamicGClasses

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-fc481da","dynamicGClasses":[{"value":"gs_videolightbox_853","type":"local","label":"gs_videolightbox_853","localed":false,"css":"","attributes":{"styleAttributes":{}},"originalBlock":"greenshift-blocks/element","selectors":[{"value":" .play_button_pulse","attributes":{"styleAttributes":{"position":["absolute"],"width":["80px"],"height":["80px"],"borderRadius":["50%"],"backgroundColor":["#ff0000"],"border":["none"],"cursor":["pointer"],"display":["flex"],"alignItems":["center"],"justifyContent":["center"],"zIndex":["1"]}},"css":".gs_videolightbox_853 .play_button_pulse{position:absolute;width:80px;height:80px;border-radius:50%;background-color:#ff0000;border:none;cursor:pointer;display:flex;align-items:center;justify-content:center;z-index:1;}"},{"value":" .play_button_pulse::before","attributes":{"styleAttributes":{"content":["\"\""],"borderRadius":["50%"],"animation":["pulse-ring 2s cubic-bezier(0.215, 0.61, 0.355, 1) infinite"],"position":["absolute"],"left":["0px"],"top":["0px"],"bottom":["0px"],"right":["0px"],"borderWidth":["1px"],"borderStyle":["solid"],"borderColor":["#ff0000"],"animation_keyframes_Extra":[{"name":"pulse-ring","code":["from{\nscale:1;\nopacity:1;\n}\nto{\nscale:1.5;\nopacity:0;\n}","","",""]}]}},"css":".gs_videolightbox_853 .play_button_pulse::before{content:\"\";border-radius:50%;animation:pulse-ring 2s cubic-bezier(0.215, 0.61, 0.355, 1) infinite;position:absolute;left:0px;top:0px;bottom:0px;right:0px;border-width:1px;border-style:solid;border-color:#ff0000;}\n@keyframes pulse-ring {\nfrom{\nscale:1;\nopacity:1;\n}\nto{\nscale:1.5;\nopacity:0;\n}\n}\n@media (prefers-reduced-motion) {\n.gs_videolightbox_00000 .play_button_pulse::before {\nanimation: none !important;\n}\n}"},{"value":" .play_button_pulse::after","attributes":{"styleAttributes":{"content":["\"\""],"position":["absolute"],"borderRadius":["50%"],"animation":["pulse-ring 2s cubic-bezier(0.215, 0.61, 0.355, 1) infinite 0.5s"],"top":["0px"],"left":["0px"],"bottom":["0px"],"right":["0px"],"borderWidth":["1px"],"borderStyle":["solid"],"borderColor":["#ff0000"]}},"css":".gs_videolightbox_853 .play_button_pulse::after{content:\"\";position:absolute;border-radius:50%;animation:pulse-ring 2s cubic-bezier(0.215, 0.61, 0.355, 1) infinite 0.5s;top:0px;left:0px;bottom:0px;right:0px;border-width:1px;border-style:solid;border-color:#ff0000;}"}]}],"interactionLayers":[{"actions":[{"actionname":"lightbox"}],"env":"no-action","triggerData":{"trigger":"click"}}],"type":"inner","className":"gs_videolightbox_853","localId":"gsbp-fc481da","styleAttributes":{"position":["relative"],"display":["flex"],"flexDirection":["column"],"justifyContent":["center"],"alignItems":["center"]},"isVariation":"videolightbox","dynamicAttributes":[{"name":"data-type","value":"video-lightbox-component"}]} -->
<div data-gspbactions="[{&quot;actions&quot;:[{&quot;actionname&quot;:&quot;lightbox&quot;}],&quot;env&quot;:&quot;no-action&quot;,&quot;triggerData&quot;:{&quot;trigger&quot;:&quot;click&quot;}}]" class="gs_videolightbox_853 gsbp-fc481da" data-type="video-lightbox-component"><!-- wp:greenshift-blocks/element {"id":"gsbp-2f4769b","tag":"button","type":"inner","className":"play_button_pulse","localId":"gsbp-2f4769b","formAttributes":{"type":"button"},"metadata":{"name":"Play Button"}} -->
<button class="play_button_pulse" type="button"><!-- wp:greenshift-blocks/element {"id":"gsbp-89c9513","tag":"svg","icon":{"icon":{"font":"","svg":"\u003csvg viewBox=\u00220 0 100 100\u0022 width=\u0022100\u0022 height=\u0022100\u0022\u003e\u003cpolygon xmlns=\u0022http://www.w3.org/2000/svg\u0022 points=\u002230,20 30,80 70,50\u0022 fill=\u0022#ffffff\u0022/\u003e\u003c/svg\u003e","image":""},"type":"svg"},"localId":"gsbp-89c9513","metadata":{"name":"Play Icon"}} -->
<svg viewBox="0 0 100 100" width="100" height="100" class="gsbp-89c9513"><polygon xmlns="http://www.w3.org/2000/svg" points="30,20 30,80 70,50" fill="#ffffff"/></svg>
<!-- /wp:greenshift-blocks/element --></button>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-745540d","tag":"img","localId":"gsbp-745540d","src":"https://placehold.co/1280x720","alt":"","styleAttributes":{"aspectRatio":["16/9"],"objectFit":["cover"]},"metadata":{"name":"Video Thumbnail"}} -->
<img class="gsbp-745540d" src="https://placehold.co/1280x720" alt="" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></div>
<!-- /wp:greenshift-blocks/element -->
```

### Key Components

1. **Container** - Main wrapper with `isVariation: "videolightbox"` and `interactionLayers` for lightbox trigger
2. **Play Button** - `.play_button_pulse` with animated pulse effect
3. **Play Icon** - SVG triangle play icon
4. **Thumbnail** - Image showing video preview

### dynamicGClasses Selectors

1. **` .play_button_pulse`** - Play button styling (circular, centered, positioned)
2. **` .play_button_pulse::before`** - First pulse ring animation
3. **` .play_button_pulse::after`** - Second pulse ring animation (delayed)

### Interaction Layers

The lightbox functionality uses `interactionLayers`:

```json
{
  "interactionLayers": [{
    "actions": [{"actionname": "lightbox"}],
    "env": "no-action",
    "triggerData": {"trigger": "click"}
  }]
}
```

This gets converted to the `data-gspbactions` HTML attribute.

---

## Marquee Block

Scrolling text or content with continuous animation.

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-ee95a85","type":"inner","localId":"gsbp-ee95a85","marqueeSpeed":12,"isVariation":"marquee"} -->
<div class="gsbp-ee95a85"><div class="gspb_marquee_content"><!-- wp:greenshift-blocks/element {"id":"gsbp-a7ca8ce","textContent":"Add Scroll Elements Here","tag":"span","localId":"gsbp-a7ca8ce","styleAttributes":{"fontSize":"30px"}} -->
<span class="gsbp-a7ca8ce">Add Scroll Elements Here</span>
<!-- /wp:greenshift-blocks/element --><span class="gspb_marquee_content_end"></span></div></div>
<!-- /wp:greenshift-blocks/element -->
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `marqueeSpeed` | Number | Scroll speed (pixels per second) |
| `isVariation` | String | Must be `"marquee"` |

### Structure

```
.marquee-container (outer element)
└── .gspb_marquee_content (scrolling content wrapper)
    ├── [your content elements]
    └── span.gspb_marquee_content_end (end marker)
```

---

## Table Element

Tables with special styling attributes for responsive layouts.

### Complete Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-7f2c7b7","tag":"table","type":"inner","localId":"gsbp-7f2c7b7","tableAttributes":{"table":{"responsive":"yes"}},"tableStyles":{"table":{"layout":"fixed","border":"collapse"},"responsive":"yes","td":{"paddingTop":["6px"],"paddingBottom":["6px"],"paddingRight":["12px"],"paddingLeft":["12px"],"borderStyle":"solid","borderWidth":"1px","borderColor":"var(--wp--preset--color--border, #00000012)","fontSize":["14px"]},"th":{"paddingTop":["6px"],"paddingBottom":["6px"],"paddingRight":["12px"],"paddingLeft":["12px"],"borderStyle":"solid","borderWidth":"1px","borderColor":"var(--wp--preset--color--border, #00000012)","fontSize":["16px"],"backgroundColor":"var(--wp--preset--color--lightbg, #cddceb21)"}},"styleAttributes":{"width":["100%"]}} -->
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

### Parameters

**`tableAttributes`** - HTML table attributes:
- `table.responsive` - Set to `"yes"` for responsive table behavior

**`tableStyles`** - Styling for table elements:

**`tableStyles.table`** - Table element styles:
- `layout` - Table layout (`"fixed"` or `"auto"`)
- `border` - Border collapse (`"collapse"` or `"separate"`)

**`tableStyles.td`** - Table cell (`<td>`) styles:
- Supports all `styleAttributes` properties
- Common: `paddingTop`, `paddingBottom`, `paddingLeft`, `paddingRight`
- Border: `borderStyle`, `borderWidth`, `borderColor`
- Typography: `fontSize`, `color`

**`tableStyles.th`** - Table header (`<th>`) styles:
- Supports all `styleAttributes` properties
- Same properties as `td` plus:
- `backgroundColor` - Header background color
- `fontWeight` - Header text weight

**`tableStyles.responsive`** - Set to `"yes"` to enable responsive behavior

### Note

Tables have an extra `tableStyles` attribute where we have styles for `table`, `td`, and `th` elements, plus a responsive attribute to make the table responsive on mobile devices.
