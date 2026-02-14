# Hono Rendering Helpers

Reference for HTML and CSS helper utilities.

## Table of Contents

- [HTML Helper](#html-helper)
- [CSS Helper](#css-helper)

---

## HTML Helper

**Import**: `hono/html`

Utilities for rendering HTML with automatic escaping and JSX integration.

### Basic Usage

#### `html` Tagged Template Literal

Create HTML strings with automatic XSS protection.

```typescript
import { Hono } from 'hono'
import { html } from 'hono/html'

const app = new Hono()

app.get('/', (c) => {
  const name = '<script>alert("xss")</script>'

  return c.html(
    html`
      <!DOCTYPE html>
      <html>
        <head>
          <title>My Page</title>
        </head>
        <body>
          <h1>Hello, ${name}!</h1>
        </body>
      </html>
    `
  )
})

// Output escapes the script tag:
// <h1>Hello, &lt;script&gt;alert("xss")&lt;/script&gt;!</h1>
```

### Raw HTML

#### `raw(html)`

Insert unescaped HTML content.

```typescript
import { html, raw } from 'hono/html'

app.get('/blog', (c) => {
  const content = '<p>This is <strong>formatted</strong> content.</p>'

  return c.html(
    html`
      <!DOCTYPE html>
      <html>
        <body>
          <div class="content">
            ${raw(content)}
          </div>
        </body>
      </html>
    `
  )
})

// Output includes raw HTML:
// <div class="content">
//   <p>This is <strong>formatted</strong> content.</p>
// </div>
```

### Inserting into JSX

HTML snippets can be inserted into JSX components.

```typescript
import { html } from 'hono/html'

const Header = () => (
  <header>
    {html`<h1>My <em>App</em></h1>`}
  </header>
)

app.get('/', (c) => {
  return c.html(
    <html>
      <body>
        <Header />
      </body>
    </html>
  )
})
```

### Functional Component

HTML helper can act as a functional component.

```typescript
import { html } from 'hono/html'

const Layout = (props: { title: string; children: any }) => html`
  <!DOCTYPE html>
  <html>
    <head>
      <title>${props.title}</title>
    </head>
    <body>
      ${props.children}
    </body>
  </html>
`

app.get('/', (c) => {
  return c.html(
    Layout({
      title: 'My Page',
      children: html`<h1>Welcome</h1>`
    })
  )
})
```

### Props and Value Embedding

Receive props and embed values dynamically.

```typescript
import { html } from 'hono/html'

interface CardProps {
  title: string
  description: string
  link: string
}

const Card = (props: CardProps) => html`
  <div class="card">
    <h2>${props.title}</h2>
    <p>${props.description}</p>
    <a href="${props.link}">Read more</a>
  </div>
`

app.get('/cards', (c) => {
  const cards = [
    { title: 'Card 1', description: 'First card', link: '/1' },
    { title: 'Card 2', description: 'Second card', link: '/2' }
  ]

  return c.html(
    html`
      <div class="cards">
        ${cards.map(card => Card(card))}
      </div>
    `
  )
})
```

### Complete Example

```typescript
import { Hono } from 'hono'
import { html, raw } from 'hono/html'

const app = new Hono()

const Layout = (props: { title: string; children: any }) => html`
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>${props.title}</title>
      <style>
        body { font-family: sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        .card { border: 1px solid #ddd; padding: 20px; margin: 10px 0; }
      </style>
    </head>
    <body>
      <header>
        <h1>${props.title}</h1>
      </header>
      <main>
        ${props.children}
      </main>
    </body>
  </html>
`

const BlogPost = (props: { title: string; content: string }) => html`
  <article class="card">
    <h2>${props.title}</h2>
    <div class="content">
      ${raw(props.content)}
    </div>
  </article>
`

app.get('/', (c) => {
  const posts = [
    {
      title: 'First Post',
      content: '<p>This is the <strong>first</strong> post.</p>'
    },
    {
      title: 'Second Post',
      content: '<p>This is the <strong>second</strong> post.</p>'
    }
  ]

  return c.html(
    Layout({
      title: 'My Blog',
      children: html`
        ${posts.map(post => BlogPost(post))}
      `
    })
  )
})

export default app
```

---

## CSS Helper

**Import**: `hono/css`

Utilities for CSS-in-JS with scoped styles, animations, and class composition.

### Basic Usage

#### `css` Tagged Template Literal

Create scoped CSS and get a generated class name.

```typescript
import { Hono } from 'hono'
import { css, Style } from 'hono/css'

const app = new Hono()

app.get('/', (c) => {
  const className = css`
    color: blue;
    font-size: 16px;
    &:hover {
      color: red;
    }
  `

  return c.html(
    <html>
      <head>
        <Style />
      </head>
      <body>
        <p class={className}>Styled text</p>
      </body>
    </html>
  )
})
```

### Style Component

**REQUIRED**: Include `<Style />` in the document head to inject CSS.

```typescript
import { Style } from 'hono/css'

app.get('/', (c) => {
  return c.html(
    <html>
      <head>
        <Style />  {/* Required for CSS injection */}
      </head>
      <body>
        {/* Your content */}
      </body>
    </html>
  )
})
```

### Animations

#### `keyframes`

Define CSS animations.

```typescript
import { css, keyframes, Style } from 'hono/css'

const fadeIn = keyframes`
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
`

const className = css`
  animation: ${fadeIn} 0.3s ease-in;
`

app.get('/', (c) => {
  return c.html(
    <html>
      <head>
        <Style />
      </head>
      <body>
        <div class={className}>Animated content</div>
      </body>
    </html>
  )
})
```

### Class Composition

#### `cx()`

Compose multiple class names.

```typescript
import { css, cx } from 'hono/css'

const base = css`
  padding: 10px;
  margin: 5px;
`

const primary = css`
  background-color: blue;
  color: white;
`

const large = css`
  font-size: 20px;
`

app.get('/', (c) => {
  // Combine classes
  const buttonClass = cx(base, primary, large)

  return c.html(
    <button class={buttonClass}>Click me</button>
  )
})
```

### Extending Classes

Extend existing styles with new properties.

```typescript
import { css } from 'hono/css'

const baseButton = css`
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
`

const primaryButton = css`
  ${baseButton}
  background-color: blue;
  color: white;

  &:hover {
    background-color: darkblue;
  }
`

const dangerButton = css`
  ${baseButton}
  background-color: red;
  color: white;

  &:hover {
    background-color: darkred;
  }
`
```

### Nesting

CSS helper supports nested selectors.

```typescript
const card = css`
  padding: 20px;
  border: 1px solid #ddd;

  & h2 {
    margin-top: 0;
    color: #333;
  }

  & p {
    line-height: 1.6;
  }

  &:hover {
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  }

  &.active {
    border-color: blue;
  }
`
```

### Global Styles

#### `:-hono-global` Pseudo-Class

Define global styles (not scoped).

```typescript
import { css, Style } from 'hono/css'

const globalStyles = css`
  :-hono-global {
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: sans-serif;
      line-height: 1.6;
    }

    a {
      color: blue;
      text-decoration: none;

      &:hover {
        text-decoration: underline;
      }
    }
  }
`

app.get('/', (c) => {
  // Trigger global styles by using the class
  const className = globalStyles

  return c.html(
    <html>
      <head>
        <Style />
      </head>
      <body>
        <div class={className}>
          {/* Global styles applied */}
        </div>
      </body>
    </html>
  )
})
```

### CSP Nonce Support

Use with Secure Headers middleware for Content Security Policy.

```typescript
import { Hono } from 'hono'
import { css, Style } from 'hono/css'
import { secureHeaders } from 'hono/secure-headers'

const app = new Hono()

app.use('*', secureHeaders({
  contentSecurityPolicy: {
    scriptSrc: ["'self'", "'nonce-{NONCE}'"],
    styleSrc: ["'self'", "'nonce-{NONCE}'"]
  }
}))

app.get('/', (c) => {
  const className = css`
    color: blue;
  `

  return c.html(
    <html>
      <head>
        {/* Style component automatically uses CSP nonce */}
        <Style />
      </head>
      <body>
        <p class={className}>Styled with CSP</p>
      </body>
    </html>
  )
})
```

### Complete Example

```typescript
import { Hono } from 'hono'
import { css, cx, keyframes, Style } from 'hono/css'

const app = new Hono()

// Global styles
const globalStyles = css`
  :-hono-global {
    body {
      font-family: system-ui, sans-serif;
      margin: 0;
      padding: 20px;
    }
  }
`

// Animation
const fadeIn = keyframes`
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
`

// Base styles
const container = css`
  max-width: 800px;
  margin: 0 auto;
`

const card = css`
  background: white;
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 20px;
  margin: 10px 0;
  animation: ${fadeIn} 0.3s ease-out;

  & h2 {
    margin-top: 0;
    color: #333;
  }

  &:hover {
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  }
`

const button = css`
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
`

const primaryButton = css`
  ${button}
  background-color: #007bff;
  color: white;

  &:hover {
    background-color: #0056b3;
  }
`

app.get('/', (c) => {
  return c.html(
    <html>
      <head>
        <Style />
      </head>
      <body class={globalStyles}>
        <div class={container}>
          <div class={card}>
            <h2>Welcome</h2>
            <p>This is a styled card component.</p>
            <button class={primaryButton}>Click me</button>
          </div>
        </div>
      </body>
    </html>
  )
})

export default app
```

---
