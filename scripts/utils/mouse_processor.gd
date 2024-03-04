class_name MouseProcessor

static func process_relative_mouse_input(relative: Vector2) -> MouseMoveInfo:
	var mmi = MouseMoveInfo.new()
	mmi.relative = relative * Cfg.controls.mouse_sensitivity
	return mmi
