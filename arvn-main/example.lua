local Arvn = loadstring(game:HttpGet("https://raw.githubusercontent.com/koteqjjjj/arvn/main/arvn.lua"))()

local Window = Arvn:CreateWindow({
	Title = "Example",
	Author = "you",
	Version = "1.0",
	Folder = "ArvnExample",
})

local function humanoid()
	local character = game.Players.LocalPlayer.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local Main = Window:Group("Main")

local Player = Main:Tab({Name = "Player", Icon = "user"})
local Movement = Player:Section("Movement")

local speed = Movement:Toggle({
	Name = "Speed",
	Keybind = "V",
	Description = "Walk faster.",
	Callback = function(on)
		local hum = humanoid()
		if not hum then return end
		if on then
			Arvn:Patch(hum, "WalkSpeed", Arvn.Flags.walk_speed)
		else
			Arvn:Restore(hum, "WalkSpeed")
		end
	end,
})

Movement:Slider({
	Name = "Walk Speed",
	Flag = "walk_speed",
	Min = 16,
	Max = 100,
	Default = 32,
	ShowWhen = speed,
	Callback = function(value)
		local hum = humanoid()
		if hum and speed:Get() then Arvn:Patch(hum, "WalkSpeed", value) end
	end,
})

local Options = Player:Section({Name = "Options", Side = "Right"})

Options:Dropdown({Name = "Target", Special = "Players"})
Options:ColorPicker({Name = "Color", Default = Color3.fromRGB(255, 80, 80)})
Options:Keybind({Name = "Action Key", Default = "F", Callback = function()
	Arvn:Notify({Title = "Action", Content = "You pressed the action key."})
end})
Options:Button({Name = "Say Hi", Callback = function()
	Arvn:Notify({Title = "Hi", Content = "Buttons run your code.", Kind = "Success"})
end})

local World = Main:Tab({Name = "World", Icon = "sun"})
local Lighting = World:Section("Lighting")

Lighting:Toggle({Name = "Always Day", Callback = function(on)
	if on then
		Arvn:Patch(game.Lighting, "ClockTime", 14)
	else
		Arvn:Restore(game.Lighting, "ClockTime")
	end
end})

Lighting:Segmented({Name = "Mode", Values = {"Soft", "Normal", "Bright"}, Default = "Normal"})

-- Resolution, ratio, style and motion.
local Display = Main:Tab({Name = "Display", Icon = "monitor"})
local ScreenTab = Display:Section("Screen")

ScreenTab:Dropdown({Name = "Scaling Mode", Values = {"Off", "Scale", "Hybrid", "Offset", "Pixel"}, Default = "Off", Callback = function(v)
	Window:SetResolution(v)
end})
ScreenTab:Dropdown({Name = "Aspect Ratio", Values = {"Off", "4:3", "16:10", "16:9", "21:9", "32:9", "Custom"}, Default = "Off", Callback = function(v)
	Window:SetAspect(v)
end})
ScreenTab:Toggle({Name = "Letterbox Bars", Callback = function(on)
	Arvn:SetFlag("ui_bars", on)
end})
ScreenTab:Button({Name = "Reset Display", Callback = function()
	Window:ResetDisplay()
end})

local Look = Display:Section({Name = "Look", Side = "Right"})
Look:Dropdown({Name = "Style", Values = {"Default", "Minimal", "Glass", "Neon", "Flat", "Material", "Retro", "Soft", "Hard"}, Default = "Default", Callback = function(v)
	Window:SetStyle(v)
end})
Look:Slider({Name = "Text Scale", Min = 75, Max = 150, Default = 100, Suffix = "%", Callback = function(v)
	Window:SetTextScale(v)
end})
Look:Toggle({Name = "Stretch The View", Callback = function(on)
	Window:SetWorldStretch(on)
end})
