# TanStack Hotkeys API Reference

## React Hooks

### useHotkey

```ts
function useHotkey(
  hotkey: RegisterableHotkey,
  callback: HotkeyCallback,
  options?: UseHotkeyOptions
): void
```

Register a keyboard shortcut. Syncs callback on every render (no stale closures). Unregisters on unmount.

### useHotkeySequence

```ts
function useHotkeySequence(
  sequence: HotkeySequence,
  callback: HotkeyCallback,
  options?: UseHotkeySequenceOptions
): void
```

Register a multi-key sequence (Vim-style). Fires when all steps are pressed in order within timeout.

### useHotkeyRecorder

```ts
function useHotkeyRecorder(options: HotkeyRecorderOptions): ReactHotkeyRecorder
```

Record custom keyboard shortcuts. Returns state and control functions for building settings UIs.

### useHeldKeys

```ts
function useHeldKeys(): string[]
```

Return reactive array of currently held key names. Keys appear in press order.

### useHeldKeyCodes

```ts
function useHeldKeyCodes(): Record<string, string>
```

Return reactive map of held key names to their physical `event.code` values. Useful for distinguishing left vs right modifiers.

### useKeyHold

```ts
function useKeyHold(key: HeldKey): boolean
```

Return whether a specific key is held. Only re-renders when that key's state changes.

### useDefaultHotkeysOptions

```ts
function useDefaultHotkeysOptions(): HotkeysProviderOptions
```

Return the current default options from HotkeysProvider context.

### useHotkeysContext

```ts
function useHotkeysContext(): HotkeysContextValue | null
```

Return the full hotkeys context value, or null if outside a provider.

## React Components

### HotkeysProvider

```tsx
<HotkeysProvider defaultOptions={...}>
  {children}
</HotkeysProvider>
```

Props: `{ children: ReactNode, defaultOptions?: HotkeysProviderOptions }`

Set global default options for all hotkey hooks. Per-hook options override provider defaults.

## Core Classes

### HotkeyManager (singleton)

Central manager for hotkey registrations. Uses per-target event listeners.

```ts
const manager = getHotkeyManager()
// or: HotkeyManager.getInstance()
```

**Properties:**
- `registrations: Store<Map<string, HotkeyRegistration>>` -- observable store of all registrations

**Methods:**
- `register(hotkey: RegisterableHotkey, callback: HotkeyCallback, options?: HotkeyOptions): HotkeyRegistrationHandle`
- `isRegistered(hotkey: Hotkey, target?: Document | Window | HTMLElement): boolean`
- `getRegistrationCount(): number`
- `triggerRegistration(id: string): boolean` -- programmatic trigger for devtools
- `destroy(): void`

**Static:**
- `getInstance(): HotkeyManager`
- `resetInstance(): void` -- useful for testing

### SequenceManager (singleton)

Manage multi-key sequence registrations.

```ts
const seqManager = getSequenceManager()
// or: SequenceManager.getInstance()
```

**Methods:**
- `register(sequence: HotkeySequence, callback: HotkeyCallback, options?: SequenceOptions): () => void`
- `getRegistrationCount(): number`
- `resetAll(): void`
- `destroy(): void`

**Static:**
- `getInstance(): SequenceManager`
- `resetInstance(): void`

### KeyStateTracker (singleton)

Track currently held keyboard keys.

```ts
const tracker = getKeyStateTracker()
// or: KeyStateTracker.getInstance()
```

**Properties:**
- `store: Store<KeyStateTrackerState>` -- observable store

**Methods:**
- `getHeldKeys(): string[]`
- `isKeyHeld(key: string): boolean`
- `isAnyKeyHeld(keys: string[]): boolean`
- `areAllKeysHeld(keys: string[]): boolean`
- `destroy(): void`

**Static:**
- `getInstance(): KeyStateTracker`
- `resetInstance(): void`

### HotkeyRecorder

Framework-agnostic recorder class. Used internally by `useHotkeyRecorder`.

```ts
const recorder = new HotkeyRecorder(options: HotkeyRecorderOptions)
```

**Properties:**
- `store: Store<HotkeyRecorderState>` -- observable store

**Methods:**
- `start(): void`
- `stop(): void`
- `cancel(): void`
- `setOptions(options: Partial<HotkeyRecorderOptions>): void`
- `destroy(): void`

## Formatting Functions

```ts
formatForDisplay(hotkey: Hotkey | string, options?: FormatDisplayOptions): string
```
Platform-aware display with symbols on Mac, text on Windows/Linux.

```ts
formatWithLabels(hotkey: Hotkey | string, platform?: 'mac' | 'windows' | 'linux'): string
```
Text labels: "Cmd+S" on Mac, "Ctrl+S" on Windows/Linux.

```ts
formatKeyForDebuggingDisplay(key: string, options?: FormatKeyDebuggingOptions): string
```
Rich debug labels for individual key names. On Mac: "Meta" → "⌘ Mod (Cmd)", "Control" → "⌃ Ctrl", "Alt" → "⌥ Opt". On Windows: "Control" → "Mod (Ctrl)", "Meta" → "Win". Special keys use symbols: "ArrowUp" → "↑", "Space" → "␣". With `source: 'code'`, values pass through unchanged.

```ts
convertToModFormat(hotkey: string): string
```
Convert platform-specific hotkey to portable Mod format.

```ts
formatHotkey(parsed: ParsedHotkey): string
```
Convert a ParsedHotkey object back to a canonical hotkey string (e.g., `'Control+Shift+S'`).

## Parsing and Validation

```ts
parseHotkey(hotkey: string, platform?: 'mac' | 'windows' | 'linux'): ParsedHotkey
```
Parse a hotkey string into component parts.

```ts
normalizeHotkey(hotkey: string, platform?: 'mac' | 'windows' | 'linux'): string
```
Normalize to canonical form. `'Cmd+S'` becomes `'Meta+S'` on Mac.

```ts
validateHotkey(hotkey: string): ValidationResult
```
Validate a hotkey string and return warnings/errors.

```ts
assertValidHotkey(hotkey: string): void
```
Throw if the hotkey string is invalid.

```ts
checkHotkey(hotkey: Hotkey | string): boolean
```
Validate a hotkey and log warnings to the console. Returns true if valid (may still have warnings). Useful for development-time feedback.

## Matching

```ts
matchesKeyboardEvent(event: KeyboardEvent, parsedHotkey: ParsedHotkey, platform?: string): boolean
```
Check if a keyboard event matches a parsed hotkey.

```ts
createHotkeyHandler(hotkey: Hotkey | ParsedHotkey, callback: HotkeyCallback, options?: CreateHotkeyHandlerOptions): (event: KeyboardEvent) => void
```
Create an event handler for a single hotkey.

```ts
createMultiHotkeyHandler(handlers: MultiHotkeyHandler, options?: CreateHotkeyHandlerOptions): (event: KeyboardEvent) => void
```
Create a single event handler for multiple hotkeys.

```ts
createSequenceMatcher(sequence: HotkeySequence, options?: { timeout?: number; platform?: string }): { match(event: KeyboardEvent): boolean; reset(): void; getProgress(): number }
```
Create a standalone sequence matcher.

## Utility Functions

```ts
getHotkeyManager(): HotkeyManager
getKeyStateTracker(): KeyStateTracker
getSequenceManager(): SequenceManager
detectPlatform(): 'mac' | 'windows' | 'linux'  // defaults to 'linux' in SSR (no navigator)
isModifier(key: string): boolean
isModifierKey(key: string): boolean
hasNonModifierKey(hotkey: string): boolean
normalizeKeyName(key: string): string  // 'esc' → 'Escape', 'del' → 'Delete', 'a' → 'A', 'f1' → 'F1'
resolveModifier(modifier: string, platform?: string): CanonicalModifier  // 'Mod' → 'Meta' (Mac) / 'Control' (Win)
keyboardEventToHotkey(event: KeyboardEvent): Hotkey  // convenience: event → canonical hotkey string
parseKeyboardEvent(event: KeyboardEvent): ParsedHotkey
rawHotkeyToParsedHotkey(raw: RawHotkey, platform?: string): ParsedHotkey
```

## Key Interfaces

### HotkeyOptions

```ts
interface HotkeyOptions {
  enabled?: boolean              // default: true
  preventDefault?: boolean       // default: true
  stopPropagation?: boolean      // default: true
  eventType?: 'keydown' | 'keyup' // default: 'keydown'
  requireReset?: boolean         // default: false
  ignoreInputs?: boolean         // default: smart (undefined)
  target?: Document | Window | HTMLElement | null // default: document
  conflictBehavior?: ConflictBehavior // default: 'warn'
  platform?: 'mac' | 'windows' | 'linux' // default: auto
}
```

### UseHotkeyOptions

Extends HotkeyOptions. The `target` property also accepts `RefObject<HTMLElement | null>`.

### UseHotkeySequenceOptions

```ts
interface UseHotkeySequenceOptions {
  timeout?: number    // default: 1000 (ms between keys)
  enabled?: boolean   // default: true
}
```

### HotkeyRecorderOptions

```ts
interface HotkeyRecorderOptions {
  onRecord: (hotkey: Hotkey) => void
  onCancel?: () => void
  onClear?: () => void
}
```

### ReactHotkeyRecorder

```ts
interface ReactHotkeyRecorder {
  isRecording: boolean
  recordedHotkey: Hotkey | null
  startRecording: () => void
  stopRecording: () => void    // stops recording, resets state (does NOT call onCancel)
  cancelRecording: () => void  // stops recording, resets state, calls onCancel callback
}
```

### HotkeyCallbackContext

```ts
interface HotkeyCallbackContext {
  hotkey: Hotkey
  parsedHotkey: ParsedHotkey
}
```

### ParsedHotkey

```ts
interface ParsedHotkey {
  key: Key | string
  ctrl: boolean
  shift: boolean
  alt: boolean
  meta: boolean
  modifiers: CanonicalModifier[]
}
```

### RawHotkey

```ts
interface RawHotkey {
  key: Key | string
  mod?: boolean    // Platform-adaptive: Cmd on Mac, Ctrl on Windows/Linux
  ctrl?: boolean
  shift?: boolean
  alt?: boolean
  meta?: boolean
}
```

### HotkeyRegistration

```ts
interface HotkeyRegistration {
  id: string
  hotkey: Hotkey
  parsedHotkey: ParsedHotkey
  callback: HotkeyCallback
  options: HotkeyOptions
  target: Document | Window | HTMLElement
  hasFired: boolean
  triggerCount: number
}
```

### HotkeyRegistrationHandle

```ts
interface HotkeyRegistrationHandle {
  readonly id: string
  callback: HotkeyCallback         // mutable -- set directly to update
  readonly isActive: boolean
  setOptions(options: Partial<HotkeyOptions>): void
  unregister(): void
}
```

### ValidationResult

```ts
interface ValidationResult {
  valid: boolean
  warnings: string[]
  errors: string[]
}
```

### HotkeysProviderOptions

```ts
interface HotkeysProviderOptions {
  hotkey?: Partial<HotkeyOptions>
  hotkeySequence?: Partial<UseHotkeySequenceOptions>
  hotkeyRecorder?: Partial<HotkeyRecorderOptions>
}
```

### FormatDisplayOptions

```ts
interface FormatDisplayOptions {
  platform?: 'mac' | 'windows' | 'linux'
}
```

### FormatKeyDebuggingOptions

```ts
interface FormatKeyDebuggingOptions {
  platform?: 'mac' | 'windows' | 'linux'
  source?: 'key' | 'code'  // default: 'key'. With 'code', values pass through unchanged
}
```

### HotkeyRecorderState

```ts
interface HotkeyRecorderState {
  isRecording: boolean
  recordedHotkey: Hotkey | null
}
```

### KeyStateTrackerState

```ts
interface KeyStateTrackerState {
  heldKeys: string[]                    // normalized key names, e.g. ['Control', 'A']
  heldCodes: Record<string, string>     // key name → event.code, e.g. { Shift: 'ShiftLeft' }
}
```

### CreateHotkeyHandlerOptions

```ts
interface CreateHotkeyHandlerOptions {
  preventDefault?: boolean
  stopPropagation?: boolean
  platform?: 'mac' | 'windows' | 'linux'
}
```

### SequenceOptions

Extends HotkeyOptions with:

```ts
interface SequenceOptions extends HotkeyOptions {
  timeout?: number // default: 1000
}
```

## Key Types

```ts
type Hotkey = Key | SingleModifierHotkey | TwoModifierHotkey | ThreeModifierHotkey | FourModifierHotkey
type RegisterableHotkey = Hotkey | RawHotkey
type HotkeyCallback = (event: KeyboardEvent, context: HotkeyCallbackContext) => void
type HotkeySequence = Hotkey[]
type Key = LetterKey | NumberKey | FunctionKey | NavigationKey | EditingKey | PunctuationKey
type Modifier = 'Control' | 'Ctrl' | 'Shift' | 'Alt' | 'Option' | 'Command' | 'Cmd' | 'CommandOrControl' | 'Mod'
type CanonicalModifier = 'Control' | 'Alt' | 'Shift' | 'Meta'
type HeldKey = CanonicalModifier | Key
type ConflictBehavior = 'warn' | 'error' | 'replace' | 'allow'
type MultiHotkeyHandler = Record<Hotkey, HotkeyCallback>
```

## Constants

- `MODIFIER_ORDER: CanonicalModifier[]` -- canonical order: `Control → Alt → Shift → Meta`. Used when normalizing hotkey strings.
- `MODIFIER_KEYS: Set<string>` -- set of canonical modifier key names
- `MODIFIER_ALIASES: Record<string, CanonicalModifier | 'Mod'>` -- maps aliases to canonical names: `'Ctrl' → 'Control'`, `'Cmd' → 'Meta'`, `'Option' → 'Alt'`, `'Mod' → 'Mod'`. Case-insensitive lookups supported.
- `ALL_KEYS`, `LETTER_KEYS` (A-Z), `NUMBER_KEYS` (0-9), `FUNCTION_KEYS` (F1-F12), `NAVIGATION_KEYS` (arrows, Home/End, PageUp/Down), `EDITING_KEYS` (Enter, Escape, Space, Tab, Backspace, Delete), `PUNCTUATION_KEYS` (`/`, `[`, `]`, `\`, `=`, `-`, `,`, `.`, `` ` ``)
- `KEY_DISPLAY_SYMBOLS` -- maps keys to display symbols: `ArrowUp → '↑'`, `Enter → '↵'`, `Escape → 'Esc'`, `Space → '␣'`
- `MAC_MODIFIER_SYMBOLS` -- `Meta → '⌘'`, `Control → '⌃'`, `Alt → '⌥'`, `Shift → '⇧'`
- `STANDARD_MODIFIER_LABELS` -- `Control → 'Ctrl'`, `Meta → 'Win'`, `Alt → 'Alt'`, `Shift → 'Shift'`

## Platform Symbol Reference

| Modifier | Mac | Windows/Linux |
|---|---|---|
| Meta (Cmd) | ⌘ | Win / Super |
| Control | ⌃ | Ctrl |
| Alt/Option | ⌥ | Alt |
| Shift | ⇧ | Shift |

Special key display:

| Key | Display |
|---|---|
| Escape | Esc |
| Backspace | ⌫ (Mac) / Backspace |
| Delete | ⌦ (Mac) / Del |
| Enter | ↵ |
| Tab | ⇥ |
| ArrowUp | ↑ |
| ArrowDown | ↓ |
| ArrowLeft | ← |
| ArrowRight | → |
| Space | Space |
