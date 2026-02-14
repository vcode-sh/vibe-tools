# Vibe Tools

> Because copy-pasting WordPress blocks like it's 2015 is *so* last decade.

A Claude Code plugin marketplace for people who'd rather vibe than grind. Built by [Vibe Code](https://x.com/vcode_sh) - we automate the boring stuff so you can focus on the creative stuff. Or coffee. Probably coffee.

## Quick Start

```bash
# Add the marketplace (one time thing, we promise)
/plugin marketplace add vcode-sh/vibe-tools

# Install what you need
/plugin install greenshift-blocks@vibe-tools
/plugin install skill-maker@vibe-tools
/plugin install base-ui-guide@vibe-tools
/plugin install shadcn-guide@vibe-tools
/plugin install hono-guide@vibe-tools
/plugin install orpc-guide@vibe-tools
/plugin install tanstack-hotkeys-guide@vibe-tools
```

That's it. No npm install, no dependency hell, no "works on my machine" moments.

## Available Plugins

| Plugin | What it does | Vibe level |
|--------|--------------|------------|
| [greenshift-blocks](./plugins/greenshift-blocks) | WordPress Gutenberg blocks that actually work | Maximum |
| [skill-maker](./plugins/skill-maker) | Create, review & package Anthropic Agent Skills | Over 9000 |

## Skill Guides

Library-specific guides that teach Claude how to use frameworks correctly. Install one and Claude instantly knows the API, patterns, and best practices.

```bash
/plugin install base-ui-guide@vibe-tools
/plugin install shadcn-guide@vibe-tools
/plugin install hono-guide@vibe-tools
/plugin install orpc-guide@vibe-tools
/plugin install tanstack-hotkeys-guide@vibe-tools
```

| Guide | Library | What Claude learns |
|-------|---------|-------------------|
| [base-ui-guide](./skills/base-ui-guide) | Base UI (`@base-ui/react`) | 35+ unstyled headless components, styling patterns, animations, composition |
| [shadcn-guide](./skills/shadcn-guide) | shadcn/ui (`shadcn`) | 58+ components, theming, registry system, form patterns, dark mode |
| [hono-guide](./skills/hono-guide) | Hono (`hono`) | Routing, middleware, RPC client, multi-runtime deployment, streaming/SSE |
| [orpc-guide](./skills/orpc-guide) | oRPC (`@orpc/*`) | Type-safe APIs, OpenAPI generation, 20+ framework adapters, streaming |
| [tanstack-hotkeys-guide](./skills/tanstack-hotkeys-guide) | TanStack Hotkeys (`@tanstack/react-hotkeys`) | Keyboard shortcuts, sequences, recording, cross-platform Mod keys |

More guides are added over time as skills get packaged in [vibe-skills](https://github.com/vcode-sh/vibe-skills).

---

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
| `/gs:accordion` | FAQ/collapsible sections |
| `/gs:tabs` | Tabbed interfaces |
| `/gs:counter` | Animated number counters |
| `/gs:countdown` | Countdown timers |
| `/gs:table` | Responsive tables |
| `/gs:video` | Videos (native, YouTube, Vimeo, lightbox) |
| `/gs:clone` | Screenshot to Greenshift blocks |

[Full docs](./plugins/greenshift-blocks/README.md) for the curious.

---

## skill-maker

Create, review, test, and package Anthropic Agent Skills for Claude.ai and Claude Code. Because writing YAML frontmatter by hand and hoping Claude triggers your skill is not a vibe.

**What you get:**
- Create skills from docs folders or project codebases automatically
- Interactive wizard, quick generation, or 8 ready-made templates
- Quality auditing with auto-fix — no more "why won't it trigger?"
- Trigger testing so you know it actually works before shipping
- Package for Claude.ai (zip) or Claude Code (plugin scaffold)

**Commands:**

| Command | Does the thing |
|---------|----------------|
| `/sm:from-docs` | Point it at a docs folder, get a skill back |
| `/sm:from-project` | Scan your codebase, extract patterns into a skill |
| `/sm:learn` | Beginner tutorial — build your first skill hands-on |
| `/sm:create` | Interactive wizard for guided creation |
| `/sm:quick` | Describe it, get it. No questions asked. |
| `/sm:template` | 8 pre-built templates for every skill category |
| `/sm:review` | Full quality audit with scoring |
| `/sm:test` | Generate trigger, functional, and perf tests |
| `/sm:fix` | Auto-fix issues found in review |
| `/sm:improve` | Iterative improvement from real-world feedback |
| `/sm:validate` | Quick pass/fail structural check |
| `/sm:package` | Package for Claude.ai or Claude Code distribution |
| `/sm:docs` | Interactive reference — 15 topics with examples |

[Full docs](./plugins/skill-maker/README.md) for the curious.

---

## Structure

```
vibe-tools/
├── .claude-plugin/
│   └── marketplace.json         # The brain
├── plugins/                     # Rich plugins (commands, agents, skills)
│   ├── greenshift-blocks/       # WordPress block generator
│   │   ├── commands/            # /gs:* magic (14 commands)
│   │   ├── agents/              # greenshift-builder
│   │   └── skills/              # Block knowledge + docs + templates
│   └── skill-maker/             # Skill creation toolkit
│       ├── commands/            # /sm:* magic (13 commands)
│       ├── agents/              # skill-builder
│       └── skills/              # Skill-making knowledge + templates + references
├── skills/                      # Skill guide plugins (auto-synced)
│   ├── base-ui-guide/           # Base UI components
│   ├── hono-guide/              # Hono web framework
│   ├── orpc-guide/              # oRPC type-safe APIs
│   ├── shadcn-guide/            # shadcn/ui components
│   └── tanstack-hotkeys-guide/  # TanStack keyboard shortcuts
├── scripts/
│   └── import-skills.sh         # Sync skills from vibe-skills
└── README.md                    # You are here
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
