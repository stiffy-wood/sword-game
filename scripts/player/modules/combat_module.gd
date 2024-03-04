class_name CombatModule extends Node3D

var player_controller: PlayerController
var weapon_handle: WeaponHandle

func _init(cci: CombatCursorInfo):
	weapon_handle = WeaponHandle.new(cci)
	add_child(weapon_handle)

func _ready():
	player_controller = get_parent().get_parent() as PlayerController
	set_weapon(WeaponSword.new())

func set_weapon(weapon: WeaponBase):
	weapon_handle.set_weapon(weapon)
	player_controller.ui_root.get_combat_cursor().set_weapon(weapon_handle.current_weapon)
