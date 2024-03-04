class_name CombatCursor extends Node2D

@export var cursor_texture: Texture = preload("res://sprites/combat_cursor.png")

var root: UIRoot
var cursor_sprite: Sprite2D

var _cursor: Cursor
var _cursor_lerper: Lerper
var _combat_tether: Tether
var _center_tether: Tether

var _weapon: WeaponBase

var _overshoot_multiplier: float = 0.5
var _current_strike_distance: float = 0.0
var _striking: bool: 
	get:
		return _current_strike_distance > 0.0

func _init():
	cursor_sprite = Sprite2D.new()
	cursor_sprite.texture = cursor_texture
	cursor_sprite.scale *= 0.3
	add_child(cursor_sprite)
	
	set_weapon(null)
	_cursor_lerper = Lerper.new_lerper(Lerper.Type.Vector, 1, 10)
	
func _ready():
	root = get_parent() as UIRoot
	_cursor = root.get_mouse_cursor()
	_cursor_lerper.set_target(root.center)
	position = root.center
	
	_combat_tether = root.create_tether(_cursor.get_cursor_tether_point(), get_cursor_tether_point(), Color(0.9, 0.2, 0.0, 0.5), Tether.Mode.Straight)
	_center_tether = root.create_tether(root.center, get_cursor_tether_point(), Color(0.9, 0.9, 0.9, 0.1), Tether.Mode.Straight)
	
func _process(delta):
	_cursor_lerper.set_target(_cursor.global_position + Vector2(0, 0 if _weapon == null else (_weapon.weight / Unlocks.max_weapon_weight) * 100))
	global_position = _cursor_lerper.lerp_full(delta, global_position)
	
	var direction_to_cursor = -global_position.direction_to(_cursor.global_position)
	cursor_sprite.rotation = lerp_angle(cursor_sprite.rotation, atan2(direction_to_cursor.y, direction_to_cursor.x) + (PI / 4), delta * 10)
	
	_combat_tether.update_start(_cursor.get_cursor_tether_point())
	_combat_tether.update_end(get_cursor_tether_point())
	_center_tether.update_end(get_cursor_tether_point())

func get_cursor_tether_point() -> Vector2:
	var rot = Vector2(cos(cursor_sprite.rotation - (PI / 4)), sin(cursor_sprite.rotation - (PI / 4)))
	return global_position - (cursor_sprite.texture.get_size() * cursor_sprite.scale * rot) / 1.5	

func sprite_to_rect(sprite: Sprite2D) -> Rect2:
	return Rect2(
		sprite.global_position - sprite.texture.get_size() * 0.5 * sprite.scale, 
		sprite.texture.get_size() * sprite.scale
	)

func set_weapon(weapon: WeaponBase):
	if weapon == null:
		return
	_weapon = weapon
	_cursor_lerper.set_inter_smoothness(Unlocks.max_weapon_weight / _weapon.weight)

func get_cursor_info() -> CombatCursorInfo:
	var cci = CombatCursorInfo.new()

	cci.get_position = func() -> Vector2: 
		return global_position
		
	cci.get_angle = func() -> float: 
		return cursor_sprite.rotation + (PI / 4)
		
	cci.get_direction_to_cursor = func() -> Vector2:
		return global_position.direction_to(_cursor.global_position)
	
	cci.get_distance_to_cursor = func() -> float:
		return global_position.distance_to(_cursor.global_position)
		
	return cci

func get_cursor_angle() -> float:
	return cursor_sprite.rotation

func get_cursor_position() -> Vector2:
	return global_position
