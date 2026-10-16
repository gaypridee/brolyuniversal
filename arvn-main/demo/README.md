# Demo

Two ways to try arvn lib without writing a script from scratch.

## Playground

[`playground.lua`](playground.lua) is a single window that puts the whole
display system on screen next to a tour of the element set. Every control is
wired to a public method, so the file doubles as a reference.

Run it from any executor or script hub:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/koteqjjjj/arvn/main/demo/playground.lua"))()
```

Or paste it into a `LocalScript` in Studio.

It has five tabs:

| Tab | What it shows |
|---|---|
| **Home** | One-click display presets — Laptop, Cinema, Pixel. |
| **Display** | Scaling mode, device scaling, design size, clamps, pixel snap, aspect ratio, ratio mode, anchor, letterbox bars, component style, borders, shadows, glow, gradients, typography, spacing and motion — all live. |
| **Camera** | World stretch, with the camera restored on demand. |
| **Elements** | Every element type: toggle, slider, dropdown, multi-dropdown, segmented, color picker, input, keybind, button, buttons, label, paragraph, info, progress, console, divider, image and player list. |
| **About** | Links and an eject button. |

## Hoarcekat stories

[`stories/`](stories) holds [Hoarcekat](https://github.com/Kampfkarren/hoarcekat)
stories, one per theme:

| Story | What it shows |
|---|---|
| `playground.story.luau` | A compact version of the playground. |
| `resolution.story.luau` | Scaling modes and aspect ratios, with an automatic tour. |
| `style.story.luau` | Shape, typography, motion, themes and accents. |
| `worldstretch.story.luau` | The world stretch camera, with restore. |

### Using them

1. Import the `stories` folder as ModuleScripts. Each file becomes a ModuleScript
   named after the file, for example `playground.story`.
2. Enable **Game Settings → Security → Allow HTTP Requests**. The stories fetch
   the library from GitHub the same way a script hub does.
3. Open the Hoarcekat plugin and pick a story.

The library draws into its own `ScreenGui`, so the stories ignore Hoarcekat's
preview frame and open a real window. When the story unmounts, it ejects the
library and the camera is restored.

If your workflow loads the library some other way, set `_G.Arvn` to a preloaded
library before a story runs and it will be used instead of the download.
