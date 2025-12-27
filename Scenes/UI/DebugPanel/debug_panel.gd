class_name Debug
extends CanvasLayer

var properties: Array = []

@onready var properties_list: VBoxContainer = $Debug/PanelContainer/PropertiesList

const fps_ms: int = 16

func _ready() -> void:
	Global.debug = self
	visible = false

func add_debug_property(id: StringName, value, time_in_frames: int) -> void:
	if properties.has(id):
		@warning_ignore("integer_division")
		if Time.get_ticks_msec() / fps_ms % time_in_frames == 0:
			var target: Label = properties_list.find_child(id, true, false) 
			target.text = id + ": " + str(value)
	else:
		var target: Label = Label.new()
		properties_list.add_child(target)
		target.name = id
		target.text = id + ": " + str(value)
		properties.append(id)

func control_debug_panel() -> void:
	visible = !visible
