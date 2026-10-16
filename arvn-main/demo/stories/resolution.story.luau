--[[
	Hoarcekat story — Resolution and ratio
	=====================================

	Drives the scaling modes and aspect ratios so you can watch the virtual
	viewport change. The **Tour** toggle walks through every mode and ratio on a
	timer; the buttons step through them by hand.

	Studio setup is the same as playground.story.luau: import as a ModuleScript
	named `resolution.story` and enable HTTP requests.
--]]

local URL = "https://raw.githubusercontent.com/koteqjjjj/arvn/main/arvn.lua"

local function fail(target, msg)
	local parent = (gethui and gethui()) or game:GetService("CoreGui")
	local gui = Instance.new("ScreenGui")
	gui.Name = "arvnStoryError"
	gui.ResetOnSpawn = false
	gui.Parent = parent
	local frame = Instance.new("Frame")
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.Size = UDim2.fromOffset(540, 230)
	frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
	frame.BorderSizePixel = 0
	frame.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(240, 240, 245)
	label.TextWrapped = true
	label.TextSize = 16
	label.Font = Enum.Font.Gotham
	label.Text = msg
	label.Parent = frame
	return function() gui:Destroy() end
end

local function loadLib(target)
	if type(rawget(_G, "Arvn")) == "table" then return _G.Arvn end
	local ok, result = pcall(function()
		local chunk = loadstring(game:HttpGet(URL))
		if not chunk then error("loadstring returned nil") end
		return chunk()
	end)
	if ok and type(result) == "table" then return result end
	return nil, fail(target, "Could not load arvn lib.\n\n" .. tostring(result)
		.. "\n\nIn Studio, enable Game Settings > Security > Allow HTTP Requests, then reopen this story.")
end

local MODES = {"Off", "Scale", "Offset", "Hybrid", "Pixel"}
local RATIOS = {"Off", "4:3", "5:4", "3:2", "16:10", "16:9", "21:9", "32:9"}

return function(target)
	local Arvn, cleanup = loadLib(target)
	if not Arvn then return cleanup end

	local Window = Arvn:CreateWindow({
		Title = "Resolution",
		Author = "arvn lib",
		Folder = "ArvnStoryResolution",
		DesignWidth = 1920,
		DesignHeight = 1080,
	})

	local Tab = Window:Group("Explore"):Tab({Name = "Resolution", Icon = "monitor"})

	local Live = Tab:Section({Name = "Live", Side = "Right"})
	local infoReal = Live:Info({Name = "Screen", Value = "-"})
	local infoBox = Live:Info({Name = "Box", Value = "-"})
	local infoVirtual = Live:Info({Name = "Virtual", Value = "-"})
	local infoFactor = Live:Info({Name = "Scale", Value = "1.000"})
	local infoOn = Live:Info({Name = "Active", Value = "No"})

	local refreshInfo
	refreshInfo = function()
		local ok, r = pcall(function() return Window:GetResolution() end)
		if not ok or type(r) ~= "table" then return end
		infoReal:Set(string.format("%d x %d", math.floor(r.real.X), math.floor(r.real.Y)))
		infoBox:Set(string.format("%d x %d", math.floor(r.box.X), math.floor(r.box.Y)))
		infoVirtual:Set(string.format("%d x %d", math.floor(r.virtual.X), math.floor(r.virtual.Y)))
		infoFactor:Set(string.format("%.3f", r.factor))
		infoOn:Set(r.on and "Yes" or "No")
	end

	local Scale = Tab:Section("Scaling")
	Scale:Dropdown({
		Name = "Scaling Mode",
		Values = MODES,
		Default = "Off",
		Callback = function(v) Window:SetResolution(v) refreshInfo() end,
	})
	Scale:Dropdown({
		Name = "Device Scaling",
		Values = {"Off", "Auto", "Compact", "Touch", "Console", "VR"},
		Default = "Off",
		Callback = function(v) Arvn:SetFlag("ui_dpi", v) refreshInfo() end,
	})
	Scale:Slider({Name = "Design Width", Min = 960, Max = 3840, Default = 1920, Suffix = "px",
		Callback = function(v) Arvn:SetFlag("ui_refw", v) refreshInfo() end})
	Scale:Slider({Name = "Design Height", Min = 540, Max = 2160, Default = 1080, Suffix = "px",
		Callback = function(v) Arvn:SetFlag("ui_refh", v) refreshInfo() end})
	Scale:Toggle({Name = "Clamp Scale", Callback = function(v) Arvn:SetFlag("ui_clamp", v) refreshInfo() end})
	Scale:Slider({Name = "Min Scale", Min = 40, Max = 150, Default = 75, Suffix = "%",
		Callback = function(v) Arvn:SetFlag("ui_clamp_min", v) refreshInfo() end})
	Scale:Slider({Name = "Max Scale", Min = 100, Max = 300, Default = 200, Suffix = "%",
		Callback = function(v) Arvn:SetFlag("ui_clamp_max", v) refreshInfo() end})
	Scale:Toggle({Name = "Pixel Snap", Callback = function(v) Arvn:SetFlag("ui_snap", v) refreshInfo() end})

	local Ratio = Tab:Section("Screen Ratio")
	Ratio:Dropdown({
		Name = "Aspect Ratio",
		Values = {"Off", "4:3", "5:4", "3:2", "16:10", "16:9", "21:9", "32:9", "Custom"},
		Default = "Off",
		Callback = function(v) Window:SetAspect(v) refreshInfo() end,
	})
	Ratio:Slider({Name = "Custom Width", Min = 1, Max = 48, Default = 4,
		Callback = function(v) Arvn:SetFlag("ui_aspect_num", v) refreshInfo() end})
	Ratio:Slider({Name = "Custom Height", Min = 1, Max = 32, Default = 3,
		Callback = function(v) Arvn:SetFlag("ui_aspect_den", v) refreshInfo() end})
	Ratio:Dropdown({
		Name = "Ratio Mode",
		Values = {"Stretch", "Fit", "Fill", "Letterbox", "Crop", "Cover", "Center"},
		Default = "Fit",
		Callback = function(v) Window:SetAspectFit(v) refreshInfo() end,
	})
	Ratio:Dropdown({
		Name = "Anchor",
		Values = {"Center", "Top Left", "Top", "Top Right", "Left", "Right", "Bottom Left", "Bottom", "Bottom Right"},
		Default = "Center",
		Callback = function(v) Arvn:SetFlag("ui_anchor", v) refreshInfo() end,
	})
	Ratio:Toggle({Name = "Letterbox Bars", Callback = function(v) Arvn:SetFlag("ui_bars", v) refreshInfo() end})
	Ratio:Toggle({Name = "Avoid Top Bar", Callback = function(v) Arvn:SetFlag("ui_topbar", v) refreshInfo() end})

	local Tour = Tab:Section({Name = "Tour", Side = "Right"})
	Tour:Paragraph({
		Title = "Automatic walk-through",
		Body = "Turn Tour on to cycle through every scaling mode and aspect ratio "
			.. "on a two second timer. The buttons step one at a time.",
	})
	Tour:Toggle({Name = "Tour", Flag = "story_tour"})

	local modeIndex, ratioIndex = 1, 1
	Tour:Buttons({
		{Name = "Next Mode", Callback = function()
			modeIndex = modeIndex % #MODES + 1
			Window:SetResolution(MODES[modeIndex])
			refreshInfo()
		end},
		{Name = "Next Ratio", Callback = function()
			ratioIndex = ratioIndex % #RATIOS + 1
			Window:SetAspect(RATIOS[ratioIndex])
			refreshInfo()
		end},
		{Name = "Reset", Callback = function()
			Window:ResetDisplay()
			refreshInfo()
		end},
	})

	Arvn:Loop(function()
		if not Arvn.Flags.story_tour then return end
		modeIndex = modeIndex % #MODES + 1
		Window:SetResolution(MODES[modeIndex])
		if MODES[modeIndex] == "Off" then
			ratioIndex = ratioIndex % #RATIOS + 1
			Window:SetAspect(RATIOS[ratioIndex])
		end
		refreshInfo()
	end, 2)

	refreshInfo()
	Arvn:Notify({Title = "Resolution", Content = "Toggle Tour to walk through the modes.", Kind = "Info"})

	return function()
		pcall(function() Arvn:Eject() end)
	end
end
