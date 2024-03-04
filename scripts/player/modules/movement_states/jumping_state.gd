class_name JumpingState extends StateBase

var _has_double_jumped: bool = false
var _has_jumped_from_grounded: bool = false
var _coyote_time_timer: Timer
var _jump_grace_period_timer: Timer

func _init(controller: PlayerController, movement_props: PlayerMoveProps):
	super(controller, movement_props)
	_flag = MoveStates.Flags.JUMPING

	_coyote_time_timer = Timer.new()
	_coyote_time_timer.autostart = true
	_coyote_time_timer.one_shot = true
	
	_jump_grace_period_timer = Timer.new()
	_jump_grace_period_timer.autostart = true
	_jump_grace_period_timer.one_shot = true

	_player_controller.add_child.call_deferred(_coyote_time_timer)
	_player_controller.add_child.call_deferred(_jump_grace_period_timer)

func _jumped_from_grounded_pos() -> bool:
	return _player_controller.is_on_floor()

func _can_execute() -> bool:
	var grounded = _jumped_from_grounded_pos()
	var can_jump = false
	
	if grounded:
		_has_double_jumped = false
		if InputMgr.has_just_jumped:
			_has_jumped_from_grounded = true
		else:
			_has_jumped_from_grounded = false
		_reset_timers()
		_start_timers()
	else:
		can_jump = _can_jump()
		
	return InputMgr.is_jumping and (grounded or can_jump)

func _can_jump():
	if _has_double_jumped:
		return false

	# jump grace period
	if _has_jumped_from_grounded and not InputMgr.has_just_jumped and not _jump_grace_period_timer.is_stopped():
		return true
	_jump_grace_period_timer.stop()
	
	# coyote time
	if not _has_jumped_from_grounded and InputMgr.has_just_jumped and not _coyote_time_timer.is_stopped():
		_coyote_time_timer.stop()
		return true
	
	# double jump
	if InputMgr.has_just_jumped and _can_use_double_jump():
		_has_double_jumped = true
		return true
	
	return false

func _reset_timers():
	_coyote_time_timer.stop()
	_jump_grace_period_timer.stop()

func _start_timers():
	_coyote_time_timer.start(_move_props.coyote_time_duration)
	_jump_grace_period_timer.start(_move_props.jump_grace_period_duration)	

func _timers_stopped():
	return _coyote_time_timer.is_stopped() and _jump_grace_period_timer.is_stopped()

func _can_use_double_jump():
	return Unlocks.double_jump == Unlocks.Status.UNLOCKED

func execute(sc: MoveStates.StateContext) -> MoveStates.StateContext:
	if not _can_execute():
		if _is_active(sc.flags, _flag):
			sc.flags = _reset_flag(sc.flags, _flag)
		return sc
	
	sc.flags = _set_flag(sc.flags, _flag)
	sc.flags = _reset_flag(sc.flags, MoveStates.Flags.FALLING 
		| MoveStates.Flags.CLIMBING
		| MoveStates.Flags.SLIDING
		| MoveStates.Flags.WALL_RUNNING
		| MoveStates.Flags.CROUCHING)
	
	sc.new_velocity = Vector3(
		sc.new_velocity.x,
		_move_props.jump_force,
		sc.new_velocity.z
	)
	return sc
