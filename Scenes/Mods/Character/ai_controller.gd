class_name AIController
extends InputController

@export var aim_speed: float = 90.0
@export var power_speed: float = 0.5
@export var reaction_time: float = 1.2
@export var error_angle: float = 5.0

func get_input_frame(_event: InputEvent = null) -> InputFrame:
	var i_frame: InputFrame = InputFrame.new()
	
	return i_frame
