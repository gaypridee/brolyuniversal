# Elements

Elements are added to a section: `Section:Toggle({...})`, `Section:Slider({...})` and so on. Each one returns a handle you can use later to read the value, change it, rename it or remove it.

- [Options every element has](#options-every-element-has)
- [Toggle](#toggle)
- [Slider](#slider)
- [Dropdown](#dropdown)
- [Segmented](#segmented)
- [ColorPicker](#colorpicker)
- [Input](#input)
- [Keybind](#keybind)
- [Button](#button)
- [Buttons](#buttons)
- [Label](#label)
- [Paragraph](#paragraph)
- [Info](#info)
- [Progress](#progress)
- [Image](#image)
- [Console](#console)
- [PlayerList](#playerlist)
- [Divider and Spacer](#divider-and-spacer)
- [Custom](#custom)
- [Pages inside a section](#pages-inside-a-section)
- [Conditions](#conditions)
- [Element methods](#element-methods)

## Options every element has

| Option | What it does |
|---|---|
| `Name` | the label |
| `Flag` | the name the value is stored under. See [flags](getting-started.md#flags-reading-and-changing-values). |
| `Description` | text shown when the mouse is over the element. `Tooltip` works too. |
| `Icon` | a small icon before the label. See [Icons](icons.md). |
| `Callback` | your function. It runs every time the value changes. |
| `Risky` | `true` makes the label red, for options that can get a player caught |
| `Locked` | `true` or a reason. The element can't be used, and the reason shows on hover. |
| `Visible` | `false` hides it |
| `ShowWhen` | only visible while a condition is true. See [Conditions](#conditions). |
| `EnableWhen` | visible, but only usable while a condition is true |
| `Keywords` | extra words search should find it by, for example `{"walkspeed", "fast"}` |
| `Save` | `false` keeps the value out of configs and autosave |
| `ResetButton` | `true` shows a small reset button while the value isn't the default |

## Toggle

An on/off switch.

```lua
local fly = Section:Toggle({
	Name = "Fly",
	Default = false,
	Keybind = "F",
	Callback = function(on)
		print(on)
	end,
})
```

| Option | What it does |
|---|---|
| `Default` | `true` or `false` |
| `Keybind` | a key, like `"F"`. Players can change it by right clicking the toggle. |
| `Keybind = {Key = "F", Mode = "Hold"}` | also sets the mode: `"Toggle"`, `"Hold"` (on while held), `"Release"` (off while held) or `"Always"` |
| `Keybind = false` | players can't bind a key to it |
| `Color` | adds a color square next to the switch. Takes a `Color3`, or `{Default = Color3, Alpha = 1, Flag = "name", Callback = function(color, alpha) end}`. |
| `Menu` | adds an arrow that opens a small panel of extra options |
| `MenuTitle` | title of that panel. The toggle's name by default. |

A toggle with a color gives you the color as its own element:

```lua
local box = Section:Toggle({Name = "Highlight", Color = Color3.fromRGB(255, 80, 80)})
print(box.Color:GetColor())
box.Color:Set(Color3.fromRGB(80, 160, 255))
```

A menu can have any elements in it. Each `Card()` is one card in the panel:

```lua
Section:Toggle({Name = "Trail", Menu = function(menu)
	local card = menu.Card()
	card:Slider({Name = "Length", Min = 1, Max = 10, Default = 3})
	card:Dropdown({Name = "Style", Values = {"Line", "Dots"}})

	local more = menu.Card()
	more:ColorPicker({Name = "Color", Default = Color3.fromRGB(255, 255, 255)})
end})
```

Methods: `Toggle()` flips it, `SetKey(key, mode)` and `GetKey()` change and read the keybind, `AddKeybind("K")` adds a keybind later, `AddColor(Color3)` adds a color square later.

## Slider

Picks a number between a minimum and a maximum.

```lua
local fov = Section:Slider({
	Name = "Field of View",
	Min = 30,
	Max = 120,
	Default = 70,
	Step = 1,
	Suffix = "°",
	Callback = function(value) end,
})
```

| Option | What it does |
|---|---|
| `Min`, `Max` | the range. `0` and `100` by default. |
| `Default` | the starting value. `Min` by default. |
| `Step` | the gap between values, like `1`, `0.1` or `5`. `Rounding = 2` means two decimals. |
| `Suffix` | text after the number, like `"%"`, `"s"` or `" studs"` |
| `MaxLabel` | text shown instead of the number at the maximum, like `"Unlimited"` |
| `Live` | `false` runs the callback only when the mouse is let go |

Players can click the number to type a value.

Change the range at any time. The current value is moved into the new range if it's outside it.

```lua
fov:SetMax(1000)
fov:SetMin(1)
fov:SetRange(10, 500)
fov:SetStep(5)
fov:SetSuffix(" studs")
```

## Dropdown

Picks one value from a list, or several with `Multi`.

```lua
Section:Dropdown({Name = "Hitbox", Values = {"Head", "Torso", "Legs"}, Default = "Head"})
Section:Dropdown({Name = "Parts", Values = {"Head", "Torso", "Legs"}, Multi = true, Default = {"Head"}})
```

| Option | What it does |
|---|---|
| `Values` | the list. It can also be a function that returns a list, an `Enum` like `Enum.Material`, or an Instance, which lists the names of its children. |
| `Default` | a value, or its number in the list. With `Multi`, a list of values. |
| `Multi` | `true` lets players pick several values. The value is then a list. |
| `Special` | `"Players"` lists the players in the server, `"Teams"` lists the teams. Both update by themselves. |
| `ExcludeSelf` | with `Special = "Players"`, `false` also lists you |
| `Placeholder` | text shown while nothing is picked |
| `Width` | width of the box in pixels |
| `ListWidth` | minimum width of the dropdown popup list |
| `Search` | `false` hides the search filter box (enabled by default) |
| `SearchPlaceholder` | placeholder text for the search box (defaults to `"Search..."`) |
| `SelectAll` | `false` hides the Select All / Deselect All toolbar in multi-choice dropdowns |

Dropdowns include a built-in search box. Multi-choice dropdowns also include quick **Select All** and **Deselect All** buttons.

```lua
local target = Section:Dropdown({Name = "Player", Special = "Players"})
local material = Section:Dropdown({Name = "Material", Values = Enum.Material, Default = "Plastic"})
local shops = Section:Dropdown({Name = "Shop", Values = workspace.Shops})
```

Change the list or selection later:

```lua
shops:SetValues({"One", "Two"})
shops:AddValues({"Three"})
shops:RemoveValues({"One"})
shops:SetValues({"Only"}, false)
parts:SelectAll()
parts:DeselectAll()
```

`SetValues(list, false)` also clears the picked value if it isn't in the new list.

## Segmented

A row of buttons where one is picked. Good for two to four short choices.

```lua
Section:Segmented({Name = "Mode", Values = {"Legit", "Rage"}, Default = "Legit", Callback = function(mode) end})
```

## ColorPicker

```lua
local color = Section:ColorPicker({
	Name = "Color",
	Default = Color3.fromRGB(255, 80, 80),
	Alpha = 1,
	Callback = function(color, alpha) end,
})
```

| Option | What it does |
|---|---|
| `Default` | a `Color3` or a hex string like `"#FF5050"` |
| `Alpha` | how visible the color is, from `0` to `1`. `Transparency` works too, the other way around. |

The picker has hue, shade and transparency controls, HEX, RGB and HSV input, recent colors, and copy and paste. Changes apply while you drag.

The value is stored as a hex string like `"#FF5050FF"`. Use `GetColor()` for a `Color3`:

```lua
local c, alpha = color:GetColor()
color:Set(Color3.fromRGB(0, 200, 255))
color:Set("#00C8FF")
```

## Input

A text box.

```lua
Section:Input({Name = "Message", Placeholder = "Type here", Callback = function(text) end})
Section:Input({Name = "Amount", Numeric = true, Min = 1, Max = 100, Default = "10", Callback = function(number) end})
```

| Option | What it does |
|---|---|
| `Default` | the starting text |
| `Placeholder` | grey text shown while it's empty |
| `Numeric` | `true` passes a number to the callback, and ignores text that isn't a number |
| `Min`, `Max` | limits for numbers |
| `MaxLength` | the most characters allowed |
| `Live` | `true` runs the callback on every key. By default it runs when the player presses Enter or clicks away. |
| `Width` | width of the box in pixels |

## Keybind

A key that runs your code. Unlike a toggle, it has no on/off switch.

```lua
Section:Keybind({Name = "Teleport", Default = "T", Callback = function() end})
Section:Keybind({Name = "Sprint", Default = "LeftShift", Mode = "Hold", Callback = function(held) end})
Section:Keybind({Name = "Zoom", Default = "Z", Mode = "Toggle", Callback = function(on) end})
```

| Option | What it does |
|---|---|
| `Default` | a key name like `"T"`, `"LeftShift"` or `"MouseButton2"`. `"None"` means no key. |
| `Mode` | `"Press"` runs the callback once. `"Hold"` passes `true` when pressed and `false` when let go. `"Toggle"` passes `true` and `false` on every other press. |
| `ChangedCallback` | runs when the player picks a different key |

`Get()` returns the key name.

## Button

```lua
Section:Button({Name = "Rejoin", Icon = "refresh-cw", Callback = function() end})
Section:Button({Name = "Delete Save", Danger = true, Confirm = true, Callback = function() end})
```

| Option | What it does |
|---|---|
| `Danger` | red style, for things that can't be undone. `Variant = "Danger"` works too. |
| `Confirm` | the first click asks "are you sure", the second click runs it |
| `Cooldown` | seconds before it can be clicked again |
| `Keybind` | a key that presses the button |

Run it from code with `Press()`. Add more functions with `OnClick(fn)`.

## Buttons

Several buttons side by side in one row.

```lua
Section:Buttons({
	{Name = "Save", Callback = function() end},
	{Name = "Load", Callback = function() end},
	{Name = "Delete", Description = "Delete this save", Callback = function() end},
})
```

## Label

Plain text.

```lua
Section:Label("Plain text")
local status = Section:Label({Text = "Not connected", Style = "Danger", Align = "Center"})
status:SetText("Connected")
```

| Option | What it does |
|---|---|
| `Style` | `"Muted"`, `"Info"`, `"Success"`, `"Warning"` or `"Danger"` |
| `Align` | `"Left"`, `"Center"` or `"Right"` |
| `Wrap` | `false` keeps it on one line |

Labels support rich text, like `<b>bold</b>` and `<font color="#FF5050">red</font>`.

## Paragraph

A title with longer text under it.

```lua
local about = Section:Paragraph({Title = "About", Body = "Longer text that wraps onto more lines."})
about:SetBody("New text.")
```

## Info

A name on the left and a value on the right. Good for live stats.

```lua
local kills = Section:Info({Name = "Kills", Value = "0"})
kills:Set(12)
```

## Progress

A bar.

```lua
local bar = Section:Progress({Name = "Farming", Value = 0, Max = 100})
bar:Set(40)
```

Without `Max`, the value goes from `0` to `1`.

## Image

```lua
Section:Image({Source = "rbxassetid://123456", Height = 140, Caption = "Map"})
Section:Image({Source = "https://files.catbox.moe/example.png", Fit = "Fit"})
Section:Image({Source = "thumb:" .. game.PlaceId, Height = 120})
```

| Option | What it does |
|---|---|
| `Source` | an asset id, a direct PNG or JPG link, `"headshot:<user id>"` for an avatar, or `"thumb:<place id>"` for a game icon |
| `Height` | height in pixels. `120` by default. |
| `Fit` | `"Crop"`, `"Fit"`, `"Stretch"` or `"Tile"` |
| `Caption` | small text under the image |
| `Tint` | a `Color3` the image is colored with |
| `Transparency` | from `0` to `1` |
| `Callback` | makes the image clickable |

Links are downloaded once and saved, so they load instantly next time. Change the picture with `SetSource(source)`.

## Console

A scrolling log.

```lua
local log = Section:Console({Height = 180, MaxLines = 200})
log:Log("Started")
log:Success("Bought item")
log:Warn("Low money")
log:Error("Could not reach the shop")
log:Clear()
log:Copy()
```

| Option | What it does |
|---|---|
| `Height` | height in pixels |
| `MaxLines` | old lines are removed after this many |
| `Timestamps` | `false` hides the time before each line |
| `Empty` | text shown while there are no lines |

## PlayerList

A list of everyone in the server with their avatar. It updates by itself.

```lua
Section:PlayerList()
```

## Divider and Spacer

```lua
Section:Divider("Advanced")
Section:Divider()
Section:Spacer(12)
```

## Custom

An empty space inside the card that you fill with your own UI. See [Your own elements](customization.md#your-own-elements).

```lua
Section:Custom({Name = "Health", Height = 30, Build = function(frame, ui)
	local bar = ui.Frame({Size = UDim2.fromScale(0.7, 1), BackgroundColor3 = ui.Accent(), Parent = frame})
	ui.Corner(bar, 6)
end})
```

## Pages inside a section

A section can have pages. Players switch between them with small tabs at the top of the card.

```lua
local Weapons = Tab:Section("Weapons")
local rifle = Weapons:Page("Rifle")
local pistol = Weapons:Page("Pistol")

rifle:Toggle({Name = "Enabled", Flag = "rifle_on"})
rifle:Slider({Name = "Range", Min = 10, Max = 500, Default = 100})
pistol:Toggle({Name = "Enabled", Flag = "pistol_on"})
```

Or name the pages when making the section, and get them after:

```lua
local Modes = Tab:Section({Name = "Modes", Pages = {"Easy", "Hard"}})
Modes:GetPage("Easy"):Slider({Name = "Speed", Min = 1, Max = 10, Default = 3})
Modes:GetPage("Hard"):Slider({Name = "Speed", Min = 1, Max = 50, Default = 20})
```

## Conditions

`ShowWhen` hides an element until something is true. `EnableWhen` keeps it visible but greyed out. Both also work on sections and tabs (`ShowWhen` only).

```lua
local fly = Section:Toggle({Name = "Fly", Flag = "fly"})
Section:Slider({Name = "Fly Speed", Min = 1, Max = 200, ShowWhen = fly})
```

A condition can be:

| Form | True when |
|---|---|
| `fly` | that toggle is on |
| `"fly"` | that flag is on |
| `{mode = "Rage"}` | the flag `mode` equals `"Rage"` |
| `{mode = {"Rage", "Semi"}}` | the flag `mode` is one of these |
| `{fly = true, mode = "Rage"}` | all of them are true |
| `function(flags) return flags.speed > 50 end` | your function returns `true` |

## Element methods

Every element handle has these:

| Method | What it does |
|---|---|
| `Get()` | the value. `el.Value` works too. |
| `Set(value)` | changes the value and runs the callback |
| `Set(value, true)` | changes the value without running the callback |
| `Reset()` | back to the default value |
| `IsDefault()` | `true` if the value is the default |
| `OnChanged(fn)` | runs `fn` when the value changes. Returns something with `Disconnect()`. |
| `SetCallback(fn)` | replaces the callback |
| `SetName(text)` | changes the label |
| `SetDescription(text)` | changes the hover text |
| `SetIcon(icon)` | changes the icon |
| `SetVisible(bool)` | shows or hides it |
| `Lock(reason)`, `Unlock()`, `IsLocked()` | greys it out so it can't be used |
| `MoveUp()`, `MoveDown()`, `MoveTo(index)` | changes its place in the section |
| `AddButton({Icon, Tooltip, Callback})` | adds a small icon button on the right of the row |
| `Highlight()` | flashes the row |
| `Reveal()` | opens the menu on the element's page and scrolls to it |
| `Destroy()` | removes it |

Some methods only exist on some elements:

| Element | Methods |
|---|---|
| Toggle | `Toggle()`, `SetKey(key, mode)`, `GetKey()`, `AddKeybind(key)`, `AddColor(color)` |
| Slider | `SetMin`, `SetMax`, `SetRange(min, max)`, `SetStep`, `SetSuffix` |
| Dropdown, Segmented | `SetValues(list, keep)`, `AddValues(list)`, `RemoveValues(list)` |
| ColorPicker | `GetColor()` returns a `Color3` and the alpha |
| Button | `Press()`, `OnClick(fn)` |
| Label | `SetText(text)` |
| Paragraph | `SetBody(text)` |
| Info, Progress | `Set(value)` |
| Image | `SetSource(source)` |
| Console | `Log`, `Success`, `Warn`, `Error`, `Clear`, `Copy` |

Find any element later by its flag, including the built-in ones:

```lua
local watermark = Arvn:GetElement("ov_wm")
watermark:Set(false)
```
