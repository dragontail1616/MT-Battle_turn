class_name FallState
extends MovementState

var max_height_resistence: float = 0.0

func enter() -> void:
	super.enter()

func input(event: InputEvent) -> void:
	super.input(event)
	
	if i_frame.falling:
		target.control_jump(target.velocity.y * 0.6, get_physics_process_delta_time())
	

func update_process(_delta: float) -> void:
	pass

func update_physics_process(delta: float) -> void:
	if not target:
		return

	super.update_physics_process(delta)
	
	if i_frame.sprint and target.is_on_floor():
		change_next_state.emit("sprintstate")
	
	if target.is_on_floor():
		change_next_state.emit("idlestate")

func exit() -> void:
	super.exit()
