extends Node2D

@export var zone: Zone:
	set(new_zone):
		zone = new_zone
		$BG.texture = zone.BG

@export_category("Dev Info")
@export var current_stage: int = 0
# A mock value for progressing turns. DEV ONLY -- replace once battle system is done
@export var temp_counter: int = 0
@export_range(0.1, 1.0)
var speed: float = 1.0:
	set(new_speed):
		speed = new_speed
		$Friendlies.set_speed(new_speed)
		$Enemies.set_speed(new_speed)
@export var units: Array[Unit] = [null, null, null, null, null, null]

@export_category("Turn Logic")
@export var player_turn = true
@export var enemy_turn = false
@export var units_attacked: int = 0
@export var enemies_attacked: int = 0
@export var total_enemies: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the music
	$BattleOST.stream = zone.music
	$BattleOST.play()
	
	# Set the transition values
	$Transition.set_properties(1, zone.Stage.size(), "Stylish Placeholder", zone.name)
	
	# Pass in the friendly units
	$BattleUI.units = units
	
	# Connect attack buttons
	$BattleUI/Unit1.Attack.connect(_unit_attack)
	$BattleUI/Unit2.Attack.connect(_unit_attack)
	$BattleUI/Unit3.Attack.connect(_unit_attack)
	$BattleUI/Unit4.Attack.connect(_unit_attack)
	$BattleUI/Unit5.Attack.connect(_unit_attack)
	$BattleUI/Unit6.Attack.connect(_unit_attack)
	
	# Get the friendly node
	var freindly_units = $Friendlies
	# Display each unit on the field and start idle animations
	for i in range(freindly_units.get_child_count()):
		# Ensure the unit exists
		if i < units.size() and units[i] != null:
			var child_node = freindly_units.get_child(i)
			child_node.set_properties(units[i].sprite_sheet, false)
	# Setup the environment
	load_next_stage(0)

func _unit_attack(unit_place: int):
	# Play attack animation, listen for anim end
	get_node(str("./Friendlies/Unit", unit_place)).attack($Enemies.get_target_position())
	get_node(str("./Friendlies/Unit", unit_place)).connect("AttackFinished", _unit_attack_finished)

func _unit_attack_finished(unit_place: int):
	# Disconnect the signal
	get_node(str("./Friendlies/Unit", unit_place)).disconnect("AttackFinished", _unit_attack_finished)
	# Check if the turn is over
	units_attacked = units_attacked + 1
	check_if_player_turn_complete()

func check_if_player_turn_complete():
	# If the player has had all units attack, end turn
	if units_attacked == get_unit_count():
		print("Ready for enemy turn")
		player_turn = false
		enemy_turn = true
		units_attacked = 0
		
		# Dev only. This allows us to progress after 3 attacks
		# When the battle system is done, this will need to be changed
		if temp_counter == 3:
			move_to_next_stage()
			temp_counter = 0
		else:
			temp_counter = temp_counter + 1
			run_enemy_turn()

func run_enemy_turn():
	print("Enemy turn!")
	for enemy in $Enemies.get_children():
		# Only play animation for units that exist
		if enemy.is_unit:
			enemy.attack($Friendlies.get_random_target())
			enemy.connect("AttackFinished", _enemy_attack_finished)

func _enemy_attack_finished(unit_place: int):
	# Disconnect the signal
	get_node(str("./Enemies/Unit", unit_place)).disconnect("AttackFinished", _enemy_attack_finished)
	# Check if the turn is over
	enemies_attacked = enemies_attacked + 1
	if (enemies_attacked == total_enemies):
		print("Enemy turn over")
		enemy_turn = false
		player_turn = true
		enemies_attacked = 0
		$BattleUI.release_attack_lockout()

func load_next_stage(stage: int):
	print("Next stage")
	var counter = 0
	total_enemies = 0
	var enemy_units = $Enemies
	enemy_units.clear_units()
	for unit in zone.Stage[stage].monsters:
		print(unit)
		total_enemies = total_enemies + 1
		# Add enemy to field, start idle animation
		var child_node = enemy_units.get_child(counter)
		child_node.set_properties(unit.sprite_sheet, true)
		
		counter = counter + 1
	current_stage = current_stage + 1

func get_unit_count():
	# returns how many non null units exist (down or active)
	var counter = 0 
	for unit in units:
		if unit != null:
			counter = counter + 1
	return counter

func move_to_next_stage():
	# Check for next stage
	if current_stage < zone.Stage.size():
		print("Moving to next stage")
		$Transition.show_transition()
		load_next_stage(current_stage)
	else:
		print("Battle Complete!!!")


func _on_transition_hide():
	# Now that they can see, allow the player to attack.
	# All enemy units have now spawned in
	$BattleUI.release_attack_lockout()


func _on_transition_show():
	# Show the stage in the transition
	$Transition.update_properties(current_stage)
	# Wait a few seconds, then return to combat
	await get_tree().create_timer(3.0).timeout
	$Transition.hide_transition()
