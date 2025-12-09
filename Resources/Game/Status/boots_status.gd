class_name BoostStatus
extends StatusEffect

var boost_speed: float = 0.5
var boost_jump: float = 0.2

func _init(duration: float = 5.0) -> void:
	type_status = Constants.TurnPhase.ON_THE_TURN
	time_duration = duration

func apply(target: Character) -> void:
	super.apply(target)
	target.factor_speed += boost_speed
	target.factor_jump_force += boost_jump

func remove(target: Character) -> void:
	super.remove(target)
	target.factor_speed -= boost_speed
	target.factor_jump_force -= boost_jump
