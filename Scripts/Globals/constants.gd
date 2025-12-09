class_name Constants
extends RefCounted

enum TurnPhase {
	ON_TURN_STARTED,
	ON_THE_TURN,
	ON_TURN_ENDED
}

enum RoundPhase {
	ON_ROUND_STARTED,
	ON_THE_ROUND,
	ON_ROUND_ENDED
}

enum DistanceValue {
	NONE,
	SHORT,
	MIDDLE,
	LONG
}

enum AmountValue {
	NONE,
	LOW,
	MIDDLE,
	HIGH
}

enum SkillCategory {
	BASIC,
	ADVANCE,
	SPECIAL
}

const items_path: Dictionary[String, String] = {
	"stone_cannon": "uid://c00vpqhply67v"
}

const status_path: Dictionary[String, String] = {
	"boots": "uid://h20eie70t8jt",
	"propelled": "uid://b7h8dabsf6jpv"
}

const levels_path: Dictionary = {
	"level_template": "uid://cncl5j1k5yx81"
}

const character_path: Dictionary[String, String] = {
	"template_char": "uid://cc2p0htb3uuvq"
}

const inventory_slot_path: Dictionary[SkillCategory, String] = {
	SkillCategory.BASIC: "PanelContainer/Panel/ItemsContainer/ItemsContainerA/InventorySlots",
	SkillCategory.ADVANCE: "PanelContainer/Panel/ItemsContainer/ItemsContainerB/InventorySlots",
	SkillCategory.SPECIAL: "PanelContainer/Panel/ItemsContainer/ItemsContainerC/InventorySlots"
}

const ui_scenes_path: Dictionary[String, String] = {
	"ui_manager": "uid://bwhk6en222i67",
	"hud_manager": "uid://6ukgc5urouio",
	"menu_pause": "uid://dl6abuv2wbtbo",
	"game_dialog": "uid://c5cvhuxvtw6ad"
}
