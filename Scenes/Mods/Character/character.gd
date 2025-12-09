class_name Character
extends CharacterBody3D

signal character_active_changed(active: bool)

@export var skin: Node3D
@export var animation: AnimationPlayer
@export var status_effect_controller: StatusEffectController

var factor_speed: float = 1.0
var factor_friction: float = 1.0
var factor_jump_force: float = 1.0
var factor_fall: float = 1.0

var character_active: bool = false:
	set(value):
		character_active = value
		character_active_changed.emit(value)

func _ready() -> void:
	pass
	#animation.animation_started.connect(func(ani_name): print(ani_name))

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("interact"):
		#status_effect_controller.apply_status_effects(PropelledStatus.new(10))

func contro_jump(jump_force: float, delta) -> void:
	velocity.y = jump_force * delta * factor_jump_force

func control_gravity(delta: float) -> void:
	var current_factor: float = 1.0 if not Input.is_action_pressed("jump") else factor_fall
	if not is_on_floor():
		velocity += get_gravity() * delta * current_factor

func control_direction(speed: float, acceleration: float, desacceleration: float, delta: float) -> void:
	
	var input_dir : = Input.get_vector("left_move", "right_move", "front_move", "back_move")
	var direction : = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction and character_active:
		velocity.x = move_toward(velocity.x, direction.x * speed * factor_speed, acceleration * delta * factor_friction)
		velocity.z = move_toward(velocity.z, direction.z * speed * factor_speed, acceleration * delta * factor_friction)
	else:
		velocity.x = move_toward(velocity.x, 0, desacceleration * delta * factor_friction)
		velocity.z = move_toward(velocity.z, 0, desacceleration * delta * factor_friction)

func control_movement() -> void:
	move_and_slide()

func disable_character() -> void:
	if character_active:
		character_active = false
