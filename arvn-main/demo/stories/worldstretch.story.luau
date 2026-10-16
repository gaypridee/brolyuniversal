--[[
	Hoarcekat story — World stretch
	===============================

	Stretches the 3D view through the camera. This changes the game's camera,
	not the menu, so it is most visible in Play mode with a scene in front of
	you. Your original field of view is restored when you turn it off or the
	story unmounts.

	Studio setup is the same as playground.story.luau: import as a ModuleScript
	named `worldstretch.story` and enable HTTP requests.
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
		Title = "World Stretch",
		Author = "arvn lib",
		Folder = "ArvnStoryWorldStretch",
	})

	local Tab = Window:Group("Explore"):Tab({Name = "Camera", Icon = "camera"})

	local World = Tab:Section("World Stretch")
	World:Paragraph({
		Title = "Stretch the 3D view",
		Body = "Roblox does not expose the render resolution, so arvn lib approximates "
			.. "a stretched view with the camera's field of view. Off by default, and "
			.. "the original camera is restored when you turn it off or unmount.",
	})
	World:Toggle({
		Name = "Stretched View",
		Description = "Master switch. Off leaves your camera alone.",
		Callback = function(v)
			Window:SetWorldStretch(v)
			Arvn:Notify({Title = "World Stretch", Content = v and "Stretching." or "Camera restored.", Kind = "Info"})
		end,
	})
	World:Dropdown({
		Name = "View Ratio",
		Values = {"4:3", "5:4", "16:10", "16:9", "21:9", "Custom"},
		Default = "4:3",
		Callback = function(v) Arvn:SetFlag("ws_aspect", v) end,
	})
	World:Slider({Name = "Custom Width", Min = 1, Max = 48, Default = 4,
		Callback = function(v) Arvn:SetFlag("ws_num", v) end})
	World:Slider({Name = "Custom Height", Min = 1, Max = 32, Default = 3,
		Callback = function(v) Arvn:SetFlag("ws_den", v) end})
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
	World:Toggle({Name = "Include Aim FOV", Description = "Reserved for aim-down-sights.", Callback = function(v)
		Arvn:SetFlag("ws_aim", v)
	end})

	local Notes = Tab:Section({Name = "Notes", Side = "Right"})
	Notes:Label("World stretch coexists with the existing camera options:")
	Notes:Label("• **cam_fov** and **cam_zoom** keep working.")
	Notes:Label("• While stretched, world stretch wins.")
	Notes:Label("• Everything is restored on eject.")
	Notes:Button({Name = "Restore Camera", Icon = "undo-2", Callback = function()
		Window:SetWorldStretch(false)
		Arvn:Notify({Title = "Camera", Content = "Original field of view restored.", Kind = "Success"})
	end})

	Arvn:Notify({Title = "World Stretch", Content = "Toggle Stretched View to begin.", Kind = "Info"})

	return function()
		pcall(function() Arvn:Eject() end)
	end
end
