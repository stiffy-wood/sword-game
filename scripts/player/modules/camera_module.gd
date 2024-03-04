class_name CameraModule extends Camera3D

@export var max_fov_multiplier = 1.2
@export var fov_sensitivity = 10

var default_cam_fov: float
var controller: PlayerController
var target_x_rotation: float

func _init():
	default_cam_fov = fov

func _ready():
	controller = get_parent() as PlayerController
	
func _process(delta):
	rotation.x = lerp_angle(rotation.x, target_x_rotation, delta * 10)
	process_camera_fov(delta)	

func _input(event):
	if event is InputEventMouseMotion:
		var mmi = MouseProcessor.process_relative_mouse_input(event.relative)
		target_x_rotation -= mmi.relative.y / 100
		target_x_rotation = clamp(fmod(target_x_rotation, 2 * PI), deg_to_rad(-80), deg_to_rad(80))

func on_mouse_move(relative: Vector2):
	target_x_rotation -= (relative.y / 100)
	target_x_rotation = clamp(fmod(target_x_rotation, 2 * PI), deg_to_rad(-80), deg_to_rad(80))

func process_camera_fov(delta):	
	if Cfg.accessibility.static_fov:
		return
	
	var projected_velocity = controller.velocity.project(-global_transform.basis.z.normalized())
	var target_fov = default_cam_fov + (((default_cam_fov * max_fov_multiplier) - default_cam_fov) * projected_velocity.length()) / controller.movement_state_machine._move_props.max_velocity #controller.movement_module.max_velocity 
	fov = lerp(fov, target_fov, delta * fov_sensitivity)
