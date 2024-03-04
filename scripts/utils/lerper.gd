class_name Lerper

enum Type{
	Angle,
	Vector,
	Float,
	Integer
}

class AngleLerper extends Lerper:
	func _init():
		_target_value = 0.0
		_inter_value = _target_value
		
	func lerp_to_target(delta) -> Variant:
		_inter_value = lerp_angle(_inter_value, _target_value, delta * _inter_smoothness)
		return _inter_value
	
	func lerp_to_inter(delta, current_value) -> Variant:
		return lerp_angle(current_value, _inter_value, delta * _smoothness)
	
	func get_target_distance_to(value) -> Variant:
		var delta = fmod(_target_value - value, 2 * PI)
		if delta > PI:
			delta -= 2 * PI
		elif delta < -PI:
			delta += 2 * PI
			
		return abs(delta)
	
	func get_inter_distance_to(value) -> Variant:
		var delta = fmod(_inter_value - value, 2 * PI)
		if delta > PI:
			delta -= 2 * PI
		elif delta < -PI:
			delta += 2 * PI
			
		return abs(delta)
		
class VectorLerper extends Lerper:
	func _init():
		_target_value = Vector2()
		_inter_value = _target_value

	func lerp_to_target(delta) -> Variant:
		_inter_value = _inter_value.lerp(_target_value, delta * _inter_smoothness)
		return _inter_value
	
	func lerp_to_inter(delta, current_value) -> Variant:
		return current_value.lerp(_inter_value, delta * _smoothness)
	
	func get_target_distance_to(value) -> Variant:
		return _target_value.distance_to(value)
	
	func get_inter_distance_to(value) -> Variant:
		return _inter_value.distance_to(value)

class FloatLerper extends Lerper:
	func _init():
		_target_value = 0.0
		_inter_value = _target_value

	func lerp_to_target(delta) -> Variant:
		_inter_value = lerpf(_inter_value, _target_value, delta * _inter_smoothness)
		return _inter_value
	
	func lerp_to_inter(delta, current_value) -> Variant:
		return lerpf(current_value, _inter_value, delta * _smoothness)
	
	func get_target_distance_to(value) -> Variant:
		return abs(_target_value - value)
	
	func get_inter_distance_to(value) -> Variant:
		return abs(_inter_value - value)

class SimpleLerper extends Lerper:
	func _init():
		_target_value = 0
		_inter_value = _target_value

	func lerp_to_target(delta) -> Variant:
		_inter_value = lerp(_inter_value, _target_value, delta * _inter_smoothness)
		return _inter_value
		
	func lerp_to_inter(delta, current_value) -> Variant:
		return lerp(current_value, _inter_value, delta * _smoothness)
		
	func get_target_distance_to(value) -> Variant:
		return abs(_target_value - value)
	
	func get_inter_distance_to(value) -> Variant:
		return abs(_inter_value - value)

var _inter_value
var _target_value
var _inter_smoothness: float
var _smoothness: float

static func new_lerper(type: Type, inter_smoothness: float, smoothness: float) -> Lerper:
	var lerper: Lerper
	if type == Type.Angle:
		lerper = AngleLerper.new()
	elif type == Type.Vector:
		lerper = VectorLerper.new()
	elif type == Type.Float:
		lerper = FloatLerper.new()
	else:
		lerper = SimpleLerper.new()
	
	lerper._inter_smoothness = inter_smoothness
	lerper._smoothness = smoothness
	return lerper

func get_target_distance_to(value) -> Variant:
	push_error("Not Implemented")
	return null

func get_inter_distance_to(value) -> Variant:
	push_error("Not Implemented")
	return null
	
## Lerps the inter value to target
func lerp_to_target(delta) -> Variant:
	push_error("Not Implemented")
	return null

## Lerps the current_value to inter_value
func lerp_to_inter(delta, current_value) -> Variant:
	push_error("Not Implemented")
	return null

## Lerps the inter value to target, and the current value to inter value
func lerp_full(delta, current_value) -> Variant:
	lerp_to_target(delta)
	return lerp_to_inter(delta, current_value)

func set_target(target):
	_target_value = target

func get_target() -> Variant:
	return _target_value
	
func set_inter_value(target):
	_inter_value = target

func get_inter_value() -> Variant:
	return _inter_value
	
func set_inter_smoothness(value: float):
	_inter_smoothness = value

func set_smoothness(value: float):
	_smoothness = value
