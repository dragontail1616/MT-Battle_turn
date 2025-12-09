class_name HitBox
extends Area3D

@export var active: bool = true
@export var collision: CollisionShape3D
@export var points: float
@export var knockback_force: float
@export var pass_across: bool

func _ready() -> void:
	monitorable = false
	collision_mask = 0b100
	
	if not area_entered.is_connected(apply_points):
		area_entered.connect(apply_points)
	

func apply_points(area: Area3D) -> void:
	if area is HurtBox:
			area.damage(points).knockback(global_transform.origin, knockback_force)
