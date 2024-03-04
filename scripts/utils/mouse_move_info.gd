class_name MouseMoveInfo

var relative: Vector2
var direction:
	get:
		return relative.normalized()
var magnitude:
	get:
		return relative.length()
var direction_angle:
	get:
		var dir = direction
		return atan2(dir.y, dir.x)
