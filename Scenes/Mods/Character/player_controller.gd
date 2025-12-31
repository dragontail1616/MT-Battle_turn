class_name PlayerController
extends InputController

func get_input_frame(event: InputEvent = null) -> InputFrame:
	var i_frame: InputFrame = InputFrame.new()
	if not target.character_active:
		return i_frame
	
	i_frame.direction = Input.get_vector("left_move", "right_move", "front_move", "back_move")
	i_frame.jump = Input.is_action_pressed("jump")
	i_frame.sprint = Input.is_action_pressed("sprint")
	i_frame.channeling = Input.is_action_pressed("skill")
	
	if event:
		i_frame.inventory = event.is_action_pressed("inventory")
		i_frame.interact = event.is_action_pressed("interact")
		i_frame.zoom_out = event.is_action_pressed("zoom_out")
		i_frame.falling = not event.is_action_pressed("jump") 
		i_frame.zoom_in = event.is_action_pressed("zoom_in")
		i_frame.power = event.is_action_released("skill")
		i_frame.pause = event.is_action_pressed("pause")
		
		if event is InputEventMouseMotion:
			i_frame.mouse_move = event.relative
	
	return i_frame
