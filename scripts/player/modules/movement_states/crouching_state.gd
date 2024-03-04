class_name CrouchingState extends StateBase

func _init(controller: PlayerController, movement_props: PlayerMoveProps):
    super(controller, movement_props)
    _flag = MoveStates.Flags.CROUCHING

func _can_execute(flags: int) -> bool:
    var forbidden_states = MoveStates.Flags.CLIMBING | MoveStates.Flags.SLIDING | MoveStates.Flags.WALL_RUNNING
    return flags & forbidden_states == 0

func execute(sc: MoveStates.StateContext) -> MoveStates.StateContext:
    if not _can_execute(sc.flags):
        sc.flags = _reset_flag(sc.flags, _flag)

    if not Cfg.controls.crouch_toggle:
        if InputMgr.is_crouching:
            sc.flags = _set_flag(sc.flags, _flag)
        else:
            sc.flags = _reset_flag(sc.flags, _flag)
    else:
        if InputMgr.has_just_crouched:
            sc.flags = _flip_flag(sc.flags, _flag)
        
    if not _is_active(sc.flags, _flag):
        _player_controller.set_height(_move_props.crouch_size) 
        return sc

    _player_controller.set_height(_move_props.crouch_size)
    print(_player_controller.get_height())
    sc.new_velocity = Vector3(
        sc.new_velocity.x * _move_props.crouch_speed_multiplier,
        sc.new_velocity.y,
        sc.new_velocity.z * _move_props.crouch_speed_multiplier
    )
    return sc

