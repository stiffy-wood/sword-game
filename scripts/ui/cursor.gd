class_name Cursor extends Node2D

@export var cursor_texture: Texture = preload("res://sprites/cursor.png")
@export var max_radius: float = 200.0
@export var radius_lower_bound: float = 0.2
@export var radius_upper_bound: float = 0.8

var root: UIRoot
var cursor_sprite: Sprite2D

var _cursor_direction_lerper: Lerper
var _cursor_position_lerper: Lerper

var _center_tether: Tether
var _target_cursor_direction: Vector2 = Vector2()

func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	cursor_sprite = Sprite2D.new()
	cursor_sprite.texture = cursor_texture
	add_child(cursor_sprite)
	
	_cursor_position_lerper = Lerper.new_lerper(Lerper.Type.Vector, 0.5, 10)
	_cursor_direction_lerper = Lerper.new_lerper(Lerper.Type.Angle, 1, 10)

func _ready():
	root = get_parent() as UIRoot
	global_position = root.center
	_center_tether = root.create_tether(root.center, global_position, Color(0.9, 0.9, 0.9, 0.1), Tether.Mode.Straight)
	
	_cursor_position_lerper.set_target(root.center)
	_cursor_position_lerper.set_inter_value(root.center)

func _process(delta):
	if _cursor_position_lerper.get_inter_distance_to(root.center) > max_radius * radius_lower_bound:
		_cursor_position_lerper.lerp_to_target(delta)
	global_position = _cursor_position_lerper.lerp_to_inter(delta, global_position)
	
	var dir_to_center = root.center.direction_to(global_position)
	_cursor_direction_lerper.set_target(atan2(dir_to_center.y, dir_to_center.x) + (PI / 4))
	cursor_sprite.global_rotation = _cursor_direction_lerper.lerp_full(delta, cursor_sprite.global_rotation)

	_center_tether.update_end(get_cursor_tether_point())
	

func _input(event):
	if event is InputEventMouseMotion:
		var mmi: MouseMoveInfo = MouseProcessor.process_relative_mouse_input(event.relative)
		
		var distance_from_center = _cursor_position_lerper.get_inter_distance_to(root.center)
		var direction_to_center = _cursor_position_lerper.get_inter_value().direction_to(root.center) as Vector2
		var movement = mmi.relative * 2
		
		if distance_from_center > max_radius * radius_upper_bound and distance_from_center < max_radius:
			var angle = acos(direction_to_center.dot(mmi.direction))
			
			if angle > PI / 2:
				var tangent_direction = direction_to_center.rotated(PI / 2)
				if tangent_direction.dot(mmi.direction) < 0:
					tangent_direction = tangent_direction.rotated(PI)
				
				movement = tangent_direction * mmi.magnitude
		
		var target_pos = _cursor_position_lerper.get_inter_value() + movement
		if target_pos.distance_to(root.center) > max_radius:
			target_pos = root.center + root.center.direction_to(target_pos) * max_radius
		
		_cursor_position_lerper.set_inter_value(target_pos)
		_cursor_direction_lerper.set_inter_value(mmi.direction_angle + (PI / 4))

func get_cursor_tether_point() -> Vector2:
	var rot = Vector2(cos(cursor_sprite.global_rotation - (PI / 4)), sin(cursor_sprite.global_rotation - (PI / 4)))
	return global_position - (cursor_sprite.texture.get_size() * rot) / 1.5
	
	
