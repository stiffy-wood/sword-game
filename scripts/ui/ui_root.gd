class_name UIRoot extends Node2D

var _size: Vector2 = Vector2()
var _center: Vector2 = Vector2()
var _reticle: Reticle
var _cursor: Cursor
var _combat_cursor: CombatCursor

var size: Vector2:
	get:
		if _size == Vector2.ZERO:
			_size = get_viewport_rect().size
		return _size

var center: Vector2:
	get:
		if _center == Vector2.ZERO:
			_center = get_viewport_rect().get_center()
		return _center

func _init():
	_reticle = Reticle.new()
	add_child(_reticle)
	
	_cursor = Cursor.new()
	add_child(_cursor)
	
	_combat_cursor = CombatCursor.new()
	add_child(_combat_cursor)

func create_tether(start: Vector2, end: Vector2, color: Color, mode: Tether.Mode) -> Tether:
	var t = Tether.new(start, end, color, mode)
	add_child.call_deferred(t)
	return t

func create_label() -> Label:
	var l = Label.new()
	add_child(l)
	return l

func get_mouse_cursor() -> Cursor:
	return _cursor

func get_combat_cursor() -> CombatCursor:
	return _combat_cursor
