# Examples

Short pieces of code for things most scripts need. Each one assumes you already have `Arvn` and `Window` from [Getting started](getting-started.md).

- [Walk speed and jump power](#walk-speed-and-jump-power)
- [Teleport to a player](#teleport-to-a-player)
- [A loop that runs while a toggle is on](#a-loop-that-runs-while-a-toggle-is-on)
- [Hold a key to use something](#hold-a-key-to-use-something)
- [Options that only show when needed](#options-that-only-show-when-needed)
- [Stats on screen](#stats-on-screen)
- [A log of what the script did](#a-log-of-what-the-script-did)
- [Ask before doing something](#ask-before-doing-something)
- [A notification with buttons](#a-notification-with-buttons)
- [Configs for each game](#configs-for-each-game)
- [Save your own data](#save-your-own-data)
- [A locked tab](#a-locked-tab)
- [A settings tab for your script](#a-settings-tab-for-your-script)
- [Your own look](#your-own-look)

## Walk speed and jump power

Changes stay after respawning and are undone on eject.

```lua
local LocalPlayer = game:GetService("Players").LocalPlayer
local Movement = Window:Group("Main"):Tab({Name = "Player", Icon = "user"}):Section("Movement")

local function humanoid()
	local character = LocalPlayer.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function apply()
	local h = humanoid()
	if not h then return end
	if Arvn.Flags.speed_on then Arvn:Patch(h, "WalkSpeed", Arvn.Flags.speed) else Arvn:Restore(h, "WalkSpeed") end
	if Arvn.Flags.jump_on then Arvn:Patch(h, "JumpPower", Arvn.Flags.jump) else Arvn:Restore(h, "JumpPower") end
end

Movement:Toggle({Name = "Speed", Flag = "speed_on", Keybind = "V", Callback = apply})
Movement:Slider({Name = "Speed", Flag = "speed", Min = 16, Max = 250, Default = 60, ShowWhen = "speed_on", Callback = apply})
Movement:Toggle({Name = "Jump", Flag = "jump_on", Callback = apply})
Movement:Slider({Name = "Jump Power", Flag = "jump", Min = 50, Max = 300, Default = 100, ShowWhen = "jump_on", Callback = apply})

Arvn:Connect(LocalPlayer.CharacterAdded, function(character)
	character:WaitForChild("Humanoid")
	apply()
end)
```

## Teleport to a player

`Special = "Players"` keeps the list up to date as players join and leave.

```lua
local Teleport = Window:Group("Main"):Tab({Name = "Teleport", Icon = "teleport"}):Section("Players")

Teleport:Dropdown({Name = "Player", Flag = "tp_target", Special = "Players"})
Teleport:Button({Name = "Teleport", Icon = "map-pin", Callback = function()
	local LocalPlayer = game.Players.LocalPlayer
	local target = game.Players:FindFirstChild(Arvn.Flags.tp_target)
	local me = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local them = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	if me and them then
		me.CFrame = them.CFrame * CFrame.new(0, 0, 3)
	else
		Arvn:Notify({Title = "Teleport", Content = "Pick a player first.", Kind = "Warning"})
	end
end})
```

## A loop that runs while a toggle is on

`Arvn:Loop` runs your function every few seconds and stops on eject. Check the flag inside it.

```lua
local Farm = Window:Group("Main"):Tab({Name = "Farm", Icon = "farm"}):Section("Collect")

Farm:Toggle({Name = "Auto Collect", Flag = "auto_collect", Keybind = "C"})

Arvn:Loop(function()
	if not Arvn.Flags.auto_collect then return end
	print("collecting")
end, 0.5)
```

Without a number, `Arvn:Loop(fn)` runs every frame.

## Hold a key to use something

```lua
local Keys = Window:Group("Main"):Tab({Name = "Keys", Icon = "keyboard"}):Section("Keys")

Keys:Keybind({Name = "Zoom", Default = "Z", Mode = "Hold", Callback = function(held)
	workspace.CurrentCamera.FieldOfView = held and 20 or 70
end})
```

A toggle can also work while a key is held. Players can pick this themselves by right clicking the toggle:

```lua
Keys:Toggle({Name = "Sprint", Flag = "sprint", Keybind = {Key = "LeftShift", Mode = "Hold"}})
```

## Options that only show when needed

```lua
local Options = Window:Group("Main"):Tab({Name = "Options", Icon = "sliders-horizontal"}):Section("Mode")

local mode = Options:Segmented({Name = "Mode", Flag = "mode", Values = {"Simple", "Advanced"}})
Options:Slider({Name = "Strength", Min = 1, Max = 10, Default = 5})
Options:Slider({Name = "Fine Tune", Min = 0, Max = 1, Default = 0.5, Step = 0.01, ShowWhen = {mode = "Advanced"}})
Options:Toggle({Name = "Debug Output", EnableWhen = {mode = "Advanced"}})
```

## Stats on screen

A widget stays on screen when the menu is closed.

```lua
local stats = Arvn:Widget({Name = "Session", Icon = "chart-column"})
local coins = 0

Arvn:Loop(function()
	coins += 1
	stats:SetRow("Coins", coins)
	stats:SetRow("Status", Arvn.Flags.auto_collect and "Farming" or "Idle")
end, 1)
```

Or in the watermark:

```lua
Arvn:AddWatermarkPart("coins", {Icon = "coins", Get = function() return coins .. " coins" end})
```

## A log of what the script did

```lua
local Log = Window:Group("Main"):Tab({Name = "Log", Icon = "scroll"}):Section("Log")
local log = Log:Console({Height = 220, MaxLines = 300})

log:Log("Script started")
log:Success("Sold 20 items")
log:Warn("Inventory almost full")
log:Error("Shop is closed")

Log:Buttons({
	{Name = "Copy", Callback = function() log:Copy() end},
	{Name = "Clear", Callback = function() log:Clear() end},
})
```

## Ask before doing something

```lua
Section:Button({Name = "Sell Everything", Danger = true, Callback = function()
	Arvn:Dialog({
		Title = "Sell everything?",
		Content = "Every item in your inventory will be sold.",
		Icon = "coins",
		Buttons = {
			{Name = "Cancel"},
			{Name = "Sell", Style = "Danger", Callback = function()
				print("selling")
			end},
		},
	})
end})
```

For a quick second-click check without a popup, use `Confirm = true` on the button.

## A notification with buttons

```lua
Arvn:Notify({
	Title = "Update available",
	Content = "Version 1.1 is out.",
	Kind = "Info",
	Persist = true,
	Buttons = {
		{Name = "Copy Link", Callback = function() setclipboard("https://example.com") end},
		{Name = "Later"},
	},
})
```

## Configs for each game

`SubFolder` keeps configs apart when one script supports several games.

```lua
local Window = Arvn:CreateWindow({
	Title = "My Hub",
	Folder = "MyHub",
	SubFolder = tostring(game.PlaceId),
})
```

## Save your own data

Data saved with `Arvn.Config` goes into autosave and configs, with the settings.

```lua
local best = Arvn.Config:Get("best_time", 0)
Arvn.Config:Set("best_time", 42.5)
```

For files of your own, use your `Folder` and clean them up on reset:

```lua
Arvn:OnReset(function()
	if isfile("MyHub/history.json") then delfile("MyHub/history.json") end
end)
```

## A locked tab

```lua
local Premium = Window:Group("Main"):Tab({Name = "Premium", Icon = "crown", Locked = "Get the full version to use this."})

if isPremium then Premium:Unlock() end
```

## A settings tab for your script

Put your own options next to the built-in ones:

```lua
local general = Window:GetTab("General")
local mine = general:Section({Name = "My Hub", Side = "Right"})
mine:Toggle({Name = "Auto Update", Flag = "auto_update", Default = true})
mine:Dropdown({Name = "Language", Flag = "lang", Values = {"English", "Deutsch", "Español"}})
```

## Your own look

```lua
Arvn.Theme:Register("Midnight", {
	Background = "#0B0B12",
	Card = "#161622",
	Text = "#F0F0FA",
	Accent = "#8A7CFF",
})

local Window = Arvn:CreateWindow({
	Title = "My Hub",
	Theme = "Midnight",
	Font = "GothamSSm",
	ToggleStyle = "Checkbox",
	Logo = "https://files.catbox.moe/logo.png",
	UIButton = {Text = "MH"},
	Particles = "Off",
	Defaults = {ui_radius = 8, wm_style = "Minimal", nt_pos = "Bottom Right"},
})
```
