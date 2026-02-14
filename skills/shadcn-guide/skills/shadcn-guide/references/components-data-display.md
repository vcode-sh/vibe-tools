# shadcn/ui Data Display Components

Cards, tables, charts, carousels, badges, avatars, and typography.

## Key Variant Differences

| Aspect | Base UI | Radix UI (Default) |
|--------|---------|-------------------|
| Style name | `base-nova` | `new-york` / `radix-nova` |
| Primitive library | `@base-ui/react` | `radix-ui` |
| Composition prop | `render={<Component />}` | `asChild` |
| Accordion API | `defaultValue` array, `multiple` prop | `type="single"\|"multiple"`, `collapsible` |

Most components share identical install commands, imports, and usage patterns. Variant-specific differences are noted per component where applicable.

---

## Alert

Displays a callout for user attention.

```bash
npx shadcn@latest add alert
```

**Deps:** None (pure component)

```tsx
import { Alert, AlertAction, AlertDescription, AlertTitle } from "@/components/ui/alert"
```

```tsx
<Alert>
  <InfoIcon />
  <AlertTitle>Heads up!</AlertTitle>
  <AlertDescription>
    You can add components and dependencies to your app using the cli.
  </AlertDescription>
  <AlertAction>
    <Button variant="outline">Enable</Button>
  </AlertAction>
</Alert>
```

- **Key props:** `variant` (`"default"` | `"destructive"`)
- **Sub-components:** `Alert`, `AlertTitle`, `AlertDescription`, `AlertAction`

---


## Avatar

An image element with a fallback for representing the user.

```bash
npx shadcn@latest add avatar
```

**Deps:** `@base-ui/react` or `radix-ui`

```tsx
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
```

```tsx
<Avatar>
  <AvatarImage src="https://github.com/shadcn.png" />
  <AvatarFallback>CN</AvatarFallback>
</Avatar>
```

- **Key props:** `size` (`"default"` | `"sm"` | `"lg"`) on `Avatar`
- **Sub-components:** `Avatar`, `AvatarImage`, `AvatarFallback`, `AvatarBadge`, `AvatarGroup`, `AvatarGroupCount`

---


## Badge

Displays a badge or a component that looks like a badge.

```bash
npx shadcn@latest add badge
```

**Deps:** None (pure component)

```tsx
import { Badge } from "@/components/ui/badge"
```

```tsx
<Badge variant="outline">Badge</Badge>
```

- **Key props:** `variant` (`"default"` | `"secondary"` | `"destructive"` | `"outline"` | `"ghost"` | `"link"`)
- Use `data-icon="inline-start"` or `data-icon="inline-end"` for icons
- **Base UI:** use `render` to render as link / **Radix:** use `asChild`

---


## Card

Displays a card with header, content, and footer.

```bash
npx shadcn@latest add card
```

**Deps:** None (pure component)

```tsx
import {
  Card, CardAction, CardContent, CardDescription,
  CardFooter, CardHeader, CardTitle,
} from "@/components/ui/card"
```

```tsx
<Card>
  <CardHeader>
    <CardTitle>Card Title</CardTitle>
    <CardDescription>Card Description</CardDescription>
    <CardAction>Card Action</CardAction>
  </CardHeader>
  <CardContent><p>Card Content</p></CardContent>
  <CardFooter><p>Card Footer</p></CardFooter>
</Card>
```

- **Key props:** `size` (`"default"` | `"sm"`) on `Card`
- **Sub-components:** `Card`, `CardHeader`, `CardTitle`, `CardDescription`, `CardAction`, `CardContent`, `CardFooter`

---


## Carousel

A carousel with motion and swipe built using Embla.

```bash
npx shadcn@latest add carousel
```

**Deps:** `embla-carousel-react`

```tsx
import {
  Carousel, CarouselContent, CarouselItem,
  CarouselNext, CarouselPrevious,
} from "@/components/ui/carousel"
```

```tsx
<Carousel>
  <CarouselContent>
    <CarouselItem>...</CarouselItem>
    <CarouselItem>...</CarouselItem>
  </CarouselContent>
  <CarouselPrevious />
  <CarouselNext />
</Carousel>
```

- **Key props:** `orientation` (`"horizontal"` | `"vertical"`), `opts` (Embla options like `align`, `loop`), `plugins`, `setApi`
- **Sub-components:** `Carousel`, `CarouselContent`, `CarouselItem`, `CarouselPrevious`, `CarouselNext`
- Use `basis-*` on `CarouselItem` for sizing (e.g. `basis-1/3`)

---


## Chart

Beautiful charts built using Recharts.

```bash
npx shadcn@latest add chart
```

**Deps:** `recharts`

```tsx
import { ChartContainer, ChartTooltipContent } from "@/components/ui/chart"
import { Bar, BarChart } from "recharts"
```

```tsx
<ChartContainer config={chartConfig} className="min-h-[200px] w-full">
  <BarChart data={data}>
    <Bar dataKey="value" />
    <ChartTooltip content={<ChartTooltipContent />} />
  </BarChart>
</ChartContainer>
```

- **Key exports:** `ChartContainer`, `ChartTooltip`, `ChartTooltipContent`, `ChartLegend`, `ChartLegendContent`, `ChartConfig` (type)
- **ChartTooltipContent props:** `labelKey`, `nameKey`, `indicator` (`"dot"` | `"line"` | `"dashed"`), `hideLabel`, `hideIndicator`
- Use `var(--color-KEY)` to reference chart config colors; set `min-h-[VALUE]` on `ChartContainer`

---


## Data Table

Powerful table and datagrids built using TanStack Table. **This is a composition pattern, not a standalone component.**

```bash
npx shadcn@latest add table
npm install @tanstack/react-table
```

**Deps:** `@tanstack/react-table` (manual install), `table` component

```tsx
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { ColumnDef, flexRender, getCoreRowModel, useReactTable } from "@tanstack/react-table"
```

```tsx
const table = useReactTable({ data, columns, getCoreRowModel: getCoreRowModel() })

<Table>
  <TableHeader>
    {table.getHeaderGroups().map((hg) => (
      <TableRow key={hg.id}>
        {hg.headers.map((h) => (
          <TableHead key={h.id}>
            {flexRender(h.column.columnDef.header, h.getContext())}
          </TableHead>
        ))}
      </TableRow>
    ))}
  </TableHeader>
  <TableBody>
    {table.getRowModel().rows.map((row) => (
      <TableRow key={row.id}>
        {row.getVisibleCells().map((cell) => (
          <TableCell key={cell.id}>
            {flexRender(cell.column.columnDef.cell, cell.getContext())}
          </TableCell>
        ))}
      </TableRow>
    ))}
  </TableBody>
</Table>
```

- Supports pagination (`getPaginationRowModel`), sorting (`getSortedRowModel`), filtering (`getFilteredRowModel`), column visibility, and row selection
- Reusable helpers: `DataTableColumnHeader`, `DataTablePagination`, `DataTableViewOptions`

---


## Empty

Displays an empty state.

```bash
npx shadcn@latest add empty
```

**Deps:** None (pure component)

```tsx
import {
  Empty, EmptyContent, EmptyDescription,
  EmptyHeader, EmptyMedia, EmptyTitle,
} from "@/components/ui/empty"
```

```tsx
<Empty>
  <EmptyHeader>
    <EmptyMedia variant="icon"><Icon /></EmptyMedia>
    <EmptyTitle>No data</EmptyTitle>
    <EmptyDescription>No data found</EmptyDescription>
  </EmptyHeader>
  <EmptyContent><Button>Add data</Button></EmptyContent>
</Empty>
```

- **Key props:** `variant` (`"default"` | `"icon"`) on `EmptyMedia`
- **Sub-components:** `Empty`, `EmptyHeader`, `EmptyMedia`, `EmptyTitle`, `EmptyDescription`, `EmptyContent`

---


## Item

A versatile component for displaying content with media, title, description, and actions.

```bash
npx shadcn@latest add item
```

**Deps:** None (pure component)

```tsx
import {
  Item, ItemActions, ItemContent,
  ItemDescription, ItemMedia, ItemTitle,
} from "@/components/ui/item"
```

```tsx
<Item>
  <ItemMedia variant="icon"><Icon /></ItemMedia>
  <ItemContent>
    <ItemTitle>Title</ItemTitle>
    <ItemDescription>Description</ItemDescription>
  </ItemContent>
  <ItemActions><Button>Action</Button></ItemActions>
</Item>
```

- **Key props:** `variant` (`"default"` | `"outline"` | `"muted"`), `size` (`"default"` | `"sm"` | `"xs"`)
- **ItemMedia variants:** `"default"` | `"icon"` | `"image"`
- **Sub-components:** `Item`, `ItemGroup`, `ItemSeparator`, `ItemMedia`, `ItemContent`, `ItemTitle`, `ItemDescription`, `ItemActions`, `ItemHeader`, `ItemFooter`
- **Base UI:** use `render` for link items / **Radix:** use `asChild`

---


## Table

A responsive table component.

```bash
npx shadcn@latest add table
```

**Deps:** None (pure component)

```tsx
import {
  Table, TableBody, TableCaption, TableCell,
  TableHead, TableHeader, TableRow,
} from "@/components/ui/table"
```

```tsx
<Table>
  <TableCaption>A list of your recent invoices.</TableCaption>
  <TableHeader>
    <TableRow>
      <TableHead>Invoice</TableHead>
      <TableHead>Status</TableHead>
      <TableHead className="text-right">Amount</TableHead>
    </TableRow>
  </TableHeader>
  <TableBody>
    <TableRow>
      <TableCell className="font-medium">INV001</TableCell>
      <TableCell>Paid</TableCell>
      <TableCell className="text-right">$250.00</TableCell>
    </TableRow>
  </TableBody>
</Table>
```

- **Sub-components:** `Table`, `TableHeader`, `TableBody`, `TableFooter`, `TableRow`, `TableHead`, `TableCell`, `TableCaption`
- Combine with `@tanstack/react-table` for Data Tables with sorting, filtering, pagination

---


## Typography

Styles for headings, paragraphs, lists, and more. **This is a set of utility class patterns, not an installable component.**

```bash
# No installation needed. Typography uses Tailwind utility classes.
```

**Common patterns:**

- `h1`: `scroll-m-20 text-4xl font-extrabold tracking-tight lg:text-5xl`
- `h2`: `scroll-m-20 border-b pb-2 text-3xl font-semibold tracking-tight`
- `h3`: `scroll-m-20 text-2xl font-semibold tracking-tight`
- `h4`: `scroll-m-20 text-xl font-semibold tracking-tight`
- `p`: `leading-7 [&:not(:first-child)]:mt-6`
- `blockquote`: `mt-6 border-l-2 pl-6 italic`
- `lead`: `text-xl text-muted-foreground`
- `large`: `text-lg font-semibold`
- `small`: `text-sm font-medium leading-none`
- `muted`: `text-sm text-muted-foreground`
- `inline-code`: `rounded bg-muted px-[0.3rem] py-[0.2rem] font-mono text-sm font-semibold`

---
