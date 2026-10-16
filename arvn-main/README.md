<p align="center">
  <img src="assets/hero.png" alt="arvn lib" width="100%">
</p>

<h1 align="center">arvn lib</h1>

<p align="center">UI library for Roblox.</p>

<p align="center">
  <a href="docs/getting-started.md">Getting started</a>
  &nbsp;·&nbsp;
  <a href="docs/elements.md">Elements</a>
  &nbsp;·&nbsp;
  <a href="docs/customization.md">Customization</a>
  &nbsp;·&nbsp;
  <a href="docs/resolution.md">Resolution</a>
  &nbsp;·&nbsp;
  <a href="docs/icons.md">Icons</a>
  &nbsp;·&nbsp;
  <a href="docs/examples.md">Examples</a>
  &nbsp;·&nbsp;
  <a href="docs/reference.md">Reference</a>
  &nbsp;·&nbsp;
  <a href="example.lua">Example</a>
  &nbsp;·&nbsp;
  <a href="demo/README.md">Demo</a>
</p>

<br>

```lua
local Arvn = loadstring(game:HttpGet("https://raw.githubusercontent.com/koteqjjjj/arvn/main/arvn.lua"))()
```

<br>

<table>
  <tr>
    <td><img src="assets/player.png" alt="Sections and option menus"></td>
    <td><img src="assets/theme.png" alt="Themes and color picker"></td>
  </tr>
  <tr>
    <td><img src="assets/keybind.png" alt="Keybinds"></td>
    <td><img src="assets/light.png" alt="Light theme"></td>
  </tr>
  <tr>
    <td><img src="assets/search.png" alt="Search"></td>
    <td><img src="assets/home.png" alt="Dashboard"></td>
  </tr>
</table>

## Example

```lua
local Arvn = loadstring(game:HttpGet("https://raw.githubusercontent.com/koteqjjjj/arvn/main/arvn.lua"))()

local Window = Arvn:CreateWindow({Title = "My Script", Author = "you", Folder = "MyScript"})

local Main = Window:Group("Main")
local Player = Main:Tab({Name = "Player", Icon = "user"})
local Movement = Player:Section("Movement")

local speed = Movement:Toggle({Name = "Speed", Keybind = "V", Callback = function(on) end})
Movement:Slider({Name = "Walk Speed", Min = 16, Max = 100, Default = 32, ShowWhen = speed})
Movement:Button({Name = "Reset", Callback = function() end})
```

The full example is in [example.lua](example.lua).

## Resolution and stretch

The menu can scale itself to any screen, confine itself to any aspect ratio,
change its shape and typography, and even stretch the 3D view. Every option is
opt-in and defaults to the original, pixel-perfect behaviour.

```lua
local Window = Arvn:CreateWindow({
	Title = "My Script",
	Resolution = "Scale",       -- Off, Scale, Hybrid, Offset, Pixel
	AspectRatio = "21:9",       -- or 16:9, 4:3, Custom, ...
	AspectFit = "Fit",          -- Stretch, Fit, Fill, Letterbox, Crop, Cover, Center
	Letterbox = true,
	Style = "Glass",            -- Default, Minimal, Glass, Neon, Flat, Material, ...
	WorldStretch = {Ratio = "21:9", FOV = 90},
})
```

See [docs/resolution.md](docs/resolution.md) for the full guide.

## Demo

A single-file playground exercises every option above, next to a tour of the
element set. Hoarcekat stories live beside it.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/koteqjjjj/arvn/main/demo/playground.lua"))()
```

See [demo/README.md](demo/README.md) for the playground and the stories.

## Credits

arvn lib by [koteqjjjj](https://github.com/koteqjjjj). Icons by [Lucide](https://lucide.dev). See [CREDITS.md](CREDITS.md).
