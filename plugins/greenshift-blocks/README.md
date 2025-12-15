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

#### Layout & Sections
| Command | Description |
|---------|-------------|
| `/gs:section [description]` | Creates a full WordPress section |
| `/gs:hero [title]` | Hero section with background and CTA |
| `/gs:columns [2-4] [description]` | Column layout |
| `/gs:page [type]` | Complete page |

#### Elements & Components
| Command | Description |
|---------|-------------|
| `/gs:element [type] [description]` | Single element |
| `/gs:gallery [type] [count]` | Image gallery (grid, masonry, slider) |
| `/gs:card [type] [description]` | Card component |

#### Interactive Blocks
| Command | Description |
|---------|-------------|
| `/gs:accordion [items] [topic]` | Collapsible accordion/FAQ |
| `/gs:tabs [count] [titles]` | Tabbed interface |
| `/gs:counter [number] [label]` | Animated number counter |
| `/gs:countdown [date] [event]` | Countdown timer |
| `/gs:table [rows]x[cols] [topic]` | Responsive table |
| `/gs:video [type] [url]` | Video (native, YouTube, Vimeo, lightbox) |

#### Design Conversion
| Command | Description |
|---------|-------------|
| `/gs:clone [image path]` | Convert screenshot/image to Greenshift blocks |

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
│   ├── page.md              # /gs:page
│   ├── accordion.md         # /gs:accordion
│   ├── tabs.md              # /gs:tabs
│   ├── counter.md           # /gs:counter
│   ├── countdown.md         # /gs:countdown
│   ├── table.md             # /gs:table
│   ├── video.md             # /gs:video
│   └── clone.md             # /gs:clone (screenshot to blocks)
├── agents/
│   └── greenshift-builder.md
├── skills/
│   └── greenshift-blocks/
│       ├── SKILL.md         # Main skill
│       ├── reference.md     # Quick reference
│       ├── docs/            # Full documentation
│       └── templates/       # Ready-to-use patterns
│           ├── section-wrapper.html
│           ├── two-columns.html
│           ├── hero-section.html
│           ├── card-grid.html
│           ├── faq-section.html
│           ├── pricing-table.html
│           ├── stats-counters.html
│           ├── features-grid.html
│           ├── cta-banner.html
│           ├── testimonials-slider.html
│           └── footer.html
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
