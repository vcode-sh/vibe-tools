# TanStack Hotkeys Usage Patterns

## 1. Multiple Hotkeys in a Component

```tsx
import { useHotkey } from '@tanstack/react-hotkeys'

function Editor() {
  useHotkey('Mod+S', () => save())
  useHotkey('Mod+Z', () => undo())
  useHotkey('Mod+Shift+Z', () => redo())
  useHotkey('Mod+F', () => openSearch())
  useHotkey('Escape', () => closeDialog())

  return <div>Editor with keyboard shortcuts</div>
}
```

## 2. Scoped Hotkeys with Refs

Attach hotkeys to specific elements. Ensure the element has `tabIndex` for focus.

```tsx
import { useRef } from 'react'
import { useHotkey } from '@tanstack/react-hotkeys'

function Panel() {
  const panelRef = useRef<HTMLDivElement>(null)

  useHotkey('Escape', () => closePanel(), { target: panelRef })

  return (
    <div ref={panelRef} tabIndex={0}>
      <p>Press Escape while focused here to close</p>
    </div>
  )
}
```

## 3. Conditional Hotkeys

```tsx
function Modal({ isOpen, onClose }: { isOpen: boolean; onClose: () => void }) {
  useHotkey('Escape', () => onClose(), { enabled: isOpen })

  if (!isOpen) return null

  return (
    <div className="modal">
      <p>Press Escape to close</p>
    </div>
  )
}
```

## 4. RawHotkey Object Form

```tsx
useHotkey({ key: 'S', mod: true }, () => save())
useHotkey({ key: 'Escape' }, () => closeModal())
useHotkey({ key: 'S', ctrl: true, shift: true }, () => saveAs())
useHotkey({ key: 'S', mod: true, shift: true }, () => saveAs())
```

## 5. Vim-Style Sequences

```tsx
import { useHotkeySequence } from '@tanstack/react-hotkeys'

function VimNavigation() {
  useHotkeySequence(['G', 'G'], () => scrollToTop())
  useHotkeySequence(['G', 'Shift+G'], () => scrollToBottom())
  useHotkeySequence(['D', 'D'], () => deleteLine())
  useHotkeySequence(['D', 'W'], () => deleteWord())
  useHotkeySequence(['C', 'I', 'W'], () => changeInnerWord())
}
```

## 6. VS Code-Style Chord Sequences

```tsx
useHotkeySequence(['Mod+K', 'Mod+C'], () => commentSelection())
```

## 7. Konami Code

```tsx
useHotkeySequence(
  [
    'ArrowUp', 'ArrowUp',
    'ArrowDown', 'ArrowDown',
    'ArrowLeft', 'ArrowRight',
    'ArrowLeft', 'ArrowRight',
    'B', 'A',
  ],
  () => enableEasterEgg(),
  { timeout: 2000 },
)
```

## 8. Shortcut Customization UI (Recording)

Full example with state management, recording, and display formatting.

```tsx
import { useState } from 'react'
import {
  useHotkey,
  useHotkeyRecorder,
  formatForDisplay,
} from '@tanstack/react-hotkeys'
import type { Hotkey } from '@tanstack/react-hotkeys'

function ShortcutSettings() {
  const [shortcuts, setShortcuts] = useState<Record<string, Hotkey>>({
    save: 'Mod+S',
    undo: 'Mod+Z',
    search: 'Mod+K',
  })

  const [editingAction, setEditingAction] = useState<string | null>(null)

  const recorder = useHotkeyRecorder({
    onRecord: (hotkey) => {
      if (editingAction) {
        setShortcuts((prev) => ({ ...prev, [editingAction]: hotkey }))
        setEditingAction(null)
      }
    },
    onCancel: () => setEditingAction(null),
  })

  // Register the actual hotkeys with their current bindings
  useHotkey(shortcuts.save, () => save())
  useHotkey(shortcuts.undo, () => undo())
  useHotkey(shortcuts.search, () => openSearch())

  return (
    <div>
      <h2>Keyboard Shortcuts</h2>
      {Object.entries(shortcuts).map(([action, hotkey]) => (
        <div key={action}>
          <span>{action}</span>
          <button
            onClick={() => {
              setEditingAction(action)
              recorder.startRecording()
            }}
          >
            {editingAction === action && recorder.isRecording
              ? 'Press keys...'
              : formatForDisplay(hotkey)}
          </button>
        </div>
      ))}
    </div>
  )
}
```

## 9. Hold-to-Reveal UI

```tsx
import { useKeyHold } from '@tanstack/react-hotkeys'

function FileItem({ file }: { file: File }) {
  const isShiftHeld = useKeyHold('Shift')

  return (
    <div className="file-item">
      <span>{file.name}</span>
      {isShiftHeld && (
        <button className="danger" onClick={() => permanentlyDelete(file)}>
          Permanently Delete
        </button>
      )}
      {!isShiftHeld && (
        <button onClick={() => moveToTrash(file)}>
          Move to Trash
        </button>
      )}
    </div>
  )
}
```

## 10. Keyboard Shortcut Hints Overlay

```tsx
import { useKeyHold } from '@tanstack/react-hotkeys'

function ShortcutHints() {
  const isModHeld = useKeyHold('Meta') // or 'Control' on Windows

  if (!isModHeld) return null

  return (
    <div className="shortcut-overlay">
      <div>S - Save</div>
      <div>Z - Undo</div>
      <div>Shift+Z - Redo</div>
      <div>K - Command Palette</div>
    </div>
  )
}
```

## 11. Menu Items with Hotkey Badges

```tsx
import { useHotkey, formatForDisplay } from '@tanstack/react-hotkeys'

function MenuItem({
  label,
  hotkey,
  onAction,
}: {
  label: string
  hotkey: string
  onAction: () => void
}) {
  useHotkey(hotkey, () => onAction())

  return (
    <div className="menu-item">
      <span>{label}</span>
      <span className="menu-shortcut">{formatForDisplay(hotkey)}</span>
    </div>
  )
}

// Usage
<MenuItem label="Save" hotkey="Mod+S" onAction={save} />
<MenuItem label="Undo" hotkey="Mod+Z" onAction={undo} />
<MenuItem label="Find" hotkey="Mod+F" onAction={openFind} />
```

## 12. Command Palette

```tsx
import { formatForDisplay } from '@tanstack/react-hotkeys'
import type { Hotkey } from '@tanstack/react-hotkeys'

interface Command {
  id: string
  label: string
  hotkey?: Hotkey
  action: () => void
}

function CommandPaletteItem({ command }: { command: Command }) {
  return (
    <div className="command-item" onClick={command.action}>
      <span>{command.label}</span>
      {command.hotkey && (
        <kbd>{formatForDisplay(command.hotkey)}</kbd>
      )}
    </div>
  )
}
```

## 13. Key State Debugging

```tsx
import {
  useHeldKeys,
  useHeldKeyCodes,
  formatKeyForDebuggingDisplay,
} from '@tanstack/react-hotkeys'

function KeyDebugger() {
  const heldKeys = useHeldKeys()
  const heldCodes = useHeldKeyCodes()

  return (
    <div className="key-debugger">
      <h3>Active Keys</h3>
      {heldKeys.map((key) => (
        <div key={key}>
          <strong>{formatKeyForDebuggingDisplay(key)}</strong>
          <span className="code">{heldCodes[key]}</span>
        </div>
      ))}
      {heldKeys.length === 0 && <p>Press any key...</p>}
    </div>
  )
}
```

## 14. Vanilla JS Usage (Without React)

```ts
import {
  createHotkeyHandler,
  createMultiHotkeyHandler,
  createSequenceMatcher,
} from '@tanstack/hotkeys'

// Single handler
const handler = createHotkeyHandler('Mod+S', (event, { hotkey }) => {
  handleSave()
})
document.addEventListener('keydown', handler)

// Multi-handler
const multiHandler = createMultiHotkeyHandler({
  'Mod+S': (event) => handleSave(),
  'Mod+Z': (event) => handleUndo(),
  'Mod+Shift+Z': (event) => handleRedo(),
})
document.addEventListener('keydown', multiHandler)

// Sequence matcher
const matcher = createSequenceMatcher(['G', 'G'], { timeout: 1000 })
document.addEventListener('keydown', (e) => {
  if (matcher.match(e)) {
    scrollToTop()
  }
})
```

## 15. HotkeyManager Direct Access

```ts
import { getHotkeyManager } from '@tanstack/react-hotkeys'

const manager = getHotkeyManager()

// Register
const handle = manager.register('Mod+S', callback)

// Update without re-registering
handle.callback = newCallback
handle.setOptions({ enabled: false })

// Check state
console.log(handle.isActive)
console.log(manager.isRegistered('Mod+S'))
console.log(manager.getRegistrationCount())

// Subscribe to registration changes
const unsubscribe = manager.registrations.subscribe(() => {
  console.log('Registrations changed:', manager.registrations.state.size)
})

// Unregister
handle.unregister()
```

## 16. Devtools Setup

```tsx
import { TanStackDevtools } from '@tanstack/react-devtools'
import { hotkeysDevtoolsPlugin } from '@tanstack/react-hotkeys-devtools'

function App() {
  return (
    <div>
      {/* Your app content */}
      <TanStackDevtools plugins={[hotkeysDevtoolsPlugin()]} />
    </div>
  )
}
```

For production debugging:

```tsx
import { hotkeysDevtoolsPlugin } from '@tanstack/react-hotkeys-devtools/production'
```

## 17. KeyUp Event Handling

```tsx
useHotkey('Shift', () => deactivateMode(), { eventType: 'keyup' })
```

## 18. Require Reset (Fire Once Per Press)

```tsx
// Only fires once per Escape press, not on key repeat
useHotkey('Escape', () => closePanel(), { requireReset: true })
```

## 19. Parsing and Validation

```ts
import { parseHotkey, normalizeHotkey, validateHotkey } from '@tanstack/react-hotkeys'

const parsed = parseHotkey('Mod+Shift+S')
// Mac: { key: 'S', ctrl: false, shift: true, alt: false, meta: true, modifiers: ['Shift', 'Meta'] }
// Windows: { key: 'S', ctrl: true, shift: true, alt: false, meta: false, modifiers: ['Control', 'Shift'] }

const result = validateHotkey('Alt+A')
// { valid: true, warnings: ['Alt+letter combinations may not work on macOS due to special characters'], errors: [] }

normalizeHotkey('Cmd+S')          // 'Meta+S' (on Mac)
normalizeHotkey('ctrl+shift+s')   // 'Control+Shift+S'
normalizeHotkey('Mod+S')          // 'Meta+S' (Mac) or 'Control+S' (Windows)
```

## 20. Shortcut Badge Component

```tsx
import { formatForDisplay } from '@tanstack/react-hotkeys'

function ShortcutBadge({ hotkey }: { hotkey: string }) {
  return <kbd className="shortcut-badge">{formatForDisplay(hotkey)}</kbd>
}

// Usage
<ShortcutBadge hotkey="Mod+S" />       // Mac: ⌘S    Windows: Ctrl+S
<ShortcutBadge hotkey="Mod+Shift+P" /> // Mac: ⇧⌘P   Windows: Ctrl+Shift+P
```

## 21. Global Default Options Provider

```tsx
import { HotkeysProvider } from '@tanstack/react-hotkeys'

function Root() {
  return (
    <HotkeysProvider
      defaultOptions={{
        hotkey: { preventDefault: true, ignoreInputs: false },
        hotkeySequence: { timeout: 1500 },
        hotkeyRecorder: { onCancel: () => console.log('Recording cancelled') },
      }}
    >
      <App />
    </HotkeysProvider>
  )
}
```

## 22. Multi-Step Commands

```tsx
// Press "h", "e", "l", "p" to open help
useHotkeySequence(['H', 'E', 'L', 'P'], () => openHelp())
```

## 23. Modifier Indicators

```tsx
import { useKeyHold } from '@tanstack/react-hotkeys'

function ModifierIndicators() {
  const isShiftHeld = useKeyHold('Shift')
  const isCtrlHeld = useKeyHold('Control')
  const isAltHeld = useKeyHold('Alt')
  const isMetaHeld = useKeyHold('Meta')

  return (
    <div className="modifier-bar">
      <span className={isShiftHeld ? 'active' : ''}>Shift</span>
      <span className={isCtrlHeld ? 'active' : ''}>Ctrl</span>
      <span className={isAltHeld ? 'active' : ''}>Alt</span>
      <span className={isMetaHeld ? 'active' : ''}>Meta</span>
    </div>
  )
}
```

## 24. Stale Closure Prevention

The `useHotkey` callback always has access to the latest state -- no need for deps arrays.

```tsx
function Counter() {
  const [count, setCount] = useState(0)

  // This callback always has access to the latest count value
  useHotkey('Mod+Shift+C', () => {
    console.log('Current count:', count)
  })

  return <button onClick={() => setCount(count + 1)}>Count: {count}</button>
}
```

## 25. Conflict Behavior Options

```tsx
// Default: warn about duplicates
useHotkey('Mod+S', () => save(), { conflictBehavior: 'warn' })

// Allow intentional duplicates silently
useHotkey('Mod+S', () => save(), { conflictBehavior: 'allow' })

// Replace existing registration
useHotkey('Mod+S', () => save(), { conflictBehavior: 'replace' })

// Throw error on conflict
useHotkey('Mod+S', () => save(), { conflictBehavior: 'error' })
```
