# TanStack Hotkeys Troubleshooting

## 1. macOS Modifier Key Behavior

**Problem:** On macOS, when a modifier key is held and a non-modifier key is pressed, the OS sometimes swallows the `keyup` event for the non-modifier key. This can cause held key state to become inaccurate.

**Solution:** TanStack Hotkeys handles this automatically in `KeyStateTracker`. No action needed. The library detects missing keyup events and corrects the state.

## 2. Window Blur Clears Held Keys

**Problem:** When the browser window loses focus (e.g., Alt+Tab), keys that were held down appear "stuck" because keyup events are never received.

**Solution:** The `KeyStateTracker` automatically clears all held keys on window blur. This is handled internally -- no action needed.

## 3. Target Elements Must Be Focusable

**Problem:** Hotkeys attached to a specific element via `target` ref do not fire.

**Solution:** Ensure the target element has `tabIndex` so it can receive keyboard events:

```tsx
function Panel() {
  const panelRef = useRef<HTMLDivElement>(null)
  useHotkey('Escape', () => closePanel(), { target: panelRef })

  return (
    <div ref={panelRef} tabIndex={0}>  {/* tabIndex is required */}
      <p>Panel content</p>
    </div>
  )
}
```

## 4. Smart ignoreInputs Default

**Problem:** Single-key shortcuts fire inside text inputs, or Mod+key shortcuts do not fire inside text inputs.

**Explanation:** The default `ignoreInputs` behavior is context-aware:
- **Mod+key and Escape:** Fire in text inputs (ignoreInputs defaults to `false`)
- **Single keys and Shift/Alt combos:** Ignored in text inputs (ignoreInputs defaults to `true`)
- **Button-type inputs** (type="button", "submit", "reset"): NOT considered text inputs -- shortcuts always work on them

**Solution:** Override the smart default explicitly:

```tsx
// Force a single key to fire in text inputs
useHotkey('Enter', () => submit(), { ignoreInputs: false })

// Force a Mod+key to NOT fire in text inputs
useHotkey('Mod+S', () => save(), { ignoreInputs: true })
```

## 5. Hotkey Conflicts

**Problem:** Console warnings about duplicate hotkey registrations.

**Explanation:** Default `conflictBehavior: 'warn'` logs warnings when the same hotkey is registered more than once on the same target. This helps catch accidental duplicate bindings.

**Solutions:**
- `'allow'` -- intentional duplicates, suppress warnings
- `'replace'` -- override the existing registration
- `'error'` -- throw for strict conflict detection
- Fix the duplicate registration in your code

```tsx
useHotkey('Mod+S', () => save(), { conflictBehavior: 'allow' })
```

## 6. Stale Closures

**Problem:** Callback references outdated React state.

**Explanation:** Not an issue with `useHotkey` -- it syncs the callback on every render. The callback always accesses the latest state.

If using `HotkeyManager` directly, update the callback via the handle:

```ts
const handle = manager.register('Mod+S', callback)
// Later, when callback changes:
handle.callback = newCallback
```

## 7. event.key vs event.code

**Problem:** Hotkeys produce unexpected behavior with special characters or different keyboard layouts.

**Explanation:** The primary API uses `event.key`. However, `event.code` is used as a fallback for letter keys (A-Z) and digit keys (0-9) when `event.key` produces special characters. This happens with:
- macOS Option+letter producing accented characters
- Shift+number producing symbols on some layouts

No action needed -- the library handles this internally.

## 8. Mod+Control and Mod+Meta Not Allowed

**Problem:** Trying to register `Mod+Control+S` or `Mod+Meta+S` fails or behaves unexpectedly.

**Explanation:** These combinations would create duplicate modifiers on one platform:
- On Mac, `Mod` resolves to `Meta`, so `Mod+Meta` would be `Meta+Meta`
- On Windows, `Mod` resolves to `Control`, so `Mod+Control` would be `Control+Control`

**Solution:** Use specific modifier names instead of combining `Mod` with `Control` or `Meta`:

```tsx
// Instead of Mod+Control+S, use one of:
useHotkey('Control+Meta+S', () => save())  // specific modifiers
useHotkey('Mod+Shift+S', () => saveAs())   // different modifier combo
```

## 9. Alt+Letter on macOS

**Problem:** `Alt+A` does not fire on macOS, or fires with an unexpected character.

**Explanation:** On macOS, Alt (Option) + letter produces special characters instead of the letter. For example, Option+A produces "å". The `validateHotkey` function warns about this:

```ts
const result = validateHotkey('Alt+A')
// { valid: true, warnings: ['Alt+letter combinations may not work on macOS due to special characters'], errors: [] }
```

**Solution:** Avoid Alt+letter combinations for cross-platform shortcuts. Use `Mod+key` or `Mod+Shift+key` instead.

## 10. Library is in Alpha

**Problem:** API changes between versions.

**Explanation:** TanStack Hotkeys is currently in alpha. The API may change. Report edge cases to help improve the library, especially around different keyboard layouts, locales, and operating systems.

**Recommendation:** Pin the version in `package.json` and test thoroughly when upgrading.

## 11. Hotkeys Not Firing

**Checklist:**
1. Is `enabled` set to `true` (or omitted for default)?
2. Is the component mounted?
3. If using `target` ref, is the element focused and does it have `tabIndex`?
4. Is the user focused on a text input? (Check `ignoreInputs` behavior)
5. Is another registration with `conflictBehavior: 'replace'` overriding yours?
6. Is `preventDefault` or `stopPropagation` from another handler blocking the event?
7. Check the devtools to see registered hotkeys and their status.

## 12. Devtools Not Appearing

**Checklist:**
1. Ensure both packages are installed: `@tanstack/react-devtools` and `@tanstack/react-hotkeys-devtools`
2. The `TanStackDevtools` component must be rendered in the component tree
3. The plugin must be passed: `plugins={[hotkeysDevtoolsPlugin()]}`
4. In production, devtools are no-op by default. Use the `/production` import for production debugging:

```tsx
import { hotkeysDevtoolsPlugin } from '@tanstack/react-hotkeys-devtools/production'
```

## 13. Overlapping Sequences

**Problem:** Multiple sequences share the same prefix and only one fires.

**Explanation:** The `SequenceManager` tracks progress for each sequence independently. Sequences with shared prefixes work correctly:

```tsx
useHotkeySequence(['D', 'D'], () => deleteLine())     // dd
useHotkeySequence(['D', 'W'], () => deleteWord())      // dw
useHotkeySequence(['D', 'I', 'W'], () => deleteInnerWord()) // diw
```

After pressing `D`, the manager waits for the next key to determine which sequence to complete. If the timeout expires, all sequences reset.

## 14. Shift+Number and Shift+Punctuation

**Problem:** `Shift+1` or `Shift+,` doesn't match as expected, or matches the wrong key.

**Explanation:** Number keys and punctuation keys produce different characters when combined with Shift (e.g., Shift+1 → `!` on US layout, Shift+`,` → `<`). This is layout-dependent, so the library excludes number and punctuation keys from Shift-based hotkey combinations to avoid unreliable behavior.

**Solution:** For Shift+number shortcuts, use the resulting symbol directly or combine with other modifiers:

```tsx
// Instead of Shift+1 (which produces '!' on US layout):
useHotkey('Mod+1', () => switchTab(1))  // use Mod instead of Shift

// Or use Mod+Shift with letter keys (reliable across layouts):
useHotkey('Mod+Shift+S', () => saveAs())
```

## 15. SSR / Server-Side Rendering

**Problem:** Platform detection returns unexpected results in SSR (Next.js, Remix).

**Explanation:** `detectPlatform()` defaults to `'linux'` when `navigator` is undefined (SSR environments). This means `Mod` resolves to `Control` during server rendering.

**Solution:** Pass an explicit `platform` option if you need Mac-specific behavior during SSR, or accept that SSR will use the `'linux'` default (which is typically fine since hydration on the client will re-evaluate).

## 16. Sequence Timeout

**Problem:** Multi-key sequence does not fire because the user types too slowly.

**Solution:** Increase the timeout (default is 1000ms):

```tsx
useHotkeySequence(['G', 'G'], () => scrollToTop(), { timeout: 2000 })
```

Or set a global default via the provider:

```tsx
<HotkeysProvider defaultOptions={{ hotkeySequence: { timeout: 2000 } }}>
  <App />
</HotkeysProvider>
```
