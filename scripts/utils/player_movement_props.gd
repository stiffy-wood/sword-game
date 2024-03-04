class_name PlayerMoveProps

var gravity = -9.8 * 1.5
var terminal_velocity = 55.5 # 55.5m/s - human terminal velocity
var move_speed = 5.0
var sprint_speed_multiplier = 1.5
var crouch_speed_multiplier = 0.5
var jump_force = 5.0

var movement_sensitivity = 10.0
var rotation_sensitivity = 10.0

var coyote_time_duration = 0.3
var jump_grace_period_duration = 0.1

var crouch_size = 0.5

var falling_move_speed_modifier = 0.5

var max_velocity: 
	get:
		return move_speed * sprint_speed_multiplier
