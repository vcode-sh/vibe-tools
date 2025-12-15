# Vibe Tools

> Because copy-pasting WordPress blocks like it's 2015 is *so* last decade.

A Claude Code plugin marketplace for people who'd rather vibe than grind. Built by [Vibe Code](https://x.com/vcode_sh) - we automate the boring stuff so you can focus on the creative stuff. Or coffee. Probably coffee.

## Quick Start

```bash
# Add the marketplace (one time thing, we promise)
/plugin marketplace add vcode-sh/vibe-tools

# Install what you need
/plugin install greenshift-blocks@vibe-tools
```

That's it. No npm install, no dependency hell, no "works on my machine" moments.

## Available Plugins

| Plugin | What it does | Vibe level |
|--------|--------------|------------|
| [greenshift-blocks](./plugins/greenshift-blocks) | WordPress Gutenberg blocks that actually work | Maximum |

## greenshift-blocks

Generate production-ready WordPress Gutenberg blocks using Greenshift/GreenLight. Because manually writing JSON-in-HTML-comments is a special kind of torture we don't wish on anyone.

**What you get:**
- Full sections and pages in seconds
- Responsive layouts (yes, mobile too)
- Animations that don't look like 2010 jQuery
- CSS variables because we're civilized
- Copy-paste ready code (finally, copy-paste done right)

**Commands:**

| Command | Does the thing |
|---------|----------------|
| `/gs:section` | Sections. Shocking, right? |
| `/gs:hero` | Hero sections with that *chef's kiss* |
| `/gs:columns` | 2-4 column layouts |
| `/gs:element` | Individual elements |
| `/gs:gallery` | Image galleries |
| `/gs:card` | Card components |
| `/gs:page` | Entire pages. Yes, really. |

[Full docs](./plugins/greenshift-blocks/README.md) for the curious.

## Structure

```
vibe-tools/
├── .claude-plugin/
│   └── marketplace.json      # The brain
├── plugins/
│   └── greenshift-blocks/    # The muscle
│       ├── commands/         # /gs:* magic
│       ├── agents/           # The specialists
│       └── skills/           # The knowledge
└── README.md                 # You are here
```

## Contributing

Got a plugin idea? Found a bug? Want to argue about tabs vs spaces?

PRs welcome. Issues tolerated. Memes appreciated.

## Author

**Vibe Code** — [@vcode_sh](https://x.com/vcode_sh)

Building tools for developers who value their time. And sanity.

## License

MIT — Do whatever you want. Just don't blame us if your WordPress site becomes sentient.

---

*Built with Claude Code, caffeine, and questionable life choices.*
