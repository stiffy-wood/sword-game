class_name Reticle extends Node2D

var root: UIRoot

var _color = Color(0.9, 0.9, 0.9, 0.5)
var _detail = 100

func _ready():
	root = get_parent() as UIRoot
	position = root.center

func _draw():
	draw_arc(Vector2(0, 0), root.get_mouse_cursor().max_radius, 0, 2 * PI, _detail, _color, 0.4, true)
	draw_circle(Vector2(0, 0), 2, _color)
