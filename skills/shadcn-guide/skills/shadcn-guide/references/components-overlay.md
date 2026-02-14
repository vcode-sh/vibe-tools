# shadcn/ui Overlay & Popup Components

Dialog, drawer, popover, tooltip, and other overlay components.

## Key Variant Differences

| Aspect | Base UI | Radix UI (Default) |
|--------|---------|-------------------|
| Style name | `base-nova` | `new-york` / `radix-nova` |
| Primitive library | `@base-ui/react` | `radix-ui` |
| Composition prop | `render={<Component />}` | `asChild` |
| Accordion API | `defaultValue` array, `multiple` prop | `type="single"\|"multiple"`, `collapsible` |

Most components share identical install commands, imports, and usage patterns. Variant-specific differences are noted per component where applicable.

---

## Alert Dialog

A modal dialog that interrupts the user with important content and expects a response.

```bash
npx shadcn@latest add alert-dialog
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel,
  AlertDialogContent, AlertDialogDescription, AlertDialogFooter,
  AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger,
} from "@/components/ui/alert-dialog"
```

```tsx
<AlertDialog>
  <AlertDialogTrigger asChild>
    <Button variant="outline">Show Dialog</Button>
  </AlertDialogTrigger>
  <AlertDialogContent>
    <AlertDialogHeader>
      <AlertDialogTitle>Are you absolutely sure?</AlertDialogTitle>
      <AlertDialogDescription>This action cannot be undone.</AlertDialogDescription>
    </AlertDialogHeader>
    <AlertDialogFooter>
      <AlertDialogCancel>Cancel</AlertDialogCancel>
      <AlertDialogAction>Continue</AlertDialogAction>
    </AlertDialogFooter>
  </AlertDialogContent>
</AlertDialog>
```

- **Key props:** `size` (`"default"` | `"sm"`) on `AlertDialogContent`
- **Sub-components:** `AlertDialog`, `AlertDialogTrigger`, `AlertDialogContent`, `AlertDialogHeader`, `AlertDialogFooter`, `AlertDialogTitle`, `AlertDialogDescription`, `AlertDialogAction`, `AlertDialogCancel`, `AlertDialogMedia`
- **Base UI:** use `render` prop on trigger / **Radix:** use `asChild` on trigger

---


## Command

Command menu for search and quick actions.

```bash
npx shadcn@latest add command
```

**Deps:** `cmdk`

```tsx
import {
  Command, CommandDialog, CommandEmpty, CommandGroup,
  CommandInput, CommandItem, CommandList,
  CommandSeparator, CommandShortcut,
} from "@/components/ui/command"
```

```tsx
<Command className="max-w-sm rounded-lg border">
  <CommandInput placeholder="Type a command or search..." />
  <CommandList>
    <CommandEmpty>No results found.</CommandEmpty>
    <CommandGroup heading="Suggestions">
      <CommandItem>Calendar</CommandItem>
    </CommandGroup>
  </CommandList>
</Command>
```

- **Sub-components:** `Command`, `CommandDialog`, `CommandInput`, `CommandList`, `CommandEmpty`, `CommandGroup`, `CommandItem`, `CommandSeparator`, `CommandShortcut`
- Built on [cmdk](https://github.com/dip/cmdk)

---


## Dialog

A window overlaid on the primary window, rendering content underneath inert.

```bash
npx shadcn@latest add dialog
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import {
  Dialog, DialogContent, DialogDescription,
  DialogHeader, DialogTitle, DialogTrigger,
} from "@/components/ui/dialog"
```

```tsx
<Dialog>
  <DialogTrigger>Open</DialogTrigger>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Are you absolutely sure?</DialogTitle>
      <DialogDescription>This action cannot be undone.</DialogDescription>
    </DialogHeader>
  </DialogContent>
</Dialog>
```

- **Key props:** `showCloseButton` (boolean) on `DialogContent`
- **Sub-components:** `Dialog`, `DialogTrigger`, `DialogContent`, `DialogHeader`, `DialogTitle`, `DialogDescription`, `DialogFooter`, `DialogClose`

---


## Drawer

A drawer component for React.

```bash
npx shadcn@latest add drawer
```

**Deps:** `vaul`

```tsx
import {
  Drawer, DrawerClose, DrawerContent, DrawerDescription,
  DrawerFooter, DrawerHeader, DrawerTitle, DrawerTrigger,
} from "@/components/ui/drawer"
```

```tsx
<Drawer>
  <DrawerTrigger>Open</DrawerTrigger>
  <DrawerContent>
    <DrawerHeader>
      <DrawerTitle>Are you absolutely sure?</DrawerTitle>
      <DrawerDescription>This action cannot be undone.</DrawerDescription>
    </DrawerHeader>
    <DrawerFooter>
      <Button>Submit</Button>
      <DrawerClose><Button variant="outline">Cancel</Button></DrawerClose>
    </DrawerFooter>
  </DrawerContent>
</Drawer>
```

- **Key props:** `direction` (`"top"` | `"right"` | `"bottom"` | `"left"`)
- **Sub-components:** `Drawer`, `DrawerTrigger`, `DrawerContent`, `DrawerHeader`, `DrawerTitle`, `DrawerDescription`, `DrawerFooter`, `DrawerClose`
- Built on [Vaul](https://github.com/emilkowalski/vaul); can combine with `Dialog` for responsive (Dialog on desktop, Drawer on mobile)

---


## Hover Card

For sighted users to preview content available behind a link.

```bash
npx shadcn@latest add hover-card
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { HoverCard, HoverCardContent, HoverCardTrigger } from "@/components/ui/hover-card"
```

```tsx
<HoverCard>
  <HoverCardTrigger>Hover</HoverCardTrigger>
  <HoverCardContent>
    The React Framework -- created and maintained by @vercel.
  </HoverCardContent>
</HoverCard>
```

- **Key props:** `openDelay`, `closeDelay` on trigger/card; `side`, `align` on content
- **Sub-components:** `HoverCard`, `HoverCardTrigger`, `HoverCardContent`

---


## Popover

Displays rich content in a portal, triggered by a button.

```bash
npx shadcn@latest add popover
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import {
  Popover, PopoverContent, PopoverDescription,
  PopoverHeader, PopoverTitle, PopoverTrigger,
} from "@/components/ui/popover"
```

```tsx
<Popover>
  <PopoverTrigger asChild>
    <Button variant="outline">Open Popover</Button>
  </PopoverTrigger>
  <PopoverContent>
    <PopoverHeader>
      <PopoverTitle>Title</PopoverTitle>
      <PopoverDescription>Description text here.</PopoverDescription>
    </PopoverHeader>
  </PopoverContent>
</Popover>
```

- **Key props:** `align`, `side` on `PopoverContent`
- **Sub-components:** `Popover`, `PopoverTrigger`, `PopoverContent`, `PopoverHeader`, `PopoverTitle`, `PopoverDescription`
- **Base UI:** use `render` on trigger / **Radix:** use `asChild` on trigger

---


## Sheet

Extends the Dialog component to display content from the edge of the screen.

```bash
npx shadcn@latest add sheet
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import {
  Sheet, SheetClose, SheetContent, SheetDescription,
  SheetFooter, SheetHeader, SheetTitle, SheetTrigger,
} from "@/components/ui/sheet"
```

```tsx
<Sheet>
  <SheetTrigger>Open</SheetTrigger>
  <SheetContent>
    <SheetHeader>
      <SheetTitle>Are you absolutely sure?</SheetTitle>
      <SheetDescription>This action cannot be undone.</SheetDescription>
    </SheetHeader>
  </SheetContent>
</Sheet>
```

- **Key props:** `side` (`"top"` | `"right"` | `"bottom"` | `"left"`) on `SheetContent`, `showCloseButton` (boolean)
- **Sub-components:** `Sheet`, `SheetTrigger`, `SheetContent`, `SheetHeader`, `SheetTitle`, `SheetDescription`, `SheetFooter`, `SheetClose`

---


## Tooltip

A popup that displays information related to an element on hover or keyboard focus.

```bash
npx shadcn@latest add tooltip
```

**Deps:** `@base-ui/react` or `radix-ui`

**Setup:** Add `<TooltipProvider>` to the root of your app.

```tsx
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip"
```

```tsx
<Tooltip>
  <TooltipTrigger>Hover</TooltipTrigger>
  <TooltipContent>
    <p>Add to library</p>
  </TooltipContent>
</Tooltip>
```

- **Key props:** `side` (`"top"` | `"right"` | `"bottom"` | `"left"`) on `TooltipContent`
- **Sub-components:** `TooltipProvider`, `Tooltip`, `TooltipTrigger`, `TooltipContent`
- For disabled button tooltips, wrap the button with a `<span>`

---
