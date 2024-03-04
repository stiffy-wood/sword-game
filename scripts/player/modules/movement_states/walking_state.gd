class_name WalkingState extends StateBase

func _init(controller: PlayerController, movement_props: PlayerMoveProps):
	super(controller, movement_props)
	_flag = MoveStates.Flags.WALKING

func _can_execute(flag: int) -> bool:
	var forbidden_states = MoveStates.Flags.CLIMBING | MoveStates.Flags.SLIDING | MoveStates.Flags.WALL_RUNNING
	return flag & forbidden_states == 0

func execute(sc: MoveStates.StateContext) -> MoveStates.StateContext:
	if not _can_execute(sc.flags):
		return sc
	sc.flags = _set_flag(sc.flags, _flag)
	var movement = InputMgr.movement
	
	sc.new_velocity = Vector3(
		movement.x * _move_props.move_speed,
		sc.new_velocity.y,
		movement.y * _move_props.move_speed
	)
	return sc
