class_name SprintState
extends MovementState

func enter() -> void:
	super.enter()

func input(event: InputEvent) -> void:
	super.input(event)
	if not i_frame.sprint:
		change_next_state.emit("runstate")
	

func update_process(_delta: float) -> void:
	pass

func update_physics_process(delta: float) -> void:
	if not target:
		return
		
	super.update_physics_process(delta)
	
	if i_frame.jump and target.is_on_floor():
		change_next_state.emit("jumpstate")
		
	if target.velocity.y > 0.0:
		change_next_state.emit("fallstate")
	
	if abs(target.velocity.length()) < 0.1:
		change_next_state.emit("idlestate")
	

func exit() -> void:
	super.exit()
