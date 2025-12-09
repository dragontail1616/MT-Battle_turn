class_name GameDialog
extends Control

signal answer_confirmed(a: bool)

@onready var title: Label = $CenterContainer/PanelContainer/MarginContainer/ConfirmPanel/VBoxContainer/Title
@onready var yes_answer: Button = $CenterContainer/PanelContainer/MarginContainer/ConfirmPanel/VBoxContainer/ButtonOptions/YesAnswer
@onready var no_answer: Button = $CenterContainer/PanelContainer/MarginContainer/ConfirmPanel/VBoxContainer/ButtonOptions/NoAnswer

var answer: bool = false

func _ready() -> void:
	visible = true
	yes_answer.button_down.connect(_confirm_answer.bind(true))
	no_answer.button_down.connect(_confirm_answer.bind(false))

func setting_dialog(option) -> void:
	title.text = option.text
	#TODO añadir tambien un cambio en el panel en dependencia
	# de la opcion selectionada

func _confirm_answer(a: bool) -> void:
	answer_confirmed.emit(a)
	queue_free()
	
