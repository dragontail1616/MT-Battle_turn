class_name UIManager
extends Control

@export var ui_actived: bool = true
@export var character: Character
@export var hud: HUDManager
@export var menu_pause: MenuPausaManager

#TODO por el momento los menu hud(inventario) y menupausa se puede combinar
#se debe hacer ajustes para que el inventario se cierre o deje de funcionar el popup

func _ready() -> void:
	hud.target = character
	menu_pause.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory") and not get_tree().paused:
		hud.control_inventory()
	if event.is_action_pressed("pause"):
		menu_pause.control_game_pause()
		hud.hud_visible = !menu_pause.game_paused

static func add_hud_manager(parent: Node = null) -> HUDManager:
	var hud_scene: PackedScene = load(Constants.ui_scenes_path.hud_manager)
	var new_hud_manager: HUDManager = hud_scene.instantiate()
	if parent:
		parent.add_child(new_hud_manager, true)
	return new_hud_manager

static func add_menu_pause_manager(parent: Node = null) -> MenuPausaManager:
	var menu_pause_scene: PackedScene = load(Constants.ui_scenes_path.menu_pause)
	var new_menu_pause: MenuPausaManager = menu_pause_scene.instantiate()
	if parent:
		parent.add_child(new_menu_pause)
	return new_menu_pause
