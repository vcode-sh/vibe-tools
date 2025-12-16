---
description: Migrate old Greenshift blocks (row, heading, etc.) to GreenLight Element blocks
argument-hint: [paste code or file path]
---

# Greenshift Block Migration Tool

Migrate old Greenshift block structures to modern GreenLight Element (`greenshift-blocks/element`) blocks while preserving the visual design with **minimal style intervention**.

## Migration Philosophy: Structure Over Style

**Core principle:** Convert block structure, strip unnecessary styling. Let the WordPress theme handle typography defaults.

### Critical Rules - Typography (NEVER MIGRATE THESE)

| Property | On Element | Action |
|----------|-----------|--------|
| `fontSize` | Headings (h1-h6) | **REMOVE** - theme handles heading sizes |
| `fontWeight` | Headings (h1-h6) | **REMOVE** - theme handles heading weights |
| `fontWeight` | Any element (if `400`/`normal`) | **REMOVE** - it's the default |
| `color` | Any text (unless on dark bg) | **REMOVE** - theme handles text colors |
| `lineHeight` | Headings (h1-h6) | **REMOVE** - theme handles |

### What TO Migrate

| Property | Action |
|----------|--------|
| Structure (`type:"inner"`, nesting) | **CONVERT** - core functionality |
| Background colors (palette vars) | **KEEP** - section appearance |
| Spacing (padding, margin, gap) | **KEEP** - layout control |
| Animations | **KEEP or STANDARDIZE** - user choice |
| `textAlign` | **KEEP** - layout property |
| `maxWidth` | **KEEP** - layout constraint |
| `fontFamily` | **KEEP** - intentional font choice |
| `fontSize` on accent/lead text | **KEEP** - intentional sizing |

---

## Instructions

### Step 1: Get the Source Code

1. Check if `$ARGUMENTS` contains a file path - if so, read the file
2. If no argument provided, ask user to:
   - Paste the Gutenberg block code directly
   - Or provide a file path to the HTML file

### Step 2: Analyze the Source Code

Identify all blocks and categorize them:

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
- `greenshift-blocks/dynamic-*` - Dynamic blocks

Report to user:
- Number of old blocks to convert
- Number of modern blocks (no change)
- Typography settings that will be **removed** (not converted)

### Step 3: Ask User Questions

Use AskUserQuestion tool:

**Question 1: Wrapper Structure**
"Should I wrap everything in a Page Wrapper to prevent gaps between sections?"
- **"Yes, wrap in Page Wrapper (Recommended)"**
- "No, keep separate blocks"

**Question 2: Animation Style**
"How should I handle animations?"
- "Remove all animations"
- **"Subtle, consistent animations (Recommended)"** - uniform fade-up, 600ms
- "Keep original animations"
- "Full staggered animations"

**Question 3: Semantic Headings**
"Should I adjust heading tags for proper hierarchy (h2→h3→h4)?"
- **"Yes, fix heading hierarchy (Recommended)"** - proper semantic structure
- "No, keep original heading tags"

**Question 4: Typography Cleanup**
"Old blocks have fontSize/fontWeight/color on headings. How to handle?"
- **"Remove unnecessary typography (Recommended)"** - let theme handle
- "Preserve all typography settings" - convert to styleAttributes as-is

**Question 5: Spacing & Gaps**
"How should I handle padding, margins, and gaps?"
- **"Keep original values (Recommended)"** - preserve working values
- "Normalize to CSS variables"
- "Reset to defaults"

---

### Step 4: Read Documentation

**ALWAYS READ:**
```
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/SKILL.md
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/12-migration-rules.md
```

**READ AS NEEDED:**
- Layouts: `docs/03-layouts.md`
- Styling: `docs/04-styling-advanced.md`
- Animations: `docs/05-animations.md`
- CSS Variables: `docs/09-css-variables.md`

### Step 5: Perform Migration

#### Typography Stripping Rules

**For all headings (h1-h6):**
```
OLD: typography.size: ["3rem","2.7rem"]
NEW: (nothing - REMOVED)

OLD: typography.fontWeight: "700"
NEW: (nothing - REMOVED)

OLD: typography.color: "var(--palette-color-1)"
NEW: (nothing - REMOVED unless on dark background)
```

**For body text:**
```
OLD: fontWeight: 400 or "normal"
NEW: (nothing - REMOVED - it's default)

OLD: color: "var(--palette-color-5)"
NEW: (nothing - REMOVED - let theme handle)

OLD: fontSize: [null, null, null, "0.9rem"]
NEW: (nothing - REMOVED - weird responsive, unnecessary)
```

**Keep these:**
```
fontSize: ["1.2rem"] → KEEP (intentional accent sizing)
fontFamily: ["custom_font"] → KEEP (specific font choice)
textAlign: ["center"] → KEEP (layout property)
marginBottom: ["1rem"] → KEEP (spacing control)
```

#### Semantic Heading Hierarchy (if user chose "fix hierarchy")

Analyze the page structure and assign proper heading levels:

```
Section Title → h2
Subsection/Card Title → h3
Minor heading within card → h4
```

**Example transformation:**
```
Original: h2 "Section Intro" + h2 "Grid Title" + h3 "Step 1"...
Fixed:    h2 "Section Intro" + h3 "Grid Title" + h4 "Step 1"...
```

#### Block Conversion Examples

**Heading:**
```html
<!-- BEFORE -->
<!-- wp:greenshift-blocks/heading {"id":"gsbp-xxx","headingContent":"Title","typography":{"size":["2rem"],"fontWeight":"700"}} -->
<h2 class="gspb_heading">Title</h2>
<!-- /wp:greenshift-blocks/heading -->

<!-- AFTER (typography removed) -->
<!-- wp:greenshift-blocks/element {"id":"gsbp-yyy","textContent":"Title","tag":"h2","localId":"gsbp-yyy","styleAttributes":{"marginBottom":["1rem"]}} -->
<h2 class="gsbp-yyy">Title</h2>
<!-- /wp:greenshift-blocks/element -->
```

**Text with unnecessary color:**
```html
<!-- BEFORE -->
<!-- wp:greenshift-blocks/text {"textContent":"Subtitle","typography":{"color":"var(--palette-color-5)","size":["1.2rem"]}} -->

<!-- AFTER (color removed, fontSize kept as accent) -->
<!-- wp:greenshift-blocks/element {"id":"gsbp-zzz","textContent":"Subtitle","localId":"gsbp-zzz","styleAttributes":{"fontSize":["1.2rem"],"marginBottom":["1rem"]}} -->
```

**Text with fontWeight: 400:**
```html
<!-- BEFORE -->
<!-- wp:greenshift-blocks/text {"typography":{"fontWeight":"400","fontFamily":"custom"}} -->

<!-- AFTER (fontWeight removed, fontFamily kept) -->
<!-- wp:greenshift-blocks/element {"styleAttributes":{"fontFamily":["custom"]}} -->
```

#### ID Format
- Generate NEW unique IDs: `gsbp-` + 7 alphanumeric chars
- `localId` MUST match `id`
- Remove old `gspb_` prefixed IDs

#### Class Format
- Remove old classes: `gspb_heading`, `gspb_row`, etc.
- Use only `localId` as class when `styleAttributes` present
- Add `alignfull` for full-width sections

#### Page Wrapper Structure (if chosen)
```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-page001","type":"inner","localId":"gsbp-page001","align":"full","styleAttributes":{"marginBlockStart":["0px"]},"metadata":{"name":"Page Wrapper"}} -->
<div class="gsbp-page001 alignfull">
  <!-- ALL MIGRATED SECTIONS GO HERE -->
</div>
<!-- /wp:greenshift-blocks/element -->
```

### Step 6: Quality Checklist

Before outputting, verify:

- [ ] All blocks use `greenshift-blocks/element`
- [ ] Every block has unique `gsbp-XXXXXXX` ID
- [ ] `localId` matches `id`
- [ ] NO inline `style` attributes
- [ ] **NO `fontSize` on headings (h1-h6)**
- [ ] **NO `fontWeight: 400` anywhere**
- [ ] **NO `color` on text (unless dark background)**
- [ ] Proper heading hierarchy (h2 → h3 → h4)
- [ ] Images have `loading="lazy"` and `width`/`height`
- [ ] Page wrapper has `align:"full"` + `alignfull` class
- [ ] Content areas use `content-size` (NOT `wide-size`)

### Step 7: Save Output

1. Generate the migrated HTML block code
2. Ask user for output path/filename
3. Save using Write tool
4. Show summary:
   - Blocks converted: X
   - Typography settings removed: X (list what was stripped)
   - Blocks unchanged: X
   - File saved location

---

## Common Typography to REMOVE

| Original Property | Reason to Remove |
|-------------------|------------------|
| `typography.size` on h1-h6 | Theme defines heading sizes |
| `typography.fontWeight` on headings | Theme defines heading weights |
| `typography.color` on any text | Theme defines text colors |
| `fontWeight: "400"` / `fontWeight: "normal"` | It's the default |
| `lineHeight` on headings | Theme defines |
| `fontSize: [null, null, null, "X"]` | Weird responsive, usually unnecessary |

## Typography to KEEP

| Property | When to Keep |
|----------|--------------|
| `fontSize: ["1.2rem"]` | Intentional accent/lead text sizing |
| `fontFamily: ["custom"]` | Specific font requirement |
| `fontWeight: ["700"]` on body text | Intentionally bold text |
| `color` on dark backgrounds | Readability requirement |
