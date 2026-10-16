--[[
	Hoarcekat story — Shape, type and motion
	========================================

	Every look-and-feel option in one window: component styles, borders,
	shadows, glow, gradients, typography and motion, plus the theme and accent.
	Watch the showcase card on the right to see each change land.

	Studio setup is the same as playground.story.luau: import as a ModuleScript
	named `style.story` and enable HTTP requests.
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

return function(target)
	local Arvn, cleanup = loadLib(target)
	if not Arvn then return cleanup end

	local Window = Arvn:CreateWindow({
		Title = "Style",
		Author = "arvn lib",
		Folder = "ArvnStoryStyle",
	})

	local Tab = Window:Group("Explore"):Tab({Name = "Style", Icon = "palette"})

	local Shape = Tab:Section("Shape")
	Shape:Dropdown({
		Name = "Component Style",
		Values = {"Default", "Minimal", "Glass", "Neon", "Flat", "Material", "Retro", "Soft", "Hard"},
		Default = "Default",
		Description = "A ready-made look for every surface.",
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

	local Theme = Tab:Section({Name = "Theme", Side = "Right"})
	Theme:Dropdown({
		Name = "Theme",
		Values = {"Dark", "Gray", "Blue", "Green", "Purple", "Orange", "Pink", "Light", "AMOLED", "Contrast"},
		Default = "Dark",
		Callback = function(v) Window:SetTheme(v) end,
	})
	Theme:ColorPicker({Name = "Accent", Default = Color3.fromRGB(224, 49, 61), Callback = function(c)
		Window:SetAccent(c)
	end})
	Theme:Toggle({Name = "Open Animation", Default = true, Callback = function(v) Arvn:SetFlag("ui_anim_open", v) end})
	Theme:Toggle({Name = "Theme Fade", Default = true, Callback = function(v) Arvn:SetFlag("ui_anim_theme", v) end})

	local Type = Tab:Section({Name = "Typography And Motion", Side = "Right"})
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
	Type:Dropdown({
		Name = "Easing",
		Values = {"Quint", "Sine", "Quad", "Cubic", "Back", "Elastic", "Bounce", "Linear"},
		Default = "Quint",
		Callback = function(v) Window:SetEasing(v) end,
	})
	Type:Dropdown({
		Name = "Animation Level",
		Values = {"Off", "Reduce", "Strong"},
		Default = "Off",
		Callback = function(v) Window:SetMotion(v) end,
	})

	local Showcase = Tab:Section({Name = "Showcase", Side = "Right"})
	Showcase:Label("Watch these react to the controls on the left.")
	Showcase:Toggle({Name = "Enabled", Default = true})
	Showcase:Slider({Name = "Amount", Min = 0, Max = 100, Default = 40})
	Showcase:Dropdown({Name = "Choice", Values = {"One", "Two", "Three"}, Default = "One"})
	Showcase:Segmented({Name = "Mode", Values = {"A", "B"}, Default = "A"})
	Showcase:Button({Name = "Ping", Icon = "bell", Callback = function()
		Arvn:Notify({Title = "Ping", Content = "Styling is live.", Kind = "Info"})
	end})
	Showcase:Button({Name = "Reset Display", Icon = "rotate-ccw", Callback = function()
		Window:ResetDisplay()
	end})

	Arvn:Notify({Title = "Style", Content = "Try the Component Style dropdown.", Kind = "Info"})

	return function()
		pcall(function() Arvn:Eject() end)
	end
end
