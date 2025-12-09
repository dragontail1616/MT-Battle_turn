class_name HUDManager
extends CanvasLayer

# TODO: hacer una señal y conectarla a l bus de señales para habilitar el mouse
# con el inventario abierto

@export var hud_action: String
@export var hud_visible: bool = true:
	set(value):
		visible = value
		visibility_changed.emit()
		hud_visible = value

@onready var inventary: Inventory = $Inventary
@onready var crosshair: CrossHair = $Crosshair

var target: Character:
	set(value):
		if not value is Character:
			return
		target = value
		inventary.character = target
		crosshair.character = target

func control_inventory() -> void:
	crosshair.actived = inventary.actived
	inventary.actived = !inventary.actived
