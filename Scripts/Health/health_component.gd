class_name HealthComponent
extends Node

signal max_health_change(diff: float)
signal health_changed(diff: float)
signal health_depleted()

@export var inmortality: bool = false
@export var knockbackable: bool = true
@export var max_health: float = 100.0:
	set(value):
		var clamped_value: float = max(1.0, value)
		if clamped_value != max_health:
			var difference: float = clamped_value - max_health
			max_health = value
			max_health_change.emit(difference)
		
		if current_health > max_health:
			current_health = max_health

var current_health: float = 0.0:
	set(value):
		if value < current_health and inmortality:
			return

		var clamped_value: float = clamp(value, 0.0, max_health)
		if clamped_value != current_health:
			var difference: float = clamped_value - current_health
			current_health = value
			health_changed.emit(difference)
		
		if current_health <= 0.0:
			health_depleted.emit()

var inmortality_timer: Timer = null

func _ready() -> void:
	current_health = max_health

func set_inmortality(value: bool) -> void:
	if current_health > 0.0:
		inmortality = value

func take_damage(amount: float) -> void:
	if not inmortality:
		current_health -= amount

func heal_life(amount: float) -> void:
	if current_health > 0.0:
		current_health += amount

func inmortality_time(duration: float) -> void:
	if not inmortality_timer:
		inmortality_timer = Timer.new()
		inmortality_timer.one_shot = true
		add_child(inmortality_timer)
	
	if inmortality_timer.timeout.is_connected(set_inmortality):
		inmortality_timer.timeout.disconnect(set_inmortality)
	
	inmortality_timer.timeout.connect(set_inmortality.bind(false))
	inmortality = true
	inmortality_timer.start(duration)
