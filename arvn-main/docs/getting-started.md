# Getting started

This page walks through a full script, from the first line to a finished menu. Every step has code you can copy.

- [Load the library](#load-the-library)
- [Create the window](#create-the-window)
- [Groups, tabs and sections](#groups-tabs-and-sections)
- [Add elements](#add-elements)
- [Flags: reading and changing values](#flags-reading-and-changing-values)
- [Callbacks](#callbacks)
- [Saving](#saving)
- [Changing the game safely](#changing-the-game-safely)
- [What every window already has](#what-every-window-already-has)
- [Key system](#key-system)
- [Reset](#reset)
- [Credits](#credits)
- [A complete script](#a-complete-script)

## Load the library

```lua
local Arvn = loadstring(game:HttpGet("https://raw.githubusercontent.com/koteqjjjj/arvn/main/arvn.lua"))()
```

`Arvn` is the library, and everything starts from it.

Running your script again replaces the old menu, so you don't need to eject it first.

## Create the window

```lua
local Window = Arvn:CreateWindow({
	Title = "My Script",
	Author = "your name",
	Version = "1.0",
	Folder = "MyScript",
})
```

| Option | What it does |
|---|---|
| `Title` | name in the sidebar, the watermark and the About section |
| `Author` | your name, shown in Settings > General > About |
| `Version` | shown in About |
| `Folder` | folder in the executor's `workspace` where this script saves settings, configs and pictures. Give every script its own folder. |

The menu opens and closes with **Right Shift**. Change it with `MenuKey = "Insert"`. Players can pick their own key in Settings > General.

There are many more options, for example the theme, the size and which built-in parts show. They are all listed in [Customization](customization.md#window-options).

## Groups, tabs and sections

The sidebar has groups. A group holds tabs. A tab is a page, and a page holds sections. A section is a card with elements in it.

```
Window
  Group         a heading in the sidebar, for example "Main"
    Tab         a page, for example "Player"
      SubTab    optional: a tab inside a tab
      Section   a card on the page, for example "Movement"
        Element a toggle, slider, button and so on
```

```lua
local Main = Window:Group("Main")

local Player = Main:Tab({Name = "Player", Icon = "user"})
local Movement = Player:Section("Movement")
local Camera = Player:Section({Name = "Camera", Side = "Right"})
```

- A page has two columns. Without `Side`, a section goes into the shorter column.
- `Icon` takes a Lucide name from the [icon list](icons.md), a prefixed name from another family like `"solar:star"`, or your own image link.
- `Window:Tab({...})` makes a tab that isn't under a heading.

### Tabs inside tabs

A tab can hold sub-tabs instead of sections. The sidebar shows them under the tab, which opens with an arrow.

```lua
local Visuals = Main:Tab({Name = "Visuals", Icon = "eye"})
local Players = Visuals:SubTab({Name = "Players", Icon = "users"})
local World = Visuals:SubTab({Name = "World", Icon = "globe"})

Players:Section("Options"):Toggle({Name = "Enabled"})
```

### Pages inside a section

A section can switch between pages, like small tabs inside the card:

```lua
local Weapons = Player:Section({Name = "Weapons", Pages = {"Rifle", "Pistol"}})
```

See [Elements](elements.md#pages-inside-a-section) for how to fill them.

## Add elements

```lua
local speed = Movement:Toggle({
	Name = "Speed",
	Description = "Walk faster.",
	Keybind = "V",
	Callback = function(on)
		print("Speed is", on)
	end,
})

Movement:Slider({
	Name = "Walk Speed",
	Flag = "walk_speed",
	Min = 16,
	Max = 100,
	Default = 32,
	Suffix = " studs",
	Callback = function(value)
		print("Walk speed is", value)
	end,
})

Movement:Dropdown({
	Name = "Mode",
	Values = {"Walk", "Run", "Fly"},
	Default = "Walk",
})

Movement:Button({
	Name = "Reset Speed",
	Callback = function()
		Arvn:Notify({Title = "Speed", Content = "Back to normal."})
	end,
})
```

- `Description` is shown when the mouse is over the element.
- `Keybind` binds a key to a toggle. Players can change it with right click.
- Every element and all of its options are in [Elements](elements.md).

## Flags: reading and changing values

Every element stores its value under a name called a flag. You set it with `Flag = "walk_speed"`. Without `Flag`, a name is made from the tab, the section and the element name.

Read and change values with `Arvn.Flags`, or with the element itself:

```lua
print(Arvn.Flags.walk_speed)
Arvn.Flags.walk_speed = 50

print(speed:Get())
speed:Set(true)
speed:Set(false, true)
```

- Changing a value moves the control in the menu and runs the callback.
- `Set(value, true)` changes the value without running the callback.

Give a flag to anything you read in your own code. With a fixed flag, saved values keep working after you rename the element.

## Callbacks

`Callback` runs every time the value changes. That includes a player clicking, a keybind, a config loading and your code calling `Set`.

```lua
Movement:Toggle({Name = "Infinite Jump", Flag = "inf_jump", Callback = function(on)
	print(on)
end})
```

Other ways to react to a value:

```lua
local conn = speed:OnChanged(function(on) print("changed", on) end)
conn:Disconnect()

Arvn:OnFlag("walk_speed", function(value) print(value) end)

speed:SetCallback(function(on) print("new callback", on) end)
```

An error in a callback never breaks the menu. Errors are collected in `Arvn.Errors`. To get them as notifications while you work on the script, use `ShowErrors = true` in `CreateWindow`.

## Saving

Everything saves by itself, with no code from you:

- the value of every element, including elements inside option menus and section pages
- keybinds and their modes
- the theme, colors and every setting
- the window size and position, and where the overlays are on screen

Players can also save named configs in Settings > Configs, pick one to load on start, and share a setup as a code.

To keep an element out of saves, give it `Save = false`.

To save your own data with the settings:

```lua
Arvn.Config:Set("kills", 10)
print(Arvn.Config:Get("kills", 0))
```

## Changing the game safely

When a player ejects the menu, the game should go back to how it was. The library handles this if you use these helpers.

`Patch` changes a property and remembers the original, and `Restore` puts it back. Eject restores everything that is still patched.

```lua
local humanoid = game.Players.LocalPlayer.Character.Humanoid

Arvn:Patch(humanoid, "WalkSpeed", 50)
Arvn:Restore(humanoid, "WalkSpeed")
Arvn:Restore(humanoid)
```

`Restore` without a property puts back everything patched on that object.

`Connect`, `Loop` and `Track` stop or clean up on eject:

```lua
Arvn:Connect(game:GetService("RunService").Heartbeat, function(dt) end)

local stop = Arvn:Loop(function()
	print("every second")
end, 1)
stop()

local part = Arvn:Track(Instance.new("Part"))

Arvn:OnEject(function()
	print("menu closed for good")
end)
```

On eject every toggle is turned off, which runs its callback with `false`. If your toggles undo their own work when turned off, eject cleans up by itself.

## What every window already has

- Settings pages: General, Appearance, Overlays, Profile, Sounds and Configs
- search over every element, with `Ctrl + F`
- a watermark, a keybind list and optional keystrokes
- notifications with sounds
- a UI button on screen that opens and closes the menu, for mobile players and anyone who forgets the key
- minimize and close buttons in the header
- the executor name in the watermark and in About
- autosave

Turn any of them off:

```lua
Arvn:CreateWindow({
	Title = "My Script",
	Watermark = false,
	Keybinds = false,
	UIButton = false,
	Search = false,
	Sounds = false,
	Notifications = false,
	Pages = {Profile = false, Sounds = false},
})
```

Players can turn these back on in Settings, and their choice is saved.

Three optional pages stay off unless you turn them on:

| Option | Page |
|---|---|
| `Dashboard = true` | a home page with player and server info |
| `Server = true` | server info, the player list and rejoin options |
| `Tools = true` | FPS unlock, Potato Mode, anti AFK and other utilities |

## Key system

Ask for a key before the menu loads:

```lua
Arvn:CreateWindow({
	Title = "My Script",
	KeySystem = {
		Title = "My Script Key",
		Note = "Get a key from the link.",
		Keys = {"key-one", "key-two"},
		Link = "https://example.com/get-key",
	},
})
```

| Option | What it does |
|---|---|
| `Keys` | the keys that work, as a list or a single string |
| `Check` | your own check instead of `Keys`: `function(key) return key == "abc" end` |
| `Link` | the `Get Key` button copies this |
| `Title`, `Note`, `Placeholder` | the text in the key window |
| `Wrong` | the message for a wrong key |
| `SaveKey` | `false` asks for the key every time. By default a correct key is saved and not asked for again. |

Nothing else loads until the key is correct.

## Reset

Settings > Configs has two buttons:

- **Reset Settings** puts every option back to default and keeps the saved configs.
- **Reset Everything** also deletes everything saved in the script's `Folder`: configs, autosave, the window position and pictures.

Settings > Appearance also has small reset buttons. They show up next to any option that was changed, and next to the title of each section.

To give your own elements a reset button, add `ResetButton = true` to the element or to the section.

If your script saves its own files, delete them when a player resets:

```lua
Arvn:OnReset(function()
	if isfile("MyScript/stats.json") then delfile("MyScript/stats.json") end
end)
```

## Credits

Put your name in `Author`, and anyone else in `Credits`:

```lua
Arvn:CreateWindow({
	Title = "My Script",
	Author = "you",
	Credits = {{"UI Design", "friend"}, {"Testing", "someone"}},
})
```

They show in Settings > General > About, above the arvn lib credit.

## A complete script

```lua
local Arvn = loadstring(game:HttpGet("https://raw.githubusercontent.com/koteqjjjj/arvn/main/arvn.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Arvn:CreateWindow({
	Title = "My Script",
	Author = "you",
	Version = "1.0",
	Folder = "MyScript",
	Theme = "Blue",
})

local Main = Window:Group("Main")
local Player = Main:Tab({Name = "Player", Icon = "user"})
local Movement = Player:Section("Movement")

local function humanoid()
	local character = LocalPlayer.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local speed = Movement:Toggle({Name = "Speed", Flag = "speed", Keybind = "V", Callback = function(on)
	local h = humanoid()
	if not h then return end
	if on then
		Arvn:Patch(h, "WalkSpeed", Arvn.Flags.speed_value)
	else
		Arvn:Restore(h, "WalkSpeed")
	end
end})

Movement:Slider({Name = "Speed Value", Flag = "speed_value", Min = 16, Max = 200, Default = 50, ShowWhen = speed, Callback = function(value)
	local h = humanoid()
	if h and Arvn.Flags.speed then Arvn:Patch(h, "WalkSpeed", value) end
end})

Arvn:Connect(LocalPlayer.CharacterAdded, function(character)
	local h = character:WaitForChild("Humanoid")
	if Arvn.Flags.speed then Arvn:Patch(h, "WalkSpeed", Arvn.Flags.speed_value) end
end)

local Misc = Main:Tab({Name = "Misc", Icon = "misc"})
Misc:Section("Server"):Button({Name = "Rejoin", Icon = "refresh-cw", Callback = function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end})
```

## Next

- [Elements](elements.md): every element and its options
- [Customization](customization.md): themes, colors, fonts, layout and built-in parts
- [Icons](icons.md): every icon, and how to use your own
- [Examples](examples.md): things most scripts need
- [Reference](reference.md): every method in one place
