class_name Character
extends CharacterBody3D

signal character_actived()
signal character_desactived()

@export var skin: Node3D
@export var animation: AnimationPlayer
@export var camera_controller: CameraController
@export var nav_agent: NavigationAgent3D


var factor_speed: float = 1.0
var factor_friction: float = 1.0
var factor_jump_force: float = 1.0
var factor_fall: float = 1.0
var direction: Vector3 = Vector3.ZERO
var input_controller: InputController
var i_frame: InputFrame

var team_name: String = ""
var control_type: Constants.ControlType = Constants.ControlType.PLAYER

var find_criteria: Callable = sort_by_short_distance

var character_active: bool = false:
	set(value):
		await get_tree().physics_frame
		Global.debug.add_debug_property(name + "active", value, 1)
		if value:
			character_actived.emit()
		else:
			character_desactived.emit()
			velocity.x = 0.0
			velocity.z = 0.0
		character_active = value


func _ready() -> void:
	character_active = false
	# esto lo define el game_manager en un futuro
	if control_type == Constants.ControlType.PLAYER:
		input_controller = PlayerController.new()
	else:
		input_controller = AIController.new()
	input_controller.target = self
	add_child(input_controller)
	
	#animation.animation_started.connect(func(ani_name): print(ani_name))

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("interact"):
		#status_effect_controller.apply_status_effects(PropelledStatus.new(10))

func control_jump(jump_force: float, delta) -> void:
	if is_on_floor():
		velocity.y = jump_force * delta * factor_jump_force

func control_gravity(delta: float) -> void:
	i_frame = input_controller.get_input_frame()
	var current_factor: float = 1.0 if i_frame.falling else factor_fall
	##if not character_active or control_type == Constants.ControlType.NONE:
		#current_factor = 1.0 if not Input.is_action_pressed("jump") else factor_fall
	if not is_on_floor():
		velocity += get_gravity() * delta * current_factor

func control_direction(speed: float, acceleration: float, desacceleration: float, delta: float) -> void:
	if not character_active or control_type == Constants.ControlType.NONE:
		return
	
	i_frame = input_controller.get_input_frame()
	var input_dir: Vector2 = i_frame.direction
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed * factor_speed, acceleration * delta * factor_friction)
		velocity.z = move_toward(velocity.z, direction.z * speed * factor_speed, acceleration * delta * factor_friction)
	else:
		velocity.x = move_toward(velocity.x, 0, desacceleration * delta * factor_friction)
		velocity.z = move_toward(velocity.z, 0, desacceleration * delta * factor_friction)

func control_movement() -> void:
	move_and_slide()

func find_next_enemy(sort_type: Callable) -> Character:
	var char_list: Array[Node] = get_tree().get_nodes_in_group("character")
	var enemies: Array[Character] = []
	for c in char_list:
		# se queda comentada el if del equipo  'or c.team_name == self.team_name'
		if c == self:
			continue
		enemies.append(c)
	enemies.sort_custom(sort_type)
	return enemies.front() if not enemies.is_empty() else null

func sort_by_short_distance(a, b) -> bool:
	return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)
