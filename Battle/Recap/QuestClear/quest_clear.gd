extends Control

signal RewardsComplete

@export var zel: int = 0
@export var karma: int = 0
@export var xp: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the initial value of the bar. This is not yet animated, so it can be set now
	$XPContainer/XPBar.max_value = ActiveAccount.max_exp
	$XPContainer/XPBar.value = ActiveAccount.current_exp
	# Begin animations
	move_zel()

func move_zel():
	var zel_tween = create_tween()
	zel_tween.tween_property($ZelContainer, "position", Vector2(0,0), 1.0)
	zel_tween.tween_callback(animate_zel)

func animate_zel():
	await get_tree().create_timer(1.0).timeout
	$LabelAnimator.set_properties(0, zel, $ZelContainer/ZelAmount)
	var zel_tween = create_tween()
	zel_tween.tween_property($LabelAnimator, "current_val", zel, 2.0)
	zel_tween.tween_callback(move_karma)

func move_karma():
	var karma_tween = create_tween()
	karma_tween.tween_property($KarmaContainer, "position", Vector2(0,0), 1.0)
	karma_tween.tween_callback(animate_karma)

func animate_karma():
	await get_tree().create_timer(1.0).timeout
	$LabelAnimator.set_properties(0, karma, $KarmaContainer/KarmaAmount)
	var karma_twen = create_tween()
	karma_twen.tween_property($LabelAnimator, "current_val", karma, 2.0)
	karma_twen.tween_callback(move_bar)

func move_bar():
	var exp_tween = create_tween()
	exp_tween.tween_property($XPContainer, "position", Vector2(0,0), 1.0)
	exp_tween.tween_callback(animate_bar.bind(ActiveAccount.current_exp, xp, ActiveAccount.current_exp))

func animate_bar(initial_exp: int, exp_amount: int, bar_amount: int):
	print(initial_exp, " ", exp_amount, " ", bar_amount)
	# Wait a few seconds
	await get_tree().create_timer(1.5).timeout
	
	# Set the initial values
	$XPContainer/XPCurrentAmount.text = str(initial_exp)
	$XPContainer/XPBar.value = bar_amount
	
	# Animate the XP obtained label
	$LabelAnimator.set_properties(0, exp_amount, $XPContainer/XPCurrentAmount)
	var tween_obtained = create_tween()
	tween_obtained.tween_property($LabelAnimator, "current_val", exp_amount, 2.0)
	
	# Animate the xp to next lvl label
	$LabelAnimator2.set_properties(exp_amount, 0, $XPContainer/XPNextAmount)
	var tween_next = create_tween()
	tween_next.tween_property($LabelAnimator2, "current_val", 0, 2.0)
	
	# Animate the exp bar
	var tween = create_tween()
	tween.tween_property($XPContainer/XPBar, "value", exp_amount, 2.0)
	tween.tween_callback(check_for_level_up.bind(exp_amount))
	# To-do: Check for level up, max level, etc
	
func check_for_level_up(exp_amount: int):
	# Check for level up
	if ActiveAccount.will_player_level_up(exp_amount):
		print("Player leveled up")
		var arg_names = ["new_level"]
		var arg_vals = [3]
		# To-do: ANimate the level text
		$content_switcher._set_blank_scene()
		$content_switcher.load_scene_with_props("res://Battle/Recap/QuestClear/LeveledUp/leveled_up.tscn", 0, arg_names, arg_vals)
	else:
		_on_XP_awarded()

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
