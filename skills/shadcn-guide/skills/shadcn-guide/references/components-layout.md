# shadcn/ui Layout & Feedback Components

Accordion, collapsible, scroll area, progress, skeleton, toast, and utilities.

## Key Variant Differences

| Aspect | Base UI | Radix UI (Default) |
|--------|---------|-------------------|
| Style name | `base-nova` | `new-york` / `radix-nova` |
| Primitive library | `@base-ui/react` | `radix-ui` |
| Composition prop | `render={<Component />}` | `asChild` |
| Accordion API | `defaultValue` array, `multiple` prop | `type="single"\|"multiple"`, `collapsible` |

Most components share identical install commands, imports, and usage patterns. Variant-specific differences are noted per component where applicable.

---

## Accordion

A vertically stacked set of interactive headings that each reveal a section of content.

```bash
npx shadcn@latest add accordion
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion"
```

```tsx
<Accordion type="single" collapsible defaultValue="item-1">
  <AccordionItem value="item-1">
    <AccordionTrigger>Is it accessible?</AccordionTrigger>
    <AccordionContent>
      Yes. It adheres to the WAI-ARIA design pattern.
    </AccordionContent>
  </AccordionItem>
</Accordion>
```

- **Key props:** `defaultValue`, `disabled`
- **Sub-components:** `Accordion`, `AccordionItem`, `AccordionTrigger`, `AccordionContent`
- **Radix:** `type="single"|"multiple"`, `collapsible` prop
- **Base UI:** `defaultValue` is an array, `multiple` boolean prop instead of `type`

---


## Aspect Ratio

Displays content within a desired ratio.

```bash
npx shadcn@latest add aspect-ratio
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { AspectRatio } from "@/components/ui/aspect-ratio"
```

```tsx
<AspectRatio ratio={16 / 9}>
  <Image src="..." alt="Image" className="rounded-md object-cover" />
</AspectRatio>
```

- **Key props:** `ratio` (number, required)
- **Common ratios:** `16/9`, `1/1` (square), `9/16` (portrait)

---


## Collapsible

An interactive component which expands/collapses a panel.

```bash
npx shadcn@latest add collapsible
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible"
```

```tsx
<Collapsible>
  <CollapsibleTrigger>Can I use this in my project?</CollapsibleTrigger>
  <CollapsibleContent>
    Yes. Free to use for personal and commercial projects.
  </CollapsibleContent>
</Collapsible>
```

- **Key props:** `open`, `onOpenChange` for controlled state
- **Sub-components:** `Collapsible`, `CollapsibleTrigger`, `CollapsibleContent`

---


## Direction

A provider component that sets the text direction for your application.

```bash
npx shadcn@latest add direction
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { DirectionProvider } from "@/components/ui/direction"
```

```tsx
<DirectionProvider direction="rtl">
  {/* Your app content */}
</DirectionProvider>
```

- **Key exports:** `DirectionProvider`, `useDirection` hook
- Essential for RTL language support (Arabic, Hebrew, Persian)

---


## Kbd

Used to display textual user input from keyboard.

```bash
npx shadcn@latest add kbd
```

**Deps:** None (pure component)

```tsx
import { Kbd } from "@/components/ui/kbd"
```

```tsx
<Kbd>Ctrl</Kbd>
```

- **Sub-components:** `Kbd`, `KbdGroup`
- Can be used inside `Button`, `Tooltip`, `InputGroupAddon`

---


## Progress

Displays an indicator showing the completion progress of a task.

```bash
npx shadcn@latest add progress
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { Progress } from "@/components/ui/progress"
```

```tsx
<Progress value={33} />
```

- **Key props:** `value` (number 0-100)
- **Sub-components:** `Progress`, `ProgressLabel`, `ProgressValue`

---


## Resizable

Accessible resizable panel groups and layouts with keyboard support.

```bash
npx shadcn@latest add resizable
```

**Deps:** `react-resizable-panels`

```tsx
import { ResizableHandle, ResizablePanel, ResizablePanelGroup } from "@/components/ui/resizable"
```

```tsx
<ResizablePanelGroup orientation="horizontal">
  <ResizablePanel>One</ResizablePanel>
  <ResizableHandle />
  <ResizablePanel>Two</ResizablePanel>
</ResizablePanelGroup>
```

- **Key props:** `orientation` (`"horizontal"` | `"vertical"`), `withHandle` on `ResizableHandle`
- **Sub-components:** `ResizablePanelGroup`, `ResizablePanel`, `ResizableHandle`
- Built on [react-resizable-panels](https://github.com/bvaughn/react-resizable-panels)

---


## Scroll Area

Augments native scroll functionality for custom, cross-browser styling.

```bash
npx shadcn@latest add scroll-area
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { ScrollArea } from "@/components/ui/scroll-area"
```

```tsx
<ScrollArea className="h-[200px] w-[350px] rounded-md border p-4">
  Your scrollable content here.
</ScrollArea>
```

- **Key exports:** `ScrollArea`, `ScrollBar`
- Use `ScrollBar` with `orientation="horizontal"` for horizontal scrolling

---


## Separator

Visually or semantically separates content.

```bash
npx shadcn@latest add separator
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { Separator } from "@/components/ui/separator"
```

```tsx
<Separator />
```

- **Key props:** `orientation` (`"horizontal"` | `"vertical"`)

---


## Skeleton

Use to show a placeholder while content is loading.

```bash
npx shadcn@latest add skeleton
```

**Deps:** None (pure component)

```tsx
import { Skeleton } from "@/components/ui/skeleton"
```

```tsx
<Skeleton className="h-[20px] w-[100px] rounded-full" />
```

- Style with standard Tailwind classes: `h-*`, `w-*`, `rounded-*`
- Use for avatar, card, text, form, and table loading placeholders

---


## Sonner

An opinionated toast component for React.

```bash
npx shadcn@latest add sonner
```

**Deps:** `sonner`, `next-themes`

```tsx
import { toast } from "sonner"
```

```tsx
toast("Event has been created.")
```

- **Setup:** Add `<Toaster />` component from `@/components/ui/sonner` to root layout
- **Toast types:** `toast()`, `toast.success()`, `toast.error()`, `toast.warning()`, `toast.info()`
- **Key props on Toaster:** `position`
- This is the recommended toast solution (replaces deprecated Toast component)

---


## Spinner

An indicator that can be used to show a loading state.

```bash
npx shadcn@latest add spinner
```

**Deps:** None (pure component)

```tsx
import { Spinner } from "@/components/ui/spinner"
```

```tsx
<Spinner />
```

- Use `size-*` utility class to change size
- Use `data-icon="inline-start"` / `data-icon="inline-end"` when inside Button or Badge
- Default icon is customizable by editing the component source

---


## Toast

**DEPRECATED** -- Use the [Sonner](#sonner) component instead.

```bash
# Do NOT install. Use `npx shadcn@latest add sonner` instead.
```

The Toast component has been deprecated. Use the Sonner component for all toast/notification needs.

---
