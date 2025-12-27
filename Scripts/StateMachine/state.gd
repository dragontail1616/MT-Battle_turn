@abstract class_name State
extends Node

@warning_ignore("unused_signal")
signal change_next_state(new_state_name: String)

var target: Character = null
var animation: AnimationPlayer = null

@abstract func enter() -> void

@abstract func input(event: InputEvent) -> void

@abstract func update_process(delta: float) -> void

@abstract func update_physics_process(delta: float) -> void

@abstract func exit() -> void
