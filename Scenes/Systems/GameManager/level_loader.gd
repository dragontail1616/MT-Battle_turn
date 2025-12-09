class_name LevelLoader
extends Node

signal level_loaded(level_root: Level)

func load_level(level_name: String = "level_template", parent = self) -> Error:
	var level_scene: PackedScene = load(Constants.levels_path.get(level_name))
	var level_root: Level = level_scene.instantiate()
	
	if not level_root:
		prints("No existe el nivel")
		return ERR_FILE_NOT_FOUND
	
	parent.add_child(level_root)
	
	level_loaded.emit(level_root)
	return OK
