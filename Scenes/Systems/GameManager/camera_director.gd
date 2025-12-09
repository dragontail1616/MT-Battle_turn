class_name CameraDirector
extends Node

signal position_arrived()

var blend_time: float = 0.5
var tween_camera: Tween
var tween_trans: Tween.TransitionType
var tween_ease: Tween.EaseType
var _main_camera: Camera3D

#TODO: añadir en un futuro un recurso con los datos de configuracion de la camara
func _init(b_time: float = blend_time, twn_trans:= Tween.TRANS_LINEAR, twn_ease:= Tween.EASE_IN) -> void:
	blend_time = b_time
	tween_trans = twn_trans
	tween_ease = twn_ease

func setup_main_camera(parent = self) -> Camera3D:
	var new_camera: Camera3D = Camera3D.new()
	parent.add_child(new_camera)
	new_camera.name = "MainCamera"
	_main_camera = new_camera

	return new_camera

func cut_to(_pos: Vector3, target_pos: Vector3) -> void:
	_main_camera.current = true
	_main_camera.look_at_from_position(_pos, target_pos)
	position_arrived.emit()

func blend_to(_to_pos: Vector3, target_pos: Vector3, _duration: float = blend_time) -> void:
	_main_camera.current = true
	if _duration <= 0:
		cut_to(_to_pos, target_pos)
	if tween_camera:
		tween_camera.kill()
	
	var front: Vector3 = _main_camera.global_basis.z
	tween_camera = create_tween().set_trans(tween_trans).set_ease(tween_ease)
	tween_camera.parallel().tween_property(_main_camera, "global_position", _to_pos, _duration)
	tween_camera.parallel().tween_method(_main_camera.look_at, front, target_pos, _duration)
	await tween_camera.finished
	position_arrived.emit()
