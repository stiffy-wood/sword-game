class_name MovementStateMachine extends Node

var _flags = 0
var _move_props: PlayerMoveProps

var _states: Array[StateBase]
var _player_controller: PlayerController

var _velocity_lerper: Lerper
var _rotation_lerper: Lerper

func _init():
    _move_props = PlayerMoveProps.new()
    _velocity_lerper = Lerper.new_lerper(Lerper.Type.Vector, _move_props.movement_sensitivity, 0)
    _velocity_lerper.set_target(Vector3())
    _velocity_lerper.set_inter_value(Vector3())
    
    _rotation_lerper = Lerper.new_lerper(Lerper.Type.Angle, _move_props.rotation_sensitivity, 0)
    
func _ready():
    _player_controller = get_parent() as PlayerController
    _states = MoveStates.get_states(_player_controller, _move_props)
    
func _process(delta):
#   _print_flag()
    var sc = MoveStates.StateContext.new(delta, _flags, _player_controller.velocity, _player_controller.get_height(), _move_props.movement_sensitivity)
    for s in _states:
        sc = s.execute(sc)
    
    _flags = sc.flags
    var v = _to_global_space(sc.new_velocity)
    
    _velocity_lerper.set_target(v)
    _velocity_lerper.set_inter_smoothness(sc.responsivness)
    _player_controller.velocity = _velocity_lerper.lerp_to_target(delta)
    _player_controller.rotation.y = _rotation_lerper.lerp_to_target(delta)
    _player_controller.set_height(sc.height)
    
    if not is_zero_approx(v.y):
        _player_controller.velocity.y = v.y

func _to_global_space(velocity: Vector3):
    return velocity * _player_controller.global_basis.inverse()

func _input(event):
    if event is InputEventMouseMotion:
        var mmi = MouseProcessor.process_relative_mouse_input(event.relative)
        _rotation_lerper.set_target(_rotation_lerper.get_target() - (mmi.relative.x / 100))

func _print_flag():
    print("Flags:")
    for e in MoveStates.Flags.keys():
        if MoveStates.Flags[e] & _flags > 0:
            print(e)
    print()
