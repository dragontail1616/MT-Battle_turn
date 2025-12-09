class_name MenuPausaManager
extends CanvasLayer

@export var menu_pausa_action: String
@export var game_paused: bool = false:
	set(value):
		visible = value
		visibility_changed.emit()
		game_paused = value
		get_tree().paused = game_paused

@onready var options_pausa: OptionsPause = $OptionsPausa
@onready var background: Control = $Background

#TODO darle un vistazo al background que hay que colocarlo en filtre ignore
#tanto al control como al color rect para poder acceder al GameDialog

var target: Character = null
var mouse_captured: bool = true

func control_game_pause() -> void:
	options_pausa.actived = !options_pausa.actived
	game_paused = !game_paused
	mouse_captured = !mouse_captured
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if mouse_captured else Input.MOUSE_MODE_VISIBLE)
