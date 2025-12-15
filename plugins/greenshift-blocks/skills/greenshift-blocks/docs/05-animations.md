# Animations

## AOS (Animate On Scroll) Animations

Use the `animation` parameter for scroll-triggered entrance animations.

### Animation Parameter Structure

```json
{
  "animation": {
    "type": "fade-up",
    "duration": 800,
    "delay": 0,
    "easing": "ease",
    "onlyonce": true,
    "infinite": false
  }
}
```

### Parameters

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `type` | String | Animation type | Required |
| `duration` | Number | Duration in ms | `800` |
| `delay` | Number | Delay in ms | `0` |
| `easing` | String | Easing function | `"ease"` |
| `onlyonce` | Boolean | Animate only first time | `true` |
| `infinite` | Boolean | Loop animation | `false` |

### Available Animation Types

#### Fade Animations
- `fade`
- `fade-up`, `fade-down`, `fade-left`, `fade-right`
- `fade-up-right`, `fade-up-left`, `fade-down-right`, `fade-down-left`

#### Zoom Animations
- `zoom-in`, `zoom-out`
- `zoom-in-up`, `zoom-in-down`, `zoom-in-left`, `zoom-in-right`
- `zoom-out-up`, `zoom-out-down`, `zoom-out-left`, `zoom-out-right`

#### Slide Animations
- `slide-up`, `slide-down`, `slide-left`, `slide-right`

#### Flip Animations
- `flip-up`, `flip-down`, `flip-left`, `flip-right`

#### Clip Animations
- `clip-right`, `clip-left`, `clip-up`, `clip-down`

### Easing Options

- `ease`
- `ease-in`
- `ease-out`
- `ease-in-out`
- `linear`

### HTML Output

Animation parameters become `data-aos-*` attributes:

```html
<div data-aos="fade-up" data-aos-delay="300" data-aos-easing="ease" data-aos-duration="800" data-aos-once="true" class="gsbp-xxx">
```

### Example with Staggered Delays

```html
<!-- Element 1: No delay -->
<!-- wp:greenshift-blocks/element {"id":"gsbp-anim01","textContent":"Title","tag":"h2","animation":{"duration":800,"easing":"ease","type":"fade-up","onlyonce":true},"localId":"gsbp-anim01"} -->
<h2 data-aos="fade-up" data-aos-easing="ease" data-aos-duration="800" data-aos-once="true" class="gsbp-anim01">Title</h2>
<!-- /wp:greenshift-blocks/element -->

<!-- Element 2: 300ms delay -->
<!-- wp:greenshift-blocks/element {"id":"gsbp-anim02","textContent":"Subtitle","tag":"p","animation":{"duration":800,"easing":"ease","type":"fade-up","delay":300,"onlyonce":true},"localId":"gsbp-anim02"} -->
<p data-aos="fade-up" data-aos-delay="300" data-aos-easing="ease" data-aos-duration="800" data-aos-once="true" class="gsbp-anim02">Subtitle</p>
<!-- /wp:greenshift-blocks/element -->

<!-- Element 3: 600ms delay -->
<!-- wp:greenshift-blocks/element {"id":"gsbp-anim03","textContent":"Click Here","tag":"a","animation":{"duration":800,"easing":"ease","type":"fade-up","delay":600,"onlyonce":true},"localId":"gsbp-anim03"} -->
<a data-aos="fade-up" data-aos-delay="600" data-aos-easing="ease" data-aos-duration="800" data-aos-once="true" class="gsbp-anim03">Click Here</a>
<!-- /wp:greenshift-blocks/element -->
```

---

## CSS Keyframe Animations (`styleAttributes`)

For custom animations via `styleAttributes`, you can define custom keyframes and apply them to elements.

### Keyframe Structure with `animation_keyframes_Extra`

Define keyframes using `animation_keyframes_Extra`: An array of objects, each with `name` (e.g., `"gs_3450"`) and `code` (CSS keyframe string).

```json
{
  "styleAttributes": {
    "animation_keyframes_Extra": [
      {
        "name": "gs_fade_scale",
        "code": "0%{opacity: 0; scale: 0.7;} 100%{opacity: 1; scale: 1;}"
      }
    ],
    "animation": ["gs_fade_scale 1s ease-out both"]
  }
}
```

### Applying Animations

Apply animation using `animation`: Array, e.g., `["gs_3450 3s infinite"]`.

The `animation` property accepts standard CSS animation values:
- Animation name (must match the `name` in `animation_keyframes_Extra`)
- Duration (e.g., `1s`, `500ms`, `3s`)
- Timing function (e.g., `ease`, `linear`, `ease-in-out`, `cubic-bezier()`)
- Fill mode (e.g., `both`, `forwards`, `backwards`, `none`)
- Iteration count (e.g., `infinite`, `3`, or omit for once)

### Example: Basic Keyframe Animation

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-k3f7a21","textContent":"Animated Text","tag":"h2","localId":"gsbp-k3f7a21","styleAttributes":{"animation_keyframes_Extra":[{"name":"gs_fade_scale","code":"0%{opacity: 0; scale: 0.7;} 100%{opacity: 1; scale: 1;}"}],"animation":["gs_fade_scale 1s ease-out both"]}} -->
<h2 class="gsbp-k3f7a21">Animated Text</h2>
<!-- /wp:greenshift-blocks/element -->
```

### Example: Infinite Looping Animation

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-k8d2b45","textContent":"Pulse","tag":"div","localId":"gsbp-k8d2b45","styleAttributes":{"animation_keyframes_Extra":[{"name":"gs_pulse","code":"0%{scale: 1;} 50%{scale: 1.1;} 100%{scale: 1;}"}],"animation":["gs_pulse 2s ease-in-out infinite"]}} -->
<div class="gsbp-k8d2b45">Pulse</div>
<!-- /wp:greenshift-blocks/element -->
```

---

## Scroll-Triggered Animations with `animationTimeline`

Use `animationTimeline` and `animationRange` for animations that trigger based on scroll position.

### Scroll Animation Structure

```json
{
  "styleAttributes": {
    "animation_keyframes_Extra": [
      {
        "name": "gs_scroll_reveal",
        "code": "0%{opacity: 0; transform: translateY(50px);} 100%{opacity: 1; transform: translateY(0);}"
      }
    ],
    "animation": ["gs_scroll_reveal linear both"],
    "animationTimeline": ["view()"],
    "animationRange": ["entry"]
  }
}
```

### `animationTimeline` Property

- Use `animationTimeline: ["view()"]` to link animation to scroll position
- The animation progresses based on element visibility in viewport

### `animationRange` Options

- `"entry"` - Animation plays as element enters viewport
- `"exit"` - Animation plays as element exits viewport
- `"entry 0% exit 100%"` - Full range (animation spans entire visibility period)
- You can also define ranges within the keyframe `code` (e.g., `entry 0%`, `exit 100%`)

### Example: Scroll-Triggered Fade and Scale

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-2a59759","textContent":"Scroll Animate","tag":"h2","localId":"gsbp-2a59759","styleAttributes":{"animation_keyframes_Extra":[{"name":"gs_9751","code":"0%{opacity: 0;scale:0.7;}100%{opacity: 1;scale:1;}"}],"animation":["gs_9751 linear both"],"animationTimeline":["view()"],"animationRange":["entry"]}} -->
<h2 class="gsbp-2a59759">Scroll Animate</h2>
<!-- /wp:greenshift-blocks/element -->
```

### Example: Scroll-Triggered Slide Up

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-s4c9d12","textContent":"Slide Up on Scroll","tag":"div","localId":"gsbp-s4c9d12","styleAttributes":{"animation_keyframes_Extra":[{"name":"gs_slide_up","code":"0%{opacity: 0; transform: translateY(50px);} 100%{opacity: 1; transform: translateY(0);}"}],"animation":["gs_slide_up linear both"],"animationTimeline":["view()"],"animationRange":["entry"]}} -->
<div class="gsbp-s4c9d12">Slide Up on Scroll</div>
<!-- /wp:greenshift-blocks/element -->
```

### Example: Scroll Progress Animation

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-p7e2f89","textContent":"Progress Bar","tag":"div","localId":"gsbp-p7e2f89","styleAttributes":{"animation_keyframes_Extra":[{"name":"gs_progress","code":"0%{width: 0%;} 100%{width: 100%;}"}],"animation":["gs_progress linear both"],"animationTimeline":["view()"],"animationRange":["entry 0% exit 100%"]}} -->
<div class="gsbp-p7e2f89">Progress Bar</div>
<!-- /wp:greenshift-blocks/element -->
```

---

## Animation Best Practices

### Stagger Pattern

For multiple elements, increase delay incrementally:

| Element | Delay |
|---------|-------|
| 1 | 0ms |
| 2 | 150-300ms |
| 3 | 300-600ms |
| 4 | 450-900ms |

### Performance Tips

1. Use `onlyonce: true` for entrance animations
2. Avoid animating `width`/`height` - use `transform: scale()`
3. Prefer `opacity` and `transform` for smooth animations
4. Keep durations between 300-1000ms
5. Use `animationTimeline` for scroll-based effects instead of JavaScript

### Common Animation Combinations

#### Hero Section
```
Title: clip-right, delay 0
Subtitle: fade-up, delay 300
Description: fade-up, delay 600
Button: fade-up, delay 900
```

#### Card Grid
```
Card 1: fade-up, delay 0
Card 2: fade-up, delay 150
Card 3: fade-up, delay 300
Card 4: fade-up, delay 450
```

#### Gallery
```
Image 1: fade-right, delay 0
Image 2: fade-up, delay 200
Image 3: fade-left, delay 400
```

---

## Complete Example: Combining AOS and Scroll Animations

```html
<!-- Hero Section with AOS animations -->
<!-- wp:greenshift-blocks/element {"id":"gsbp-hero01","type":"inner","localId":"gsbp-hero01","styleAttributes":{"paddingTop":["100px"],"paddingBottom":["100px"]}} -->
<div class="gsbp-hero01">
  <!-- Title with clip animation -->
  <!-- wp:greenshift-blocks/element {"id":"gsbp-hero02","textContent":"Welcome","tag":"h1","animation":{"duration":800,"easing":"ease","type":"clip-right","onlyonce":true},"localId":"gsbp-hero02"} -->
  <h1 data-aos="clip-right" data-aos-easing="ease" data-aos-duration="800" data-aos-once="true" class="gsbp-hero02">Welcome</h1>
  <!-- /wp:greenshift-blocks/element -->

  <!-- Subtitle with delayed fade -->
  <!-- wp:greenshift-blocks/element {"id":"gsbp-hero03","textContent":"Discover Our Services","tag":"p","animation":{"duration":800,"easing":"ease","type":"fade-up","delay":300,"onlyonce":true},"localId":"gsbp-hero03"} -->
  <p data-aos="fade-up" data-aos-delay="300" data-aos-easing="ease" data-aos-duration="800" data-aos-once="true" class="gsbp-hero03">Discover Our Services</p>
  <!-- /wp:greenshift-blocks/element -->
</div>
<!-- /wp:greenshift-blocks/element -->

<!-- Content section with scroll-triggered animation -->
<!-- wp:greenshift-blocks/element {"id":"gsbp-scroll01","textContent":"This appears on scroll","tag":"h2","localId":"gsbp-scroll01","styleAttributes":{"animation_keyframes_Extra":[{"name":"gs_reveal","code":"0%{opacity: 0;scale:0.8;}100%{opacity: 1;scale:1;}"}],"animation":["gs_reveal linear both"],"animationTimeline":["view()"],"animationRange":["entry"]}} -->
<h2 class="gsbp-scroll01">This appears on scroll</h2>
<!-- /wp:greenshift-blocks/element -->
```
