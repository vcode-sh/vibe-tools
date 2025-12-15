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
- Images with aspect ratios
- Buttons/CTAs (primary, secondary, outline)
- Icons (where and what type)
- Background colors/gradients/images
- Border radius and shadows
- Decorative elements

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

### Step 3: Read ALL Documentation (MANDATORY)

You MUST read these files before generating code:

**Core Reference (ALWAYS READ):**
```
${CLAUDE_PLUGIN_ROOT}/ref/instructions.md
```
This file contains ALL the rules and block structures. Read it completely.

**Skill Documentation:**
```
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/SKILL.md
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/reference.md
```

**Specific Docs Based on Design:**
- Layouts: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/03-layouts.md`
- Styling: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/04-styling-advanced.md`
- Animations: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/05-animations.md`
- Sliders: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/06-slider.md`
- Dynamic Content: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/07-dynamic-content.md`
- Variations: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/08-variations.md`
- CSS Variables: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/09-css-variables.md`

**Templates for Reference:**
```
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/templates/
```

### Step 4: Available Block Types Reference

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
| `youtubeplay` | YouTube video embed |
| `vimeoplay` | Vimeo video embed |
| `svgtextpath` | Curved text on SVG path |
| `chart` | ApexCharts (line, area, bar, pie, radar, candlestick) |

**HTML Tags to Use:**
- `section` - Main section wrappers
- `div` - Generic containers (default)
- `h1`-`h6` - Headings
- `span` - Inline text
- `a` - Buttons and links (prefer over `button`)
- `img` - Images
- `video` - Native video
- `audio` - Audio player
- `svg` - Icons
- `table`, `tr`, `td`, `th` - Tables
- `iframe` - YouTube/Vimeo embeds
- `button` - Only for form buttons

### Step 5: Generate Precise Block Code

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
   - Include `originalWidth` and `originalHeight` in JSON
   - NO `width`/`height` HTML attributes

6. **Responsive values**: Arrays `["desktop", "tablet", "mobile_l", "mobile_p"]`
   - Single value `["10px"]` applies to all breakpoints

7. **CSS Variables**: Use WordPress preset variables:
   ```
   Font: var(--wp--preset--font-size--giga), var(--wp--preset--font-size--grand), etc.
   Spacing: var(--wp--preset--spacing--80), var(--wp--preset--spacing--60), etc.
   Colors: var(--wp--preset--color--primary), var(--wp--preset--color--secondary), etc.
   ```

8. **Links**: Use `tag: "a"` with `href`, for external add `linkNewWindow: true`

9. **Animations**: Use `animation` object with `type`, `duration`, `delay`, `easing`, `onlyonce`

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

### Step 6: Save Output

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

- [ ] Every block has unique `gsbp-XXXXXXX` ID
- [ ] `localId` matches `id` for EVERY block
- [ ] NO inline `style` attributes ANYWHERE
- [ ] `class` includes `localId` when `styleAttributes` present
- [ ] Images have `loading="lazy"`
- [ ] Section → Content Area → Elements hierarchy
- [ ] CSS variables used (not hardcoded values)
- [ ] Responsive arrays for key dimensions
- [ ] Layout matches original screenshot
- [ ] Colors approximate original design
- [ ] Interactive components use correct variations

## Common Mistakes to Avoid

1. **Missing localId in class** - If styleAttributes exists, class MUST include localId
2. **Using style attribute** - NEVER use inline styles
3. **Wrong nesting** - Always wrap content in section → content area
4. **Missing textContent** - text blocks need both HTML content AND textContent param
5. **Hardcoded values** - Use CSS variables instead
6. **Same IDs** - Every single block needs unique ID
7. **Wrong tag for buttons** - Use `a` tag, not `button` (unless in forms)

## If Image Cannot Be Read

If the image path is invalid:
1. Ask user for correct path
2. Accept pasted screenshots
3. Or accept detailed text description of the design

## Example Workflow

1. User provides: `/gs:clone /path/to/screenshot.png`
2. Read and analyze the image
3. Read `ref/instructions.md` (full documentation)
4. Read relevant docs based on what's in the design
5. Generate block code following all rules
6. Save to HTML file
7. Confirm to user
