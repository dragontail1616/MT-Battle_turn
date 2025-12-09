class_name PropelledStatus
extends StatusEffect

var propelled_jump: float = 1.0
var fall_resistence: float = 0.4

func _init(duration: float = 5.0) -> void:
	type_status = Constants.TurnPhase.ON_THE_TURN
	time_duration = duration

func apply(target: Character) -> void:
	target.factor_jump_force += propelled_jump
	target.factor_fall -= fall_resistence

func remove(target: Character) -> void:
	target.factor_jump_force -= propelled_jump
	target.factor_fall += fall_resistence
