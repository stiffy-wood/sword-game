class_name MoveStates

enum Flags{
    WALKING =      0b0_0000_0001,
    SPRINTING =    0b0_0000_0010,
    FALLING =      0b0_0000_0100,
    JUMPING =      0b0_0000_1000,
    CROUCHING =    0b0_0001_0000,
    SLIDING =      0b0_0010_0000,
    WALL_RUNNING = 0b0_0100_0000,
    CLIMBING =     0b0_1000_0000,
    VAULTING =     0b1_0000_0000
}


class StateContext:
    var delta: float
    var flags: int
    var current_velocity: Vector3
    var new_velocity: Vector3
    var height: float
    var responsivness: float 

    func _init(delta: float, flags: int, current_velocity: Vector3, height: float, responsivness: float):
        self.delta = delta
        self.flags = flags
        self.current_velocity = current_velocity
        self.new_velocity = self.current_velocity
        self.height = height
        self.responsivness = responsivness
        

# Order of states is important
static func get_states(pc: PlayerController, pmp: PlayerMoveProps) -> Array[StateBase]:
    return  [
        WalkingState.new(pc, pmp),
        CrouchingState.new(pc, pmp),
        JumpingState.new(pc, pmp),
        SprintingState.new(pc, pmp),
        FallingState.new(pc, pmp),
    ]
