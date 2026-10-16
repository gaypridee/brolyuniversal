# Resolution, ratio and stretch

arvn lib can scale itself to any screen and confine itself to any aspect ratio.
Everything here is **opt-in**: on a fresh install the menu behaves exactly like
it did before, pixel for pixel.

- [How it works](#how-it-works)
- [Scaling modes](#scaling-modes)
- [Aspect ratio](#aspect-ratio)
- [Letterbox bars](#letterbox-bars)
- [Avoid the top bar](#avoid-the-top-bar)
- [Device scaling](#device-scaling)
- [Shape and style](#shape-and-style)
- [Typography](#typography)
- [Motion](#motion)
- [World stretch](#world-stretch)
- [Doing it from code](#doing-it-from-code)
- [Reset](#reset)

## How it works

The whole interface (window, overlays, tooltips, notifications, HUD) is laid out
inside a single **virtual viewport**, a frame called `Viewport`. A `UIScale`
maps virtual units to real pixels.

- With the default settings the virtual viewport equals the real screen and the
  scale is `1`, so nothing moves.
- When you turn on a scaling mode, the scale follows your screen so the menu
  keeps the same *relative* size on every device.
- When you pick an aspect ratio, the virtual viewport is a box with that ratio
  and everything is clipped and placed inside it.

You can see all of this live in Settings > Appearance.

## Scaling modes

Settings > Appearance > Resolution > **Scaling Mode**.

| Mode | What it does |
|---|---|
| `Off` | Native pixels. The default. The design size does not matter. |
| `Scale` | Everything scales with the screen width, using **Design Width**. |
| `Hybrid` | Scales by whichever of width or height is smaller, so the UI never overflows. |
| `Offset` | Fixed pixel size, but still confined to the aspect box. |
| `Pixel` | Like `Offset`, meant for crisp pixel-art layouts. |

- **Design Width** / **Design Height** are the resolution you designed at.
  `1920 x 1080` is a good default.
- **Clamp Scale** limits how small or big the scale may get. Handy to stop the
  menu from becoming unreadable on tiny windows or huge on 4K.
- **Pixel Snap** rounds the virtual size so edges stay sharp.

```lua
Arvn:CreateWindow({
	Title = "My Script",
	Resolution = "Scale",
	DesignWidth = 1920,
	DesignHeight = 1080,
	Defaults = {ui_clamp = true, ui_clamp_min = 70, ui_clamp_max = 160},
})
```

## Aspect ratio

Settings > Appearance > Screen Ratio > **Aspect Ratio**.

Pick a preset (`4:3`, `5:4`, `3:2`, `16:10`, `16:9`, `21:9`, `32:9`) or
`Custom` and use the two sliders. `Off` keeps the screen's own ratio.

**Ratio Mode** decides how the box fills the screen:

| Mode | Result |
|---|---|
| `Stretch` | Ignore the ratio, fill the screen. |
| `Fit` / `Letterbox` | The largest box with that ratio that fits inside the screen. |
| `Fill` / `Cover` / `Crop` | The smallest box that covers the screen; the extra is clipped. |
| `Center` | The box at native size, centered. |

**Anchor** chooses where the box sits when it is smaller than the screen.

```lua
Arvn:CreateWindow({
	Title = "My Script",
	AspectRatio = "16:9",
	AspectFit = "Fit",
	AspectAnchor = "Center",
	Letterbox = true,
})
```

## Letterbox bars

When the ratio box is smaller than the screen, turn on **Letterbox Bars** to draw
solid bars over the empty area. **Bar Color** changes them.

## Avoid the top bar

**Avoid Top Bar** keeps the interface below the Roblox top bar instead of under
it. Off by default. When it is on, the letterbox box and all placement use the
area under the top bar.

## Device scaling

**Device Scaling** adds a little scale for the device:

| Value | Effect |
|---|---|
| `Off` | nothing (default) |
| `Auto` | detects touch, console or VR |
| `Compact` | `0.9x` |
| `Touch` | `1.1x` |
| `Console` | `1.15x` |
| `VR` | `1.25x` |

## Shape and style

Settings > Appearance > Shape And Style. These rebuild the menu, so they apply
on the next frame rather than instantly.

- **Component Style** — `Default`, `Minimal`, `Glass`, `Neon`, `Flat`,
  `Material`, `Retro`, `Soft`, `Hard`. Each one adjusts rounding, edge light,
  glass and glow together.
- **Border Style** — `Soft`, `Hard`, `None`, `Inset`, `Outline`, with a
  **Border Width** from 1 to 3.
- **Drop Shadows** — a dark halo under floating surfaces, with **Shadow Size**
  and **Shadow Dark**.
- **Accent Glow** — an accent halo around surfaces, with **Glow Strength**.
- **Card Gradient** — a subtle gradient on cards and panels, with an angle.
- **Tinted Panels** — blends a little accent into panels.

## Typography

- **Text Scale** — scales all menu text.
- **Font Weight** — shifts every weight up or down (`Light` to `Bold`).
- **Icon Scale** — scales icons that are 16px or more, so small chips stay tidy.

## Motion

- **Easing** — the curve used by every transition (`Quint`, `Sine`, `Quad`,
  `Cubic`, `Back`, `Elastic`, `Bounce`, `Linear`).
- **Animation Level** — `Off`, `Reduce` (shorter, capped) or `Strong`
  (longer, livelier).
- **Open Animation** — slide and scale the menu as it opens.
- **Theme Fade** — blend colours smoothly when the theme changes.

## World stretch

Settings > Appearance > World Stretch changes the **3D camera**, not the menu.
It is **off by default** and your original camera is restored when you turn it
off or eject.

- **Stretched View** — master switch.
- **View Ratio** — the ratio to emulate.
- **View Mode** — `Stretch`, `Letterbox` or `Crop`.
- **FOV Axis** — which axis the field of view applies to (`Vertical`,
  `Diagonal`, `MaxAxis`).
- **Field Of View** — the camera field of view while stretched.
- **Include Aim FOV** — reserved for aim-down-sights.

Because Roblox does not expose the render resolution, this uses the camera's
`FieldOfViewMode` and `FieldOfView` to approximate a stretched view. It coexists
with the existing `cam_fov` and `cam_zoom` options; world stretch wins while it
is on.

```lua
Arvn:CreateWindow({
	Title = "My Script",
	WorldStretch = {Ratio = "21:9", Mode = "Stretch", FOV = 90, FOVMode = "MaxAxis"},
})
```

## Doing it from code

```lua
Window:SetResolution("Scale")     -- ui_fit
Window:SetAspect("21:9")          -- ui_aspect
Window:SetAspectFit("Fit")        -- ui_aspect_fit
Window:SetDensity("Spacious")     -- ui_density
Window:SetStyle("Neon")           -- ui_style
Window:SetTextScale(105)          -- ui_font_scale
Window:SetIconScale(110)          -- ui_icon_scale
Window:SetElementScale(95)        -- ui_elem_scale
Window:SetEasing("Back")          -- ui_ease
Window:SetMotion("Reduce")        -- ui_motion
Window:SetWorldStretch(true)      -- ws_on
Window:ResetDisplay()             -- every display option back to default
local res = Window:GetResolution() -- {real, box, origin, virtual, factor, ar, on}
```

`Arvn:SetResolution`, `Arvn:SetAspect`, `Arvn:SetStyle`, `Arvn:SetDensity` and
`Arvn:GetResolution` do the same on the library.

Every option is also a flag, so `Arvn.Flags.ui_fit`, `Arvn:SetFlag("ui_aspect",
"16:9")` and `Arvn:OnFlag("ui_style", fn)` work as usual.

## Reset

Settings > Appearance > Screen Ratio > **Reset Display** puts every scaling,
ratio, style, typography and motion option back to its default.
