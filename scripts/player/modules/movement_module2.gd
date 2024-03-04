class_name MovementModule2 extends Node

signal player_turned(relative: Vector2)
signal player_moved(relative: Vector2)
signal player_jumped()

@export var gravity = -9.8 * 1.5
@export var terminal_velocity = 55.5 # 55.5m/s - human terminal velocity
@export var move_speed = 5.0
@export var sprint_speed_multiplier = 1.5
@export var jump_force = 5.0
@export var sprint_speed_acceleration = 10.0

@export var movement_sensitivity = 10.0
@export var rotation_sensitivity = 10.0

@export var coyote_time_frames = 20
@export var max_jump_force_duration_frames = 5

var target_velocity: Vector3 = Vector3()
var target_y_rotation: float = 0.0

var current_speed_multiplier: float = 1.0
var frames_since_left_ground = 0

var has_double_jumped = false
var controller: PlayerController

var max_velocity: float:
	get:
		return move_speed * sprint_speed_multiplier

var _rotation_lerper: Lerper

func _init():
	_rotation_lerper = Lerper.new_lerper(Lerper.Type.Angle, 10, 10)

func _ready():
	controller = get_parent()

func _process(delta):
	controller.velocity = get_velocity(delta, controller.velocity)
	controller.rotation.y = _rotation_lerper.lerp_to_target(delta)
	
func get_velocity(delta, current_velocity: Vector3):
	target_velocity = process_horizontal_movement(delta, target_velocity)
	target_velocity.y = process_jumping(delta, target_velocity.y)
	target_velocity = process_velocity(target_velocity)

	current_velocity = current_velocity.lerp(target_velocity, movement_sensitivity * delta)
	if not is_zero_approx(target_velocity.y):
		current_velocity.y = target_velocity.y
	
	return current_velocity

func process_velocity(current_velocity: Vector3):
	return current_velocity * controller.global_basis.inverse() # apply to global space

func process_horizontal_movement(delta, current_velocity: Vector3):
	var move_velocity = Vector3(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		0,
		Input.get_action_strength("Backward") - Input.get_action_strength("Forward")
	).normalized() * move_speed 

	move_velocity = process_sprinting(delta, move_velocity)
	
	move_velocity.y = current_velocity.y
	return move_velocity

func process_sprinting(delta, current_horizontal_velocity):
	current_speed_multiplier = lerp(
		current_speed_multiplier, 
		sprint_speed_multiplier if Input.is_action_pressed("Sprint") else 1.0, 
		delta * sprint_speed_acceleration)
		
	return current_horizontal_velocity * current_speed_multiplier

func process_jumping(delta, current_y_velocity):
	if not controller.is_on_floor():
		frames_since_left_ground += 1
		current_y_velocity = clamp(current_y_velocity + gravity * delta, -terminal_velocity, jump_force)
	else:
		frames_since_left_ground = 0
		current_y_velocity = 0
		has_double_jumped = false
	
	if check_continous_jump() or check_coyote_time_jump():
		current_y_velocity = jump_force
	elif check_double_jump():
		current_y_velocity = jump_force
		has_double_jumped = true
		frames_since_left_ground = 0
	
	return current_y_velocity

func check_continous_jump():
	return Input.is_action_pressed("Jump") and not Input.is_action_just_pressed("Jump") and frames_since_left_ground <= max_jump_force_duration_frames

func check_coyote_time_jump():
	return Input.is_action_just_pressed("Jump") and frames_since_left_ground <= coyote_time_frames
	
func check_double_jump():
	return Input.is_action_just_pressed("Jump") and can_use_double_jump() and not has_double_jumped

func check_is_sprinting():
	return current_speed_multiplier > 1.0

func can_use_double_jump():
	return Unlocks.double_jump == Unlocks.Status.UNLOCKED
	
func _input(event):
	if event is InputEventMouseMotion:
		var mmi = MouseProcessor.process_relative_mouse_input(event.relative)
		_rotation_lerper.set_target(_rotation_lerper.get_target() - (mmi.relative.x / 100))
		player_turned.emit(mmi.relative)
