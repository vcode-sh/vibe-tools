# Custom Scripts

Add custom JavaScript to blocks using `customJs` and `customJsEnabled` parameters.

## Basic Parameters

To add custom scripts to any Greenshift block, you need two parameters:

- **`customJs`**: String containing your JavaScript code
- **`customJsEnabled`**: Boolean, set to `true` to enable the script

## Basic Structure

```json
{
  "customJs": "console.log('Hello from block');",
  "customJsEnabled": true
}
```

## Simple Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-script01","textContent":"Interactive Block","localId":"gsbp-script01","customJs":"console.log('Block loaded');","customJsEnabled":true} -->
<div>Interactive Block</div>
<!-- /wp:greenshift-blocks/element -->
```

---

## GSAP Integration

Greenshift includes the GSAP animation library. Import GSAP using the plugin URL placeholder:

```javascript
import gsap from "{{PLUGIN_URL}}/libs/motion/gsap.js";
```

### Complete GSAP Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-dfc6b73","textContent":"block with some script","localId":"gsbp-dfc6b73","isVariation":"divtext","customJs":"import gsap from \"{{PLUGIN_URL}}/libs/motion/gsap.js\";\nconsole.log('test');","customJsEnabled":true} -->
<div>block with some script</div>
<!-- /wp:greenshift-blocks/element -->
```

### GSAP Animation Example

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-gsap01","textContent":"Animated Element","localId":"gsbp-gsap01","customJs":"import gsap from \"{{PLUGIN_URL}}/libs/motion/gsap.js\";\n\nconst element = document.querySelector('.gsbp-gsap01');\ngsap.from(element, {\n  duration: 1,\n  y: 50,\n  opacity: 0,\n  ease: 'power2.out'\n});","customJsEnabled":true} -->
<div class="gsbp-gsap01">Animated Element</div>
<!-- /wp:greenshift-blocks/element -->
```

---

## Script Best Practices

1. **Scope your selectors** - Use the block's unique class (localId)
2. **Use ES modules** - Import statements work
3. **Check element existence** - Elements might not be in DOM yet
4. **Avoid global namespace pollution** - Use IIFEs or modules

### Scoped Example

```javascript
import gsap from "{{PLUGIN_URL}}/libs/motion/gsap.js";

// Use specific selector for this block
const blockId = 'gsbp-abc1234';
const element = document.querySelector(`.${blockId}`);

if (element) {
  gsap.to(element, {
    scrollTrigger: {
      trigger: element,
      start: 'top 80%'
    },
    y: 0,
    opacity: 1,
    duration: 0.8
  });
}
```

---

## Available Libraries

| Library | Import Path |
|---------|-------------|
| GSAP | `{{PLUGIN_URL}}/libs/motion/gsap.js` |
| ScrollTrigger | `{{PLUGIN_URL}}/libs/motion/ScrollTrigger.js` |

---

## JSON Escaping

When including JavaScript in JSON, escape:
- Double quotes: `\"`
- Newlines: `\n`
- Backslashes: `\\`

### Multi-line Script Example

```json
{
  "customJs": "import gsap from \"{{PLUGIN_URL}}/libs/motion/gsap.js\";\n\nconst el = document.querySelector('.my-class');\nif (el) {\n  gsap.to(el, { opacity: 1 });\n}",
  "customJsEnabled": true
}
```

---

## Important Notes

- Use native script support via `customJs` and `customJsEnabled` parameters
- For GSAP scripts, always use the import statement: `import gsap from "{{PLUGIN_URL}}/libs/motion/gsap.js";`
- The `{{PLUGIN_URL}}` placeholder is automatically replaced with the correct plugin path
- Scripts are executed when the block loads on the page
- Always ensure `customJsEnabled` is set to `true` for scripts to run
