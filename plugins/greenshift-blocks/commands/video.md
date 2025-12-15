---
description: Create a video block for WordPress Greenshift - native, YouTube, Vimeo, or lightbox
argument-hint: [type: native|youtube|vimeo|lightbox] [video URL or leave empty]
---

# Greenshift Video Generator

Generate video blocks for various sources and display types. Supports native HTML5 video, YouTube embeds, Vimeo embeds, and video lightbox popups.

## Instructions

1. Read the `greenshift-blocks` skill documentation, specifically `docs/08-variations.md` for video blocks
2. Generate video block according to: $ARGUMENTS

## Video Types

### Native Video
- HTML5 video element
- Self-hosted MP4/WebM
- Full control over playback
- Best for background videos

### YouTube Embed
- Embed via iframe
- Auto-converts URL to embed format
- Good for background or inline
- `isVariation: "youtubeplay"`

### Vimeo Embed
- Embed via iframe
- Auto-converts URL to embed format
- Professional video hosting
- `isVariation: "vimeoplay"`

### Video Lightbox
- Thumbnail with play button
- Video opens in popup
- Animated pulse effect
- `isVariation: "videolightbox"`

---

## Native Video Block

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-XXXXXXX","tag":"video","localId":"gsbp-XXXXXXX","src":"https://example.com/video.mp4","loop":true,"controls":true,"autoplay":false,"muted":false,"playsinline":true,"originalWidth":1920,"originalHeight":1080} -->
<video loop controls playsinline><source src="https://example.com/video.mp4" type="video/mp4"/></video>
<!-- /wp:greenshift-blocks/element -->
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `src` | String | Video URL |
| `loop` | Boolean | Loop video |
| `controls` | Boolean | Show playback controls |
| `autoplay` | Boolean | Auto start (requires muted) |
| `muted` | Boolean | Mute audio |
| `playsinline` | Boolean | Inline playback on mobile |
| `originalWidth` | Number | Original video width |
| `originalHeight` | Number | Original video height |

### Styling for Native Video
```json
{
  "styleAttributes": {
    "width": ["100%"],
    "height": ["auto"],
    "aspectRatio": ["16/9"],
    "objectFit": ["cover"],
    "borderRadius": ["var(--wp--custom--border-radius--small, 10px)"]
  }
}
```

---

## YouTube Embed Block

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-XXXXXXX","tag":"iframe","localId":"gsbp-XXXXXXX","src":"https://www.youtube.com/embed/VIDEO_ID?autoplay=1&mute=1&loop=1&playlist=VIDEO_ID","dynamicAttributes":[{"name":"allow","value":"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"},{"name":"allowfullscreen","value":"true"}],"styleAttributes":{"aspectRatio":["16/9"],"display":["block"],"objectFit":["cover"],"width":["100%"]},"isVariation":"youtubeplay"} -->
<iframe class="gsbp-XXXXXXX" src="https://www.youtube.com/embed/VIDEO_ID" frameborder="0" loading="lazy" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
<!-- /wp:greenshift-blocks/element -->
```

### URL Conversion

| Input URL | Embed URL |
|-----------|-----------|
| `youtube.com/watch?v=ABC123` | `youtube.com/embed/ABC123` |
| `youtu.be/ABC123` | `youtube.com/embed/ABC123` |

### Background Video Parameters
Add to embed URL for background use:
- `?autoplay=1` - Auto start
- `&mute=1` - Muted (required for autoplay)
- `&loop=1` - Loop video
- `&playlist=VIDEO_ID` - Required for loop
- `&controls=0` - Hide controls
- `&showinfo=0` - Hide title

### Disable Interaction (Background)
```json
{
  "styleAttributes": {
    "pointerEvents": ["none"]
  }
}
```

---

## Vimeo Embed Block

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-XXXXXXX","tag":"iframe","localId":"gsbp-XXXXXXX","src":"https://player.vimeo.com/video/VIDEO_ID?background=1&autoplay=1&loop=1&muted=1","dynamicAttributes":[{"name":"allow","value":"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"},{"name":"allowfullscreen","value":"true"}],"styleAttributes":{"aspectRatio":["16/9"],"display":["block"],"objectFit":["cover"],"width":["100%"]},"isVariation":"vimeoplay"} -->
<iframe class="gsbp-XXXXXXX" src="https://player.vimeo.com/video/VIDEO_ID" frameborder="0" loading="lazy" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
<!-- /wp:greenshift-blocks/element -->
```

### URL Conversion

| Input URL | Embed URL |
|-----------|-----------|
| `vimeo.com/123456789` | `player.vimeo.com/video/123456789` |

### Background Video Parameters
- `?background=1` - Background mode (no controls)
- `&autoplay=1` - Auto start
- `&loop=1` - Loop video
- `&muted=1` - Muted

---

## Video Lightbox Block

Thumbnail with animated play button that opens video in popup.

### Structure
```
.gs_videolightbox (container)
├── button.play_button_pulse
│   └── svg (play icon)
└── img (video thumbnail)
```

### Container Parameters
```json
{
  "isVariation": "videolightbox",
  "className": "gs_videolightbox_XXX",
  "dynamicAttributes": [{"name": "data-type", "value": "video-lightbox-component"}],
  "interactionLayers": [{
    "actions": [{"actionname": "lightbox"}],
    "env": "no-action",
    "triggerData": {"trigger": "click"}
  }],
  "styleAttributes": {
    "position": ["relative"],
    "display": ["flex"],
    "justifyContent": ["center"],
    "alignItems": ["center"]
  }
}
```

### Play Button with Pulse Animation

dynamicGClasses for animated pulse:
```json
{
  "dynamicGClasses": [{
    "value": "gs_videolightbox_XXX",
    "selectors": [
      {
        "value": " .play_button_pulse",
        "attributes": {
          "styleAttributes": {
            "position": ["absolute"],
            "width": ["80px"],
            "height": ["80px"],
            "borderRadius": ["50%"],
            "backgroundColor": ["#ff0000"],
            "border": ["none"],
            "cursor": ["pointer"],
            "display": ["flex"],
            "alignItems": ["center"],
            "justifyContent": ["center"],
            "zIndex": ["1"]
          }
        }
      },
      {
        "value": " .play_button_pulse::before",
        "attributes": {
          "styleAttributes": {
            "content": ["\"\""],
            "borderRadius": ["50%"],
            "animation": ["pulse-ring 2s cubic-bezier(0.215, 0.61, 0.355, 1) infinite"],
            "position": ["absolute"],
            "inset": ["0"],
            "borderWidth": ["1px"],
            "borderStyle": ["solid"],
            "borderColor": ["#ff0000"]
          }
        }
      },
      {
        "value": " .play_button_pulse::after",
        "attributes": {
          "styleAttributes": {
            "content": ["\"\""],
            "borderRadius": ["50%"],
            "animation": ["pulse-ring 2s cubic-bezier(0.215, 0.61, 0.355, 1) infinite 0.5s"],
            "position": ["absolute"],
            "inset": ["0"],
            "borderWidth": ["1px"],
            "borderStyle": ["solid"],
            "borderColor": ["#ff0000"]
          }
        }
      }
    ]
  }]
}
```

### Play Icon SVG
```html
<svg viewBox="0 0 100 100" width="100" height="100">
  <polygon points="30,20 30,80 70,50" fill="#ffffff"/>
</svg>
```

### Thumbnail Image
```json
{
  "tag": "img",
  "src": "https://placehold.co/1280x720",
  "alt": "Video thumbnail",
  "styleAttributes": {
    "aspectRatio": ["16/9"],
    "objectFit": ["cover"],
    "width": ["100%"],
    "borderRadius": ["var(--wp--custom--border-radius--small, 10px)"]
  }
}
```

---

## Audio Block (Bonus)

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-XXXXXXX","tag":"audio","localId":"gsbp-XXXXXXX","src":"https://example.com/audio.mp3","controls":true} -->
<audio controls><source src="https://example.com/audio.mp3" type="audio/mpeg"/></audio>
<!-- /wp:greenshift-blocks/element -->
```

---

## Common Video Aspect Ratios

| Ratio | Use Case |
|-------|----------|
| 16/9 | Standard widescreen |
| 4/3 | Classic format |
| 1/1 | Square (social) |
| 9/16 | Vertical/mobile |
| 21/9 | Cinematic |

## Output Requirements

- Return ONLY Greenshift block HTML code
- Use appropriate isVariation for embed types
- Include proper allow attributes for iframes
- Each element needs unique ID (gsbp-XXXXXXX)
- Include loading="lazy" for iframes
- For lightbox, include interactionLayers and dynamicGClasses
- Use placeholder thumbnail for lightbox if no image provided
