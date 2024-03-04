class_name WeaponSword extends WeaponBase

func _init():
	super()
	var weapon_resource = load("res://sword.blend")
	weapon = weapon_resource.instantiate()
	add_child(weapon)
	
	size = 0.2
	weight = 1.5
