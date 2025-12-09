class_name SprintState
extends MovementState

func enter() -> void:
	super.enter()

func input(event: InputEvent) -> void:
	if event.is_action_released("run"):
		change_next_state.emit("runstate")
	
		super.input(event)

func update_process(_delta: float) -> void:
	pass

func update_physics_process(delta: float) -> void:
	if not target:
		return
	if Input.is_action_just_pressed("jump") and target.is_on_floor():
		change_next_state.emit("jumpstate")
		
	if target.velocity.y > 0.0:
		change_next_state.emit("fallstate")
	
	if abs(target.velocity.length()) < 0.1:
		change_next_state.emit("idlestate")
	
	super.update_physics_process(delta)

func exit() -> void:
	super.exit()
