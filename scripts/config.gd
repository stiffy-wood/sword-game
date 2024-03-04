class_name Config extends Node

class Accessibility:
	var static_fov: bool = false
	var left_handed: bool = false

class Controls:
	var mouse_sensitivity: float = 0.2
	var crouch_toggle: bool = true
	var sprint_toggle: bool = true

var _cfg_file: ConfigFile

var accessibility: Accessibility
var controls: Controls

func _init():
	_cfg_file = ConfigFile.new()
	_cfg_file.load("res://config.cfg")
	
	accessibility = Accessibility.new()
	controls = Controls.new()
	
	_update_values()

func _update_values():
	accessibility.static_fov = _cfg_file.get_value("Accessibility", "static_fov", accessibility.static_fov)
	accessibility.left_handed = _cfg_file.get_value("Accessibility", "left_handed", accessibility.left_handed)
	controls.mouse_sensitivity = _cfg_file.get_value("Controls", "mouse_sensitivity", controls.mouse_sensitivity)
	controls.crouch_toggle = _cfg_file.get_value("Controls", "crouch_toggle", controls.crouch_toggle)
	controls.sprint_toggle = _cfg_file.get_value("Controls", "sprint_toggle", controls.sprint_toggle)
	
func update_config(section: String, property: String, value):
	if value == null:
		return
	
	_cfg_file.set_value(section, property, value)
	_cfg_file.save("res://config.cfg")
