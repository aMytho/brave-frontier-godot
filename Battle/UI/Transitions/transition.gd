extends Control

signal TransitionHide
signal TransitionShow

# The initial and visiable positions for the transition
var off_screen: Vector2 = Vector2(640, 88)
var on_screen: Vector2 = Vector2(-248,88)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_transition():
	# Shows the transition and emits when finished
	var tween = create_tween()
	tween.tween_property($TransitionContainer, "position", on_screen, 0.4)
	tween.tween_callback(_on_transition_complete.bind(false))

func hide_transition():
	# Hides the transition and emtis when finished
	var tween = create_tween()
	tween.tween_property($TransitionContainer, "position", off_screen, 0.4)
	tween.tween_callback(_on_transition_complete.bind(true))

func _on_transition_complete(is_hide: bool):
	# The transition finished moving. Emits what type of movement it was
	if is_hide:
		emit_signal("TransitionHide")
	else:
		emit_signal("TransitionShow")

func set_properties(initial_stage: int, total_stages: int, dungeon_name: String, zone_name: String):
	$TransitionContainer/TransitionContent.set_properties(initial_stage, total_stages, dungeon_name, zone_name)

func update_properties(new_stage: int):
	$TransitionContainer/TransitionContent.update_progress(new_stage)
