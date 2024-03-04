class_name FallingState extends StateBase

func _init(controller: PlayerController, movement_props: PlayerMoveProps):
    super(controller, movement_props)
    _flag = MoveStates.Flags.FALLING

func _can_execute(flags: int) -> bool:
    var forbidden_states = MoveStates.Flags.CLIMBING \
        | MoveStates.Flags.WALL_RUNNING \
        | MoveStates.Flags.JUMPING \
        | MoveStates.Flags.VAULTING
        
    if flags & forbidden_states != 0:
        return false
    
    return not _player_controller.is_on_floor()

func execute(sc: MoveStates.StateContext) -> MoveStates.StateContext:
    if not _can_execute(sc.flags):
        sc.flags = _reset_flag(sc.flags, _flag)
        return sc
        
    sc.flags = _set_flag(sc.flags, MoveStates.Flags.FALLING)
    sc.new_velocity.y = max(sc.new_velocity.y + _move_props.gravity * sc.delta, -_move_props.terminal_velocity)
    sc.responsivness = sc.responsivness * _move_props.falling_move_speed_modifier
    return sc
    
    
