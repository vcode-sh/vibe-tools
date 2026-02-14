# JSX in Hono

Comprehensive guide to using JSX for both server-side and client-side rendering in Hono.

## JSX (Server-Side)

### 1. Setup

#### TypeScript Configuration

Add the following to your `tsconfig.json`:

```json
{
  "compilerOptions": {
    "jsx": "react-jsx",
    "jsxImportSource": "hono/jsx"
  }
}
```

#### Deno Configuration

For Deno projects, use `deno.json`:

```json
{
  "compilerOptions": {
    "jsx": "precompile",
    "jsxImportSource": "@hono/hono/jsx"
  }
}
```

#### Pragma Comment

Alternatively, add this pragma comment at the top of your `.tsx` files:

```tsx
/** @jsxImportSource hono/jsx */
```

#### File Extension Requirement

**Important**: Files using JSX must have the `.tsx` extension, not `.ts`.

### 2. Usage

#### Basic Component Pattern

```tsx
import { FC } from 'hono/jsx'

const Component: FC = () => {
  return <div>Hello, Hono!</div>
}
```

#### Layout Pattern

```tsx
import { FC } from 'hono/jsx'

const Layout: FC = ({ children }) => {
  return (
    <html>
      <head>
        <title>My App</title>
      </head>
      <body>{children}</body>
    </html>
  )
}

const Page: FC = () => {
  return <h1>Welcome</h1>
}
```

#### Rendering with Context

Use `c.html()` to render JSX components:

```tsx
app.get('/', (c) => {
  return c.html(<Component />)
})
```

### 3. Metadata Hoisting

Hono automatically hoists `title`, `link`, and `meta` tags to the `<head>` section, even if defined within components.

```tsx
const Page: FC = () => {
  return (
    <div>
      <title>Page Title</title>
      <meta name="description" content="Page description" />
      <h1>Content</h1>
    </div>
  )
}
```

**Note**:
- Existing elements in `<head>` are not removed
- New elements are added to the end of `<head>`

### 4. Fragment

Use `Fragment` for grouping elements without a wrapper:

```tsx
import { Fragment } from 'hono/jsx'

const Component: FC = () => {
  return (
    <Fragment>
      <div>First</div>
      <div>Second</div>
    </Fragment>
  )
}
```

Or use the shorthand syntax:

```tsx
const Component: FC = () => {
  return (
    <>
      <div>First</div>
      <div>Second</div>
    </>
  )
}
```

### 5. PropsWithChildren

Use `PropsWithChildren` for typed children props:

```tsx
import { FC, PropsWithChildren } from 'hono/jsx'

type Props = PropsWithChildren<{
  title: string
}>

const Card: FC<Props> = ({ title, children }) => {
  return (
    <div>
      <h2>{title}</h2>
      <div>{children}</div>
    </div>
  )
}
```

### 6. dangerouslySetInnerHTML

Render raw HTML content (use with caution):

```tsx
const Component: FC = () => {
  const html = '<strong>Bold text</strong>'

  return <div dangerouslySetInnerHTML={{ __html: html }} />
}
```

### 7. memo

Memoize components to prevent unnecessary re-renders:

```tsx
import { memo } from 'hono/jsx'

const ExpensiveComponent: FC<{ data: string }> = memo(({ data }) => {
  // Complex rendering logic
  return <div>{data}</div>
})
```

### 8. Context

Create and use context for sharing data across components:

```tsx
import { createContext, useContext, FC } from 'hono/jsx'

const ThemeContext = createContext<string>('light')

const ThemedButton: FC = () => {
  const theme = useContext(ThemeContext)
  return <button className={theme}>Click me</button>
}

const App: FC = () => {
  return (
    <ThemeContext.Provider value="dark">
      <ThemedButton />
    </ThemeContext.Provider>
  )
}
```

### 9. Async Components

Components can be asynchronous and will be automatically awaited by `c.html()`:

```tsx
const AsyncComponent: FC = async () => {
  const data = await fetchData()
  return <div>{data}</div>
}

const Page: FC = async () => {
  const user = await getUser()
  return (
    <div>
      <h1>Welcome {user.name}</h1>
      <AsyncComponent />
    </div>
  )
}

app.get('/', async (c) => {
  return c.html(<Page />)
})
```

### 10. Suspense (Experimental)

Stream components with loading states using Suspense:

```tsx
import { Suspense } from 'hono/jsx/streaming'
import { renderToReadableStream } from 'hono/jsx/streaming'

const SlowComponent: FC = async () => {
  await new Promise(resolve => setTimeout(resolve, 2000))
  return <div>Loaded!</div>
}

const App: FC = () => {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <SlowComponent />
    </Suspense>
  )
}

app.get('/', async (c) => {
  const stream = renderToReadableStream(<App />)

  return c.body(stream, {
    headers: {
      'Transfer-Encoding': 'chunked',
      'Content-Type': 'text/html; charset=UTF-8'
    }
  })
})
```

**Important**: You must set:
- `Transfer-Encoding: chunked`
- `Content-Type: text/html`

### 11. ErrorBoundary (Experimental)

Handle errors in async components:

```tsx
import { ErrorBoundary } from 'hono/jsx/streaming'

const FailingComponent: FC = async () => {
  throw new Error('Something went wrong')
  return <div>Success</div>
}

const App: FC = () => {
  return (
    <ErrorBoundary fallback={<div>Error occurred!</div>}>
      <Suspense fallback={<div>Loading...</div>}>
        <FailingComponent />
      </Suspense>
    </ErrorBoundary>
  )
}
```

The `fallback` prop renders when an error is caught. Works seamlessly with async components and Suspense.

### 12. StreamingContext (Experimental)

Configure streaming behavior, including CSP nonces:

```tsx
import { StreamingContext } from 'hono/jsx/streaming'

const App: FC = () => {
  return (
    <StreamingContext.Provider value={{ scriptNonce: 'random-nonce-value' }}>
      <Suspense fallback={<div>Loading...</div>}>
        <AsyncComponent />
      </Suspense>
    </StreamingContext.Provider>
  )
}
```

### 13. Override Type Definitions

Extend JSX type definitions for custom elements:

```tsx
declare module 'hono/jsx' {
  namespace JSX {
    interface IntrinsicElements {
      'custom-element': {
        'data-value'?: string
        class?: string
      }
    }
  }
}

// Now you can use:
const Component: FC = () => {
  return <custom-element data-value="test" class="custom" />
}
```

## Client Components (hono/jsx/dom)

### 1. Overview

Build interactive UI components that run in the browser with a significantly smaller bundle size.

**Bundle Size Comparison**:
- Hono JSX: ~2.8KB
- React: ~47.8KB

```tsx
import { render } from 'hono/jsx/dom'

const Counter = () => {
  const [count, setCount] = useState(0)

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  )
}

render(<Counter />, document.getElementById('root')!)
```

### 2. render()

Mount your application to a DOM element:

```tsx
import { render } from 'hono/jsx/dom'

const App = () => {
  return <div>Hello, World!</div>
}

const rootElement = document.getElementById('root')
if (rootElement) {
  render(<App />, rootElement)
}
```

### 3. React-Compatible Hooks

Hono provides a comprehensive set of hooks compatible with React:

#### State Management

```tsx
import { useState, useReducer } from 'hono/jsx/dom'

// useState
const [state, setState] = useState(initialState)

// useReducer
const [state, dispatch] = useReducer(reducer, initialState)
```

#### Effects and Lifecycle

```tsx
import { useEffect, useLayoutEffect, useInsertionEffect } from 'hono/jsx/dom'

// useEffect - runs after render
useEffect(() => {
  // Effect logic
  return () => {
    // Cleanup
  }
}, [dependencies])

// useLayoutEffect - runs synchronously after DOM mutations
useLayoutEffect(() => {
  // Layout effect logic
}, [dependencies])

// useInsertionEffect - runs before all DOM mutations
useInsertionEffect(() => {
  // Insertion effect logic
}, [dependencies])
```

#### Refs and Memoization

```tsx
import { useRef, useCallback, useMemo, useImperativeHandle } from 'hono/jsx/dom'

// useRef
const ref = useRef(initialValue)

// useCallback
const memoizedCallback = useCallback(() => {
  doSomething(a, b)
}, [a, b])

// useMemo
const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b])

// useImperativeHandle
useImperativeHandle(ref, () => ({
  focus: () => {
    inputRef.current?.focus()
  }
}))
```

#### Other Hooks

```tsx
import {
  useId,
  useDebugValue,
  useSyncExternalStore,
  useDeferredValue
} from 'hono/jsx/dom'

// useId - generate unique IDs
const id = useId()

// useDebugValue - label custom hooks in DevTools
useDebugValue(value)

// useSyncExternalStore - subscribe to external stores
const state = useSyncExternalStore(subscribe, getSnapshot)

// useDeferredValue - defer updating non-urgent parts
const deferredValue = useDeferredValue(value)
```

#### Transitions

```tsx
import { startTransition, useTransition } from 'hono/jsx/dom'

// startTransition - mark updates as non-urgent
startTransition(() => {
  setState(newState)
})

// useTransition - track transition state
const [isPending, startTransition] = useTransition()
```

#### Form Hooks

```tsx
import { useFormStatus, useActionState, useOptimistic } from 'hono/jsx/dom'

// useFormStatus - get form submission status
const { pending, data, method, action } = useFormStatus()

// useActionState - manage form actions
const [state, formAction] = useActionState(action, initialState)

// useOptimistic - optimistic updates
const [optimisticState, addOptimistic] = useOptimistic(state, updateFn)
```

#### Resource Loading

```tsx
import { use } from 'hono/jsx/dom'

// use - read resource values (promises, context)
const value = use(promise)
```

#### Element Creation

```tsx
import {
  createElement,
  memo,
  isValidElement,
  createRef,
  forwardRef
} from 'hono/jsx/dom'

// createElement
const element = createElement('div', { className: 'container' }, 'Hello')

// memo - memoize components
const MemoizedComponent = memo(Component)

// isValidElement - check if value is valid element
if (isValidElement(element)) {
  // Handle element
}

// createRef - create ref object
const ref = createRef()

// forwardRef - forward refs to child components
const FancyButton = forwardRef((props, ref) => (
  <button ref={ref}>{props.children}</button>
))
```

### 4. startViewTransition() Family

Integrate with the View Transitions API for smooth animations:

#### Basic Usage

```tsx
import { startViewTransition } from 'hono/jsx/dom'

const Component = () => {
  const [show, setShow] = useState(false)

  const toggle = () => {
    startViewTransition(() => {
      setShow(!show)
    })
  }

  return (
    <div>
      <button onClick={toggle}>Toggle</button>
      {show && <div>Content</div>}
    </div>
  )
}
```

#### viewTransition() for CSS

Generate unique `view-transition-name` values:

```tsx
import { viewTransition } from 'hono/jsx/dom/css'

const Component = () => {
  return (
    <div style={viewTransition()}>
      Animated content
    </div>
  )
}

// Generates: { viewTransitionName: 'unique-id' }
```

#### useViewTransition() Hook

Track transition state:

```tsx
import { useViewTransition } from 'hono/jsx/dom'

const Component = () => {
  const [isUpdating, startTransition] = useViewTransition()
  const [count, setCount] = useState(0)

  const increment = () => {
    startTransition(() => {
      setCount(count + 1)
    })
  }

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={increment} disabled={isUpdating}>
        {isUpdating ? 'Updating...' : 'Increment'}
      </button>
    </div>
  )
}
```

### 5. hono/jsx/dom Runtime

For smaller bundle sizes in client-side code, use the `hono/jsx/dom` runtime:

#### TypeScript Configuration

```json
{
  "compilerOptions": {
    "jsx": "react-jsx",
    "jsxImportSource": "hono/jsx/dom"
  }
}
```

#### Vite Configuration

```ts
// vite.config.ts
export default {
  esbuild: {
    jsxImportSource: 'hono/jsx/dom'
  }
}
```

**Benefit**: The `hono/jsx/dom` runtime produces smaller bundles compared to `hono/jsx` when building client-side applications.

## JSX Renderer Middleware

### 1. jsxRenderer

Middleware for consistent layouts and rendering options:

#### Basic Layout

```tsx
import { jsxRenderer } from 'hono/jsx-renderer'

app.use(jsxRenderer(({ children }) => {
  return (
    <html>
      <head>
        <title>My App</title>
      </head>
      <body>{children}</body>
    </html>
  )
}))

app.get('/', (c) => {
  return c.render(<h1>Hello!</h1>)
})
```

#### Options

```tsx
app.use(jsxRenderer(Layout, {
  // Control doctype rendering
  docType: true,  // Renders: <!DOCTYPE html>
  // docType: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"...>',

  // Enable streaming
  stream: true,
  // stream: {
  //   onError: (e) => console.error(e)
  // }
}))
```

#### Nested Layouts

```tsx
app.use(jsxRenderer(({ children }) => {
  return (
    <html>
      <body>{children}</body>
    </html>
  )
}))

app.get('/', jsxRenderer(({ children, Layout }) => {
  return (
    <Layout>
      <header>Header</header>
      {children}
    </Layout>
  )
}), (c) => {
  return c.render(<main>Content</main>)
})
```

#### useRequestContext()

Access Hono's context within components:

```tsx
import { useRequestContext } from 'hono/jsx-renderer'

const Component = () => {
  const c = useRequestContext()
  const url = c.req.url

  return <div>Current URL: {url}</div>
}
```

#### Extending ContextRenderer

Create custom render methods with additional props:

```tsx
import { jsxRenderer } from 'hono/jsx-renderer'

declare module 'hono' {
  interface ContextRenderer {
    (content: string | Promise<string>, props?: {
      title?: string
      description?: string
    }): Response
  }
}

app.use(jsxRenderer(({ children, title, description }) => {
  return (
    <html>
      <head>
        {title && <title>{title}</title>}
        {description && <meta name="description" content={description} />}
      </head>
      <body>{children}</body>
    </html>
  )
}))

app.get('/', (c) => {
  return c.render(
    <h1>Home</h1>,
    {
      title: 'Home Page',
      description: 'Welcome to my site'
    }
  )
})
```

## Best Practices

1. **Use `.tsx` extension**: Always use `.tsx` for files containing JSX
2. **Type your props**: Use TypeScript interfaces for component props
3. **Memoize expensive components**: Use `memo()` for performance
4. **Prefer async components**: Use async/await for data fetching on the server
5. **Use Suspense for streaming**: Leverage Suspense for better user experience with slow data
6. **Small client bundles**: Use `hono/jsx/dom` runtime for client-side code
7. **Sanitize HTML**: Be cautious with `dangerouslySetInnerHTML`
8. **Use Context sparingly**: Avoid overusing context for performance reasons

## Common Patterns

### Data Fetching Pattern

```tsx
const UserProfile: FC<{ id: string }> = async ({ id }) => {
  const user = await db.user.findById(id)

  return (
    <div>
      <h2>{user.name}</h2>
      <p>{user.email}</p>
    </div>
  )
}

app.get('/user/:id', (c) => {
  const id = c.req.param('id')
  return c.html(<UserProfile id={id} />)
})
```

### Layout with Slots Pattern

```tsx
const Layout: FC<{ header?: JSX.Element; children: JSX.Element }> = ({
  header,
  children
}) => {
  return (
    <html>
      <head><title>App</title></head>
      <body>
        {header && <header>{header}</header>}
        <main>{children}</main>
      </body>
    </html>
  )
}

app.get('/', (c) => {
  return c.html(
    <Layout header={<nav>Navigation</nav>}>
      <h1>Content</h1>
    </Layout>
  )
})
```

### Client-Side Hydration Pattern

```tsx
// Server-side rendering
app.get('/', (c) => {
  return c.html(
    <html>
      <body>
        <div id="root">
          <App />
        </div>
        <script type="module" src="/client.js"></script>
      </body>
    </html>
  )
})

// client.js
import { render } from 'hono/jsx/dom'
import { App } from './App'

render(<App />, document.getElementById('root')!)
```

## Summary

Hono's JSX implementation provides:
- Full TypeScript support
- Server-side rendering with async components
- Streaming and Suspense for progressive rendering
- React-compatible client-side hooks
- Significantly smaller bundle sizes
- Flexible middleware for layouts
- Type-safe component development

Whether building server-rendered pages or interactive client applications, Hono's JSX offers a modern, efficient, and developer-friendly solution.
