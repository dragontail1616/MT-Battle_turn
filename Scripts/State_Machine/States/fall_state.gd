class_name FallState
extends MovementState

var max_height: float = 0.0

func enter() -> void:
	super.enter()

func input(event: InputEvent) -> void:
	if event.is_action_released("jump"):
		target.contro_jump(target.velocity.y * 0.6, get_physics_process_delta_time())
	
	super.input(event)

func update_process(_delta: float) -> void:
	pass

func update_physics_process(delta: float) -> void:
	if not target:
		return

	if Input.is_action_pressed("run") and target.is_on_floor():
		change_next_state.emit("sprintstate")
	
	if target.is_on_floor():
		change_next_state.emit("idlestate")
	
	super.update_physics_process(delta)

func exit() -> void:
	super.exit()
