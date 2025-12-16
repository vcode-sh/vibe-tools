# Migration & Styling Rules

## Core Philosophy: Convert Structure, Not Style

When migrating old Greenshift blocks to GreenLight Element, the goal is **structural conversion** with **minimal style intervention**. Let the WordPress theme handle defaults.

---

## Typography Rules (CRITICAL)

### Headings (h1-h6): NEVER Style These Properties

| Property | Rule | Reason |
|----------|------|--------|
| `fontSize` | **NEVER add** | Theme typography defines heading sizes |
| `fontWeight` | **NEVER add** | Theme defines heading weights |
| `color` | **NEVER add** | Theme defines text colors |
| `lineHeight` | **RARELY add** | Only when explicitly breaking layout |

**Exception:** Text on dark/colored backgrounds needs explicit color.

**WRONG - Over-styled heading:**
```json
{
  "tag": "h2",
  "textContent": "Title",
  "styleAttributes": {
    "fontSize": ["3rem", "2.7rem"],
    "fontWeight": ["700"],
    "color": ["var(--wp--preset--color--palette-color-1)"]
  }
}
```

**CORRECT - Minimal heading:**
```json
{
  "tag": "h2",
  "textContent": "Title",
  "styleAttributes": {
    "marginBottom": ["1rem"],
    "textAlign": ["center"]
  }
}
```

Or even better - **no styleAttributes at all** if theme defaults work.

### When Original Has Typography Settings

If the old block had `typography.size`, `typography.color`, etc.:

1. **DON'T** blindly convert them to `styleAttributes.fontSize`, etc.
2. **DO** ask: "Is this necessary, or will the theme handle it?"
3. **DEFAULT** to removing typography styles unless explicitly required

---

## Semantic Heading Hierarchy

Use proper HTML heading hierarchy, not what the original code had.

### Page Structure Pattern

```
h1 - Page title (often in theme header)
h2 - Main section titles
h3 - Subsection titles
h4 - Minor headings within subsections
h5/h6 - Rarely needed
```

### Example: "How To Book" Section

**Original (semantically wrong):**
```
h2 - "The journey with us, step-by-step" (intro)
h2 - "How to Book Your Wedding Videographer" (grid title)
h3 - "You reach out" (step 1)
h3 - "You book" (step 2)
...
```

**Fixed (semantically correct):**
```
h2 - "Krok po kroku" (section title - ONE h2 per section)
h3 - "Jak wygląda współpraca z nami" (subsection title)
h4 - "Napisz lub zadzwoń" (step heading)
h4 - "Rezerwacja" (step heading)
...
```

**Rule:** If a "title" appears inside a grid/card alongside other content, it's likely h3 or h4, not h2.

---

## Text Color Rules

### NEVER Set Color On:
- Headings (h1-h6)
- Paragraphs in standard sections
- Text in light/default backgrounds

### ONLY Set Color When:
- Text is on dark background: `"color": ["var(--wp--preset--color--white, #ffffff)"]`
- Text is on colored background requiring contrast
- Decorative/accent text with specific design requirement

**WRONG:**
```json
"styleAttributes": {
  "color": ["var(--wp--preset--color--palette-color-5, var(--theme-palette-color-5, #5f768c))"]
}
```

**CORRECT:** Remove color entirely - let theme cascade.

---

## Font Weight Rules

### NEVER Set fontWeight:
- `fontWeight: ["400"]` - This is the default, remove it
- `fontWeight: ["normal"]` - Same as above
- On headings - theme handles heading weights

### ONLY Set fontWeight When:
- Making specific text bold that isn't naturally bold: `["700"]` or `["bold"]`
- Semi-bold accent text: `["600"]`
- Light weight text for stylistic reasons: `["300"]`

---

## Font Size Rules for Body Text

### Default Body Text (paragraphs, divs)
- **Don't add fontSize** if theme default (typically 1rem/16px) works
- **Don't preserve weird responsive arrays** like `[null, null, null, "0.9rem"]`

### When to Add fontSize:
- Large intro/lead text: `fontSize: ["1.2rem"]` or `["var(--wp--preset--font-size--r)"]`
- Small/caption text: `fontSize: ["0.85rem"]` or `["var(--wp--preset--font-size--xs)"]`
- Specific design requirement

### Standardizing Responsive Arrays

**Original (weird):**
```json
"fontSize": [null, null, null, "0.9rem"]
```
This means: default on desktop/tablet, 0.9rem only on mobile.

**Better approach:** Either:
1. Remove entirely (let theme handle)
2. Set consistent value: `["1rem"]`
3. Keep only if the mobile-specific size is truly intentional

---

## Line Height Rules

### NEVER Add lineHeight:
- To headings (theme handles)
- When using default body text

### ONLY Add lineHeight When:
- Custom text sizing requires it
- Improving readability of dense text: `["1.5"]` or `["1.6em"]`
- Tight leading for large display text: `["1.1"]`

---

## Background Color Rules

### Theme Palette Variables

**CORRECT - Theme palette (adapts to theme settings):**
```json
"backgroundColor": ["var(--wp--preset--color--palette-color-5, var(--theme-palette-color-5, #e7e5e4))"]
"backgroundColor": ["var(--wp--preset--color--palette-color-6, var(--theme-palette-color-6, #f5f5f4))"]
"backgroundColor": ["var(--wp--preset--color--palette-color-7, var(--theme-palette-color-7, #fafaf9))"]
"backgroundColor": ["var(--wp--preset--color--palette-color-8, var(--theme-palette-color-8, #ffffff))"]
```

**WRONG - Generic color names (override theme customization):**
```json
"backgroundColor": ["var(--wp--preset--color--white, #ffffff)"]
"backgroundColor": ["var(--wp--preset--color--light-grey, #f8f8f8)"]
"backgroundColor": ["#f5f5f5"]
```

### Palette Number Guide

| Palette | Typical Use | Fallback |
|---------|-------------|----------|
| palette-color-1 | Primary brand | Dark/bold |
| palette-color-2 | Secondary brand | Accent |
| palette-color-3 | Tertiary | Medium |
| palette-color-4 | Text dark | Near black |
| palette-color-5 | Text muted | Gray |
| palette-color-6 | Surface light | Light gray |
| palette-color-7 | Surface lighter | Near white |
| palette-color-8 | Background | White |

**Note:** Exact values vary by theme. The palette system ensures consistency.

---

## Spacing & Gap Rules

### Keep Working Values

If original has `"columnGap": ["20px"]` and it works - **keep it**.

**DON'T** automatically convert every pixel value to CSS variables.

### When to Use CSS Variables for Spacing

Use variables when:
- Creating new blocks from scratch
- User explicitly requests "normalize to theme"
- Value is clearly arbitrary and could benefit from consistency

**Spacing variable mapping:**
| Range | Variable |
|-------|----------|
| ~8-12px | `var(--wp--preset--spacing--30)` |
| ~14-18px | `var(--wp--preset--spacing--40)` |
| ~20-28px | `var(--wp--preset--spacing--50)` |
| ~30-40px | `var(--wp--preset--spacing--60)` |
| ~45-60px | `var(--wp--preset--spacing--70)` |
| ~70-90px | `var(--wp--preset--spacing--80)` |

---

## Margin Rules for Text Elements

### Standard Pattern

**Headings:** Only `marginBottom` for spacing to next element
```json
"styleAttributes": {
  "marginTop": ["0px"],
  "marginBottom": ["1rem"]
}
```

**Paragraphs:** Usually no margin styling needed (theme handles)

**Last element in container:** Consider `marginBottom: ["0px"]` to prevent extra space

---

## Migration Decision Tree

```
For each style property in old block:
│
├─ Is it fontSize on h1-h6?
│  └─ YES → REMOVE IT
│
├─ Is it color on regular text?
│  └─ Is background dark/colored?
│     ├─ YES → KEEP (but use white/contrast color)
│     └─ NO → REMOVE IT
│
├─ Is it fontWeight: 400/normal?
│  └─ YES → REMOVE IT
│
├─ Is it fontWeight on a heading?
│  └─ YES → REMOVE IT
│
├─ Is it working spacing (px/rem)?
│  └─ YES → KEEP IT (don't force CSS variables)
│
├─ Is it lineHeight on body text without custom fontSize?
│  └─ YES → PROBABLY REMOVE IT
│
└─ Default: KEEP if it serves a clear purpose
```

---

## Before/After Examples

### Example 1: Section Heading

**Before (old block):**
```json
{
  "headingContent": "The journey with us",
  "typography": {
    "size": ["3rem", "2.7rem"],
    "alignment": ["center"]
  },
  "spacing": {
    "margin": {"bottom": ["1rem"]}
  }
}
```

**WRONG Migration:**
```json
{
  "textContent": "The journey with us",
  "tag": "h2",
  "styleAttributes": {
    "fontSize": ["3rem", "2.7rem"],
    "textAlign": ["center"],
    "marginBottom": ["1rem"]
  }
}
```

**CORRECT Migration:**
```json
{
  "textContent": "The journey with us",
  "tag": "h2",
  "styleAttributes": {
    "marginBottom": ["1rem"],
    "textAlign": ["center"]
  }
}
```

### Example 2: Subtitle Text

**Before:**
```json
{
  "textContent": "What happens next?",
  "typography": {
    "size": ["1.2rem"],
    "color": "var(--palette-color-5)",
    "fontfamily": "ct_font_freight_display_pro",
    "customweight": "custom",
    "customweightnumber": 400
  }
}
```

**WRONG Migration:**
```json
{
  "textContent": "What happens next?",
  "styleAttributes": {
    "fontSize": ["1.2rem"],
    "color": ["var(--wp--preset--color--palette-color-5, ...)"],
    "fontFamily": ["ct_font_freight_display_pro"],
    "fontWeight": ["400"]
  }
}
```

**CORRECT Migration:**
```json
{
  "textContent": "What happens next?",
  "styleAttributes": {
    "fontSize": ["1.2rem"],
    "fontFamily": ["ct_font_freight_display_pro"],
    "marginBottom": ["1.5rem"],
    "textAlign": ["center"],
    "maxWidth": ["680px"]
  }
}
```

- Removed `color` (let theme handle)
- Removed `fontWeight: 400` (it's the default)
- Kept `fontSize` (intentional accent size)
- Kept `fontFamily` (specific font choice)

### Example 3: Step Card Heading

**Before:**
```json
{
  "headingTag": "h3",
  "headingContent": "You reach out",
  "typography": {
    "size": ["2rem", null, null, "1.5rem"]
  }
}
```

**CORRECT Migration:**
```json
{
  "tag": "h4",
  "textContent": "You reach out",
  "styleAttributes": {
    "marginTop": ["0px"]
  }
}
```

- Changed to `h4` (proper hierarchy - steps are minor headings)
- Removed fontSize entirely
- Only kept structural margin
