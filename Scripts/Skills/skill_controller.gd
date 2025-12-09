class_name SkillController
extends Node3D

enum SkillType {
	NONE,
	PROJECTILE,
	BUILD,
	BUFF,
	EVENT
}

@export var skill_type_selected: SkillType = SkillType.NONE
@export var skill_scene: PackedScene
@export var camera: Camera3D
@export var muzzle: Marker3D

var _max_ray_distance: float = 1000.0
var _projectile_preview: Projectile = null
var direccion: Vector3 = Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("skill"):
		if event.is_action_pressed("skill"):
			_projectile_preview = preview_projectile()
		if event.is_action_released("skill"):
			_projectile_preview.queue_free()
			instantiate_projectile()

func instantiate_projectile() -> Projectile:
	if not skill_scene:
		return
	
	var projectile_instance: Projectile = skill_scene.instantiate()
	
	var viewpord_size: Vector2 = get_viewport().get_visible_rect().size
	var ray_origin: Vector3 = camera.project_ray_origin(viewpord_size * 0.5)
	var ray_normal: Vector3 = camera.project_ray_normal(viewpord_size * 0.5)
	
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_normal * _max_ray_distance)
	var result:= get_world_3d().direct_space_state.intersect_ray(query)
	var target_position: Vector3 = result.position if result else ray_origin + ray_normal * _max_ray_distance
	
	var projectile_direction = (target_position - muzzle.global_position).normalized()
	
	get_tree().get_current_scene().add_child(projectile_instance)
	
	projectile_instance.global_position = muzzle.global_position
	projectile_instance.global_basis = Basis.looking_at(projectile_direction, Vector3.UP)
	
	projectile_instance.throw_projectile(projectile_direction)
	
	return projectile_instance


func preview_projectile() -> Projectile:
	if not skill_scene:
		return
	
	var preview_instance: Projectile = skill_scene.instantiate()
	
	muzzle.add_child(preview_instance)
	
	preview_instance.global_position = muzzle.global_position
	preview_instance.position.z -= 0.5
	preview_instance.global_basis = Basis.looking_at(-muzzle.global_basis.z, Vector3.UP)
	preview_instance.freeze = true
	
	preview_instance.show_projectile()
	
	return preview_instance
