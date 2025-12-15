# Greenshift Blocks Plugin for Claude Code

Plugin for generating WordPress Gutenberg blocks using the Greenshift/GreenLight system.

## Installation

### Via Vibe Tools Marketplace

```bash
/plugin marketplace add vcode-sh/vibe-tools
/plugin install greenshift-blocks@vibe-tools
```

### As Project Skills (local)

Copy the `skills/greenshift-blocks/` directory to `.claude/skills/` in your project:
```bash
cp -r plugins/greenshift-blocks/skills/greenshift-blocks .claude/skills/
```

## Components

### Skill: greenshift-blocks

Automatically activates when you use keywords like:
- wordpress, gutenberg, greenshift
- section, block, layout, hero, gallery
- element, columns

### Slash Commands

| Command | Description |
|---------|-------------|
| `/gs:section [description]` | Creates a full WordPress section |
| `/gs:hero [title]` | Hero section with background and CTA |
| `/gs:columns [2-4] [description]` | Column layout |
| `/gs:element [type] [description]` | Single element |
| `/gs:gallery [type] [count]` | Image gallery |
| `/gs:card [type] [description]` | Card component |
| `/gs:page [type]` | Complete page |

### Agent: greenshift-builder

Specialized agent for building complex sections and pages. Automatically triggered for comprehensive tasks.

## Usage

### Basic

```
Create a hero section for a wedding photographer website
```

```
/gs:hero Wedding Photography - Capture Your Special Day
```

```
/gs:columns 2 Text on left, image gallery on right
```

### Advanced

```
Create a complete landing page for a photography studio:
- Hero with video background
- About Us section with 2 columns
- Portfolio gallery (4-column grid)
- Testimonials section
- CTA with contact form
```

## Documentation

Full documentation is available in `skills/greenshift-blocks/docs/`:

| File | Topic |
|------|-------|
| `00-index.md` | Navigation index |
| `01-core-structure.md` | Block format, JSON parameters |
| `02-attributes.md` | HTML attributes, links, images |
| `03-layouts.md` | Sections, columns, flexbox |
| `04-styling-advanced.md` | Local classes, gradients |
| `05-animations.md` | AOS, CSS keyframes |
| `06-slider.md` | Swiper slider configuration |
| `07-dynamic-content.md` | Dynamic text, query grids |
| `08-variations.md` | Accordion, tabs, counter |
| `09-css-variables.md` | Fonts, spacing, shadows |
| `10-scripts.md` | Custom JavaScript, GSAP |
| `11-charts.md` | ApexCharts integration |

## File Structure

```
greenshift-blocks/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/
│   ├── section.md           # /gs:section
│   ├── hero.md              # /gs:hero
│   ├── columns.md           # /gs:columns
│   ├── element.md           # /gs:element
│   ├── gallery.md           # /gs:gallery
│   ├── card.md              # /gs:card
│   └── page.md              # /gs:page
├── agents/
│   └── greenshift-builder.md
├── skills/
│   └── greenshift-blocks/
│       ├── SKILL.md         # Main skill
│       ├── reference.md     # Quick reference
│       ├── docs/            # Full documentation
│       └── templates/       # Ready patterns
└── README.md
```

## Example Output

The plugin generates ready HTML code for WordPress Gutenberg Code Editor:

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-a3f7b2c","tag":"section","type":"inner",...} -->
<section class="gsbp-a3f7b2c alignfull">
  <!-- nested blocks -->
</section>
<!-- /wp:greenshift-blocks/element -->
```

## Generation Rules

1. **Unique IDs**: Every block has `id` and `localId` in format `gsbp-XXXXXXX`
2. **No inline styles**: Styles only through `styleAttributes`
3. **CSS Variables**: Prefer CSS variables over hardcoded values
4. **Responsiveness**: Values as array `["desktop", "tablet", "mobile_l", "mobile_p"]`
5. **AOS Animations**: Automatic data-aos attributes
6. **Lazy loading**: All images with `loading="lazy"`

## Author

**Vibe Code** - [@vcode_sh](https://x.com/vcode_sh)

## License

MIT
