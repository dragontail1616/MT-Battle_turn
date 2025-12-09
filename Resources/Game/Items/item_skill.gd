class_name ItemSkill
extends Resource


@export var item_skill_name: String = ""
@export var item_skill_image: CompressedTexture2D
@export var item_skill_category: Constants.SkillCategory = Constants.SkillCategory.BASIC
@export var points: float = 0.0
@export var distance: float = 0.0
@export var cost: float = 0.0
@export_multiline var item_skill_description: String = ""
