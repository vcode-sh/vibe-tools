# shadcn/ui Menu & Navigation Components

Menus, navigation, breadcrumbs, tabs, sidebar, and pagination.

## Key Variant Differences

| Aspect | Base UI | Radix UI (Default) |
|--------|---------|-------------------|
| Style name | `base-nova` | `new-york` / `radix-nova` |
| Primitive library | `@base-ui/react` | `radix-ui` |
| Composition prop | `render={<Component />}` | `asChild` |
| Accordion API | `defaultValue` array, `multiple` prop | `type="single"\|"multiple"`, `collapsible` |

Most components share identical install commands, imports, and usage patterns. Variant-specific differences are noted per component where applicable.

---

## Breadcrumb

Displays the path to the current resource using a hierarchy of links.

```bash
npx shadcn@latest add breadcrumb
```

**Deps:** None (pure component)

```tsx
import {
  Breadcrumb, BreadcrumbItem, BreadcrumbLink,
  BreadcrumbList, BreadcrumbPage, BreadcrumbSeparator,
} from "@/components/ui/breadcrumb"
```

```tsx
<Breadcrumb>
  <BreadcrumbList>
    <BreadcrumbItem>
      <BreadcrumbLink href="/">Home</BreadcrumbLink>
    </BreadcrumbItem>
    <BreadcrumbSeparator />
    <BreadcrumbItem>
      <BreadcrumbPage>Current Page</BreadcrumbPage>
    </BreadcrumbItem>
  </BreadcrumbList>
</Breadcrumb>
```

- **Sub-components:** `Breadcrumb`, `BreadcrumbList`, `BreadcrumbItem`, `BreadcrumbLink`, `BreadcrumbPage`, `BreadcrumbSeparator`, `BreadcrumbEllipsis`
- **Base UI:** use `render` prop on `BreadcrumbLink` for custom link components / **Radix:** use `asChild`

---


## Context Menu

Displays a menu of actions triggered by a right click.

```bash
npx shadcn@latest add context-menu
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import {
  ContextMenu, ContextMenuContent,
  ContextMenuItem, ContextMenuTrigger,
} from "@/components/ui/context-menu"
```

```tsx
<ContextMenu>
  <ContextMenuTrigger>Right click here</ContextMenuTrigger>
  <ContextMenuContent>
    <ContextMenuItem>Profile</ContextMenuItem>
    <ContextMenuItem>Billing</ContextMenuItem>
  </ContextMenuContent>
</ContextMenu>
```

- **Key props:** `variant="destructive"` on items, `side`, `align` on content
- **Sub-components:** `ContextMenu`, `ContextMenuTrigger`, `ContextMenuContent`, `ContextMenuItem`, `ContextMenuCheckboxItem`, `ContextMenuRadioGroup`, `ContextMenuRadioItem`, `ContextMenuSub`, `ContextMenuSubTrigger`, `ContextMenuSubContent`, `ContextMenuSeparator`, `ContextMenuShortcut`, `ContextMenuLabel`

---


## Dropdown Menu

Displays a menu triggered by a button with actions and functions.

```bash
npx shadcn@latest add dropdown-menu
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuGroup,
  DropdownMenuItem, DropdownMenuLabel,
  DropdownMenuSeparator, DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
```

```tsx
<DropdownMenu>
  <DropdownMenuTrigger asChild>
    <Button variant="outline">Open</Button>
  </DropdownMenuTrigger>
  <DropdownMenuContent>
    <DropdownMenuLabel>My Account</DropdownMenuLabel>
    <DropdownMenuItem>Profile</DropdownMenuItem>
    <DropdownMenuSeparator />
    <DropdownMenuItem>Settings</DropdownMenuItem>
  </DropdownMenuContent>
</DropdownMenu>
```

- **Key props:** `variant="destructive"` on items
- **Sub-components:** `DropdownMenu`, `DropdownMenuTrigger`, `DropdownMenuContent`, `DropdownMenuGroup`, `DropdownMenuLabel`, `DropdownMenuItem`, `DropdownMenuSeparator`, `DropdownMenuShortcut`, `DropdownMenuSub`, `DropdownMenuSubTrigger`, `DropdownMenuSubContent`, `DropdownMenuCheckboxItem`, `DropdownMenuRadioGroup`, `DropdownMenuRadioItem`
- **Base UI:** use `render` on trigger / **Radix:** use `asChild` on trigger

---


## Menubar

A visually persistent menu common in desktop applications.

```bash
npx shadcn@latest add menubar
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import {
  Menubar, MenubarContent, MenubarGroup, MenubarItem,
  MenubarMenu, MenubarSeparator, MenubarShortcut, MenubarTrigger,
} from "@/components/ui/menubar"
```

```tsx
<Menubar>
  <MenubarMenu>
    <MenubarTrigger>File</MenubarTrigger>
    <MenubarContent>
      <MenubarItem>
        New Tab <MenubarShortcut>Cmd+T</MenubarShortcut>
      </MenubarItem>
      <MenubarSeparator />
      <MenubarItem>Print</MenubarItem>
    </MenubarContent>
  </MenubarMenu>
</Menubar>
```

- **Sub-components:** `Menubar`, `MenubarMenu`, `MenubarTrigger`, `MenubarContent`, `MenubarGroup`, `MenubarItem`, `MenubarSeparator`, `MenubarShortcut`, `MenubarCheckboxItem`, `MenubarRadioGroup`, `MenubarRadioItem`, `MenubarSub`, `MenubarSubTrigger`, `MenubarSubContent`, `MenubarLabel`

---


## Navigation Menu

A collection of links for navigating websites.

```bash
npx shadcn@latest add navigation-menu
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import {
  NavigationMenu, NavigationMenuContent, NavigationMenuItem,
  NavigationMenuLink, NavigationMenuList, NavigationMenuTrigger,
} from "@/components/ui/navigation-menu"
```

```tsx
<NavigationMenu>
  <NavigationMenuList>
    <NavigationMenuItem>
      <NavigationMenuTrigger>Item One</NavigationMenuTrigger>
      <NavigationMenuContent>
        <NavigationMenuLink>Link</NavigationMenuLink>
      </NavigationMenuContent>
    </NavigationMenuItem>
  </NavigationMenuList>
</NavigationMenu>
```

- **Sub-components:** `NavigationMenu`, `NavigationMenuList`, `NavigationMenuItem`, `NavigationMenuTrigger`, `NavigationMenuContent`, `NavigationMenuLink`
- `navigationMenuTriggerStyle()` available for styling links as triggers
- **Base UI:** use `render` on `NavigationMenuLink` for custom links / **Radix:** use `asChild`

---


## Pagination

Pagination with page navigation, next and previous links.

```bash
npx shadcn@latest add pagination
```

**Deps:** None (pure component)

```tsx
import {
  Pagination, PaginationContent, PaginationEllipsis,
  PaginationItem, PaginationLink, PaginationNext, PaginationPrevious,
} from "@/components/ui/pagination"
```

```tsx
<Pagination>
  <PaginationContent>
    <PaginationItem><PaginationPrevious href="#" /></PaginationItem>
    <PaginationItem><PaginationLink href="#" isActive>1</PaginationLink></PaginationItem>
    <PaginationItem><PaginationEllipsis /></PaginationItem>
    <PaginationItem><PaginationNext href="#" /></PaginationItem>
  </PaginationContent>
</Pagination>
```

- **Key props:** `isActive` on `PaginationLink`, `text` on `PaginationPrevious`/`PaginationNext`
- **Sub-components:** `Pagination`, `PaginationContent`, `PaginationItem`, `PaginationLink`, `PaginationPrevious`, `PaginationNext`, `PaginationEllipsis`
- For Next.js, replace `<a>` with Next.js `<Link>` in the component source

---


## Sidebar

A composable, themeable and customizable sidebar component.

```bash
npx shadcn@latest add sidebar
```

**Deps:** None (pure component)

```tsx
import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar"
import { AppSidebar } from "@/components/app-sidebar"
```

```tsx
<SidebarProvider>
  <AppSidebar />
  <main>
    <SidebarTrigger />
    {children}
  </main>
</SidebarProvider>
```

- **Structure:** `SidebarProvider` > `Sidebar` > `SidebarHeader` / `SidebarContent` / `SidebarFooter`
- **Key props:** `defaultOpen`, `open`, `onOpenChange` on `SidebarProvider`; `--sidebar-width` / `--sidebar-width-mobile` CSS variables
- **Sub-components:** `SidebarProvider`, `Sidebar`, `SidebarTrigger`, `SidebarHeader`, `SidebarContent`, `SidebarFooter`, `SidebarGroup`, `SidebarGroupLabel`, `SidebarGroupContent`, `SidebarMenu`, `SidebarMenuItem`, `SidebarMenuButton`, `SidebarMenuSub`, `SidebarMenuSubItem`, `SidebarMenuSubButton`, `SidebarSeparator`
- Collapsible to icons; composable with other components

---


## Tabs

A set of layered sections of content displayed one at a time.

```bash
npx shadcn@latest add tabs
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
```

```tsx
<Tabs defaultValue="account" className="w-[400px]">
  <TabsList>
    <TabsTrigger value="account">Account</TabsTrigger>
    <TabsTrigger value="password">Password</TabsTrigger>
  </TabsList>
  <TabsContent value="account">Make changes to your account here.</TabsContent>
  <TabsContent value="password">Change your password here.</TabsContent>
</Tabs>
```

- **Key props:** `defaultValue`, `variant` (`"default"` | `"line"`) on `TabsList`, `orientation` (`"horizontal"` | `"vertical"`)
- **Sub-components:** `Tabs`, `TabsList`, `TabsTrigger`, `TabsContent`

---
