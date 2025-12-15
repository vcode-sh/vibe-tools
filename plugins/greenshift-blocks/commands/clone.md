---
description: Convert a screenshot or image of a website/component into WordPress Greenshift blocks
argument-hint: [image path or paste screenshot]
---

# Screenshot to Greenshift Block Converter

Convert screenshots, website designs, or component images into production-ready WordPress Gutenberg blocks using Greenshift.

## Instructions

### Step 1: Read the Image

1. Use the Read tool to view the provided screenshot/image at: $ARGUMENTS
2. If no image path provided, ask the user to provide the screenshot path

### Step 2: Analyze the Design Thoroughly

Study the screenshot and document EVERYTHING you see:

**Layout Structure:**
- Overall layout type (hero, section, card grid, footer, etc.)
- Column structure and widths (2-col, 3-col, 4-col)
- Content hierarchy and nesting
- Spacing patterns (padding, margins, gaps)
- Full-width vs contained width

**Visual Elements:**
- Headings (H1, H2, H3, etc.) with sizes
- Paragraph text and descriptions
- Images with aspect ratios (estimate dimensions for placeholders)
- Buttons/CTAs (primary, secondary, outline, ghost)
- Icons (where and what type)
- Decorative elements

**Backgrounds & Layers:**
- Background colors (solid, transparent with opacity)
- Background gradients (direction, colors, stops)
- Background images (full-width, contained, patterns)
- Overlays (dark/light overlays on images, opacity level)
- Layered elements (what's on top of what, z-index order)
- Parallax or fixed backgrounds

**Border & Shape Details:**
- Border radius (slight rounding vs pill-shaped vs circle)
- Estimate radius: small (~5px), medium (~10-15px), large (~20-30px), pill (~50px), circle (50%)
- Border styles (solid, dashed, none)
- Border colors and widths
- Box shadows (subtle, medium, heavy)
- Card/container shapes

**Interactive Components (identify if present):**
- Sliders/Carousels
- Accordions/FAQs
- Tabs
- Counters/Statistics
- Countdown timers
- Video players (native, YouTube, Vimeo, lightbox)
- Tables
- Marquee/scrolling text

**Styling Details:**
- Color palette (extract exact colors where possible)
- Typography sizes and weights
- Alignment (center, left, right, justify)
- Hover effects visible in design

### Step 3: Ask User About Color Handling

Before generating code, ASK the user:

**"I can see the colors in your design. How would you like me to handle them?"**

Use AskUserQuestion tool with these options:
1. **"Use CSS Variables (Recommended)"** - Colors will use WordPress theme variables like `var(--wp--preset--color--primary)`, `var(--wp--preset--color--secondary)`. The design will automatically match the user's WordPress theme.
2. **"Use Exact Colors from Screenshot"** - Colors will be hardcoded hex values extracted from the design (e.g., `#3B82F6`, `#1F2937`). Use this if the user wants pixel-perfect color matching.

**Color Variable Mapping Guide:**
| Design Element | CSS Variable |
|----------------|--------------|
| Primary buttons, accents | `var(--wp--preset--color--primary)` or `var(--wp--preset--color--brand)` |
| Secondary buttons | `var(--wp--preset--color--secondary)` |
| Dark text | `var(--wp--preset--color--text)` or `var(--wp--preset--color--heading)` |
| Light/muted text | `var(--wp--preset--color--text-light)` |
| Light backgrounds | `var(--wp--preset--color--lightbg)` |
| Dark backgrounds | `var(--wp--preset--color--darkbg)` |
| Borders | `var(--wp--preset--color--border)` |
| White | `#ffffff` (ok to hardcode) |
| Black | `#000000` (ok to hardcode) |

### Step 4: Ask User About Animations

ASK the user about animations:

**"Would you like entrance animations on elements, or keep everything static?"**

Use AskUserQuestion tool with these options:
1. **"Static (No Animations)"** - Elements appear immediately, no entrance effects. Best for fast-loading, accessible pages.
2. **"Subtle Animations (Recommended)"** - Gentle fade-up animations on scroll. Professional and modern.
3. **"Full Animations"** - More dynamic entrance effects with staggered delays. More engaging but heavier.

### Step 5: Ask User for Additional Context (Optional but Recommended)

Screenshots can be misinterpreted - embedded content, browser UI elements, or complex layouts may not be recognized correctly. ASK the user:

**"Do you have any additional details about this design I should know?"**

Use AskUserQuestion tool with these options:
1. **"No, screenshot is clear"** - Proceed with analysis as-is.
2. **"Yes, let me clarify"** - User will provide additional context.

**If user chooses to clarify, ask them to describe:**
- Which elements are actual components vs browser/embed artifacts
- Specific functionality (e.g., "the cards should be clickable links")
- Content that should be different (e.g., "use different placeholder text")
- Elements to skip or ignore
- Specific interactions (e.g., "hover effects on buttons")
- Responsive behavior preferences

**Common clarifications to look for:**
| Screenshot Issue | User Might Clarify |
|------------------|-------------------|
| Browser chrome visible | "Ignore the browser UI, just the page content" |
| Embedded iframe/widget | "That's an embedded map, use a placeholder div" |
| Multiple sections | "Only convert the hero section, not the nav" |
| Video thumbnails | "That's a video player, use videolightbox variation" |
| Form elements | "Those are form fields, skip them for now" |
| Mobile vs desktop | "This is mobile view, make it responsive" |
| Charts/graphs visible | "Create real chart" or "Just use image placeholder" |

**Special Case: Charts Detected**

If you detect charts, graphs, or data visualizations in the screenshot, ASK specifically:

**"I see what looks like a chart/graph in the design. How should I handle it?"**

Use AskUserQuestion tool with these options:
1. **"Create Real Interactive Chart"** - Will use Greenshift's ApexCharts (`type: "chart"`, `isVariation: "chart"`). You'll need to ask about chart type (line, bar, pie, area, radar) and sample data.
2. **"Use Image Placeholder"** - Will use a placeholder image in place of the chart. Simpler, no interactivity.
3. **"Skip This Element"** - Don't include the chart area at all.

**If user wants real chart, follow up with:**
- Chart type: line, area, bar, pie, radar, candlestick
- Sample data structure (or use placeholder data)
- Color scheme preference
- Read `docs/11-charts.md` for ApexCharts configuration

---

## Animation Guidelines (When User Chooses Animations)

### General Rules
- **Always use `onlyonce: true`** - Entrance animations should play only once
- **Keep durations short**: 300-800ms max (default: 800ms)
- **Default easing**: `ease-out` for entrance animations (elements entering screen)
- **Stagger delays**: 150-300ms between sequential elements

### Available Easing in Greenshift

**AOS Animations (simple entrance effects):**
- `ease` - General purpose (default)
- `ease-out` - Best for elements entering ✓
- `ease-in-out` - For elements moving within screen
- `linear` - Constant speed

**CSS Keyframe Animations (for custom effects):**
Can use `cubic-bezier()` for advanced easing:
- `ease-out-cubic`: `cubic-bezier(.215, .61, .355, 1)` ✓ Recommended
- `ease-out-quart`: `cubic-bezier(.165, .84, .44, 1)`
- `ease-out-expo`: `cubic-bezier(.19, 1, .22, 1)`

### Recommended Animation Patterns

**Subtle (Option 2):**
```json
"animation": {"type": "fade-up", "duration": 600, "easing": "ease-out", "onlyonce": true}
```

**Full Animations (Option 3) - Staggered:**
| Element | Type | Delay |
|---------|------|-------|
| Heading | `fade-up` or `clip-right` | 0ms |
| Subheading | `fade-up` | 200ms |
| Description | `fade-up` | 400ms |
| Button | `fade-up` | 600ms |
| Cards (grid) | `fade-up` | +150ms each |

### Performance Rules
- Prefer `opacity` and `transform` (scale, translate) - GPU accelerated
- Avoid animating `width`, `height`, `top`, `left` - use transforms instead
- Don't animate blur values above 20px
- Maximum 1s duration for any animation

### Accessibility
- Users with `prefers-reduced-motion` will see reduced/no animations (handled by Greenshift)
- Entrance animations help guide attention but shouldn't be overwhelming

### DO NOT USE
- `infinite` animations for content (only for decorative loaders)
- Bouncy/spring effects (not available in Greenshift)
- Very long animations (>1s)
- `ease-in` for entrance (makes UI feel slow)

---

### Step 6: Read Documentation (MANDATORY)

You MUST read these files before generating code. Read them IN THIS ORDER:

**1. SKILL.md (ALWAYS READ FIRST):**
```
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/SKILL.md
```
This is the primary reference with all critical rules, SVG encoding, image handling, and card patterns.

**2. Core Structure & Attributes (ALWAYS READ):**
```
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/01-core-structure.md
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/02-attributes.md
```

**3. Specific Docs Based on Design (READ AS NEEDED):**
- Layouts: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/03-layouts.md`
- Styling: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/04-styling-advanced.md`
- Animations: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/05-animations.md`
- Sliders: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/06-slider.md`
- Dynamic Content: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/07-dynamic-content.md`
- Variations (Accordions, Tabs, etc.): `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/08-variations.md`
- CSS Variables: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/09-css-variables.md`

**4. Templates for Reference:**
```
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/templates/
```

**NOTE:** Do NOT read `ref/instructions.md` - it's too large and causes token errors. The skill docs above contain all necessary information.

### Step 7: Available Block Types Reference

Use these block types based on what you see in the design:

**Core Blocks:**
| Block | Use For |
|-------|---------|
| `wp:greenshift-blocks/element` | ALL basic elements (div, span, h1-h6, p, a, img, video, audio, svg, section, table, tr, td, th, button) |
| `wp:greenshift-blocks/swiper` | Sliders and carousels |
| `wp:greenshift-blocks/querygrid` | Dynamic post grids |
| `wp:greenshift-blocks/element` (type: "chart") | Charts (line, area, bar, pie, radar, candlestick) |

**Block Variations (`isVariation`):**
| Variation | Use For |
|-----------|---------|
| `contentwrapper` | Full-width section wrapper |
| `nocolumncontent` | Centered content container |
| `contentcolumns` | Section with columns |
| `contentarea` | Flexbox column container |
| `divtext` | Simple text div |
| `accordion` | Collapsible FAQ/accordion |
| `tabs` | Tabbed interfaces |
| `tablist` | Tab buttons container |
| `counter` | Animated number counters |
| `countdown` | Countdown timers |
| `marquee` | Scrolling text/content |
| `buttoncomponent` | Styled buttons with variants |
| `videolightbox` | Video with popup lightbox |
| `youtubeplay` | YouTube video embed (background) |
| `vimeoplay` | Vimeo video embed (background) |
| `svgtextpath` | Curved text on SVG path |
| `chart` | ApexCharts (line, area, bar, pie, radar, candlestick) |

**HTML Tags to Use:**
- `section` - Main section wrappers
- `div` - Generic containers (default)
- `h1`-`h6` - Headings
- `span` - Inline text
- `a` - Buttons and links (prefer over `button`)
- `img` - Images
- `video` - Native video with `<source>` child
- `audio` - Audio player with `<source>` child
- `svg` - Icons (use `icon` parameter)
- `table`, `tr`, `td`, `th` - Tables
- `iframe` - YouTube/Vimeo embeds
- `button` - Only for form buttons (use `formAttributes: {type: "button"}`)

**Special Parameters by Feature:**

*Icons (SVG):*
```json
"tag": "svg",
"icon": {"icon": {"svg": "<svg>...</svg>"}, "fill": "currentColor", "type": "svg"}
```
**IMPORTANT SVG RULES:**
- WordPress STRIPS stroke/fill attributes from outer `<svg>` element
- For stroke-based icons (Lucide/Feather style), put stroke on `<path>` elements:
```json
"icon": {"icon": {"svg": "<svg viewBox=\"0 0 24 24\"><path d=\"...\" stroke=\"currentColor\" stroke-width=\"2\" fill=\"none\"/></svg>"}, "fill": "currentColor", "type": "svg"}
```
- Control color via `styleAttributes.color` (inherits to currentColor)
- For solid icons use `fill="currentColor"` in icon parameter

*Border Radius (rounded corners):*
```json
"styleAttributes": {
  "borderTopLeftRadius": ["10px"],
  "borderTopRightRadius": ["10px"],
  "borderBottomLeftRadius": ["10px"],
  "borderBottomRightRadius": ["10px"],
  "borderRadiusLink_Extra": true  // links all corners
}
```
Or use CSS variables: `"borderTopLeftRadius": ["var(--wp--custom--border-radius--medium, 15px)"]`
Circle: `"borderRadius": ["50%"]`

*Background Images:*
```json
"styleAttributes": {
  "backgroundImage": ["url(https://placehold.co/1920x1080)"],
  "backgroundSize": ["cover"],
  "backgroundPosition": ["center center"],
  "backgroundRepeat": ["no-repeat"],
  "backgroundAttachment": ["fixed"]  // for parallax
}
```

*Gradients:*
```json
"styleAttributes": {
  "imageGradient_Extra": true,
  "backgroundImage": ["linear-gradient(135deg, #color1 0%, #color2 100%)"]
}
```
For text gradients add: `"backgroundClip": ["text"], "color": ["transparent"]`

*Overlays (div layers on images):*
```json
// Parent container with position relative
"styleAttributes": {
  "position": ["relative"]
}
// Overlay child with position absolute
"styleAttributes": {
  "position": ["absolute"],
  "top": ["0"],
  "left": ["0"],
  "right": ["0"],
  "bottom": ["0"],
  "backgroundColor": ["rgba(0,0,0,0.5)"],
  "zIndex": ["1"]
}
// Content on top
"styleAttributes": {
  "position": ["relative"],
  "zIndex": ["2"]
}
```

*Shadows:*
```json
"styleAttributes": {
  "boxShadow": ["0px 10px 30px rgba(0,0,0,0.1)"]
}
```
Or use presets: `"boxShadow": ["var(--wp--preset--shadow--soft)"]`

*Borders:*
```json
"styleAttributes": {
  "borderWidth": ["1px"],
  "borderStyle": ["solid"],
  "borderColor": ["#e0e0e0"]
}
```

*Form Attributes (buttons):*
```json
"tag": "button", "formAttributes": {"type": "button"}
```

*Dynamic Attributes:*
```json
"dynamicAttributes": [{"name": "data-type", "value": "section-component"}]
```

*Custom Scripts:*
```json
"customJs": "console.log('test');", "customJsEnabled": true
```
For GSAP: `import gsap from "{{PLUGIN_URL}}/libs/motion/gsap.js";`

*Keyframe Animations:*
```json
"styleAttributes": {
  "animation_keyframes_Extra": [{"name": "gs_123", "code": "0%{opacity:0}100%{opacity:1}"}],
  "animation": ["gs_123 1s ease"],
  "animationTimeline": ["view()"],  // for scroll trigger
  "animationRange": ["entry"]
}
```

### Step 8: Generate Precise Block Code

**CRITICAL RULES (MUST FOLLOW):**

1. **Unique IDs**: Every block MUST have unique `id` and `localId` in format `gsbp-` + 7 random alphanumeric characters (e.g., `gsbp-a3f7b2c`)

2. **NEVER use inline styles**: NO `style="..."` attributes - ONLY use `styleAttributes`

3. **Class attribute**: If block has `styleAttributes`, the `localId` MUST be in the HTML `class`

4. **Content types**:
   - `type: "text"` - Text-only blocks, requires matching `textContent` param
   - `type: "inner"` - Containers with nested blocks
   - `type: "no"` - Spacers/decorative elements

5. **Images**:
   - Always `loading="lazy"`
   - Use `https://placehold.co/WxH` for placeholders
   - Include `originalWidth` and `originalHeight` in JSON params
   - MUST also add matching `width` and `height` HTML attributes to the `<img>` tag
   - Example: `{"originalWidth": 600, "originalHeight": 400}` → `<img ... width="600" height="400" loading="lazy"/>`

6. **Responsive values**: Arrays `["desktop", "tablet", "mobile_l", "mobile_p"]`
   - Single value `["10px"]` applies to all breakpoints

7. **CSS Variables**: Use WordPress preset variables:
   ```
   Font: var(--wp--preset--font-size--giga), var(--wp--preset--font-size--grand), etc.
   Spacing: var(--wp--preset--spacing--80), var(--wp--preset--spacing--60), etc.
   Colors: var(--wp--preset--color--primary), var(--wp--preset--color--secondary), etc.
   ```

8. **Links**: Use `tag: "a"` with `href`, for external add `linkNewWindow: true`

9. **AOS Animations** (if user chose animations):
   ```json
   "animation": {"type": "fade-up", "duration": 600, "delay": 0, "easing": "ease-out", "onlyonce": true}
   ```
   - Types: fade-up, fade-down, fade-left, fade-right, zoom-in, zoom-out, flip-up, slide-up, clip-right
   - Duration: 300-800ms (shorter is better)
   - Easing: `ease-out` for entrance (recommended)
   - Always `onlyonce: true` for entrance animations
   - Stagger delays: +150-200ms per element

**LAYOUT HIERARCHY (MANDATORY):**
```
Section wrapper (tag: "section", align: "full", isVariation: "contentwrapper")
  └─ Content area (isVariation: "nocolumncontent" or "contentarea")
       └─ Inner elements (headings, text, images, buttons, columns)
```

**COMPLEX COMPONENTS:**

For Accordions, Tabs, Counters, Countdowns, Video Lightbox:
- Read `docs/08-variations.md` for complete structure
- Use `dynamicGClasses` for interactive styling
- Follow exact class naming (.gs_item, .gs_content, etc.)

For Sliders:
- Read `docs/06-slider.md` for Swiper configuration
- Use `wp:greenshift-blocks/swiper` with `wp:greenshift-blocks/swipe` children

For Tables:
- Use `tableStyles` for cell styling (not regular styleAttributes)
- Set `tableAttributes` for responsive behavior

For Charts:
- Read `docs/11-charts.md` for ApexCharts configuration
- Use `type: "chart"` and `isVariation: "chart"`
- Configure via `chartData` with `options` containing chart JSON

For Dynamic Content (Query Grids):
- Read `docs/07-dynamic-content.md` for dynamic blocks
- Use `wp:greenshift-blocks/querygrid` with `query_filters`
- Dynamic text: wrap in `<dynamictext></dynamictext>` with `dynamictext` param
- Dynamic links: use `dynamiclink` param for `<a>` and `<img>`
- Available placeholders: `{{POST_ID}}`, `{{POST_TITLE}}`, `{{POST_URL}}`, `{{CURRENT_DATE_YMD}}`

For Audio:
- Use `tag: "audio"` with `controls: true`
- Child `<source>` element with type

**CSS Variables Quick Reference:**
```
Font: giga > grand > high > xxl > xl > l > m > r > s > xs > mini
Spacing: 100 > 90 > 80 > 70 > 60 > 50 > 40 > 30 > 20
Shadows: highlight > accent > soft > elegant > mild > focus
Border: xlarge > large > medium > small > mini > circle
Transitions: motion > accent > smooth > mild > elegant > soft > creative > ease-in-out > ease
```

### Step 9: Save Output

1. Generate the complete HTML block code
2. Ask user for output path/filename or suggest based on content (e.g., `hero-section.html`, `pricing-table.html`)
3. Save to the specified path using Write tool
4. Show the user where file was saved

## Output Format

- Return ONLY valid WordPress Gutenberg block HTML
- No markdown code blocks in the output file
- No explanations in the output file
- Ready to paste directly into WordPress Gutenberg Code Editor

## Quality Checklist

Before saving, verify:

**Structure & IDs:**
- [ ] Every block has unique `gsbp-XXXXXXX` ID
- [ ] `localId` matches `id` for EVERY block
- [ ] NO inline `style` attributes ANYWHERE
- [ ] `class` includes `localId` when `styleAttributes` present
- [ ] Section → Content Area → Elements hierarchy

**Images:**
- [ ] Images have `loading="lazy"`
- [ ] Images have `width` and `height` HTML attributes matching `originalWidth`/`originalHeight` JSON
- [ ] Background images use placehold.co URLs

**SVG Icons:**
- [ ] SVG content uses Unicode escapes: `\u003c` for `<`, `\u003e` for `>`, `\u0022` for `"`

**Styling:**
- [ ] CSS variables used (not hardcoded values)
- [ ] Responsive arrays for key dimensions

**Design Details:**
- [ ] Border radius: card radius vs image/inner element radius (usually different)
- [ ] Card images: inset look requires SMALLER radius on image than card wrapper
- [ ] Padding/margins: image edge-to-edge or inset with visible container background?
- [ ] Image `object-fit`: cover (fills) vs contain (maintains ratio)
- [ ] Shadows: subtle vs prominent, on card vs on image
- [ ] Layout matches original screenshot
- [ ] Colors approximate original design
- [ ] Overlays use position absolute with proper z-index

## Common Mistakes to Avoid

1. **Missing localId in class** - If styleAttributes exists, class MUST include localId
2. **Using style attribute** - NEVER use inline styles
3. **Wrong nesting** - Always wrap content in section → content area
4. **Missing textContent** - text blocks need both HTML content AND textContent param
5. **Hardcoded values** - Use CSS variables instead
6. **Same IDs** - Every single block needs unique ID
7. **Wrong tag for buttons** - Use `a` tag, not `button` (unless in forms)
8. **SVG stroke on wrong element** - Put stroke/fill on `<path>`, not `<svg>` (WordPress strips them from svg)
9. **Missing width/height on img HTML** - MUST add matching `width`/`height` attributes when using `originalWidth`/`originalHeight` in JSON
10. **HTML comments for organization** - WordPress STRIPS all HTML comments - don't use them
11. **SVG not Unicode-encoded** - SVG in `icon.icon.svg` MUST use `\u003c` for `<`, `\u003e` for `>`, `\u0022` for `"`

## If Image Cannot Be Read

If the image path is invalid:
1. Ask user for correct path
2. Accept pasted screenshots
3. Or accept detailed text description of the design

## Example Workflow

1. User provides: `/gs:clone /path/to/screenshot.png`
2. Read and analyze the image thoroughly
3. Ask user: "CSS Variables or Exact Colors?"
4. Ask user: "Static, Subtle, or Full Animations?"
5. Ask user: "Any additional details about this design?" (clarify ambiguous elements)
6. Read `SKILL.md` first (primary reference with critical rules)
7. Read `docs/01-core-structure.md` and `docs/02-attributes.md`
8. Read relevant specific docs based on what's in the design
9. Generate block code following all rules + user preferences + clarifications
10. Save to HTML file
11. Confirm to user
