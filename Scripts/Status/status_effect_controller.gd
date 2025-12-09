class_name StatusEffectController
extends Node

@export var target: Character

var _status_effect: Array[StatusEffect] = []

#TODO: Debo controllar que al aplicar el apply_status_effect no se activen los efectos que sean por turnos y rondas

func _process(delta: float) -> void:
	control_time_status_effect(delta)

func apply_status_effects(effect: StatusEffect) -> void:
	for e in _status_effect:
		if e.get_script().get_global_name() == effect.get_script().get_global_name():
			e.time_duration = effect.time_duration
			e.turn_duration = effect.turn_duration
			return
	_status_effect.append(effect)
	effect.apply(target)
	
func control_time_status_effect(delta: float) -> void:
	for effect:StatusEffect in _status_effect:
		if effect.type_status != Constants.TurnPhase.ON_THE_TURN:
			continue
		
		effect.time_duration -= delta
		if effect.time_duration <= 0.0:
			effect.remove(target)
			_status_effect.erase(effect)

func control_turn_status_effect(turn_phase: Constants.TurnPhase):
	for effect:StatusEffect in _status_effect:
		if effect.type_status == Constants.TurnPhase.ON_THE_TURN:
			continue
		
		if effect.type_status == turn_phase:
			effect.turn_duration -= 1
		
		if effect.turn_duration <= 0:
			effect.remove(target)
			_status_effect.erase(effect)
