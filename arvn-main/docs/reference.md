# Reference

Every method in one place. The other pages explain them with examples.

- [Arvn](#arvn)
- [Arvn.Theme](#arvntheme)
- [Arvn.Config](#arvnconfig)
- [Window](#window)
- [Group](#group)
- [Tab](#tab)
- [Section](#section)
- [Elements](#elements)
- [Notification handle](#notification-handle)
- [Widget](#widget)
- [Templates](#templates)
- [Built-in settings](#built-in-settings)
- [Eject](#eject)

## Arvn

| Method | What it does |
|---|---|
| `Arvn:CreateWindow(options)` | makes the window. See [Window options](customization.md#window-options). |
| `Arvn:Notify({Title, Content, Kind, Icon, Color, Duration, Persist, Buttons, Callback, Sound, Compact})` | shows a notification and returns a [handle](#notification-handle) |
| `Arvn:Dialog({Title, Content, Icon, Buttons, Dismissable})` | a popup with buttons |
| `Arvn:Prompt({Title, Content, Placeholder, Default, Validate, Callback})` | a popup with a text box |
| `Arvn:Widget({Name, Icon, Rows, Width, Visible, Empty})` | a panel on screen. Returns a [widget](#widget). |
| `Arvn:GetElement(flag)` | any element by its flag, built-in ones included |
| `Arvn:GetFlag(flag)`, `Arvn:SetFlag(flag, value)` | same as `Arvn.Flags[flag]` |
| `Arvn:OnFlag(flag, fn)` | runs `fn(value)` when a flag changes. Returns something with `Disconnect()`. |
| `Arvn:Patch(instance, property, value)` | changes a property and remembers the original |
| `Arvn:Restore(instance, property)` | puts the original back. Without a property, puts back all of them on that instance. |
| `Arvn:Connect(signal, fn)` | a connection that is disconnected on eject |
| `Arvn:Loop(fn, seconds)` | runs `fn` every few seconds, or every frame without `seconds`. Stops on eject. Returns a stop function. |
| `Arvn:Track(instance)` | destroys the instance on eject |
| `Arvn:OnEject(fn)` | runs `fn` on eject |
| `Arvn:OnReset(fn)` | runs `fn` when a player uses Reset Everything |
| `Arvn:SetWatermark({Text, Visible})` | changes the watermark |
| `Arvn:AddWatermarkPart(key, {Icon, Get})`, `Arvn:RemoveWatermarkPart(key)` | a live value in the watermark |
| `Arvn:SetTheme(name)` | same as `Arvn.Theme:Set(name)` |
| `Arvn:SetFont(name)`, `Arvn:AddFont(name, family)` | the menu font |
| `Arvn:SetResolution(mode)`, `Arvn:SetAspect(ratio)`, `Arvn:SetStyle(name)`, `Arvn:SetDensity(name)`, `Arvn:GetResolution()` | see [Resolution, ratio and stretch](resolution.md) |
| `Arvn:SetNotifySide(side)` | `"Top Right"`, `"Top Center"`, `"Top Left"`, `"Bottom Right"`, `"Bottom Center"` or `"Bottom Left"` |
| `Arvn:AddTooltip(guiObject, text)` | a tooltip on your own UI |
| `Arvn:RegisterElement(name, {Height, Default, Build})` | a new element type every section gets |
| `Arvn:HasIcon(name)` | `true` if the icon exists |
| `Arvn:Toggle(open)`, `Arvn:IsOpen()` | opens or closes the menu |
| `Arvn:Eject()` | same as `Window:Eject()` |

| Field | What it is |
|---|---|
| `Arvn.Flags` | every value by flag. Setting one updates the menu and runs the callback. |
| `Arvn.Elements` | every element you made, by flag |
| `Arvn.Theme` | see [Arvn.Theme](#arvntheme) |
| `Arvn.Config` | see [Arvn.Config](#arvnconfig) |
| `Arvn.Errors` | errors from your callbacks: `{t = time, msg = text}` |
| `Arvn.ShowErrors` | `true` shows callback errors as notifications |
| `Arvn.OnError` | set to a function to get every callback error |
| `Arvn.Themes`, `Arvn.Fonts`, `Arvn.Sounds` | the names you can pick from |
| `Arvn.Templates` | the names `Tab:Template` takes |
| `Arvn.Hex(color, alpha)` | turns a `Color3` into the hex string colors are stored as |
| `Arvn.Version` | the library version |

## Arvn.Theme

| Method | What it does |
|---|---|
| `Register(name, colors)` | adds a theme. See [Make your own theme](customization.md#make-your-own-theme). |
| `Set(name)`, `Get()`, `List()` | pick a theme, read the current colors, list theme names |
| `SetColor(name, color)`, `SetColors({name = color})` | change single colors on top of the theme |
| `GetColor(name)` | the current value of a color |
| `ResetColor(name)` | removes one change. Without a name, removes all of them. |
| `OnChanged(fn)` | runs `fn(theme)` when the theme or accent changes |
| `Export()`, `Import(code, name)` | share a theme as text |
| `Bind(instance, {Property = "Color"})`, `Unbind(instance)` | keeps your own UI in theme colors |

Color names: `Background`, `Panel`, `Card`, `Field`, `Hover`, `Popup`, `Text`, `Label`, `Subtext`, `Dim` and `Accent`.

## Arvn.Config

| Method | What it does |
|---|---|
| `Save(name)`, `Load(name)`, `Delete(name)`, `List()` | named configs |
| `SetAutoload(name)`, `GetAutoload()` | the config loaded on start |
| `Export()`, `Import(code)` | a config as a share code |
| `Set(key, value)`, `Get(key, default)` | your own data, saved with the settings |
| `ResetAll()` | the same as Reset Everything |

## Window

| Method | What it does |
|---|---|
| `Group(name)` or `Group({Name, Order, Visible})` | a sidebar heading. Returns a [Group](#group). |
| `Tab({...})` | a tab without a heading. Returns a [Tab](#tab). |
| `GetGroup(name)`, `GetTab(name)` | finds one by name, built-in ones included |
| `SelectTab(tab)` | opens a tab |
| `SetTitle(text)`, `SetSubtitle(text)`, `SetAuthor(text)`, `SetLogo(logo)` | the window's text and logo |
| `SetSize(width, height)` | the window size |
| `SetTheme(name)`, `SetAccent(color)`, `SetFont(name)`, `SetScale(percent)` | the look |
| `SetResolution(mode)`, `SetAspect(ratio)`, `SetAspectFit(mode)` | screen scaling and ratio, see [Resolution](resolution.md) |
| `SetStyle(name)`, `SetDensity(name)` | component style and spacing |
| `SetTextScale(pct)`, `SetIconScale(pct)`, `SetElementScale(pct)` | text, icon and row scale |
| `SetEasing(name)`, `SetMotion(level)` | transition curve and animation level |
| `SetWorldStretch(bool)`, `ResetDisplay()`, `GetResolution()` | 3D view stretch, display reset, and the current resolution table |
| `SetBackground({Image, Opacity, Darken, Fit, Enabled})` | the background image |
| `SetMenuKey(key)` | the key that opens the menu |
| `Toggle(open)`, `IsOpen()` | open or close the menu |
| `Minimize(bool)`, `IsMinimized()` | shrink the window to its header |
| `Center()` | moves the window to the middle of the screen |
| `OpenSearch()` | opens the menu with the search box focused |
| `OnOpen(fn)`, `OnClose(fn)` | runs `fn` when the menu opens or closes |
| `LockAll(reason)`, `UnlockAll()` | greys out every element on your pages |
| `Notify`, `Dialog`, `Prompt` | same as the `Arvn` ones |
| `SaveConfig(name)`, `LoadConfig(name)` | same as `Arvn.Config` |
| `Eject()` | turns everything off and removes the menu |

## Group

| Method | What it does |
|---|---|
| `Tab({Name, Icon, Description, Order, Locked, Visible, ShowWhen, Flag})` | adds a tab |
| `GetTab(name)` | finds a tab |
| `GetName()`, `SetName(text)` | the heading text |
| `SetVisible(bool)`, `SetOrder(n)` | hide or move it |
| `Destroy()` | removes it with its tabs |

## Tab

| Method | What it does |
|---|---|
| `Section(name)` or `Section({Name, Side, Order, Visible, ShowWhen, Pages, ResetButton})` | adds a section. Returns a [Section](#section). |
| `LeftSection(name)`, `RightSection(name)` | a section in that column |
| `SubTab({...})` | a tab inside this tab. Takes the same options as a tab. |
| `GetSection(name)`, `GetSubTab(name)` | finds one by name |
| `Template(name)` | fills the tab with a built-in page, see [Templates](#templates) |
| `CustomPage(function(frame, ui) end)` | a page you build yourself |
| `Select()` | opens it |
| `GetName()`, `SetName(text)`, `SetIcon(icon)`, `SetDescription(text)` | change how it looks |
| `SetVisible(bool)`, `IsVisible()`, `SetOrder(n)`, `MoveTo(index)` | show, hide or move it |
| `Lock(reason)`, `Unlock()` | stop it from being opened |
| `Destroy()` | removes it |

## Section

A section has every element as a method: `Toggle`, `Slider`, `Dropdown`, `Segmented`, `ColorPicker`, `Input`, `Keybind`, `Button`, `Buttons`, `Label`, `Paragraph`, `Info`, `Progress`, `Image`, `Console`, `PlayerList`, `Divider`, `Spacer` and `Custom`, plus any you add with `RegisterElement`.

| Method | What it does |
|---|---|
| `Page(name)` | adds a page to the section and returns it, for adding elements |
| `GetPage(name)` | finds a page |
| `GetName()`, `SetName(text)` | the title |
| `SetSide("Left" or "Right")`, `SetOrder(n)` | move it |
| `SetVisible(bool)`, `SetShowWhen(condition)` | hide it |
| `Destroy()` | removes it |

## Elements

Options and methods for each element are in [Elements](elements.md).

| Method | Works on |
|---|---|
| `Get()`, `Set(value, silent)`, `Reset()`, `IsDefault()` | every element with a value |
| `OnChanged(fn)`, `SetCallback(fn)` | every element with a value |
| `SetName`, `SetDescription`, `SetIcon`, `SetVisible`, `Lock`, `Unlock`, `IsLocked` | every element |
| `MoveUp`, `MoveDown`, `MoveTo(index)`, `Highlight`, `Reveal`, `Destroy` | every element |
| `AddButton({Icon, Tooltip, Callback})` | every row element |
| `Toggle`, `SetKey(key, mode)`, `GetKey`, `AddKeybind(key)`, `AddColor(color)` | Toggle |
| `SetMin`, `SetMax`, `SetRange(min, max)`, `SetStep`, `SetSuffix` | Slider |
| `SetValues(list, keep)`, `AddValues(list)`, `RemoveValues(list)`, `SelectAll()`, `DeselectAll()` | Dropdown, Segmented |
| `GetColor()` | ColorPicker, and the `Color` of a toggle |
| `Press()` | Button |
| `OnClick(fn)` | Button, Keybind |
| `SetText(text)` | Label |
| `SetBody(text)` | Paragraph |
| `Set(value)` | Info, Progress |
| `SetSource(source)` | Image |
| `Log`, `Success`, `Warn`, `Error`, `Append(text, level)`, `Clear`, `Copy` | Console |

## Notification handle

`Arvn:Notify` returns this. Call its methods with `:`.

| Method | What it does |
|---|---|
| `SetTitle(text)`, `SetBody(text)` | change the text |
| `SetProgress(0 to 1)` | shows a progress bar |
| `Dismiss()` | closes it |

## Widget

| Method | What it does |
|---|---|
| `SetRow(name, value, color)` | adds or updates a row |
| `RemoveRow(name)`, `Clear()` | removes rows |
| `SetTitle(text)`, `SetVisible(bool)` | the title and visibility |
| `Destroy()` | removes it |

## Templates

`Tab:Template(name)` fills a tab with a ready-made page.

| Name | What it has |
|---|---|
| `Player` | camera (field of view, zoom, third person, freecam) and character options that work out of the box |
| `World` | lighting, time of day, fog and color grading that work out of the box |
| `Extras` | a crosshair, cinematic bars and a vignette, that work out of the box |
| `Server` | server info and rejoin options |
| `Tools` | FPS unlock, Potato Mode and other utilities |
| `PlayerVisuals`, `Targets` | options only. They save like everything else, and you read their flags in your own code. |

## Built-in settings

Every option in Settings is a flag. Read or set them with `Arvn.Flags`, and set their starting value with `Defaults` in `CreateWindow`.

### General

| Flag | Setting | Default |
|---|---|---|
| `ui_menukey` | Menu Key | `"RightShift"` |
| `ui_menumode` | Key Mode: `"Toggle"` or `"Hold"` | `"Toggle"` |
| `ui_openload` | Open On Load | `true` |
| `ui_escclose` | Close With Escape | `false` |
| `ui_remember` | Remember Page | `true` |
| `ui_cursor` | Menu Cursor: `"System"` or `"Dot"` | `"System"` |
| `ui_button` | UI Button | `true` |
| `ui_tooltips` | Tooltips | `true` |
| `ui_anim` | Animations | `true` |
| `ui_anim_speed` | Animation Speed, `50` to `200` | `100` |
| `ui_bindnotify` | On/Off Alerts: `"Off"`, `"Keybinds Only"` or `"Always"` | `"Keybinds Only"` |
| `ui_confirm` | Ask Before Eject | `true` |

### Appearance

| Flag | Setting | Default |
|---|---|---|
| `ui_theme` | Theme | `"Dark"` |
| `ui_accent` | Accent | `"#E0313DFF"` |
| `ui_accent_sync` | picking a theme also picks its accent | `true` |
| `pal_win`, `pal_panel`, `pal_card`, `pal_text`, `pal_sub` | Custom theme colors | the theme's |
| `ui_scale` | Size, `75` to `130` | `100` |
| `ui_density` | Spacing: `"Comfortable"` or `"Compact"` | `"Comfortable"` |
| `ui_radius` | Roundness, `4` to `20` | `14` |
| `ui_font` | Font | `"BuilderSans"` |
| `ui_toggle` | Switch Style: `"Switch"`, `"Square"` or `"Checkbox"` | `"Switch"` |
| `ui_glass` | See-Through | `true` |
| `ui_glass_amt` | Transparency, `0` to `100` | `45` |
| `ui_rim` | Edge Light | `true` |
| `ui_blur` | Blur behind the menu | `true` |
| `ui_blur_size` | Blur Strength, `4` to `56` | `24` |
| `ui_dim` | Darken behind the menu | `true` |
| `ui_dim_amt` | Darken Amount, `0` to `85` | `40` |
| `fx_style` | Particles: `"Snow"`, `"Sparkles"`, `"Dust"` or `"Off"` | `"Snow"` |
| `fx_density` | Particle Density, `10` to `250` | `90` |
| `fx_size` | Particle Size, `1` to `6` | `3` |
| `fx_speed` | Particle Speed, `25` to `300` | `100` |
| `fx_follow` | Particles follow the cursor | `true` |

### Overlays

| Flag | Setting | Default |
|---|---|---|
| `ov_wm` | Watermark | `true` |
| `wm_style` | Watermark Style: `"Glass"`, `"Solid"` or `"Minimal"` | `"Glass"` |
| `wm_fps`, `wm_ping`, `wm_uptime`, `wm_exec`, `wm_user` | frame rate, ping, session time, executor, account | `true` |
| `wm_region`, `wm_time` | location, clock | `false` |
| `ov_kb` | Keybind List | `true` |
| `kb_inactive` | also list keybinds that are off | `true` |
| `kb_hideempty` | hide the list when it's empty | `false` |
| `ov_ks` | Keystrokes | `false` |
| `ks_layout` | Keystrokes Layout: `"Stacked"`, `"Compact"` or `"Wide"` | `"Stacked"` |
| `ks_mouse`, `ks_cps`, `ks_space` | mouse buttons, clicks per second, space bar | `true` |
| `nt_on` | Notifications | `true` |
| `nt_pos` | Notification Position | `"Top Right"` |
| `nt_dur` | Notification Duration in seconds, `1` to `10` | `4` |
| `nt_style` | Notification Style: `"Card"` or `"Compact"` | `"Card"` |
| `nt_max` | Most notifications on screen, `1` to `8` | `5` |
| `ov_lock` | Lock overlay positions | `false` |

### Profile

| Flag | Setting | Default |
|---|---|---|
| `prof_name`, `prof_tag` | Display Name, Tagline | `""` |
| `pfp_url` | profile picture link | `""` |
| `bg_on` | Background Image | `false` |
| `bg_url` | background link | `""` |
| `bg_opacity` | Background Opacity, `0` to `100` | `45` |
| `bg_dark` | Background Darken, `0` to `90` | `45` |
| `bg_fit` | Background Fit: `"Crop"`, `"Fit"`, `"Stretch"` or `"Tile"` | `"Crop"` |

### Sounds

| Flag | Setting | Default |
|---|---|---|
| `snd_on` | Sounds | `true` |
| `snd_vol` | Volume, `0` to `100` | `55` |
| `snd_click`, `snd_toggle`, `snd_hover`, `snd_slider`, `snd_open`, `snd_notify`, `snd_bind`, `snd_error` | the sound for each event, one of `Arvn.Sounds` | `"Soft"`, `"Switch"`, `"None"`, `"Tick"`, `"Swoosh"`, `"Chime"`, `"Pop"`, `"Drop"` |

## Eject

Eject can be done from Settings, from the profile menu, or with `Window:Eject()`. It:

- saves the current settings first, so nothing is lost
- turns off every toggle that isn't a setting, which runs their callbacks with `false`
- puts back everything changed with `Patch`
- stops every `Connect` and `Loop`, and destroys everything passed to `Track`
- runs your `OnEject` functions
- removes the menu
