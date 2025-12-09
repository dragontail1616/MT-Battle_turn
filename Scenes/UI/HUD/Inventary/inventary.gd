class_name Inventory
extends Control

@export var debug: bool = false
@export var tween_time: float = 0.4
@export var tween_transition: Tween.TransitionType = Tween.TransitionType.TRANS_SPRING
@export var tween_ease: Tween.EaseType = Tween.EaseType.EASE_OUT

@onready var items_container: VBoxContainer = $PanelContainer/Panel/ItemsContainer

var current_inventory: Dictionary[String, int] = {"stone_cannon": 5}
var tween_inventory:Tween = null
var character: Character = null
var actived: bool = false:
	set(value):
		if value:
			tween_inventory_in()
		else:
			tween_inventory_out()
		visibility_changed.emit()
		actived = value

func _ready() -> void:
	actived = false
	fill_inventory()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("inventory"):
		#actived = !actived
	#if event.is_action_pressed("interact"):
		#subtract_item_skill("stone_cannon")

func fill_inventory() -> void:
	for item in current_inventory:
		add_item_skill(item, current_inventory[item])

func clear_invetory() -> void:
	for item in current_inventory:
		subtract_item_skill(item, current_inventory[item])

func add_item_skill(item_name: String, amount: int = 1) -> void:
	var item: ItemSkill = load(Constants.items_path.get(item_name)).duplicate()
	var inv_sts: GridContainer = get_node(Constants.inventory_slot_path.get(item.item_skill_category))
	for slot: ItemSlot in inv_sts.get_children():
		slot.debug = debug
		if slot.filled:
			if slot.item_skill.item_skill_name.to_pascal_case() == item.item_skill_name.to_pascal_case():
				slot.amount += amount
				current_inventory[item_name] += amount
				break
			continue
		slot.item_skill = item
		slot.setting_item_skill(amount)
		break

func subtract_item_skill(item_name: String, amount: int = 1) -> void:
	if not current_inventory.has(item_name):
		return
	var item: ItemSkill = load(Constants.items_path.get(item_name)).duplicate()
	var inv_sts: GridContainer = get_node(Constants.inventory_slot_path.get(item.item_skill_category))
	for slot:ItemSlot in inv_sts.get_children():
		if slot.filled:
			if slot.item_skill.item_skill_name == item.item_skill_name:
				slot.amount -= amount
				current_inventory[item_name] -= amount
				if slot.amount <= 0:
					slot.debug = false
					slot.clear_item_skill()
					current_inventory.erase(item_name)
				break
			continue


func tween_inventory_in() -> void:
	tween_setting()
	
	tween_inventory.tween_property(items_container, "scale", Vector2.ONE, tween_time).from(Vector2.ONE * 0.6)
	tween_inventory.tween_property(self, "modulate", Color.WHITE, tween_time).from(Color.TRANSPARENT)
	tween_inventory.tween_property(self, "scale", Vector2.ONE, tween_time).from(Vector2.ONE * 0.25)
	tween_inventory.tween_property(self, "rotation_degrees", 0.0, tween_time).from(15.0)
	tween_inventory.tween_interval(1.0)
	show()


func tween_inventory_out() -> void:
	tween_setting()
	
	tween_inventory.tween_property(items_container, "scale", Vector2.ONE * 0.8, tween_time).from(Vector2.ONE)
	tween_inventory.tween_property(self, "modulate", Color.TRANSPARENT, tween_time).from(Color.LIGHT_GRAY)
	tween_inventory.tween_property(self, "scale", Vector2.ZERO, tween_time).from(Vector2.ONE)
	tween_inventory.tween_property(self, "rotation_degrees", 15.0, tween_time).from(0)
	await tween_inventory.finished
	hide()

func tween_setting(parallel: bool = true) -> void:
	if tween_inventory:
		tween_inventory.kill()
	
	tween_inventory = create_tween().set_parallel(parallel)
	tween_inventory.set_trans(tween_transition).set_ease(tween_ease)
