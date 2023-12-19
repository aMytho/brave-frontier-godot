extends Control

signal RewardsComplete

@export var zel: int = 0
@export var karma: int = 0
## The total amount of xp
@export var xp: int = 0
## The amount of xp added so far. We keep track of this for the xpcurrentamount label
@export var exp_added: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the initial value of the bar. This is not yet animated, so it can be set now
	$XPContainer/XPBar.max_value = ActiveAccount.max_exp
	$XPContainer/XPBar.value = ActiveAccount.current_exp
	# Begin animations
	move_zel()


func move_zel():
	# Show the zel
	var zel_tween = create_tween()
	zel_tween.tween_property($ZelContainer, "position", Vector2(0,0), 1.0)
	zel_tween.tween_callback(animate_zel)


func animate_zel():
	# Wait, then animate the value
	await get_tree().create_timer(1.0).timeout
	$LabelAnimator.set_properties(0, zel, $ZelContainer/ZelAmount)
	var zel_tween = create_tween()
	zel_tween.tween_property($LabelAnimator, "current_val", zel, 2.0)
	zel_tween.tween_callback(move_karma)


func move_karma():
	# Show the karma
	var karma_tween = create_tween()
	karma_tween.tween_property($KarmaContainer, "position", Vector2(0,0), 1.0)
	karma_tween.tween_callback(animate_karma)


func animate_karma():
	# Wait, then animate the value
	await get_tree().create_timer(1.0).timeout
	$LabelAnimator.set_properties(0, karma, $KarmaContainer/KarmaAmount)
	var karma_twen = create_tween()
	karma_twen.tween_property($LabelAnimator, "current_val", karma, 2.0)
	karma_twen.tween_callback(move_bar)


func move_bar():
	# Show the bar
	var exp_tween = create_tween()
	exp_tween.tween_property($XPContainer, "position", Vector2(0,0), 1.0)
	# Based on level overflow, animate the xp bar
	if ActiveAccount.will_player_level_up(xp):
		exp_tween.tween_callback(animate_bar.bind(
			ActiveAccount.current_exp, ActiveAccount.max_exp - ActiveAccount.current_exp, true))
	else:
		exp_tween.tween_callback(animate_bar.bind(ActiveAccount.current_exp, xp, false))


func animate_bar(initial_exp: int, bar_amount: int, is_overlfow: bool):
	print(
		"Animating XP bar with ", initial_exp, " as initial, ", bar_amount, " and is overflow:", is_overlfow
		)
	var max_exp = ActiveAccount.max_exp
	# Wait a few seconds
	await get_tree().create_timer(1.5).timeout
	$content_switcher._set_blank_scene()
	
	# Set the initial values
	$XPContainer/XPCurrentAmount.text = str(initial_exp + exp_added)
	$XPContainer/XPNextAmount.text = str(max_exp - initial_exp)
	$XPContainer/XPBar.max_value = max_exp
	$XPContainer/XPBar.value = initial_exp
	
	# Animate the XP obtained label
	$LabelAnimator.set_properties(initial_exp + exp_added, bar_amount, $XPContainer/XPCurrentAmount)
	var tween_obtained = create_tween()
	tween_obtained.tween_property($LabelAnimator, "current_val", initial_exp + exp_added + bar_amount, 2.0)
	
	# Animate the xp to next lvl label
	$LabelAnimator2.set_properties(max_exp - initial_exp, max_exp - initial_exp - bar_amount, $XPContainer/XPNextAmount)
	var tween_next = create_tween()
	tween_next.tween_property($LabelAnimator2, "current_val", max_exp - initial_exp - bar_amount, 2.0)
	
	# Animate the exp bar
	var tween = create_tween()
	tween.tween_property($XPContainer/XPBar, "value", bar_amount + initial_exp, 2.0)
	tween.tween_callback(check_for_level_up.bind(bar_amount, is_overlfow))


func check_for_level_up(exp_amount: int, is_overflow: bool):
	print("EXP bar animation completed, adding: ", exp_amount, " to player.")
	# Didn't level up...
	if !is_overflow:
		print("The player won't level up")
		ActiveAccount.add_exp(exp_amount)
		_on_XP_awarded()
	else:
		# Level up!
		print("The player leveled up")
		var arg_names = ["new_level"]
		var arg_vals = [ActiveAccount.level + 1]
		# Load the animation for the level up event
		$content_switcher._set_blank_scene()
		$content_switcher.load_scene_with_props("res://Battle/Recap/QuestClear/LeveledUp/leveled_up.tscn", 0, arg_names, arg_vals)
		# Add the exp to the DB.
		# We have to add an extra one since exp_amount and current xp == max == not level up
		ActiveAccount.add_exp(exp_amount + 1)
		
		# Adjust the decrement/increment
		xp = xp - exp_amount
		exp_added = exp_added + exp_amount
		if exp_amount == 0:
			# We awared all the exp!
			_on_XP_awarded()
		else:
			# There is still exp left to add.
			if ActiveAccount.will_player_level_up(xp):
				$content_switcher.get_scene().connect("LevelsComplete",
					animate_bar.bind(0, ActiveAccount.max_exp, true))
			else:
				# Show the next level
				$content_switcher.get_scene().connect("LevelsComplete",
					animate_bar.bind(0, xp, false))


func _on_XP_awarded():
	await get_tree().create_timer(2.0).timeout
	# TODO: Get real values
	var arg_names = ["sparks", "crits", "hc", "bc"]
	var arg_vals = [111, 222, 333, 444]
	$content_switcher._set_blank_scene()
	$content_switcher.load_scene_with_props("res://Battle/Recap/QuestClear/CombatStats/combat_stats.tscn", 0, arg_names, arg_vals)
	# Wait a few seconds, and let the parent know that we can move to the next thing
	await get_tree().create_timer(4.0).timeout
	emit_signal("RewardsComplete")
