class_name StateMachine
extends Node

@warning_ignore("unused_signal")
signal state_changed(from: String, to: String)

@export var enable: bool = true
@export var debug_state_machine: bool = false
@export var initial_state: State
@export var target: Character
@export var animation: AnimationPlayer

var states: Dictionary[String, State] = {}

var _current_state: State

func _ready() -> void:
	if not initial_state or not enable:
		push_warning("StateMachine: initial_state is null")
		set_process(false)
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
	if _current_state:
		_current_state.update_process(delta)
		Global.debug.add_debug_property("Current State" + target.name, _current_state.name, 20)
		Global.debug.add_debug_property("velocity" + target.name, target.velocity.length(), 20)

func _physics_process(delta: float) -> void:
	if _current_state: _current_state.update_physics_process(delta)

func change_next_state(name_next_state: String) -> void:
	if debug_state_machine:
		Utils.debug_print(target.name, "Changing state from:", _current_state.name.to_lower(), "to:", name_next_state)

	if not states.has(name_next_state):
		Utils.debug_print("State doesn't exist:", name_next_state)
		return
	
	var prev_state: State = _current_state
	var new_state: State = states.get(name_next_state.to_lower())
	_current_state.exit()
	_current_state = new_state
	_current_state.enter()
	state_changed.emit(prev_state.name.to_lower(), new_state.name.to_lower())
