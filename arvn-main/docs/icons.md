# Icons

Pick an icon by writing its name. Names come from the built-in **Lucide** set — the same names as [lucide.dev](https://lucide.dev/icons). A picture snapshot of that set is at the [bottom of this page](#all-icons), and the other families are reachable with a prefix (see [Icon families](#icon-families)).

```lua
Main:Tab({Name = "Aim", Icon = "crosshair"})
Aim:SetIcon("target")
```

Icons work everywhere the menu shows one:

| Where | How |
|---|---|
| tabs and sub-tabs | `Icon = "crosshair"`, or `Tab:SetIcon("crosshair")` |
| built-in pages | `Pages = {Appearance = {Icon = "brush"}}` in `CreateWindow` |
| elements | `Icon = "zap"` on any element, or `SetIcon("zap")` |
| buttons on a row | `Element:AddButton({Icon = "copy", Callback = fn})` |
| notifications and dialogs | `Icon = "bell"` |
| widgets and watermark parts | `Icon = "coins"` |
| the UI button | `UIButton = {Icon = "menu"}` |
| your own UI | `ui.Icon("star", 16, color)` inside `Custom` and `CustomPage` |

## Common picks

| Tab | Icon |
|---|---|
| Aim | `crosshair`, `target` |
| Combat | `swords`, `sword`, `shield` |
| Visuals | `eye`, `scan-eye` |
| Movement | `footprints`, `gauge`, `zap` |
| Player | `user`, `person-standing` |
| World | `globe`, `sun`, `mountain` |
| Teleports | `map-pin`, `compass` |
| Farming | `pickaxe`, `sprout`, `repeat` |
| Shop | `shopping-cart`, `coins`, `gem` |
| Misc | `package`, `sparkles` |
| Settings | `settings`, `sliders-horizontal` |

## Icon families

The default family is **Lucide**, so a plain name like `crosshair` is looked up there. To use one of the other families the Icons library ships, prefix the name with `family:`:

```lua
Main:Tab({Name = "Aim", Icon = "solar:crosshair"})
Main:Tab({Name = "Fun", Icon = "geist:sparkle"})
```

Families: `lucide` (default), `solar`, `geist`, `craft`, `sfsymbols`, `gravity`.

Names don't care about capitals or spaces, so `"Gamepad 2"` works too (prefixed names are passed through as written).

## Your own image

```lua
Main:Tab({Name = "Aim", Icon = "https://files.catbox.moe/abc123.png"})
Main:Tab({Name = "Aim", Icon = "rbxassetid://1234567"})
Main:Tab({Name = "Game", Icon = "thumb:" .. game.PlaceId})
```

- A link must point straight to a PNG or JPG. It is downloaded once, saved, and shown in its own colors.
- Asset ids are colored like the built-in icons. Upload them white on a transparent background.
- `thumb:<place id>` shows that game's icon. `headshot:<user id>` shows a player's avatar.

If a name doesn't exist, the tab gets the default icon and the console shows a warning.

`Arvn:HasIcon(name)` checks whether a name resolves. Browse the names at [lucide.dev](https://lucide.dev/icons).

## All icons

![Icons a to file-json](../assets/icons-1.png)

![Icons file-text to power](../assets/icons-2.png)

![Icons power-off to zoom-out](../assets/icons-3.png)
