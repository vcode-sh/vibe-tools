---
description: Migrate old Greenshift blocks (row, heading, etc.) to GreenLight Element blocks
argument-hint: [paste code or file path]
---

# Greenshift Block Migration Tool

Migrate old Greenshift block structures to modern GreenLight Element (`greenshift-blocks/element`) blocks while preserving the visual design.

## Migration Philosophy: Minimal Intervention

**Core principle:** Migrate structure, not style. Preserve what works, fix what's broken.

### DO:
- Convert old block types to GreenLight Element
- Fix structural issues (IDs, classes, nesting)
- Wrap in Page Wrapper to control spacing
- Remove `overlay` parameter (generates inline styles)
- Convert old `background` parameter to `styleAttributes`

### DON'T:
- Add `fontSize`, `fontWeight`, `color` that weren't there before
- Replace working pixel values with CSS variables unless broken
- Force CSS variables everywhere - only when improving broken values
- Over-style elements that were working fine

### Hardcoded Values
- **Keep working values** - if `"columnGap": ["25px"]` works, leave it
- **Only convert broken values** - or when user explicitly requests normalization
- **Don't add new styles** - if original had no `fontSize`, don't add one

## Instructions

### Step 1: Get the Source Code

1. Check if `$ARGUMENTS` contains a file path - if so, read the file
2. If no argument provided, ask user to:
   - Paste the Gutenberg block code directly
   - Or provide a file path to the HTML file

### Step 2: Analyze the Source Code

Identify all blocks in the source code and categorize them:

**Blocks to CONVERT (old blocks):**
| Old Block | Convert To |
|-----------|------------|
| `greenshift-blocks/row` | `greenshift-blocks/element` with `tag:"section"`, `align:"full"` |
| `greenshift-blocks/row-column` | `greenshift-blocks/element` with `type:"inner"` or remove |
| `greenshift-blocks/heading` | `greenshift-blocks/element` with `tag:"h1-h6"`, `textContent` |
| `greenshift-blocks/text` | `greenshift-blocks/element` with `textContent` |
| `greenshift-blocks/button` | `greenshift-blocks/element` with `tag:"a"` |
| `greenshift-blocks/image` | `greenshift-blocks/element` with `tag:"img"` |
| `greenshift-blocks/container` | `greenshift-blocks/element` with `type:"inner"` |

**Blocks to KEEP (already modern):**
- `greenshift-blocks/element` - Already GreenLight
- `greenshift-blocks/swiper` - Slider
- `greenshift-blocks/querygrid` - Query grid
- `greenshift-blocks/dynamic-post-image` - Dynamic image
- `greenshift-blocks/dynamic-post-title` - Dynamic title
- `greenshift-blocks/meta` - Meta data

Report to user what was found:
- Number of old blocks to convert
- Number of modern blocks (no change needed)
- Any complex structures detected (accordions, tabs, sliders)

### Step 3: Ask User Questions

Use AskUserQuestion tool to gather user preferences:

**Question 1: Wrapper Structure**

"Should I wrap everything in a single section container to avoid gaps between blocks?"

Options:
1. **"Yes, wrap in section (Recommended)"** - Creates clean, gap-free structure with proper section padding
2. **"No, keep separate blocks"** - Maintains original block separation

---

**Question 2: Animation Style**

"How should I handle animations?"

Options:
1. **"Remove all animations"** - Clean, static output with no entrance effects
2. **"Subtle, consistent animations (Recommended)"** - Applies uniform `fade-up` with 600ms duration
3. **"Keep original animations"** - Preserves existing animation settings where present
4. **"Full staggered animations"** - Adds progressive delays for sequential entrance

---

**Question 3: Background Handling**

"I detected background settings. How should I handle them?"

Options:
1. **"Keep original backgrounds"** - Preserve as-is (may use old `background` param)
2. **"Convert to styleAttributes (Recommended)"** - Modern format using `backgroundImage`, `backgroundSize`, etc.
3. **"Add parallax effect"** - Convert to styleAttributes + add `backgroundAttachment: ["fixed"]`
4. **"Remove backgrounds"** - Strip all background settings

---

**Question 4: Spacing & Gaps**

"How should I handle padding, margins, and gaps?"

Options:
1. **"Keep original values (Recommended)"** - Preserve working pixel/rem values as-is
2. **"Normalize to CSS variables"** - Convert spacing to WordPress preset variables (only if requested)
3. **"Reset to defaults"** - Apply standard section padding and gaps

---

**Question 5: Color Handling**

"How should I handle colors?"

Options:
1. **"Keep exact colors (Recommended)"** - Preserve original hex/rgb values that are working
2. **"Convert to CSS variables"** - Map colors to WordPress theme variables (only if theme integration needed)

---

### Step 4: Read Documentation

Before generating migrated code, read the necessary documentation:

**ALWAYS READ:**
```
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/SKILL.md
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/01-core-structure.md
```

**READ AS NEEDED:**
- Layouts: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/03-layouts.md`
- Styling/Parallax: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/04-styling-advanced.md`
- Animations: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/05-animations.md`
- CSS Variables: `${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/09-css-variables.md`

### Step 5: Perform Migration

**Migration Rules:**

#### 1. Block Conversion

**Old `greenshift-blocks/heading`:**
```html
<!-- BEFORE -->
<!-- wp:greenshift-blocks/heading {"id":"gsbp-xxx","headingContent":"Title","spacing":{...},"typography":{...}} -->
<h2 id="gspb_heading-id-gsbp-xxx" class="gspb_heading gspb_heading-id-gsbp-xxx">Title</h2>
<!-- /wp:greenshift-blocks/heading -->

<!-- AFTER -->
<!-- wp:greenshift-blocks/element {"id":"gsbp-xxx","textContent":"Title","tag":"h2","localId":"gsbp-xxx","styleAttributes":{...}} -->
<h2 class="gsbp-xxx">Title</h2>
<!-- /wp:greenshift-blocks/element -->
```

**Old `greenshift-blocks/row`:**
```html
<!-- BEFORE -->
<!-- wp:greenshift-blocks/row {"id":"gspb_row-id-xxx",...} -->
<div class="gspb_row">...</div>
<!-- /wp:greenshift-blocks/row -->

<!-- AFTER -->
<!-- wp:greenshift-blocks/element {"id":"gsbp-xxx","tag":"section","type":"inner","localId":"gsbp-xxx","align":"full","styleAttributes":{...},"isVariation":"contentwrapper"} -->
<section class="gsbp-xxx alignfull">...</section>
<!-- /wp:greenshift-blocks/element -->
```

#### 2. ID Format
- Generate NEW unique IDs in format `gsbp-` + 7 alphanumeric chars
- `localId` MUST match `id`
- Remove old `gspb_` prefixed IDs

#### 3. Class Format
- Remove old classes like `gspb_heading`, `gspb_row`, etc.
- Use only `localId` as class when `styleAttributes` present
- Add `alignfull` for full-width sections

#### 4. Style Conversion
- Move `typography` properties to `styleAttributes` (fontSize, fontWeight, lineHeight, etc.)
- Move `spacing` properties to `styleAttributes` (padding, margin)
- Move `background` to `styleAttributes.backgroundImage`, etc.
- Remove `background` parameter entirely

#### 5. Background Conversion (if user chose styleAttributes or parallax)

**Old format (DO NOT USE):**
```json
"background": {
  "image": ["url"],
  "size": ["cover"],
  "parallax": true
}
```

**New format:**
```json
"styleAttributes": {
  "backgroundImage": ["url(...)"],
  "backgroundSize": ["cover"],
  "backgroundPosition": ["center center"],
  "backgroundRepeat": ["no-repeat"],
  "backgroundAttachment": ["fixed"]  // if parallax requested
}
```

#### 6. Animation Application (based on user choice)

**Subtle animations:**
```json
"animation": {"type": "fade-up", "duration": 600, "easing": "ease-out", "onlyonce": true}
```

**Staggered animations:**
- First element: delay 0
- Each subsequent element: +150ms delay

#### 7. Spacing Normalization (if user chose CSS variables)

| Old Value | New Value |
|-----------|-----------|
| `80px`-`100px` | `var(--wp--preset--spacing--80)` |
| `50px`-`70px` | `var(--wp--preset--spacing--70)` |
| `30px`-`50px` | `var(--wp--preset--spacing--60)` |
| `20px`-`30px` | `var(--wp--preset--spacing--50)` |
| `10px`-`20px` | `var(--wp--preset--spacing--40)` |

#### 8. Page Wrapper Structure (if user chose wrap)

Wrap all content in a Page Wrapper (NOT a section):
```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-page001","type":"inner","localId":"gsbp-page001","align":"full","styleAttributes":{"marginBlockStart":["0px"]},"metadata":{"name":"Page Wrapper"}} -->
<div class="gsbp-page001 alignfull">
  <!-- ALL MIGRATED SECTIONS GO HERE -->
</div>
<!-- /wp:greenshift-blocks/element -->
```

**IMPORTANT:** Use `content-size` (not `wide-size`) for content width:
```json
"width": ["var(--wp--style--global--content-size, 1290px)"]
```

#### 9. Overlay Conversion

**DO NOT** use the `overlay` parameter - it generates inline styles!

**Old format (AVOID):**
```json
"overlay": {
  "color": "#000000",
  "opacity": 0.4
}
```
This generates: `<div class="gspb_backgroundOverlay" style="background-color:#000000;opacity:0.4"></div>`

**New format:** Remove the overlay parameter entirely, or create a separate positioned element with `styleAttributes`.

### Step 6: Quality Checklist

Before outputting, verify:

- [ ] All blocks use `greenshift-blocks/element` (except swiper, querygrid)
- [ ] Every block has unique `gsbp-XXXXXXX` ID
- [ ] `localId` matches `id` for every block
- [ ] NO inline `style` attributes anywhere
- [ ] `class` includes `localId` when `styleAttributes` present
- [ ] No old `gspb_` class prefixes remain
- [ ] No old `background` parameter (use styleAttributes)
- [ ] **No `overlay` parameter** (generates inline styles!)
- [ ] Images have `loading="lazy"` and `width`/`height` attributes
- [ ] Page wrapper has `align:"full"` + `alignfull` class
- [ ] Content areas use `content-size` (NOT `wide-size`)
- [ ] Proper section > content area > elements hierarchy

### Step 7: Save Output

1. Generate the migrated HTML block code
2. Ask user for output path/filename or suggest `migrated-[original-name].html`
3. Save using Write tool
4. Show summary:
   - Blocks converted: X
   - Blocks unchanged: X
   - User choices applied
   - File saved location

## Common Migration Patterns

### Heading with Typography

**Before:**
```json
{
  "headingContent": "Title",
  "typography": {
    "fontSize": "48px",
    "fontWeight": "700",
    "lineHeight": "1.2"
  },
  "spacing": {
    "marginBottom": "20px"
  }
}
```

**After:**
```json
{
  "textContent": "Title",
  "tag": "h2",
  "styleAttributes": {
    "fontSize": ["var(--wp--preset--font-size--giga)"],
    "fontWeight": ["700"],
    "lineHeight": ["1.2"],
    "marginBottom": ["var(--wp--preset--spacing--50)"]
  }
}
```

### Row with Background

**Before:**
```json
{
  "background": {
    "image": ["https://example.com/bg.jpg"],
    "size": ["cover"],
    "position": ["center"],
    "parallax": true
  }
}
```

**After:**
```json
{
  "tag": "section",
  "type": "inner",
  "align": "full",
  "styleAttributes": {
    "backgroundImage": ["url(https://example.com/bg.jpg)"],
    "backgroundSize": ["cover"],
    "backgroundPosition": ["center center"],
    "backgroundRepeat": ["no-repeat"],
    "backgroundAttachment": ["fixed"]
  },
  "isVariation": "contentwrapper"
}
```

## Error Handling

If migration encounters issues:
1. Report which blocks couldn't be converted
2. Explain why (missing data, unknown block type)
3. Suggest manual fixes if needed
4. Continue with other blocks
