@abstract class_name StatusEffect
extends Resource

@export var type_status: Constants.TurnPhase
@export var time_duration: float = 0.0
@export var turn_duration: int = 0

func apply(target: Character) -> void:
	prints("The status", self.get_script().get_global_name(), "has been applied to", target.name)

func remove(target: Character) -> void:
	prints("The status", self.get_script().get_global_name(), "has been removed to", target.name)
