class_name SprintingState extends StateBase

func _init(controller: PlayerController, movement_props: PlayerMoveProps):
    super(controller, movement_props)
    _flag = MoveStates.Flags.SPRINTING

func execute(sc: MoveStates.StateContext) -> MoveStates.StateContext:
    # if player is not walking, it makes no sense to sprint
    if not sc.flags & (MoveStates.Flags.WALKING) > 0:
        sc.flags = _reset_flag(sc.flags, _flag)

    # if player is in the air, do not change the movement speed
    if _player_controller.is_on_floor():
        # if sprint is not toggleable, just set the flag depending if the sprint button is pressed
        # otherwise flip it
        if not Cfg.controls.sprint_toggle:
            if InputMgr.is_sprinting:
                sc.flags = _set_flag(sc.flags, _flag)
            else:
                sc.flags = _reset_flag(sc.flags, _flag)
        else:
            if InputMgr.has_just_sprinted:
                sc.flags = _flip_flag(sc.flags, _flag)

    if not _is_active(sc.flags, _flag):
        return sc

    sc.new_velocity = Vector3(
        sc.new_velocity.x * _move_props.sprint_speed_multiplier,
        sc.new_velocity.y,
        sc.new_velocity.z * _move_props.sprint_speed_multiplier
    )
    return sc

