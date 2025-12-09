class_name CrossHair
extends Control

@export_category("Visual")
@export var ring_color : Color = Color(1.0, 1.0, 1.0, 0.498)
@export var dot_color  : Color = Color(0.941, 0.941, 0.941, 0.549)
@export var ring_thickness : float = 1.5
@export var ring_radius : float = 24.0
@export var dot_radius : float = 2.0

@export_category("Motion")
@export var max_scale : float= 1.5
@export var tween_duration : float = 0.25
@export var tween_ease :Tween.EaseType = Tween.EASE_OUT_IN
@export var tween_trans : Tween.TransitionType = Tween.TRANS_QUINT
@export var speed_factor : float = 0.25

var character: Character = null
var tween: Tween

var current_scale := 1.0
var actived: bool = true:
	set(value):
		if value:
			show()
			visibility_changed.emit(true)
		else:
			hide()
			visibility_changed.emit(false)
		actived = value

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)

func _process(_delta: float) -> void:
	if not character:
		return
	var h_speed := Vector2(character.velocity.x, character.velocity.z).length()
	var target := 1.0 + h_speed * speed_factor
	target = min(target, max_scale)

	if not tween or tween.is_running() or !is_equal_approx(current_scale, target):
		if tween: tween.kill()
		tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_IDLE)
		tween.tween_property(self, "current_scale", target, tween_duration).set_ease(tween_ease).set_trans(tween_trans)

	queue_redraw()

func _draw() -> void:
	var center := size * 0.5
	var r  := ring_radius * current_scale
	var t  := ring_thickness

	#full_circle(center, r, t)
	arcs_circle(center, r, t)

func full_circle(center, r, t) -> void:
	var d := dot_radius * current_scale

	draw_arc(center, r, 0, TAU, 64, ring_color, t, true)

	draw_circle(center, d, dot_color)


func arcs_circle(center, r, t) -> void:
	var gap := PI * 0.05

	var q1 := Vector2(-PI + gap, -PI*0.5 - gap)    # LU
	var q2 := Vector2(-PI*0.5 + gap, -gap)         # LD
	var q3 := Vector2( gap,  PI*0.5 - gap)         # RD
	var q4 := Vector2( PI*0.5 + gap,  PI - gap)    # RU

	draw_arc(center, r, q1.x, q1.y, 16, ring_color, t, true)
	draw_arc(center, r, q2.x, q2.y, 16, ring_color, t, true)
	draw_arc(center, r, q3.x, q3.y, 16, ring_color, t, true)
	draw_arc(center, r, q4.x, q4.y, 16, ring_color, t, true)

	draw_circle(center, dot_radius * current_scale, dot_color)
