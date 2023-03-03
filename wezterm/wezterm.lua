local wezterm = require("wezterm")
local act = wezterm.action

local activate_resize_keytable = act.ActivateKeyTable({
	name = "resize_pane",
	one_shot = false,
	timeout_milliseconds = 1000,
	until_unknown = true,
})

return {
	disable_default_key_bindings = true,
	visual_bell = {
		fade_in_duration_ms = 75,
		fade_out_duration_ms = 75,
		target = "CursorColor",
	},
	-- timeout_milliseconds defaults to 1000 and can be omitted
	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = {
		-- normal keys
		{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
		{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
		{ key = "f", mods = "CMD", action = act.Search({ CaseSensitiveString = "" }) },
		{ key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = true }) },
		{ key = "k", mods = "CMD", action = act.ClearScrollback("ScrollbackOnly") },
		{ key = "q", mods = "CMD", action = act.QuitApplication },
		{ key = "LeftArrow", mods = "ALT", action = act.SendString("\x1bb") },
		{ key = "RightArrow", mods = "ALT", action = act.SendString("\x1bf") },
		{ key = "LeftArrow", mods = "CMD", action = act.SendKey({ key = "Home" }) },
		{ key = "RightArrow", mods = "CMD", action = act.SendKey({ key = "End" }) },
		{ key = "+", mods = "CMD|SHIFT", action = act.IncreaseFontSize },
		{ key = "_", mods = "CMD|SHIFT", action = act.DecreaseFontSize },
		{ key = "0", mods = "CMD", action = act.ResetFontSize },
		-- tabs
		{ key = "t", mods = "CMD", action = act.SpawnCommandInNewTab({ cwd = "$HOME" }) },
		{ key = "a", mods = "LEADER", action = act.ActivateLastTab },
		{ key = "n", mods = "LEADER", action = act.ActivateTabRelativeNoWrap(1) },
		{ key = "p", mods = "LEADER", action = act.ActivateTabRelativeNoWrap(-1) },
		{ key = "1", mods = "CMD", action = act.ActivateTab(0) },
		{ key = "2", mods = "CMD", action = act.ActivateTab(1) },
		{ key = "3", mods = "CMD", action = act.ActivateTab(2) },
		{ key = "4", mods = "CMD", action = act.ActivateTab(3) },
		{ key = "5", mods = "CMD", action = act.ActivateTab(4) },
		{ key = "6", mods = "CMD", action = act.ActivateTab(5) },
		{ key = "7", mods = "CMD", action = act.ActivateTab(6) },
		{ key = "8", mods = "CMD", action = act.ActivateTab(7) },
		{ key = "9", mods = "CMD", action = act.ActivateTab(8) },
		-- splits
		{ key = "|", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = '"', mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
		{ key = "}", mods = "LEADER", action = act.RotatePanes("Clockwise") },
		{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
		-- when resizing, resize on the first keypress then activate layer
		{
			key = "h",
			mods = "LEADER|CTRL",
			action = act.Multiple({ act.AdjustPaneSize({ "Left", 1 }), activate_resize_keytable }),
		},
		{
			key = "j",
			mods = "LEADER|CTRL",
			action = act.Multiple({ act.AdjustPaneSize({ "Down", 1 }), activate_resize_keytable }),
		},
		{
			key = "k",
			mods = "LEADER|CTRL",
			action = act.Multiple({ act.AdjustPaneSize({ "Up", 1 }), activate_resize_keytable }),
		},
		{
			key = "l",
			mods = "LEADER|CTRL",
			action = act.Multiple({ act.AdjustPaneSize({ "Right", 1 }), activate_resize_keytable }),
		},
		-- wezterm
		{
			key = "u",
			mods = "LEADER",
			action = wezterm.action.QuickSelectArgs({
				label = "open url",
				patterns = {
					"https?://\\S+",
				},
				action = wezterm.action_callback(function(window, pane)
					local url = window:get_selection_text_for_pane(pane)
					wezterm.log_info("opening: " .. url)
					wezterm.open_with(url)
				end),
			}),
		},
		{ key = "d", mods = "LEADER", action = act.DetachDomain("CurrentPaneDomain") },
		{ key = "d", mods = "LEADER|SHIFT", action = act.ShowDebugOverlay },
		{ key = "Space", mods = "LEADER", action = act.ToggleFullScreen },
		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
		{ key = "a", mods = "LEADER|CTRL", action = act.SendString("\x01") },
	},
	key_tables = {
		resize_pane = {
			{ key = "h", mods = "CTRL", action = act.AdjustPaneSize({ "Left", 1 }) },
			{ key = "j", mods = "CTRL", action = act.AdjustPaneSize({ "Down", 1 }) },
			{ key = "k", mods = "CTRL", action = act.AdjustPaneSize({ "Up", 1 }) },
			{ key = "l", mods = "CTRL", action = act.AdjustPaneSize({ "Right", 1 }) },
			-- Cancel the mode by pressing escape
			{ key = "Escape", action = "PopKeyTable" },
		},
	},
}
