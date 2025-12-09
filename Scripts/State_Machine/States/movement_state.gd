class_name MovementState
extends State

@export var state_speed: float = 15.0
@export var state_accel: float = 15.0
@export var state_desaccel: float = 20.0
@export var holding_speed: float = 2.5
@export var jump_force: float = 300.0
@export var state_animation: String

var _current_speed: float = 0.0
var _current_accel: float = 0.0
var _current_desacel: float = 0.0

var _is_channeling: bool = false:
	set(value):
		if value == _is_channeling:
			return
		if value:
			_current_animation = "Charging_Magic"
		else :
			_current_animation = state_animation
		_is_channeling = value
		if animation: animation.play(_current_animation)

var _current_animation: String = ""

func enter() -> void:
	_current_animation = state_animation
	_is_channeling = false
	if animation and _current_animation != "" and not _is_channeling:
		if animation.is_playing(): animation.stop()
		animation.play(_current_animation)

	_current_speed = state_speed
	_current_accel = state_accel
	_current_desacel = state_desaccel

func input(_event: InputEvent) -> void:
	pass

func update_process(_delta: float) -> void:
	pass

func update_physics_process(delta: float) -> void:
	if not target:
		return
	_is_channeling = Input.is_action_pressed("skill")
	_current_speed = holding_speed if Input.is_action_pressed("skill") else state_speed
	
	target.control_gravity(delta)
	target.control_direction(_current_speed, _current_accel, _current_desacel, delta)
	target.control_movement()

func exit() -> void:
	if animation:
		animation.stop()
	target.velocity.x = 0.0
	target.velocity.z = 0.0
