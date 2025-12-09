class_name StateMachine
extends Node

@warning_ignore("unused_signal")
signal state_changed(from: String, to: String)

@export var debug_state_machine: bool = false
@export var initial_state: State
@export var target: Character
@export var animation: AnimationPlayer

var states: Dictionary[String, State] = {}

var _current_state: State

func _ready() -> void:
	if not initial_state:
		push_warning("StateMachine: initial_state is null")
		set_physics_process(false)
		return
	
	_current_state = initial_state
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.target = target as Character
			child.animation = animation as AnimationPlayer
			if not child.change_next_state.is_connected(change_next_state):
				child.change_next_state.connect(change_next_state)
	
	_current_state.enter()

func _unhandled_input(event: InputEvent) -> void:
	if _current_state: _current_state.input(event)

func _process(delta: float) -> void:
	if _current_state: _current_state.update_process(delta)

func _physics_process(delta: float) -> void:
	if _current_state: _current_state.update_physics_process(delta)

func change_next_state(name_next_state: String) -> void:
	if not target.character_active:
		return
	if debug_state_machine:
		debug_print("Changing state from:", _current_state.name.to_lower(), "to:", name_next_state)

	if not states.has(name_next_state):
		debug_print("State doesn't exist:", name_next_state)
		return
	else:
		var prev_state: State = _current_state
		var new_state: State = states.get(name_next_state.to_lower())
		_current_state.exit()
		_current_state = new_state
		_current_state.enter()
		state_changed.emit(prev_state.name.to_lower(), new_state.name.to_lower())

func set_paused(paused: bool) -> void:
	set_process(!paused)
	set_physics_process(!paused)

func debug_print(...arg) -> void:
	if not debug_state_machine:
		return
		
	var print_text: String = ""
	
	for a in arg:
		if not a is String:
			a = str(a)
		print_text += a + ("" if arg.back() == a else " ")
	
	push_warning(print_text)
	
