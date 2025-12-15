# Vibe Tools

Claude Code plugin marketplace by [Vibe Code](https://x.com/vcode_sh).

## Installation

### Add Marketplace

```bash
/plugin marketplace add vcode-sh/vibe-tools
```

### Install Plugins

```bash
# Install greenshift-blocks plugin
/plugin install greenshift-blocks@vibe-tools
```

## Available Plugins

| Plugin | Description |
|--------|-------------|
| [greenshift-blocks](./plugins/greenshift-blocks) | Generate WordPress Gutenberg blocks using Greenshift/GreenLight |

## Plugins

### greenshift-blocks

Generate production-ready WordPress Gutenberg blocks using the Greenshift/GreenLight block system.

**Features:**
- Complete section and page generation
- Responsive layouts with flexbox
- AOS animations
- CSS variables for theming
- Ready-to-paste WordPress block markup

**Commands:**
- `/gs:section` - Create WordPress sections
- `/gs:hero` - Hero section with background and CTA
- `/gs:columns` - Column layouts (2-4 columns)
- `/gs:element` - Single elements
- `/gs:gallery` - Image galleries
- `/gs:card` - Card components
- `/gs:page` - Complete pages

[Full documentation](./plugins/greenshift-blocks/README.md)

## Repository Structure

```
vibe-tools/
├── .claude-plugin/
│   └── marketplace.json      # Marketplace manifest
├── plugins/
│   └── greenshift-blocks/    # Greenshift blocks plugin
│       ├── .claude-plugin/
│       │   └── plugin.json   # Plugin manifest
│       ├── commands/         # Slash commands
│       ├── agents/           # Specialized agents
│       └── skills/           # Skills with docs & templates
└── README.md
```

## Contributing

Contributions welcome! Please submit pull requests to add new plugins or improve existing ones.

## Author

**Vibe Code** - [@vcode_sh](https://x.com/vcode_sh)

## License

MIT
