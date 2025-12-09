class_name ItemSlot
extends Panel

signal item_skill_selected(item_skill_name: String)

@export var item_skill: ItemSkill

@onready var item_button: TextureButton = $ItemButton
@onready var item_amount: Label = $ItemAmount

var debug: bool = false

var filled: bool = false
var amount: int = 0:
	set(value):
		amount = clamp(value, 0, 99)
		amount = value
		item_amount.text = str(amount)

func _ready() -> void:
	setting_item_skill()

func setting_item_skill(new_amount: int = 1) -> void:
	if not item_skill:
		return
	item_button.texture_normal = item_skill.item_skill_image
	item_button.pressed.connect(item_skill_selection.bind(item_skill.item_skill_name))
	item_button.mouse_entered.connect(item_skill_area_entered)
	item_button.mouse_exited.connect(item_skill_area_exited)
	amount += new_amount
	item_amount.text = str(amount)
	filled = true

func clear_item_skill() -> void:
	item_skill = null
	item_button.texture_normal = null
	item_button.pressed.disconnect(item_skill_selection)
	item_button.mouse_entered.disconnect(item_skill_area_entered)
	item_button.mouse_exited.disconnect(item_skill_area_exited)
	amount = 0
	item_amount.text = ""
	filled = false

func item_skill_selection(item_skill_name: String) -> void:
	prints("The skill", item_skill_name, "has been selected")
	item_skill_selected.emit(item_skill_name)

func item_skill_area_entered() -> void:
	if debug:
		prints("You has entered in", item_skill.item_skill_name, "area")
	var item_area: Rect2i = Rect2i(Vector2i(global_position), Vector2i(size))
	Popups.show_skill_popup(item_area, item_skill)

func item_skill_area_exited() -> void:
	if debug:
		prints("You has exited in", item_skill.item_skill_name, "area")
	Popups.hide_skill_popup()
