class_name Utils
extends Node

static var rnd: RandomNumberGenerator = RandomNumberGenerator.new()

#region Random Funtions
static func set_seed(_seed: int) -> void:
	rnd.seed = _seed

static func get_seed() -> int:
	return rnd.seed

static func rand_int(_max_limit: int) -> int:
	return rnd.randi() % _max_limit

static func rand_float(_max_limit: int = 1) -> float:
	return (rnd.randf() * _max_limit)

static func random_int(_min_limit:int, _max_limit:int) -> int:
	return rnd.randi_range(_min_limit, _max_limit)

static func random_float(_min_limit:float, _max_limit:float) -> float:
	return rnd.randf_range(_min_limit, _max_limit)

static func random_vector2(_min_limit:Vector2, _max_limit:Vector2) -> Vector2:
	var x_range: float = rnd.randf_range(_min_limit.x, _max_limit.x)
	var y_range: float = rnd.randf_range(_min_limit.y, _max_limit.y)
	return Vector2(x_range, y_range)

static func random_vector2i(_min_limit:Vector2, _max_limit:Vector2) -> Vector2:
	var _min_limit_int: Vector2i = Vector2i(_min_limit)
	var _max_limit_int: Vector2i = Vector2i(_max_limit)
	var x_range: int = rnd.randi_range(_min_limit_int.x, _max_limit_int.x)
	var y_range: int = rnd.randi_range(_min_limit_int.y, _max_limit_int.y)
	return Vector2(x_range, y_range)

static func random_vector3(_min_limit:Vector3, _max_limit:Vector3) -> Vector3:
	var x_range: float = rnd.randf_range(_min_limit.x, _max_limit.x)
	var y_range: float = rnd.randf_range(_min_limit.y, _max_limit.y)
	var z_range: float = rnd.randf_range(_min_limit.z, _max_limit.z)
	return Vector3(x_range, y_range, z_range)

static func random_vector3i(_min_limit:Vector3, _max_limit:Vector3) -> Vector3:
	var _min_limit_int: Vector3i = Vector3i(_min_limit)
	var _max_limit_int: Vector3i = Vector3i(_max_limit)
	var x_range: int = rnd.randi_range(_min_limit_int.x, _max_limit_int.x)
	var y_range: int = rnd.randi_range(_min_limit_int.y, _max_limit_int.y)
	var z_range: int = rnd.randi_range(_min_limit_int.z, _max_limit_int.z)
	return Vector3(x_range, y_range, z_range)

static func random_mirror_vector2(limit: Vector2) -> Vector2:
	return random_vector2(-limit, limit)

static func random_mirror_vector2i(limit: Vector2) -> Vector2:
	return random_vector2i(-limit, limit)

static func random_mirror_vector3(limit: Vector3) -> Vector3:
	return random_vector3(-limit, limit)

static func random_mirror_vector3i(limit: Vector3) -> Vector3:
	return random_vector3i(-limit, limit)

static func random_mirror_int(limit:int) -> int:
	return rnd.randi_range(-limit, limit)

static func random_mirror_float(limit: float) -> float:
	return rnd.randf_range(-limit, limit)

static func random_array_pick(array: Array) -> Variant:
	var i = random_int(0, array.size())
	return array[i]

static func random_dict_pick(dict: Dictionary) -> Variant:
	var i = random_array_pick(dict.keys())
	return dict[i]

#endregion Random Funtions
