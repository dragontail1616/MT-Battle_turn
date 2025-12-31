class_name GameManager
extends Node

var level_name: String = "":
	set(value):
		if Constants.levels_path.has(value):
			level_name = value
	get():
		return level_name.to_lower()

var inter_turn_time: float = 2.0
var character_list: Dictionary[String, Character] = {}
var team_list: Dictionary[String, Array] = {}
var level_root: Level
var spawn_list: Array = []
var object_list: Array = []
var level_loader: LevelLoader
var ui_manager: UIManager
var camera_director: CameraDirector
var turn_manager: TurnManager
var turn_timer: Timer
var tween_interval: Tween

var _label_timer: Label
var char_prepared: bool = false

func _ready() -> void:
	load_level()
	spawn_characters()
	setup_managers()
	instance_ui_manager(self)

func _process(_delta: float) -> void:
	if not turn_timer.is_stopped():
		_label_timer.text = str(turn_timer.time_left).pad_decimals(0)

func load_level() -> void:
	level_loader = LevelLoader.new()
	add_child(level_loader)
	level_loader.level_loaded.connect(_on_load_level)
	level_loader.load_level("level_template", self)
	spawn_list.shuffle()

func spawn_characters() -> void:
	for _i in range(2):
		var spawn_point: Vector3 = spawn_list.pop_front().global_position
		instance_characters("template_char", "0", level_root.characters_node, spawn_point)

func setup_managers() -> void:
	turn_timer = Timer.new()
	add_child(turn_timer)
	turn_timer.one_shot = true
	
	turn_manager = TurnManager.new(character_list, team_list)
	turn_manager.round_started.connect(_on_round_started)
	turn_manager.round_ended.connect(_on_round_ended)
	turn_manager.turn_started.connect(_on_turn_started)
	turn_manager.turn_ended.connect(_on_turn_ended)
	
	camera_director = CameraDirector.new()
	add_child(camera_director)
	camera_director.setup_main_camera(level_root)
	
	turn_manager.start_turn()

func instance_characters(char_name:= "template_char", char_team = "0", parent = self, spawn:= Vector3.ZERO) -> Error:
	var char_scene: PackedScene = load(Constants.character_path.get(char_name))
	if not char_scene:
		return ERR_FILE_NOT_FOUND
	var char_instance: Character = char_scene.instantiate()
	char_instance.name = char_name
	parent.add_child(char_instance, true)
	
	char_instance.global_position = spawn
	character_list[char_instance.name] = char_instance
	if not team_list.has(char_team):
		team_list[char_team] = []
	team_list[char_team].append(char_instance.name)
	
	return OK

func instance_ui_manager(parent:= self) -> Error:
	var ui_scene: PackedScene = load(Constants.ui_scenes_path.ui_manager)
	if not ui_scene:
		return ERR_FILE_NOT_FOUND
	var ui_manager_instance: UIManager = ui_scene.instantiate()
	ui_manager = ui_manager_instance
	parent.add_child(ui_manager_instance, true)
	
	_label_timer = Label.new()
	ui_manager_instance.add_child(_label_timer)
	
	_label_timer.add_theme_font_size_override("font_size", 64)
	_label_timer.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	_label_timer.text = ""
	_label_timer.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	
	return OK

func _on_load_level(node_root: Level) -> void:
	level_root = node_root
	spawn_list = node_root.spawns_node.get_children()

func _on_round_started(no_round: int) -> void:
	prints("Round", no_round, "started")
	#var points: Array[Array] = []
	if tween_interval:
		tween_interval.kill()
	tween_interval = create_tween()
	var camera_shot_amount = Utils.random_int(1, 1)
	for _i in range(camera_shot_amount):
		var ran_dur = Utils.random_float(1.8, 2.2)
		var ran_int = Utils.random_float(1.6, 2.0)
		var spawn_pos: Vector3 = spawn_list.pick_random().global_position + Vector3.UP * 6
		var spawn_targ: Vector3 = spawn_list.pick_random().global_position
		tween_interval.tween_callback(camera_director.blend_to.bind(spawn_pos, spawn_targ, ran_dur))
		tween_interval.tween_interval(ran_int)

func _on_round_ended(no_round: int) -> void:
	prints("Round", no_round, "ended")

func _on_turn_started(character: Character, no_turn: int, team_name: String) -> void:
	if tween_interval and tween_interval.is_valid():
		await tween_interval.finished
	
	prints("Character", character.name, "form team", team_name, "start the turn", no_turn)
	var char_back_pos: Vector3 = character.global_basis.z * 3
	camera_director.blend_to(character.global_position +char_back_pos, character.global_position, 1.5)
	await camera_director.position_arrived
	character.character_active = true
	
	var moved : bool = false
	var max_wait : float = 2.0 
	var umbral := 0.05 
	var t := 0.0
	
	while t < max_wait and not moved:
		await get_tree().process_frame
		t += get_process_delta_time()
		if character.velocity.length() > umbral:
			moved = true
			break
	
	turn_timer.start(4.0)
	await turn_timer.timeout
	turn_manager.next_turn()

func _on_turn_ended(character: Character, no_turn: int, team_name: String) -> void:
	prints("Character", character.name, "form team", team_name, "end the turn", no_turn)
	character.character_active = false
