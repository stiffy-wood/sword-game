class_name StateBase

var _flag: MoveStates.Flags
var _player_controller: PlayerController
var _move_props: PlayerMoveProps

func _init(controller: PlayerController, movement_props: PlayerMoveProps):
    _player_controller = controller
    _move_props = movement_props

func _is_active(flags: int, flag: int) -> bool:
    return flag & flags > 0
    
func _set_flag(flags: int, flag: int) -> int:
    return flags | flag

func _reset_flag(flags: int, flag: int) -> int:
    return flags & (~flag)

func _flip_flag(flags: int, flag: int) -> int:
    return flags ^ flag

func execute(sc: MoveStates.StateContext) -> MoveStates.StateContext:
    push_error("Not Implemented")
    return sc
