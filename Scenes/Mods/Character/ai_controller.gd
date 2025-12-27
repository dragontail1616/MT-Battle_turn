class_name AIController
extends InputController

@export var aim_speed: float = 90.0
@export var power_speed: float = 0.5
@export var reaction_time: float = 1.2
@export var error_angle: float = 5.0

var i_frame: InputFrame

func get_input_frame(event: InputEvent = null) -> InputFrame:
	i_frame = InputFrame.new()
	
	return i_frame
