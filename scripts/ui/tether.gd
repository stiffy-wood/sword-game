class_name Tether extends Line2D

enum Mode{
	Bezier,
	Straight
}

var _start: Vector2
var _mid_start: Vector2
var _mid_end: Vector2
var _end: Vector2
var _detail = 10.0
var _mode: Mode = Mode.Straight

func _init(start: Vector2, end: Vector2, color: Color, mode: Mode):
	_start = start
	_end = end
	
	_mid_start = _start
	_mid_end = _end
	
	_mode = mode
	
	default_color = color
	end_cap_mode = Line2D.LINE_CAP_ROUND
	begin_cap_mode = Line2D.LINE_CAP_ROUND
	width = 1

func update_start(start: Vector2):
	_start = start

func update_end(end: Vector2):
	_end = end

func update_color(color: Color):
	default_color = color

func update_width(new_width: float):
	width = new_width

func _process(delta):
	if _mode == Mode.Bezier:
		_mid_start = _mid_start.lerp(
			_start.lerp(_end, 0.5), 
			0.1)
		_mid_end = _mid_end.lerp(
			_start.lerp(_end, 0.8), 
			0.1)
		points = _calculate_bezier_curve()
	
	
	elif _mode == Mode.Straight:
		points = [_start, _end]
	queue_redraw()

func _calculate_bezier_curve():
	var bezier_points = []
	for i in range(_detail + 1):
		var t = i / float(_detail)
		bezier_points.append(_calculate_bezier_point(t, _start, _mid_start, _mid_end, _end))
	return bezier_points
	
func _calculate_bezier_point(t, p0, p1, p2, p3) -> Vector2:
	var p01 = p0.lerp(p1, t)
	var p12 = p1.lerp(p2, t)
	var p23 = p2.lerp(p3, t)
	
	var p012 = p01.lerp(p12, t)
	var p123 = p12.lerp(p23, t)
	
	return p012.lerp(p123, t)
