class_name Projectile
extends RigidBody3D

@export var projectile_skin: Node3D
@export var hit_box: HitBox
@export var projectile_speed: float = 100.0
@export var points: float = 20.0
@export var knockback_force: float = 2.0
@export var pass_across: bool = false
@export var cost: float = 10.0

var tween_projectile: Tween

func _ready() -> void:
	hit_box.points = points
	hit_box.knockback_force = knockback_force
	hit_box.pass_across = pass_across

func show_projectile() -> void:
	if not projectile_skin:
		return
		
	if tween_projectile:
		tween_projectile.kill()
	
	tween_projectile = create_tween()

	tween_projectile.tween_property(projectile_skin, "scale", Vector3.ONE, 1.0).from(Vector3.ZERO)
	
	await tween_projectile.finished


func throw_projectile(direction: Vector3) -> void:
	if not direction:
		return
	
	apply_impulse(direction * projectile_speed)
	
	await get_tree().create_timer(5.0).timeout
	queue_free()
