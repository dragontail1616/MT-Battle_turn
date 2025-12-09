class_name OptionsPause
extends Control

@export var debug: bool = false
@export var tween_time: float = 0.4
@export var tween_transition: Tween.TransitionType = Tween.TransitionType.TRANS_SPRING
@export var tween_ease: Tween.EaseType = Tween.EaseType.EASE_OUT

@onready var resumen: Button = $MarginContainer/PanelContainer/Panel/MarginContainer/MenuOptions/MarginContainer/ButtonOptions/Resumen
@onready var restart: Button = $MarginContainer/PanelContainer/Panel/MarginContainer/MenuOptions/MarginContainer/ButtonOptions/Restart
@onready var settings: Button = $MarginContainer/PanelContainer/Panel/MarginContainer/MenuOptions/MarginContainer/ButtonOptions/Settings
@onready var quit: Button = $MarginContainer/PanelContainer/Panel/MarginContainer/MenuOptions/MarginContainer/ButtonOptions/Quit

var tween_pause: Tween = null
var actived: bool = false:
	set(value):
		if value:
			tween_pause_in()
		else:
			tween_pause_out()
		visibility_changed.emit()
		actived = value

func _ready() -> void:
	actived = false
	resumen.pressed.connect(_resumen_button_pressed.bind(resumen))
	restart.pressed.connect(_restart_button_pressed.bind(restart))
	settings.pressed.connect(_settings_button_pressed.bind(settings))
	quit.pressed.connect(_quit_button_pressed.bind(quit))

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#actived = !actived

func _resumen_button_pressed(button: Button) -> void:
	prints("resumen button pressed", button.name)

func _restart_button_pressed(button: Button) -> void:
	prints("restart button pressed", button.name)
	#TODO: operaciones repetidas junto a quit button. Acoplar en una funcion
	#considerar si colocar esta operaciones en una funcion constaste o autoload
	var game_dialog_scene: PackedScene = preload(Constants.ui_scenes_path.game_dialog)
	var new_game_dialog: GameDialog = game_dialog_scene.instantiate()
	
	new_game_dialog.call_deferred("setting_dialog", button)
	get_tree().get_root().add_child(new_game_dialog)
	new_game_dialog.answer_confirmed.connect(_dialog_answer.bind(button.name.to_lower()))

func _settings_button_pressed(button: Button) -> void:
	prints("settings button pressed", button.name)

func _quit_button_pressed(button: Button) -> void:
	prints("quit button pressed", button.name)
	#TODO: operaciones repetidas junto a restart button. Acoplar en una funcion
	#considerar si colocar esta operaciones en una funcion constaste o autoload
	var game_dialog_scene: PackedScene = preload(Constants.ui_scenes_path.game_dialog)
	var new_game_dialog: GameDialog = game_dialog_scene.instantiate()
	
	new_game_dialog.call_deferred("setting_dialog", button)
	get_tree().get_root().add_child(new_game_dialog)
	new_game_dialog.answer_confirmed.connect(_dialog_answer.bind(button.name.to_lower()))

func _dialog_answer(answer: bool, option_name: String) -> void:
	if not answer:
		return
	match option_name:
		"restart": prints("Game restarted")
		"quit":
			prints("Game quit")
			get_tree().quit()

func tween_pause_in() -> void:
	tween_setting()
	
	tween_pause.tween_property(self, "scale:x", 1.0, tween_time).from(0.0)
	tween_pause.tween_property(self, "scale:y", 1.0, tween_time).from(0.6)
	tween_pause.tween_property(self, "modulate", Color.WHITE, tween_time).from(Color.TRANSPARENT)
	tween_pause.tween_interval(1.0)
	show()

func tween_pause_out() -> void:
	tween_setting()
	# TODO: ajustar para que la animacion de ocultado se ejecute antes
	# de despausar el juego, de se posible crear una señal menu_pause_finished
	# porque el tween await no esta funcionando porque la variable se cambia antes
	tween_pause.tween_property(self, "scale:x", 0.0, tween_time).from(1.0)
	tween_pause.tween_property(self, "scale:y", 0.6, tween_time).from(1.0)
	tween_pause.tween_property(self, "modulate", Color.TRANSPARENT, tween_time).from(Color.WHITE_SMOKE)
	await tween_pause.finished
	hide()

func tween_setting(parallel: bool = true) -> void:
	if tween_pause:
		tween_pause.kill()
	
	tween_pause = create_tween().set_parallel(parallel)
	tween_pause.set_trans(tween_transition).set_ease(tween_ease)
