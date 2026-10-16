--[[
	Hoarcekat story — Playground
	============================

	A compact version of demo/playground.lua that runs inside Hoarcekat (or any
	other storybook plugin). The library draws into its own ScreenGui, so this
	story ignores `target` and simply opens a real window.

	Studio setup
	------------
	1. Put this file in the game as a ModuleScript named `playground.story`.
	2. Enable Game Settings > Security > Allow HTTP Requests so the story can
	   fetch the library from GitHub.
	3. Open the Hoarcekat plugin and pick Playground.

	If your plugin exposes the library differently, set `_G.Arvn` before the
	story runs and it will be used instead of the download.
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
		.. "\n\nIn Studio, enable Game Settings > Security > Allow HTTP Requests, then reopen this story. "
		.. "Or set _G.Arvn to a preloaded library before the story runs.")
end

return function(target)
	local Arvn, cleanup = loadLib(target)
	if not Arvn then return cleanup end

	local Window = Arvn:CreateWindow({
		Title = "Playground",
		Author = "arvn lib",
		Folder = "ArvnStoryPlayground",
		DesignWidth = 1920,
		DesignHeight = 1080,
	})

	local Main = Window:Group("Main")

	local Home = Main:Tab({Name = "Home", Icon = "house"})
	local Intro = Home:Section("Welcome")
	Intro:Paragraph({
		Title = "arvn lib playground",
		Body = "A tour of the display system: scaling, aspect ratio, letterbox "
			.. "bars, component styles, typography and motion. Every option is "
			.. "opt-in and defaults to the original look.",
	})
	Intro:Buttons({
		{Name = "Notify", Callback = function() Arvn:Notify({Title = "Hello", Content = "From a Hoarcekat story.", Kind = "Success"}) end},
		{Name = "Copy Link", Callback = function()
			local link = "https://github.com/koteqjjjj/arvn"
			if setclipboard then
				setclipboard(link)
				Arvn:Notify({Title = "Copied", Content = "Repository link copied.", Kind = "Success"})
			else
				Arvn:Notify({Title = "Link", Content = link, Kind = "Info"})
			end
		end},
	})

	local Display = Main:Tab({Name = "Display", Icon = "monitor"})
	local Live = Display:Section({Name = "Live", Side = "Right"})
	local infoBox = Live:Info({Name = "Box", Value = "-"})
	local infoVirtual = Live:Info({Name = "Virtual", Value = "-"})
	local infoFactor = Live:Info({Name = "Scale", Value = "1.000"})

	local refreshInfo
	refreshInfo = function()
		local ok, r = pcall(function() return Window:GetResolution() end)
		if not ok or type(r) ~= "table" then return end
		infoBox:Set(string.format("%d x %d", math.floor(r.box.X), math.floor(r.box.Y)))
		infoVirtual:Set(string.format("%d x %d", math.floor(r.virtual.X), math.floor(r.virtual.Y)))
		infoFactor:Set(string.format("%.3f", r.factor))
	end

	local Screen = Display:Section("Screen")
	Screen:Dropdown({
		Name = "Scaling Mode",
		Values = {"Off", "Scale", "Offset", "Hybrid", "Pixel"},
		Default = "Off",
		Callback = function(v) Window:SetResolution(v) refreshInfo() end,
	})
	Screen:Slider({Name = "Design Width", Min = 960, Max = 3840, Default = 1920, Suffix = "px",
		Callback = function(v) Arvn:SetFlag("ui_refw", v) refreshInfo() end})
	Screen:Slider({Name = "Design Height", Min = 540, Max = 2160, Default = 1080, Suffix = "px",
		Callback = function(v) Arvn:SetFlag("ui_refh", v) refreshInfo() end})
	Screen:Dropdown({
		Name = "Aspect Ratio",
		Values = {"Off", "4:3", "5:4", "3:2", "16:10", "16:9", "21:9", "32:9", "Custom"},
		Default = "Off",
		Callback = function(v) Window:SetAspect(v) refreshInfo() end,
	})
	Screen:Dropdown({
		Name = "Ratio Mode",
		Values = {"Stretch", "Fit", "Fill", "Letterbox", "Crop", "Cover", "Center"},
		Default = "Fit",
		Callback = function(v) Window:SetAspectFit(v) refreshInfo() end,
	})
	Screen:Toggle({Name = "Letterbox Bars", Callback = function(v) Arvn:SetFlag("ui_bars", v) refreshInfo() end})
	Screen:Button({Name = "Reset Display", Icon = "rotate-ccw", Callback = function()
		Window:ResetDisplay()
		refreshInfo()
	end})

	local Look = Display:Section({Name = "Look And Motion", Side = "Right"})
	Look:Dropdown({
		Name = "Component Style",
		Values = {"Default", "Minimal", "Glass", "Neon", "Flat", "Material", "Retro", "Soft", "Hard"},
		Default = "Default",
		Callback = function(v) Window:SetStyle(v) end,
	})
	Look:Slider({Name = "Text Scale", Min = 75, Max = 150, Default = 100, Suffix = "%",
		Callback = function(v) Window:SetTextScale(v) end})
	Look:Slider({Name = "Element Scale", Min = 75, Max = 150, Default = 100, Suffix = "%",
		Callback = function(v) Window:SetElementScale(v) end})
	Look:Dropdown({
		Name = "Spacing",
		Values = {"Compact", "Comfortable", "Spacious"},
		Default = "Comfortable",
		Callback = function(v) Window:SetDensity(v) end,
	})
	Look:Dropdown({
		Name = "Easing",
		Values = {"Quint", "Sine", "Quad", "Cubic", "Back", "Elastic", "Bounce", "Linear"},
		Default = "Quint",
		Callback = function(v) Window:SetEasing(v) end,
	})
	Look:Dropdown({
		Name = "Animation Level",
		Values = {"Off", "Reduce", "Strong"},
		Default = "Off",
		Callback = function(v) Window:SetMotion(v) end,
	})

	refreshInfo()

	local Elements = Main:Tab({Name = "Elements", Icon = "layout-grid"})
	local Inputs = Elements:Section("Inputs")
	local fly = Inputs:Toggle({Name = "Fly", Keybind = "F", Color = Color3.fromRGB(255, 80, 80)})
	Inputs:Slider({Name = "Fly Speed", Min = 1, Max = 200, Default = 60, Suffix = " studs", ShowWhen = fly})
	Inputs:Dropdown({Name = "Target", Special = "Players"})
	Inputs:Segmented({Name = "Mode", Values = {"Legit", "Rage"}, Default = "Legit"})
	Inputs:ColorPicker({Name = "Highlight", Default = Color3.fromRGB(80, 160, 255)})
	Inputs:Toggle({
		Name = "Trail",
		Menu = function(menu)
			local card = menu.Card()
			card:Slider({Name = "Length", Min = 1, Max = 10, Default = 3})
			card:Dropdown({Name = "Style", Values = {"Line", "Dots"}})
			menu.Card():ColorPicker({Name = "Color", Default = Color3.fromRGB(255, 255, 255)})
		end,
	})
	Inputs:Button({Name = "Say Hi", Icon = "hand", Callback = function()
		Arvn:Notify({Title = "Hi", Content = "Buttons run your code.", Kind = "Success"})
	end})

	local Output = Elements:Section({Name = "Output", Side = "Right"})
	Output:Label({Text = "Story is running.", Style = "Success"})
	local bar = Output:Progress({Name = "Progress", Value = 0, Max = 100})
	local log = Output:Console({Height = 150, MaxLines = 150})
	log:Log("Story mounted")
	Output:Divider("Actions")
	Output:Buttons({
		{Name = "Log", Callback = function() log:Log("A line at " .. os.date("%H:%M:%S")) end},
		{Name = "Clear", Callback = function() log:Clear() end},
	})

	local step = 0
	Arvn:Loop(function()
		step = (step + 7) % 101
		bar:Set(step)
	end, 0.5)

	Arvn:Notify({Title = "Playground", Content = "Story loaded.", Kind = "Success"})

	return function()
		pcall(function() Arvn:Eject() end)
	end
end
