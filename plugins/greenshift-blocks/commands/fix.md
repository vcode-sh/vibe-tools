---
description: Verify and fix Greenshift block code against documentation rules, optionally enhance animations
argument-hint: [file path to HTML code]
---

# Greenshift Code Verifier & Fixer

Verify Greenshift block code against all documentation rules, fix issues, and optionally enhance animations.

## Instructions

### Step 1: Get the Source Code

1. Check if `$ARGUMENTS` contains a file path - if so, read the file using Read tool
2. If no argument provided, ask user to:
   - Provide a file path to the HTML file
   - Or paste the Gutenberg block code directly

### Step 2: Read Documentation

Before verification, read the core documentation:

```
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/SKILL.md
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/01-core-structure.md
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/02-attributes.md
${CLAUDE_PLUGIN_ROOT}/skills/greenshift-blocks/docs/12-migration-rules.md
```

**CRITICAL:** The migration-rules doc contains typography stripping rules that apply to verification.

### Step 3: Perform Comprehensive Verification

Analyze EVERY block in the code against these rules. Report ALL issues found.

---

## Verification Rules Checklist

### A. Block Identity (CRITICAL)

| Rule | Check | Fix |
|------|-------|-----|
| A1 | `id` starts with `gsbp-` + 7 alphanumeric chars | Generate valid ID |
| A2 | `localId` exists and matches `id` exactly | Set `localId` = `id` |
| A3 | No duplicate IDs across all blocks | Generate unique IDs |

### B. Styling Rules (CRITICAL)

| Rule | Check | Fix |
|------|-------|-----|
| B1 | NO inline `style="..."` attributes in HTML | Move to `styleAttributes` |
| B2 | If `styleAttributes` exists, `localId` is in HTML `class` | Add `localId` to class |
| B3 | `styleAttributes` values are arrays `["value"]` | Convert to array format |
| B4 | camelCase property names in `styleAttributes` | Fix casing |

### C. Content Type Rules (CRITICAL)

| Rule | Check | Fix |
|------|-------|-----|
| C1 | `type: "text"` blocks have `textContent` matching HTML | Sync `textContent` |
| C2 | `type: "inner"` used for container blocks | Set correct type |
| C3 | `type: "no"` used for empty/spacer elements | Set correct type |
| C4 | Plain text in `type: "inner"` blocks wrapped in `<span>` elements | Wrap text |

### D. Image Rules (CRITICAL)

| Rule | Check | Fix |
|------|-------|-----|
| D1 | All `<img>` have `loading="lazy"` | Add attribute |
| D2 | `originalWidth`/`originalHeight` in JSON have matching `width`/`height` HTML attributes | Add/sync attributes |
| D3 | Placeholder images use `https://placehold.co/WxH` format | Fix URL format |

### E. SVG Icon Rules (CRITICAL)

| Rule | Check | Fix |
|------|-------|-----|
| E1 | SVG in `icon.icon.svg` uses Unicode escapes: `\u003c` `\u003e` `\u0022` | Encode properly |
| E2 | Stroke-based icons have `stroke` on `<path>`, not `<svg>` | Move attributes |

### F. Link & Button Rules (IMPORTANT)

| Rule | Check | Fix |
|------|-------|-----|
| F1 | Buttons use `tag: "a"` unless in forms | Change to `<a>` tag |
| F2 | External links have `linkNewWindow: true` | Add parameter |
| F3 | `<a>` tags with `href` have the `href` in JSON | Sync `href` |

### G. Block Type Rules (IMPORTANT)

| Rule | Check | Fix |
|------|-------|-----|
| G1 | No old blocks: `greenshift-blocks/row`, `/heading`, `/text`, `/button`, `/container` | Convert to `element` |
| G2 | No `overlay` parameter (generates inline styles) | Remove, create overlay element |
| G3 | No `background` parameter (use `styleAttributes`) | Convert to `styleAttributes` |

### H. Structure Rules (IMPORTANT)

| Rule | Check | Fix |
|------|-------|-----|
| H1 | Full-width sections have `align: "full"` + `alignfull` class | Add both |
| H2 | Content areas use `content-size` not `wide-size` | Fix variable |
| H3 | Multi-section pages have Page Wrapper | Add wrapper |
| H4 | No HTML comments like `<!-- SECTION -->` | Use `metadata:{"name":"..."}` |

### K. Slider Rules (CRITICAL)

| Rule | Check | Fix |
|------|-------|-----|
| K1 | Image gallery slides use `greenshift-blocks/element` with `tag:"img"` inside `slider-content-zone` | Restructure slide |
| K2 | Swipe blocks have `imageurl:""` (empty string) | Set empty string |
| K3 | No `slider-overlaybg` or `slider-image-wrapper` divs | Remove divs |
| K4 | Swipe blocks have `bgContain:false` | Add parameter |
| K5 | Slide images don't have `width="100%" height="100%"` | Remove attributes |

### I. Animation Rules (WARNING)

| Rule | Check | Fix |
|------|-------|-----|
| I1 | AOS animations have `onlyonce: true` | Add parameter |
| I2 | `data-aos-*` attributes match JSON `animation` object | Sync attributes |
| I3 | Duration between 300-1000ms | Adjust value |
| I4 | Stagger delays are incremental (0, 150, 300...) | Fix delays |

### J. Typography & Minimal Styling (IMPORTANT)

| Rule | Check | Fix |
|------|-------|-----|
| J1 | **NO `fontSize` on headings (h1-h6)** | **REMOVE** - theme handles |
| J2 | **NO `fontWeight` on headings (h1-h6)** | **REMOVE** - theme handles |
| J3 | **NO `color` on headings/text** (unless dark bg) | **REMOVE** - theme handles |
| J4 | No `fontWeight: ["400"]` anywhere | Remove - it's default |
| J5 | No `lineHeight` on headings | Remove - theme handles |
| J6 | Semantic heading hierarchy (h2→h3→h4) | Suggest fixes |
| J7 | Background colors use palette vars | Convert to palette-color-X |

**See `docs/12-migration-rules.md` for detailed typography rules.**

### Typography Decision Guide

**For headings (h1-h6):**
- REMOVE: `fontSize`, `fontWeight`, `color`, `lineHeight`
- KEEP: `marginTop`, `marginBottom`, `textAlign`

**For body text:**
- REMOVE: `fontWeight: ["400"]`, `color` (unless on dark bg)
- KEEP: `fontSize` if intentional accent (e.g., `["1.2rem"]`), `fontFamily`

---

## Step 4: Generate Verification Report

Present findings to user in this format:

```
## Verification Report

### Summary
- Total blocks analyzed: X
- Critical issues: X
- Important issues: X
- Warnings: X

### Critical Issues (MUST FIX)
1. [A1] Block "gsbp-xxx" - Invalid ID format
2. [B1] Block "gsbp-yyy" - Inline style attribute found
3. [D1] Image missing loading="lazy"
...

### Important Issues (SHOULD FIX)
1. [G1] Old block type "greenshift-blocks/heading" found
2. [H1] Section missing alignfull class
...

### Warnings (OPTIONAL)
1. [J1] Unnecessary fontSize on paragraph
2. [I3] Animation duration 1500ms exceeds recommended 1000ms
...
```

---

## Step 5: Ask User About Fixes

Use AskUserQuestion tool:

**Question 1: Apply Fixes?**

"I found X issues in your code. How should I proceed?"

Options:
1. **"Fix all issues (Recommended)"** - Apply all fixes automatically
2. **"Fix critical only"** - Only fix Critical issues, leave others
3. **"Show me fixes first"** - Display proposed changes before applying
4. **"Cancel"** - Don't make any changes

---

## Step 6: Ask About Animation Enhancement (Optional)

If code has animations OR user might want animations, ask:

**Question 2: Enhance Animations?**

"Would you like to enhance or standardize the animations?"

Options:
1. **"Keep current animations"** - Only fix animation issues, don't change style
2. **"Remove all animations"** - Strip all animations for static output
3. **"Subtle animations (Recommended)"** - Uniform `fade-up`, 600ms, ease-out
4. **"Professional staggered"** - `fade-up` with incremental delays (0, 150, 300...)
5. **"Dynamic mix"** - Varied animations (clip, fade, zoom) with staggered delays

### Animation Presets Detail

#### Preset: Subtle
```json
"animation": {"type": "fade-up", "duration": 600, "easing": "ease-out", "onlyonce": true}
```
- All elements get same animation
- No delays
- Clean, minimal effect

#### Preset: Professional Staggered
```json
// Element 1
"animation": {"type": "fade-up", "duration": 600, "easing": "ease-out", "onlyonce": true}
// Element 2
"animation": {"type": "fade-up", "duration": 600, "delay": 150, "easing": "ease-out", "onlyonce": true}
// Element 3
"animation": {"type": "fade-up", "duration": 600, "delay": 300, "easing": "ease-out", "onlyonce": true}
```
- Same animation type
- Incremental delays: 0, 150, 300, 450...
- Professional, sequential appearance

#### Preset: Dynamic Mix
```json
// Heading
"animation": {"type": "clip-right", "duration": 800, "easing": "ease-out", "onlyonce": true}
// Subheading
"animation": {"type": "fade-up", "duration": 600, "delay": 200, "easing": "ease-out", "onlyonce": true}
// Description
"animation": {"type": "fade-up", "duration": 600, "delay": 400, "easing": "ease-out", "onlyonce": true}
// Buttons
"animation": {"type": "fade-up", "duration": 600, "delay": 600, "easing": "ease-out", "onlyonce": true}
// Cards/Grid items
"animation": {"type": "zoom-in", "duration": 500, "delay": +150 each, "easing": "ease-out", "onlyonce": true}
// Images
"animation": {"type": "fade", "duration": 800, "easing": "ease-out", "onlyonce": true}
```
- Different animation types based on element
- Staggered delays
- More engaging, dynamic feel

---

## Step 7: Apply Fixes

Apply all chosen fixes:

1. **Fix Critical Issues** - Always apply
2. **Fix Important Issues** - Based on user choice
3. **Apply Animation Preset** - Based on user choice
4. **Maintain Structure** - Don't break existing hierarchy

### Fix Application Order

1. Fix block IDs first (A1, A2, A3)
2. Fix styling issues (B1, B2, B3, B4)
3. Fix content types (C1, C2, C3, C4)
4. Fix images (D1, D2, D3)
5. Fix SVG encoding (E1, E2)
6. Fix links/buttons (F1, F2, F3)
7. Convert old blocks (G1, G2, G3)
8. Fix structure (H1, H2, H3)
9. Apply animation changes (I1, I2, I3, I4 or preset)
10. Clean up minimal styling warnings (J1, J2, J3) - only if user chose "Fix all"

---

## Step 8: Quality Check

After fixes, verify:

**Structure & IDs:**
- [ ] All IDs are unique and valid format
- [ ] All `localId` match `id`
- [ ] No inline style attributes
- [ ] Structure is valid (section > content > elements)
- [ ] No HTML comments (use `metadata:{"name":"..."}`)

**Typography (CRITICAL):**
- [ ] **NO `fontSize` on headings (h1-h6)**
- [ ] **NO `fontWeight` on headings (h1-h6)**
- [ ] **NO `color` on text** (unless on dark background)
- [ ] **NO `fontWeight: ["400"]` anywhere**
- [ ] Proper heading hierarchy (h2 → h3 → h4)

**Images & Media:**
- [ ] All images have `loading="lazy"` and dimensions
- [ ] SVG properly encoded
- [ ] Slider images use element blocks in `slider-content-zone`
- [ ] Swipe blocks have `imageurl:""` and `bgContain:false`

**Other:**
- [ ] Animations have `onlyonce: true`
- [ ] No old block types remain
- [ ] Background colors use palette variables

---

## Step 9: Save Output

1. Generate the fixed Greenshift block HTML code
2. Suggest filename: `fixed-[original-name].html` or ask user
3. **SAVE the code to an HTML file** using the Write tool
4. Show summary:
   - Issues fixed: X
   - Animation preset applied: [name]
   - File saved: [path]

**IMPORTANT:** Always save output to a `.html` file. Never just display the code in chat.

---

## Example Verification Output

```
## Verification Report

### Summary
- Total blocks analyzed: 12
- Critical issues: 4
- Important issues: 2
- Warnings: 3

### Critical Issues (MUST FIX)
1. [A2] Block "gsbp-abc1234" - localId missing, id exists
2. [B1] Block "gsbp-def5678" - Found inline style="color: red"
3. [B2] Block "gsbp-ghi9012" - Has styleAttributes but localId not in class
4. [D1] Image block "gsbp-jkl3456" - Missing loading="lazy"

### Important Issues (SHOULD FIX)
1. [G1] Found old block type "greenshift-blocks/heading" - should be element
2. [H1] Section "gsbp-mno7890" - Has align:"full" but missing alignfull class

### Warnings (OPTIONAL)
1. [I1] Animation missing onlyonce:true on block "gsbp-pqr1234"
2. [I3] Animation duration 1500ms on block "gsbp-stu5678"
3. [J2] Unnecessary fontWeight:"400" on block "gsbp-vwx9012"
```

---

## Error Handling

If file cannot be read:
1. Report the error clearly
2. Ask user to provide valid file path or paste code directly

If code is severely malformed:
1. Report which parts cannot be parsed
2. Attempt to fix what's possible
3. Note unfixable sections in output
