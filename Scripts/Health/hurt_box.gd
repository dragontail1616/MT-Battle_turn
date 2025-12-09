class_name HurtBox
extends Area3D


@export var health_component: HealthComponent

func _ready() -> void:
	monitoring = false
	collision_layer = 0b100

func damage(amount: float) -> HurtBox:
	health_component.take_damage(amount)
	return self

func heal(amount: float) -> HurtBox:
	health_component.heal_health(amount)
	return self

func knockback(origin:Vector3, force: float) -> HurtBox:
	return self

#func effeft(e: Effect) -> HurtBox:
	#return self
