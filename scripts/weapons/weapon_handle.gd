class_name WeaponHandle extends Node3D
var current_weapon: WeaponBase
var is_attacking = false

var _combat_module: CombatModule
var _player_controller: PlayerController

var _cci: CombatCursorInfo

func _init(cci: CombatCursorInfo):
	_cci = cci

func _ready():
	_combat_module = get_parent()
	_player_controller = _combat_module.get_parent().get_parent()

func _process(delta):
	if current_weapon != null:
		var pos2 = _cci.get_position.call()
	
		var pos3 = _2d_to_3d(pos2)
		
		position = pos3 / 10
		position.z = pos3.z
		
		#basis = basis.looking_at(pos3, Vector3.UP)
		current_weapon.rotation.y = _cci.get_angle.call()
		rotation.x =- PI/2

func set_weapon(weapon: WeaponBase):
	if current_weapon != null:
		current_weapon.queue_free()
	add_child(weapon)
	current_weapon = weapon

func _2d_to_3d(pos2: Vector2) -> Vector3:
	pos2 -= _player_controller.ui_root.size
	var ui_center = _player_controller.ui_root.center
	var cam_fov = _player_controller.camera_module.fov
	return Vector3(
		remap(pos2.x, -ui_center.x, ui_center.x, 0, cam_fov),
		-remap(pos2.y, -ui_center.y, ui_center.y, 0, cam_fov),
		current_weapon.size * -5
	)
