class_name PlayerController extends CharacterBody3D

var root: Root

var movement_state_machine: MovementStateMachine
var camera_module: CameraModule
var combat_module: CombatModule

var ui_root: UIRoot
var collision_shape: CollisionShape3D

var default_height: float

func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	movement_state_machine = MovementStateMachine.new()
	add_child(movement_state_machine)
	
	ui_root = UIRoot.new()
	add_child(ui_root)
	
	collision_shape = CollisionShape3D.new()
	collision_shape.shape = CapsuleShape3D.new()
	add_child(collision_shape)
	default_height = collision_shape.shape.height

func _ready():
	root = (get_tree().root.get_child(0) as Root)
	camera_module = $PlayerCamera

	combat_module = CombatModule.new(ui_root.get_combat_cursor().get_cursor_info())
	camera_module.add_child(combat_module)
	
	collision_shape = $CollisionShape3D
	
func _process(delta):
	move_and_slide()
	
func set_height(new_height: float):
	collision_shape.scale.y = new_height
	
func get_height() -> float:
	return collision_shape.scale.y

