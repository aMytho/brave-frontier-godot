extends Control

signal RewardsComplete

@export var zel: int = 0
@export var karma: int = 0
@export var xp: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the initial value of the bar. This is not yet animated, so it can be set now
	$XPBar.value = ActiveAccount.current_exp
	animate_zel()

func animate_zel():
	$LabelAnimator.set_properties(0, zel, $ZelAmount)
	var zel_tween = create_tween()
	zel_tween.tween_property($LabelAnimator, "current_val", zel, 2.0)
	zel_tween.tween_callback(animate_karma)

func animate_karma():
	await get_tree().create_timer(1.5).timeout
	$LabelAnimator.set_properties(0, karma, $KarmaAmount)
	var karma_twen = create_tween()
	karma_twen.tween_property($LabelAnimator, "current_val", karma, 2.0)
	karma_twen.tween_callback(animate_bar)

func animate_bar():
	# Wait a few seconds
	await get_tree().create_timer(1.5).timeout
	# Animate the XP obtained label
	$LabelAnimator.set_properties(0, xp, $XPCurrentAmount)
	var tween_obtained = create_tween()
	tween_obtained.tween_property($LabelAnimator, "current_val", xp, 2.0)
	
	
	# Animate the xp to next lvl label
	
	$LabelAnimator2.set_properties(xp, 0, $XPNextAmount)
	var tween_next = create_tween()
	tween_next.tween_property($LabelAnimator2, "current_val", 0, 2.0)
	
	# Animate the exp bar
	var tween = create_tween()
	tween.tween_property($XPBar, "value", xp, 2.0)
	tween.tween_callback(_on_XP_awarded)
	# To-do: Check for level up, max level, etc

func _on_XP_awarded():
	await get_tree().create_timer(2.0).timeout
	# To-do: get real values
	var arg_names = ["sparks", "crits", "hc", "bc"]
	var arg_vals = [111, 222, 333, 444]
	$content_switcher._set_blank_scene()
	$content_switcher.load_scene_with_props("res://Battle/Recap/QuestClear/CombatStats/combat_stats.tscn", 0, arg_names, arg_vals)
	# Wait a few seconds, and let the parent know that we can move to the next thing
	await get_tree().create_timer(4.0).timeout
	emit_signal("RewardsComplete")
