class_name JumpState
extends MovementState

func enter() -> void:
	super.enter()
	target.contro_jump(jump_force, get_physics_process_delta_time())

func input(event: InputEvent) -> void:
	super.input(event)

func update_process(_delta: float) -> void:
	pass

func update_physics_process(_delta: float) -> void:
	if not target:
		return
	
	if target.velocity.y < 0.0:
		change_next_state.emit("fallstate")

func exit() -> void:
	super.exit()
