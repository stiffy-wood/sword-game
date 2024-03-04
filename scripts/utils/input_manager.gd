class_name InputManager extends Node

var moving_forward: bool:
    get:
        return Input.is_action_pressed("Forward")
        
var moving_backward: bool:
    get:
        return Input.is_action_pressed("Backward")
        
var moving_left: bool:
    get:
        return Input.is_action_pressed("Left")
        
var moving_right: bool:
    get:
        return Input.is_action_pressed("Right")

var is_moving: bool:
    get:
        return moving_forward || moving_backward || moving_left || moving_right

var movement: Vector2:
    get:
        return Vector2(
        Input.get_action_strength("Right") - Input.get_action_strength("Left"),
        Input.get_action_strength("Backward") - Input.get_action_strength("Forward")
        )
        
var is_jumping: bool:
    get:
        return Input.is_action_pressed("Jump")
        
var has_just_jumped: bool:
    get:
        return Input.is_action_just_pressed("Jump")

var has_stopped_jumping: bool:
    get:
        return Input.is_action_just_released("Jump")
        
var is_sprinting: bool:
    get:
        return Input.is_action_pressed("Sprint")

var has_just_sprinted: bool:
    get:
        return Input.is_action_just_pressed("Sprint")

var is_crouching: bool:
    get:
        return Input.is_action_pressed("Crouch")

var has_just_crouched: bool:
    get:
        return Input.is_action_just_pressed("Crouch")
