--[[
	arvn lib — Playground
	=====================

	A single window that puts the whole resolution / ratio / style system on
	screen next to a tour of the element set. Every control below is wired to a
	public method, so the file doubles as a reference.

	How to run
	----------
	Executor, script hub or the command bar — run it as is. It fetches the
	library from GitHub exactly like the README does:

		loadstring(game:HttpGet("https://raw.githubusercontent.com/koteqjjjj/arvn/main/demo/playground.lua"))()

	Studio — paste it into a LocalScript, or open the Hoarcekat stories in
	`demo/stories/` and let the plugin load the library for you.
--]]

local LIB = "https://raw.githubusercontent.com/koteqjjjj/arvn/main/arvn.lua"

local ok, Arvn = pcall(function()
	return loadstring(game:HttpGet(LIB))()
end)
if not ok or type(Arvn) ~= "table" then
	warn("[playground] could not load arvn lib: " .. tostring(Arvn))
	return
end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- The window is created with the design size set, so the Scaling Mode
-- controls have something sensible to scale against. Everything else in the
-- display system is left at its default, which is the original look.
local Window = Arvn:CreateWindow({
	Title = "Playground",
	Author = "you",
	Version = "1.0",
	Folder = "ArvnPlayground",
	DesignWidth = 1920,
	DesignHeight = 1080,
})

local function notify(title, content, kind)
	Arvn:Notify({Title = title, Content = content, Kind = kind or "Info"})
end

local function copy(text)
	if setclipboard then
		setclipboard(text)
		notify("Copied", "Link copied to your clipboard.", "Success")
	else
		notify("Link", text, "Info")
	end
end

local Main = Window:Group("Main")

-- Forward declaration: the Home tab has a shortcut that jumps to Display,
-- which is created a little further down.
local Display

-- ---------------------------------------------------------------------------
-- Home
-- ---------------------------------------------------------------------------

local Home = Main:Tab({Name = "Home", Icon = "house"})
local Intro = Home:Section("Welcome")
Intro:Paragraph({
	Title = "arvn lib playground",
	Body = "This window shows off the display system: scaling, aspect ratio, "
		.. "letterbox bars, component styles, typography, motion and an optional "
		.. "world stretch. Every option is opt-in, so a plain window still looks "
		.. "exactly like it always did.",
})
Intro:Divider("Try this")
Intro:Label("Open **Display** to resize the menu, **Camera** to stretch the view.")
Intro:Buttons({
	{Name = "Display", Callback = function() if Display then Display:Select() end end},
	{Name = "Notify", Callback = function() notify("Hello", "Buttons run your code.", "Success") end},
	{Name = "Copy Link", Callback = function()
		copy("https://github.com/koteqjjjj/arvn")
	end},
})

local Presets = Home:Section({Name = "Quick Looks", Side = "Right"})
Presets:Label("One click sets a whole display preset.")
Presets:Buttons({
	{Name = "Laptop", Description = "Scale to a 1920x1080 design.", Callback = function()
		Arvn:SetResolution("Scale")
		Arvn:SetFlag("ui_refw", 1920)
		Arvn:SetFlag("ui_refh", 1080)
		Arvn:SetFlag("ui_aspect", "Off")
		Arvn:SetFlag("ui_bars", false)
		notify("Preset", "Laptop — scaling on, no letterbox.", "Info")
	end},
	{Name = "Cinema", Description = "Ultrawide with bars.", Callback = function()
		Arvn:SetFlag("ui_aspect", "21:9")
		Arvn:SetAspectFit("Fit")
		Arvn:SetFlag("ui_bars", true)
		notify("Preset", "Cinema — 21:9 with letterbox bars.", "Info")
	end},
	{Name = "Pixel", Description = "Crisp, snapped, no smoothing.", Callback = function()
		Arvn:SetResolution("Pixel")
		Arvn:SetFlag("ui_snap", true)
		notify("Preset", "Pixel — fixed size, snapped edges.", "Info")
	end},
})

-- ---------------------------------------------------------------------------
-- Display — the resolution, ratio, style, type and motion controls
-- ---------------------------------------------------------------------------

Display = Main:Tab({Name = "Display", Icon = "monitor"})

-- Right column first so refreshInfo exists before the controls call it.
local Live = Display:Section({Name = "Live", Side = "Right"})
local infoMode = Live:Info({Name = "Scaling Mode", Value = "Off"})
local infoAspect = Live:Info({Name = "Aspect Ratio", Value = "Off"})
local infoBox = Live:Info({Name = "Box", Value = "-"})
local infoVirtual = Live:Info({Name = "Virtual", Value = "-"})
local infoFactor = Live:Info({Name = "Scale", Value = "1.000"})
local infoOn = Live:Info({Name = "Active", Value = "No"})

local refreshInfo
refreshInfo = function()
	local ok2, r = pcall(function() return Window:GetResolution() end)
	if not ok2 or type(r) ~= "table" then return end
	infoMode:Set(Arvn.Flags.ui_fit or "Off")
	infoAspect:Set(Arvn.Flags.ui_aspect or "Off")
	infoBox:Set(string.format("%d x %d", math.floor(r.box.X), math.floor(r.box.Y)))
	infoVirtual:Set(string.format("%d x %d", math.floor(r.virtual.X), math.floor(r.virtual.Y)))
	infoFactor:Set(string.format("%.3f", r.factor))
	infoOn:Set(r.on and "Yes" or "No")
end

local Resolution = Display:Section("Resolution")
Resolution:Dropdown({
	Name = "Scaling Mode",
	Values = {"Off", "Scale", "Offset", "Hybrid", "Pixel"},
	Default = "Off",
	Description = "How the menu is scaled to your screen. Off keeps the plain pixel size.",
	Callback = function(v)
		Window:SetResolution(v)
		refreshInfo()
	end,
})
Resolution:Dropdown({
	Name = "Device Scaling",
	Values = {"Off", "Auto", "Compact", "Touch", "Console", "VR"},
	Default = "Off",
	Description = "Extra scale for the device or screen density.",
	Callback = function(v)
		Arvn:SetFlag("ui_dpi", v)
		refreshInfo()
	end,
})
Resolution:Slider({Name = "Design Width", Min = 960, Max = 3840, Default = 1920, Suffix = "px",
	Callback = function(v) Arvn:SetFlag("ui_refw", v) refreshInfo() end})
Resolution:Slider({Name = "Design Height", Min = 540, Max = 2160, Default = 1080, Suffix = "px",
	Callback = function(v) Arvn:SetFlag("ui_refh", v) refreshInfo() end})
Resolution:Toggle({Name = "Clamp Scale", Description = "Limit how small or big the scale can get.", Callback = function(v)
	Arvn:SetFlag("ui_clamp", v)
	refreshInfo()
end})
Resolution:Slider({Name = "Min Scale", Min = 40, Max = 150, Default = 75, Suffix = "%",
	Callback = function(v) Arvn:SetFlag("ui_clamp_min", v) refreshInfo() end})
Resolution:Slider({Name = "Max Scale", Min = 100, Max = 300, Default = 200, Suffix = "%",
	Callback = function(v) Arvn:SetFlag("ui_clamp_max", v) refreshInfo() end})
Resolution:Toggle({Name = "Pixel Snap", Description = "Round the virtual size to whole pixels for sharp edges.", Callback = function(v)
	Arvn:SetFlag("ui_snap", v)
	refreshInfo()
end})

local Ratio = Display:Section("Screen Ratio")
Ratio:Dropdown({
	Name = "Aspect Ratio",
	Values = {"Off", "4:3", "5:4", "3:2", "16:10", "16:9", "21:9", "32:9", "Custom"},
	Default = "Off",
	Callback = function(v)
		Window:SetAspect(v)
		refreshInfo()
	end,
})
Ratio:Slider({Name = "Custom Width", Min = 1, Max = 48, Default = 4,
	Callback = function(v) Arvn:SetFlag("ui_aspect_num", v) refreshInfo() end})
Ratio:Slider({Name = "Custom Height", Min = 1, Max = 32, Default = 3,
	Callback = function(v) Arvn:SetFlag("ui_aspect_den", v) refreshInfo() end})
Ratio:Dropdown({
	Name = "Ratio Mode",
	Values = {"Stretch", "Fit", "Fill", "Letterbox", "Crop", "Cover", "Center"},
	Default = "Fit",
	Callback = function(v)
		Window:SetAspectFit(v)
		refreshInfo()
	end,
})
Ratio:Dropdown({
	Name = "Anchor",
	Values = {"Center", "Top Left", "Top", "Top Right", "Left", "Right", "Bottom Left", "Bottom", "Bottom Right"},
	Default = "Center",
	Callback = function(v) Arvn:SetFlag("ui_anchor", v) refreshInfo() end,
})
Ratio:Toggle({Name = "Letterbox Bars", Description = "Draw dark bars over the empty area.", Callback = function(v)
	Arvn:SetFlag("ui_bars", v)
	refreshInfo()
end})
Ratio:ColorPicker({Name = "Bar Color", Default = Color3.fromRGB(0, 0, 0), Callback = function(c)
	Arvn:SetFlag("ui_bars_color", Arvn.Hex(c))
	refreshInfo()
end})
Ratio:Toggle({Name = "Avoid Top Bar", Description = "Keep the interface below the Roblox top bar.", Callback = function(v)
	Arvn:SetFlag("ui_topbar", v)
	refreshInfo()
end})
Ratio:Button({Name = "Reset Display", Icon = "rotate-ccw", Description = "Back to every default.", Callback = function()
	Window:ResetDisplay()
	refreshInfo()
	notify("Display", "Every display option is back to default.", "Info")
end})

-- Shape, type and motion live on the right column under Live.
local Shape = Display:Section({Name = "Shape And Style", Side = "Right"})
Shape:Dropdown({
	Name = "Component Style",
	Values = {"Default", "Minimal", "Glass", "Neon", "Flat", "Material", "Retro", "Soft", "Hard"},
	Default = "Default",
	Description = "A ready-made look for every surface. Rebuilds the menu.",
	Callback = function(v) Window:SetStyle(v) end,
})
Shape:Dropdown({
	Name = "Border Style",
	Values = {"Soft", "Hard", "None", "Inset", "Outline"},
	Default = "Soft",
	Callback = function(v) Arvn:SetFlag("ui_border", v) end,
})
Shape:Slider({Name = "Border Width", Min = 1, Max = 3, Default = 1,
	Callback = function(v) Arvn:SetFlag("ui_border_thick", v) end})
Shape:Toggle({Name = "Drop Shadows", Callback = function(v) Arvn:SetFlag("ui_shadow", v) end})
Shape:Slider({Name = "Shadow Size", Min = 4, Max = 32, Default = 14,
	Callback = function(v) Arvn:SetFlag("ui_shadow_size", v) end})
Shape:Slider({Name = "Shadow Dark", Min = 0, Max = 100, Default = 55, Suffix = "%",
	Callback = function(v) Arvn:SetFlag("ui_shadow_amt", v) end})
Shape:Toggle({Name = "Accent Glow", Callback = function(v) Arvn:SetFlag("ui_glow", v) end})
Shape:Slider({Name = "Glow Strength", Min = 0, Max = 100, Default = 60, Suffix = "%",
	Callback = function(v) Arvn:SetFlag("ui_glow_amt", v) end})
Shape:Toggle({Name = "Card Gradient", Callback = function(v) Arvn:SetFlag("ui_gradient", v) end})
Shape:Slider({Name = "Gradient Angle", Min = 0, Max = 360, Default = 90, Suffix = "°",
	Callback = function(v) Arvn:SetFlag("ui_gradient_rot", v) end})
Shape:Toggle({Name = "Tinted Panels", Callback = function(v) Arvn:SetFlag("ui_accent_panel", v) end})

local Type = Display:Section({Name = "Typography", Side = "Right"})
Type:Slider({Name = "Text Scale", Min = 75, Max = 150, Default = 100, Suffix = "%",
	Callback = function(v) Window:SetTextScale(v) end})
Type:Dropdown({
	Name = "Font Weight",
	Values = {"Light", "Regular", "Medium", "SemiBold", "Bold"},
	Default = "Medium",
	Callback = function(v) Arvn:SetFlag("ui_font_weight", v) end,
})
Type:Slider({Name = "Icon Scale", Min = 75, Max = 150, Default = 100, Suffix = "%",
	Callback = function(v) Window:SetIconScale(v) end})
Type:Slider({Name = "Element Scale", Min = 75, Max = 150, Default = 100, Suffix = "%",
	Callback = function(v) Window:SetElementScale(v) end})
Type:Dropdown({
	Name = "Spacing",
	Values = {"Compact", "Comfortable", "Spacious"},
	Default = "Comfortable",
	Callback = function(v) Window:SetDensity(v) end,
})

local Motion = Display:Section({Name = "Motion", Side = "Right"})
Motion:Dropdown({
	Name = "Easing",
	Values = {"Quint", "Sine", "Quad", "Cubic", "Back", "Elastic", "Bounce", "Linear"},
	Default = "Quint",
	Callback = function(v) Window:SetEasing(v) end,
})
Motion:Dropdown({
	Name = "Animation Level",
	Values = {"Off", "Reduce", "Strong"},
	Default = "Off",
	Callback = function(v) Window:SetMotion(v) end,
})
Motion:Toggle({Name = "Open Animation", Default = true, Callback = function(v) Arvn:SetFlag("ui_anim_open", v) end})
Motion:Toggle({Name = "Theme Fade", Default = true, Callback = function(v) Arvn:SetFlag("ui_anim_theme", v) end})

refreshInfo()

-- ---------------------------------------------------------------------------
-- Camera — world stretch
-- ---------------------------------------------------------------------------

local Camera = Main:Tab({Name = "Camera", Icon = "camera"})
local World = Camera:Section("World Stretch")
World:Paragraph({
	Title = "Stretch the 3D view",
	Body = "Roblox does not expose the render resolution, so arvn lib approximates "
		.. "a stretched view with the camera's field of view. It is off by default "
		.. "and your original camera is restored when you turn it off or eject.",
})
World:Toggle({
	Name = "Stretched View",
	Description = "Master switch. Off leaves your camera alone.",
	Callback = function(v)
		Window:SetWorldStretch(v)
		notify("World Stretch", v and "Stretching the view." or "Camera restored.", "Info")
	end,
})
World:Dropdown({
	Name = "View Ratio",
	Values = {"4:3", "5:4", "16:10", "16:9", "21:9", "Custom"},
	Default = "4:3",
	Callback = function(v) Arvn:SetFlag("ws_aspect", v) end,
})
World:Dropdown({
	Name = "View Mode",
	Values = {"Stretch", "Letterbox", "Crop"},
	Default = "Stretch",
	Callback = function(v) Arvn:SetFlag("ws_mode", v) end,
})
World:Dropdown({
	Name = "FOV Axis",
	Values = {"Vertical", "Diagonal", "MaxAxis"},
	Default = "MaxAxis",
	Callback = function(v) Arvn:SetFlag("ws_fov_mode", v) end,
})
World:Slider({Name = "Field Of View", Min = 40, Max = 120, Default = 90, Suffix = "°",
	Callback = function(v) Arvn:SetFlag("ws_fov", v) end})

local CameraRight = Camera:Section({Name = "Notes", Side = "Right"})
CameraRight:Label("World stretch coexists with the existing camera options:")
CameraRight:Label("• **cam_fov** and **cam_zoom** still work.")
CameraRight:Label("• While stretched, world stretch wins.")
CameraRight:Button({Name = "Restore Camera", Icon = "undo-2", Callback = function()
	Window:SetWorldStretch(false)
	notify("Camera", "Original field of view restored.", "Success")
end})

-- ---------------------------------------------------------------------------
-- Elements — a tour of everything a section can hold
-- ---------------------------------------------------------------------------

local Elements = Main:Tab({Name = "Elements", Icon = "layout-grid"})

local Inputs = Elements:Section("Inputs")
local fly = Inputs:Toggle({
	Name = "Fly",
	Description = "A toggle with a keybind and a color square.",
	Keybind = "F",
	Color = Color3.fromRGB(255, 80, 80),
	Callback = function(on) notify("Fly", on and "Flying." or "Landed.", "Info") end,
})
Inputs:Slider({Name = "Fly Speed", Min = 1, Max = 200, Default = 60, Suffix = " studs", ShowWhen = fly})
Inputs:Dropdown({Name = "Target", Special = "Players", Description = "Live player list."})
Inputs:Dropdown({Name = "Parts", Values = {"Head", "Torso", "Legs"}, Multi = true, Default = {"Head"},
	Description = "A multi-choice dropdown with search and select all."})
Inputs:Segmented({Name = "Mode", Values = {"Legit", "Rage"}, Default = "Legit"})
Inputs:ColorPicker({Name = "Highlight", Default = Color3.fromRGB(80, 160, 255)})
Inputs:Input({Name = "Message", Placeholder = "Type here"})
Inputs:Input({Name = "Amount", Numeric = true, Min = 1, Max = 100, Default = "10"})
Inputs:Keybind({Name = "Action Key", Default = "T", Callback = function()
	notify("Action", "You pressed the action key.", "Info")
end})
Inputs:Button({Name = "Say Hi", Icon = "hand", Callback = function()
	notify("Hi", "Buttons run your code.", "Success")
end})
Inputs:Buttons({
	{Name = "Save", Callback = function() notify("Save", "Saved.", "Success") end},
	{Name = "Load", Callback = function() notify("Load", "Loaded.", "Info") end},
	{Name = "Delete", Danger = true, Confirm = true, Callback = function() notify("Delete", "Deleted.", "Danger") end},
})

local Output = Elements:Section({Name = "Output", Side = "Right"})
local status = Output:Label({Text = "Everything is fine.", Style = "Success"})
Output:Paragraph({Title = "Paragraph", Body = "A title with longer text underneath that wraps onto a few lines."})
local kills = Output:Info({Name = "Kills", Value = "0"})
local bar = Output:Progress({Name = "Farming", Value = 0, Max = 100})
Output:Divider("A log")
local log = Output:Console({Height = 160, MaxLines = 200})
log:Log("Script started")
log:Success("Connected")
log:Warn("Inventory almost full")

local ticker = 0
Arvn:Loop(function()
	ticker += 1
	kills:Set(ticker)
	bar:Set(ticker % 101)
	if ticker % 10 == 0 then log:Log("Tick " .. ticker) end
	status:Set("Tick " .. ticker .. " — status nominal.")
end, 1)

Output:Buttons({
	{Name = "Log Line", Callback = function() log:Log("A line at " .. os.date("%H:%M:%S")) end},
	{Name = "Copy", Callback = function() log:Copy() end},
	{Name = "Clear", Callback = function() log:Clear() end},
})

local Lists = Elements:Section({Name = "Images And Lists", Side = "Right"})
Lists:Image({Source = "thumb:" .. game.PlaceId, Height = 120, Caption = "This place"})
Lists:PlayerList()

-- ---------------------------------------------------------------------------
-- About
-- ---------------------------------------------------------------------------

local About = Main:Tab({Name = "About", Icon = "info"})
local Info = About:Section("About")
Info:Paragraph({
	Title = "arvn lib",
	Body = "A UI library for Roblox. This playground lives in the repository at "
		.. "demo/playground.lua and the Hoarcekat stories next to it.",
})
Info:Info({Name = "Library", Value = "arvn lib"})
Info:Info({Name = "Playground", Value = "demo/playground.lua"})
Info:Button({Name = "Copy Repository Link", Icon = "external-link", Callback = function()
	copy("https://github.com/koteqjjjj/arvn")
end})
Info:Button({Name = "Eject", Icon = "log-out", Danger = true, Confirm = true, Callback = function()
	Window:Eject()
end})

notify("Playground", "The demo is ready. Open the Display tab.", "Success")
