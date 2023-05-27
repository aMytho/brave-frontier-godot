extends Control

signal RewardsComplete

@export var zel: int = 0
@export var karma: int = 0
@export var xp: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the initial values
	$ZelAmount.text = str(zel)
	$KarmaAmount.text = str(karma)
	$XXCurrentAmount.text = str(xp)
	$XPBar.value = ActiveAccount.current_exp
	# To-do: calc level exp and next level xp
	await get_tree().create_timer(2.5).timeout
	animate_bar(xp)

func animate_bar(new_val: int):
	# Animate the exp bar
	var tween = create_tween()
	tween.tween_property($XPBar, "value", new_val, 2.0)
	tween.tween_callback(_on_XP_awarded)

func _on_XP_awarded():
	await get_tree().create_timer(3.0).timeout
	# To-do: get real values
	var arg_names = ["sparks", "crits", "hc", "bc"]
	var arg_vals = [111, 222, 333, 444]
	$content_switcher._set_blank_scene()
	$content_switcher.load_scene_with_props("res://Battle/Recap/QuestClear/CombatStats/combat_stats.tscn", 0, arg_names, arg_vals)
	# Wait a few seconds, and let the parent know that we can move to the next thing
	await get_tree().create_timer(3.0).timeout
	emit_signal("RewardsComplete")
