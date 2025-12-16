---
description: Create an animated number counter for WordPress Greenshift that counts up on scroll
argument-hint: [target number] [label or description]
---

# Greenshift Counter Generator

Generate animated number counters that count up when scrolled into view. Perfect for statistics, achievements, or metrics sections.

## Instructions

1. Read the `greenshift-blocks` skill documentation, specifically `docs/08-variations.md` for counter structure
2. Generate counter according to: $ARGUMENTS

## Counter Types

### Single Counter
- Large animated number
- Optional label below/beside
- Good for hero stats

### Counter Grid
- Multiple counters in row/grid
- Icons above numbers
- Labels below
- Stats section layout

### Counter with Icon
- Icon above number
- Number with suffix (%, +, k, etc.)
- Description text

### Milestone Counter
- Progress bar style
- Number overlaid
- Good for achievements

## Basic Counter Structure

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-XXXXXXX","textContent":"0","localId":"gsbp-XXXXXXX","styleAttributes":{...},"isVariation":"counter","endNumber":100,"durationNumber":2,"offsetNumber":50,"stepNumber":1} -->
<div class="gsbp-XXXXXXX" data-gs-counter="{&quot;end&quot;:100,&quot;duration&quot;:2,&quot;offset&quot;:50,&quot;step&quot;:1}">0</div>
<!-- /wp:greenshift-blocks/element -->
```

## Key Parameters

### Counter Block
```json
{
  "isVariation": "counter",
  "textContent": "0",
  "endNumber": 100,
  "durationNumber": 2,
  "offsetNumber": 50,
  "stepNumber": 1,
  "styleAttributes": {
    "fontSize": ["50px"],
    "lineHeight": ["50px"],
    "minHeight": ["50px"],
    "minWidth": ["50px"],
    "display": ["inline-block"],
    "position": ["relative"],
    "fontWeight": ["bold"]
  }
}
```

### Parameter Definitions

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `endNumber` | Number | Target number to count to | Required |
| `durationNumber` | Number | Animation duration in seconds | 2 |
| `offsetNumber` | Number | Scroll offset trigger (%) | 50 |
| `stepNumber` | Number | Increment step size | 1 |
| `textContent` | String | Starting display value | "0" |

## data-gs-counter Attribute

The counter uses a JSON data attribute:

```html
data-gs-counter="{&quot;end&quot;:100,&quot;duration&quot;:2,&quot;offset&quot;:50,&quot;step&quot;:1}"
```

**Decoded JSON:**
```json
{
  "end": 100,
  "duration": 2,
  "offset": 50,
  "step": 1
}
```

## Counter with Suffix

For numbers like "500+" or "99%":

```html
<!-- Counter wrapper -->
<!-- wp:greenshift-blocks/element {"type":"inner","styleAttributes":{"display":["inline-flex"],"alignItems":["baseline"]}} -->
<div>
  <!-- Number -->
  <!-- wp:greenshift-blocks/element {"isVariation":"counter","endNumber":500,...} -->
  <div data-gs-counter="...">0</div>
  <!-- /wp:greenshift-blocks/element -->

  <!-- Suffix -->
  <!-- wp:greenshift-blocks/element {"textContent":"+","tag":"span",...} -->
  <span>+</span>
  <!-- /wp:greenshift-blocks/element -->
</div>
<!-- /wp:greenshift-blocks/element -->
```

## Counter Grid Section

Full section with multiple counters:

```
Section (alignfull)
└── Content Area
    └── Counter Grid (flexbox, 4 columns)
        ├── Counter Item 1
        │   ├── Icon (optional)
        │   ├── Number (counter)
        │   └── Label
        ├── Counter Item 2
        │   └── ...
        └── ...
```

## Styling Recommendations

### Number Styling
```json
{
  "styleAttributes": {
    "fontSize": ["var(--wp--preset--font-size--giant, 4rem)"],
    "fontWeight": ["700"],
    "color": ["var(--wp--preset--color--primary, #000)"],
    "lineHeight": ["1"]
  }
}
```

### Label Styling
```json
{
  "styleAttributes": {
    "fontSize": ["var(--wp--preset--font-size--s, 1rem)"],
    "marginTop": ["var(--wp--preset--spacing--40, 1rem)"],
    "opacity": ["0.7"],
    "textTransform": ["uppercase"],
    "letterSpacing": ["0.1em"]
  }
}
```

### Grid Container
```json
{
  "styleAttributes": {
    "display": ["flex"],
    "flexWrap": ["wrap"],
    "justifyContent": ["center"],
    "columnGap": ["var(--wp--preset--spacing--70, 3rem)"],
    "rowGap": ["var(--wp--preset--spacing--60, 2rem)"],
    "textAlign": ["center"]
  }
}
```

## Animation Tips

- **Duration**: 2-3 seconds for best effect
- **Offset**: 50% triggers when half visible
- **Step**: Use 1 for smooth, higher for faster jumps
- **Large numbers**: Consider step of 10-100 for thousands

## Common Counter Values

| Type | Example | endNumber | Suffix |
|------|---------|-----------|--------|
| Percentage | 99% | 99 | % |
| Count | 500+ | 500 | + |
| Thousands | 10k | 10 | k |
| Years | 25 years | 25 | years |
| Currency | $1M | 1 | M |

## Output Requirements

- Include data-gs-counter attribute with proper JSON
- Use textContent="0" as starting value
- Each counter needs unique ID (gsbp-XXXXXXX)
- Include proper responsive font sizes
- Add animations (fade-up) to container if multiple counters

## Output

1. Generate the complete Greenshift counter block HTML code
2. Ask user for filename or suggest one based on content (e.g., `counter-stats.html`)
3. **SAVE the code to an HTML file** using the Write tool
4. Confirm the file location to the user

**IMPORTANT:** Always save output to a `.html` file. Never just display the code in chat.
