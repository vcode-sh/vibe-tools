---
name: tanstack-hotkeys-guide
description: >-
  TanStack Hotkeys guide for type-safe keyboard shortcuts in React. Use when user asks to
  "add keyboard shortcuts", "register hotkeys", "handle keyboard shortcuts in React",
  "implement key bindings", "use TanStack Hotkeys", "use useHotkey", "add Mod+S shortcut",
  "create vim-style key sequences", "record keyboard shortcuts", "track held keys",
  "format hotkey display", "show keyboard shortcut badges", or asks about
  "@tanstack/react-hotkeys", "useHotkey hook", "useHotkeySequence", "useHotkeyRecorder",
  "useHeldKeys", "useKeyHold", "HotkeyManager", "formatForDisplay", or "keyboard shortcut
  customization UI". Covers hotkey registration, multi-key sequences, hotkey recording,
  key state tracking, platform-aware display formatting, and devtools integration. Do NOT
  use for react-hotkeys-hook, Mousetrap, use-hotkeys, hotkeys-js, or other keyboard
  shortcut libraries -- this is specifically for @tanstack/react-hotkeys.
metadata:
  author: Documentation Analysis
  version: 1.0.0
  source: documentation-analysis
  source-docs: source/tanstack/hotkeys/
  category: react-library
  tags:
    - tanstack
    - hotkeys
    - keyboard-shortcuts
    - react
    - typescript
---

## Purpose

TanStack Hotkeys is a type-safe, framework-agnostic library for handling keyboard shortcuts. It provides React hooks for registering hotkeys, multi-key sequences, recording custom shortcuts, tracking key state, and platform-aware display formatting. The library uses `event.key` as its primary API with `event.code` fallback for letter/digit keys. Currently in **alpha** -- API may change.

**When NOT to use:** For a single shortcut listener, a plain `addEventListener('keydown', ...)` may suffice. Reach for TanStack Hotkeys when you need multiple shortcuts, cross-platform `Mod` handling, sequences, recording, or key-state tracking.

## Instructions

- Always use `Mod` instead of platform-specific `Meta` or `Control` for cross-platform shortcuts
- Import from `@tanstack/react-hotkeys` for React projects (it re-exports everything from `@tanstack/hotkeys`)
- Import from `@tanstack/hotkeys` only for vanilla JS without React
- Prefer the string form (`'Mod+S'`) over RawHotkey objects unless the hotkey is dynamic or built programmatically
- Always add `tabIndex={0}` to elements used as `target` refs -- they must be focusable to receive keyboard events
- When building shortcut customization UIs, combine `useHotkeyRecorder` with `formatForDisplay` for recording and display
- The recorder auto-converts platform keys to portable `Mod` format -- do not manually convert recorded hotkeys
- Do NOT combine `Mod` with `Control` or `Mod` with `Meta` -- these create duplicate modifiers on one platform
- Avoid `Alt+letter` shortcuts for cross-platform apps -- macOS produces special characters with Option+letter
- Avoid `Shift+number` and `Shift+punctuation` shortcuts -- results are keyboard-layout-dependent
- Warn the user that TanStack Hotkeys is in **alpha** when recommending it for production use
- Default `preventDefault: true` and `stopPropagation: true` are intentional -- override explicitly only when needed
- Use `conflictBehavior: 'allow'` for intentional duplicate hotkeys, not to silence bugs

## Installation

```bash
npm install @tanstack/react-hotkeys
```

The React package re-exports everything from `@tanstack/hotkeys`. No separate core install needed. For vanilla JS only, install `@tanstack/hotkeys` directly.

Optional devtools:

```bash
npm install @tanstack/react-devtools @tanstack/react-hotkeys-devtools
```

## Quick Start

```tsx
import { useHotkey } from '@tanstack/react-hotkeys'

function App() {
  useHotkey('Mod+S', () => saveDocument())
  return <div>Press Cmd+S (Mac) or Ctrl+S (Windows) to save</div>
}
```

`Mod` resolves to Meta (Cmd) on macOS and Control on Windows/Linux.

## React Hooks Reference

### useHotkey(hotkey, callback, options?)

Register a keyboard shortcut. Auto-syncs callback every render (no stale closures). Auto-unregisters on unmount.

```tsx
useHotkey('Mod+S', (event, { hotkey, parsedHotkey }) => {
  save()
})
```

Accept a string (`'Mod+S'`) or RawHotkey object (`{ key: 'S', mod: true }`).

### useHotkeySequence(sequence, callback, options?)

Register Vim-style multi-key sequences. Each step can include modifiers.

```tsx
useHotkeySequence(['G', 'G'], () => scrollToTop())
useHotkeySequence(['Mod+K', 'Mod+C'], () => commentSelection())
```

Options: `{ timeout: 1000, enabled: true }`.

### useHotkeyRecorder(options)

Record custom keyboard shortcuts for settings UIs. Auto-converts to portable `Mod` format.

```tsx
const { isRecording, recordedHotkey, startRecording, stopRecording, cancelRecording } =
  useHotkeyRecorder({ onRecord: (hotkey) => setShortcut(hotkey) })
```

Options: `{ onRecord, onCancel?, onClear? }`. Escape cancels. Backspace/Delete clears.

### useHeldKeys()

Return a reactive `string[]` of currently held key names.

### useHeldKeyCodes()

Return a reactive `Record<string, string>` mapping key names to `event.code` values.

### useKeyHold(key)

Return `boolean` for a specific key's hold state. Only re-renders when that key changes.

```tsx
const isShiftHeld = useKeyHold('Shift')
```

### useDefaultHotkeysOptions()

Return the current default options from `HotkeysProvider` context.

### useHotkeysContext()

Return the full hotkeys context value, or `null` if outside a provider.

## HotkeysProvider

Wrap the app to set global default options. Per-hook options override provider defaults.

```tsx
import { HotkeysProvider } from '@tanstack/react-hotkeys'

<HotkeysProvider defaultOptions={{
  hotkey: { preventDefault: true },
  hotkeySequence: { timeout: 1500 },
  hotkeyRecorder: { onCancel: () => console.log('cancelled') },
}}>
  <App />
</HotkeysProvider>
```

## Hotkey String Format

- Modifiers: `Control`, `Alt`, `Shift`, `Meta`
- Cross-platform: `Mod` (Cmd on Mac, Ctrl on Windows/Linux)
- Format: `Modifier+Modifier+Key` -- e.g., `'Mod+Shift+S'`
- Single keys: `'Escape'`, `'Enter'`, `'F1'`, `'ArrowUp'`, `'A'`, `'1'`, `'/'`
- RawHotkey alternative: `{ key: 'S', mod: true, shift: true }`
- `Mod+Control` and `Mod+Meta` combinations are NOT allowed (would duplicate modifiers)

## useHotkey Options

| Option | Default | Description |
|---|---|---|
| enabled | true | Whether the hotkey is active |
| preventDefault | true | Call event.preventDefault() |
| stopPropagation | true | Call event.stopPropagation() |
| eventType | 'keydown' | 'keydown' or 'keyup' |
| requireReset | false | Fire only once per key press |
| ignoreInputs | smart | false for Mod+key and Escape; true for single keys and Shift/Alt combos |
| target | document | DOM element, document, window, or React ref |
| conflictBehavior | 'warn' | 'warn', 'error', 'replace', or 'allow' |
| platform | auto | Override: 'mac', 'windows', 'linux' |

Smart `ignoreInputs` default: Mod+key shortcuts and Escape fire in text inputs. Single keys and Shift/Alt combos are ignored. Button-type inputs (type="button/submit/reset") are NOT ignored -- shortcuts work on them.

## Display Formatting

```tsx
import { formatForDisplay, formatWithLabels, formatKeyForDebuggingDisplay } from '@tanstack/react-hotkeys'

formatForDisplay('Mod+S')        // Mac: "⌘S"         Windows: "Ctrl+S"
formatWithLabels('Mod+S')        // Mac: "Cmd+S"      Windows: "Ctrl+S"
formatKeyForDebuggingDisplay('Meta') // Mac: "⌘ Mod (Cmd)"
```

Options: `{ platform: 'mac' | 'windows' | 'linux' }`.

## Core Utilities (Vanilla JS)

Use these without React:

```ts
import {
  parseHotkey, normalizeHotkey, validateHotkey,
  createHotkeyHandler, createMultiHotkeyHandler, createSequenceMatcher,
  getHotkeyManager, getKeyStateTracker, getSequenceManager,
} from '@tanstack/hotkeys'
```

- `parseHotkey('Mod+S')` -- return ParsedHotkey object
- `normalizeHotkey('cmd+s')` -- return canonical form `'Meta+S'`
- `validateHotkey('Alt+A')` -- return `{ valid, warnings, errors }`
- `createHotkeyHandler('Mod+S', callback)` -- return event handler function
- `createMultiHotkeyHandler({ 'Mod+S': save, 'Mod+Z': undo })` -- return single event handler
- `createSequenceMatcher(['G', 'G'], { timeout: 500 })` -- return `{ match(), reset(), getProgress() }`

## Key Rules and Gotchas

- Library is in ALPHA -- API may change
- `Mod` is the recommended way to write cross-platform shortcuts
- Default `preventDefault: true` and `stopPropagation: true` -- override explicitly if needed
- When using `target` with a ref, ensure the element has `tabIndex` for focus
- macOS may swallow keyup events for non-modifier keys when a modifier is held -- library handles this
- Window blur auto-clears all held keys to prevent "stuck" keys
- `conflictBehavior: 'warn'` is default -- logs duplicates during development
- `event.key` is primary. `event.code` is fallback for letter/digit keys when `event.key` produces special characters (macOS Option+letter, Shift+number)
- Alt+letter on macOS may produce special characters. `validateHotkey` warns about this
- Shift+number and Shift+punctuation produce layout-dependent characters (Shift+1 → `!`) -- avoid these combos; use Mod+number instead
- SSR: `detectPlatform()` defaults to `'linux'` when navigator is undefined -- `Mod` resolves to `Control` during server rendering
- Canonical modifier order in normalized strings: `Control → Alt → Shift → Meta`

## Devtools Setup

```tsx
import { TanStackDevtools } from '@tanstack/react-devtools'
import { hotkeysDevtoolsPlugin } from '@tanstack/react-hotkeys-devtools'

function App() {
  return (
    <div>
      <TanStackDevtools plugins={[hotkeysDevtoolsPlugin()]} />
    </div>
  )
}
```

Devtools are no-op in production by default. Use `/production` import path for production debugging:

```tsx
import { hotkeysDevtoolsPlugin } from '@tanstack/react-hotkeys-devtools/production'
```

## Reference Files

- `references/api-reference.md` -- Full API surface with types and interfaces. Read when you need exact type signatures, constructor parameters, or constant values.
- `references/patterns.md` -- 25 usage patterns with complete code examples. Read when generating component code, building UIs with hotkeys, or choosing between implementation approaches.
- `references/troubleshooting.md` -- Platform quirks, common issues, and solutions. Read when debugging hotkey issues, when the user reports unexpected behavior, or when working with macOS/SSR edge cases.
