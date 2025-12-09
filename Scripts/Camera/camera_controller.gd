class_name CameraController
extends Node3D

@export var character: Character
@export var sprint_arm: SpringArm3D
@export var camera: Camera3D
@export var shaker: ShakerComponent3D
@export var state_machine: StateMachine
@export var mouse_captured: bool = false
@export var v_sens: float = 0.005
@export var h_sens: float = 0.005
@export var max_v_rotation: float = PI * 0.5
@export var default_zoom: float = 1.5
@export var max_zoom: float = 8.0
@export var min_zoom: float = 1.0
@export_range(0.05, 1.0, 0.05) var zoom_speed: float = 0.5
@export_range(0.05, 1.0, 0.05) var zoom_accel: float = 0.25
@export var default_fov: int = 75
@export var sprint_fov: int = 90
@export var inventory_fov: int = 50
@export var min_jump_fov: int = 60
@export var max_jump_fov: int = 80
@export var default_tween_time: float = 1.2
@export var sprint_tween_time: float = 1.2
@export var inventory_tween_time: float = 1.5
@export var jump_tween_time: float = 0.5
@export var tween_transition: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var tween_ease: Tween.EaseType = Tween.EaseType.EASE_IN_OUT

var v_rotation: float = 0.0
var h_rotation: float = 0.0
var current_zoom: float = 0.0
var tween_camera: Tween

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if mouse_captured else Input.MOUSE_MODE_VISIBLE)
	state_machine.state_changed.connect(camera_state)
	sprint_arm.spring_length = default_zoom
	current_zoom = default_zoom
	character.character_active_changed.connect(func (a: bool): camera.current = a)

func _input(event: InputEvent) -> void:
	if not camera.current:
		return
	#if event.is_action_pressed("ui_cancel"):
		#mouse_captured = !mouse_captured
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if mouse_captured else Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion and mouse_captured:
		var mouse_event: Vector2 = event.screen_relative
		camera_movement(mouse_event)
	
	if event.is_action_pressed("zoom_in"):
		current_zoom -= zoom_speed
	elif event.is_action_pressed("zoom_out"):
		current_zoom += zoom_speed
	else:
		camera_zoom()


#region Camera Actions

func camera_movement(mouse_movement: Vector2) -> void:
	if not character:
		return
	
	h_rotation += mouse_movement.x * h_sens
	v_rotation += mouse_movement.y * v_sens
	v_rotation = clamp(v_rotation, -max_v_rotation, max_v_rotation)
	
	transform.basis = Basis()
	character.transform.basis = Basis()
	
	character.rotate_object_local(Vector3.UP, -h_rotation)
	rotate_object_local(Vector3.RIGHT, -v_rotation)

func camera_zoom() -> void:
	if not sprint_arm:
		return
	
	current_zoom = clamp(current_zoom, min_zoom, max_zoom)
	sprint_arm.spring_length = lerp(sprint_arm.spring_length, current_zoom, zoom_accel)

#endregion

#region Camera Effects

func camera_state(_prev_state: String, new_state: String) -> void:
	match new_state:
		"idlestate": remove_camera_effect()
		"runstate": remove_camera_effect()
		"sprintstate": sprint_camera_effect()
		"jumpstate": jump_camera_effect()

func remove_camera_effect() -> void:
	setting_tween()
	
	shaker.stop_shake()
	
	tween_camera.tween_property(camera, "fov", default_fov, default_tween_time).from_current()
	tween_camera.tween_property(camera, "v_offset", 0.0, 0.5).from_current()
	tween_camera.tween_property(camera, "h_offset", 0.0, 0.5).from_current()
	

func sprint_camera_effect() -> void:
	setting_tween()
	
	shaker.intensity = 1.0
	shaker.shake_speed = 2.0
	shaker.play_shake()
	
	tween_camera.tween_property(camera, "fov", sprint_fov, sprint_tween_time)

func jump_camera_effect() -> void:
	setting_tween()
	
	tween_camera.tween_property(camera, "fov", min_jump_fov, jump_tween_time)
	tween_camera.tween_property(camera, "v_offset", -0.25, 0.25)
	tween_camera.tween_interval(0.5)
	tween_camera.tween_property(camera, "fov", max_jump_fov, jump_tween_time)
	tween_camera.tween_property(camera, "v_offset", 0.4, 0.25)
	
	await tween_camera.finished
	remove_camera_effect()


func inventory_camera_effect() -> void:
	setting_tween()
	
	tween_camera.tween_property(camera, "fov", inventory_fov, inventory_tween_time)
	tween_camera.tween_property(camera, "v_offset", -0.2, 0.5)
	tween_camera.tween_property(camera, "h_offset",  0.25, 0.5)


func setting_tween(parallel: bool = true) -> void:
	if tween_camera:
		tween_camera.kill()
	
	tween_camera = create_tween().set_parallel(parallel).set_trans(tween_transition).set_ease(tween_ease)

#endregion
