class_name Utils
extends Node

static var rnd: RandomNumberGenerator = RandomNumberGenerator.new()

static func spawn_node(s: PackedScene, parent = null) -> Node:
	var instance:= s.instantiate()
	parent.add_child(instance)
	return instance

static func spawn_node_position(s: PackedScene, pos = null, parent = null) -> Node:
	var instance:= s.instantiate()
	parent.add_child(instance)
	instance.global_position = pos
	return instance

static func spawn_node_method(s: PackedScene, parent = null, ...arg) -> Node:
	var instance:= s.instantiate()
	parent.add_child(instance)
	for a in arg:
		if instance.get_method_list().has(a[0]): # modificarse por lo que devuelve get_method_list
			instance.set(a[0], a[1])
	return instance

static func plane_to_vector3(plane: Vector2, height: float = 0.0) -> Vector3:
	return Vector3(plane.x, height, plane.y)

static func debug_print(...arg) -> void:
	var print_text: String = ""
	
	for a in arg:
		if not a is String:
			a = str(a)
		print_text += a + ("" if arg.back() == a else " ")
	
	push_warning(print_text)


#region Random Funtions
static func set_seed(_seed: int) -> void:
	rnd.seed = _seed

static func get_seed() -> int:
	return rnd.seed

static func rand_int(_max_limit: int = 100) -> int:
	if is_null(_max_limit): return -1
	return rnd.randi() % _max_limit

static func rand_float(_max_limit: int = 1) -> float:
	if is_null(_max_limit): return -1
	return (rnd.randf() * _max_limit)

static func rand_vector2(limit: float) -> Vector2:
	if is_null(limit): return Vector2.ZERO
	return random_mirror_vector2(Vector2(limit, limit))

static func rand_vector3(limit: float) -> Vector3:
	if is_null(limit): return Vector3.ZERO
	return random_mirror_vector3(Vector3(limit, limit, limit))

static func random_int(_min_limit:int = 0, _max_limit:int = 100) -> int:
	if is_null(_min_limit) or is_null(_max_limit): return -1
	return rnd.randi_range(_min_limit, _max_limit)

static func random_float(_min_limit:float = 0.0, _max_limit:float = 1.0) -> float:
	if is_null(_min_limit) or is_null(_max_limit): return -1
	return rnd.randf_range(_min_limit, _max_limit)

static func random_vector2(_min_limit:Vector2, _max_limit:Vector2) -> Vector2:
	if is_null(_min_limit) or is_null(_max_limit): return Vector2.ZERO
	var x_range: float = rnd.randf_range(_min_limit.x, _max_limit.x)
	var y_range: float = rnd.randf_range(_min_limit.y, _max_limit.y)
	return Vector2(x_range, y_range)

static func random_vector2i(_min_limit:Vector2, _max_limit:Vector2) -> Vector2:
	if is_null(_min_limit) or is_null(_max_limit): return Vector2.ZERO
	var _min_limit_int: Vector2i = Vector2i(_min_limit)
	var _max_limit_int: Vector2i = Vector2i(_max_limit)
	var x_range: int = rnd.randi_range(_min_limit_int.x, _max_limit_int.x)
	var y_range: int = rnd.randi_range(_min_limit_int.y, _max_limit_int.y)
	return Vector2(x_range, y_range)

static func random_vector3(_min_limit:Vector3, _max_limit:Vector3) -> Vector3:
	if is_null(_min_limit) or is_null(_max_limit): return Vector3.ZERO
	var x_range: float = rnd.randf_range(_min_limit.x, _max_limit.x)
	var y_range: float = rnd.randf_range(_min_limit.y, _max_limit.y)
	var z_range: float = rnd.randf_range(_min_limit.z, _max_limit.z)
	return Vector3(x_range, y_range, z_range)

static func random_vector3i(_min_limit:Vector3, _max_limit:Vector3) -> Vector3:
	if is_null(_min_limit) or is_null(_max_limit): return Vector3.ZERO
	var _min_limit_int: Vector3i = Vector3i(_min_limit)
	var _max_limit_int: Vector3i = Vector3i(_max_limit)
	var x_range: int = rnd.randi_range(_min_limit_int.x, _max_limit_int.x)
	var y_range: int = rnd.randi_range(_min_limit_int.y, _max_limit_int.y)
	var z_range: int = rnd.randi_range(_min_limit_int.z, _max_limit_int.z)
	return Vector3(x_range, y_range, z_range)

static func random_mirror_int(limit:int = 10) -> int:
	if is_null(limit): return 0
	return rnd.randi_range(-limit, limit)

static func random_mirror_float(limit: float = 1.0) -> float:
	if is_null(limit): return 0.0
	return rnd.randf_range(-limit, limit)

static func random_mirror_vector2(limit: Vector2) -> Vector2:
	if is_null(limit): return Vector2.ZERO
	return random_vector2(-limit, limit)

static func random_mirror_vector2i(limit: Vector2) -> Vector2:
	if is_null(limit): return Vector2i.ZERO
	return random_vector2i(-limit, limit)

static func random_mirror_vector3(limit: Vector3) -> Vector3:
	if is_null(limit): return Vector3.ZERO
	return random_vector3(-limit, limit)

static func random_mirror_vector3i(limit: Vector3) -> Vector3:
	if is_null(limit): return Vector3.ZERO
	return random_vector3i(-limit, limit)

static func random_array_pick(array: Array) -> Variant:
	if array.is_empty(): return null
	var i = random_int(0, array.size())
	return array[i]

static func random_dict_pick(dict: Dictionary) -> Variant:
	if dict.is_empty(): return null
	var i = random_array_pick(dict.keys())
	return dict[i]

#endregion Random Funtions

static func is_null(value: Variant) -> bool:
	return value == null
