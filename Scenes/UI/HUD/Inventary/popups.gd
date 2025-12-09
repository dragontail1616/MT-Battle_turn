extends CanvasLayer

@onready var popup_panel: PopupPanel = $Control/PopupPanel
@onready var skill_name: Label = $Control/PopupPanel/VBoxContainer/SkillName
@onready var texture_rect: TextureRect = $Control/PopupPanel/VBoxContainer/HBoxContainer/TextureRect
@onready var points_label: Label = $Control/PopupPanel/VBoxContainer/HBoxContainer/StastText/PointsLabel
@onready var range_label: Label = $Control/PopupPanel/VBoxContainer/HBoxContainer/StastText/RangeLabel
@onready var label_cost: Label = $Control/PopupPanel/VBoxContainer/HBoxContainer/StastText/LabelCost
@onready var description_label: Label = $Control/PopupPanel/VBoxContainer/DescriptionLabel

func show_skill_popup(slot: Rect2i, item: ItemSkill) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var correction: Vector2i = Vector2.ZERO
	var padding: int = 4
	
	if mouse_pos.x <= get_viewport().get_visible_rect().size.x/2:
		correction = Vector2i(slot.size.x, 0)
	else:
		correction = -Vector2i(popup_panel.size.x + padding, 0)
	
	setting_item_stats(item)
	popup_panel.popup(Rect2i(slot.position + correction, popup_panel.size))

func hide_skill_popup() -> void:
	popup_panel.hide()

func setting_item_stats(item: ItemSkill) -> void:
	skill_name.text = item.item_skill_name
	texture_rect.texture = item.item_skill_image if item.item_skill_image else null
	points_label.text = str(item.points)
	range_label.text = str(item.distance)
	label_cost.text = str(item.cost)
	description_label.text = str(item.item_skill_description)
	
