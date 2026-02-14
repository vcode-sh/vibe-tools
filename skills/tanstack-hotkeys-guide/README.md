# TanStack Hotkeys Guide Plugin

Add keyboard shortcuts to React apps in seconds. This plugin teaches Claude everything about TanStack Hotkeys -- from simple Mod+S save shortcuts to Vim-style key sequences, hotkey recording for settings UIs, real-time key state tracking, and platform-aware display formatting.

## What it does

Instead of wrestling with keyboard event handling, platform differences, and input element filtering, just describe what you need. Claude will generate correct TanStack Hotkeys code with proper cross-platform `Mod` shortcuts, smart input handling defaults, and the right hook for each use case.

Covers 8 React hooks, 4 singleton managers, 6 formatting utilities, and 25+ real-world patterns.

## Installation

```bash
claude install-plugin /path/to/tanstack-hotkeys-guide-plugin
```

Or add the plugin directory to your Claude Code configuration.

## Usage

Once installed, Claude automatically activates this guide when you:

- "Add keyboard shortcuts to my React app"
- "Register hotkeys with TanStack Hotkeys"
- "Add a Mod+S save shortcut"
- "Create Vim-style key sequences"
- "Build a keyboard shortcut customization UI"
- "Record keyboard shortcuts for settings"
- "Track held keys for modifier indicators"
- "Show keyboard shortcut badges in menus"
- "Format hotkeys for platform-aware display"
- "Set up TanStack Hotkeys devtools"
- "Handle keyboard shortcuts in text inputs"
- "Add a command palette with hotkey hints"

## What's included

| Reference | Coverage |
|-----------|----------|
| React Hooks | useHotkey, useHotkeySequence, useHotkeyRecorder, useHeldKeys, useHeldKeyCodes, useKeyHold, useDefaultHotkeysOptions, useHotkeysContext |
| Provider | HotkeysProvider for global default options |
| Core Classes | HotkeyManager, SequenceManager, KeyStateTracker, HotkeyRecorder |
| Formatting | formatForDisplay, formatWithLabels, formatKeyForDebuggingDisplay, convertToModFormat, formatHotkey |
| Parsing & Validation | parseHotkey, normalizeHotkey, validateHotkey, assertValidHotkey, checkHotkey |
| Matching | matchesKeyboardEvent, createHotkeyHandler, createMultiHotkeyHandler, createSequenceMatcher |
| Patterns | 25 usage patterns: editor shortcuts, scoped hotkeys, conditional hotkeys, sequences, recording UI, hold-to-reveal, shortcut hints, menu badges, command palette, key debugger, vanilla JS, devtools |
| Troubleshooting | macOS quirks, window blur, focusable targets, smart ignoreInputs, conflicts, SSR, Alt+letter, Shift+number |

## License

MIT
