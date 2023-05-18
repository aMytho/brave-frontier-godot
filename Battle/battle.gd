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
@export var total_allies: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the music
	$BattleOST.stream = zone.music
	$BattleOST.play()
	
	# Set the transition values
	$Transition.set_properties(1, zone.Stage.size(), "Stylish Placeholder", zone.name)
	
	# Pass in the friendly units
	$BattleUI.units = units
	
	battleUIUnitAttackConnect()
	$stats_checking.unitHasDied.connect(_when_unit_has_died)
	
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

func battleUIUnitAttackConnect():
	$BattleUI/Unit1.Attack.connect(_unit_attack)
	$BattleUI/Unit2.Attack.connect(_unit_attack)
	$BattleUI/Unit3.Attack.connect(_unit_attack)
	$BattleUI/Unit4.Attack.connect(_unit_attack)
	$BattleUI/Unit5.Attack.connect(_unit_attack)
	$BattleUI/Unit6.Attack.connect(_unit_attack)

func _unit_attack(unit_place: int):
	# Play attack animation, listen for anim end
	if null != units[unit_place-1] and !units[unit_place-1].is_dead:
		var target = $Enemies.get_target()
		get_node(str("./Friendlies/Unit", unit_place)).attack(target.position)
		$stats_checking.unitTakingDamage(units[unit_place-1], zone.Stage[current_stage-1].monsters[target.place_ID - 1])
		
		get_node(str("./Friendlies/Unit", unit_place)).connect("AttackFinished", _unit_attack_finished)

func _unit_attack_finished(unit_place: int):
	# Disconnect the signal
	get_node(str("./Friendlies/Unit", unit_place)).disconnect("AttackFinished", _unit_attack_finished)
	# Check if the turn is over
	units_attacked = units_attacked + 1
	check_if_player_turn_complete()

func check_if_player_turn_complete():
	# If the player has had all units attack, end turn
	if units_attacked == total_allies:
		print("Ready for enemy turn")
		player_turn = false
		enemy_turn = true
		units_attacked = 0
		total_enemies = $stats_checking.areUnitsDead(zone.Stage[current_stage-1].monsters)
		# Dev only. This allows us to progress after 3 attacks
		# When the battle system is done, this will need to be changed
		if 0 == total_enemies:
			move_to_next_stage()
			temp_counter = 0
		else:
			temp_counter = temp_counter + 1
			run_enemy_turn()

func run_enemy_turn():
	print("Enemy turn!")
	var enemy_count = 0
	for enemy in $Enemies.get_children():
		# Only play animation for units that exist
		var monstersArray = zone.Stage[current_stage-1].monsters
		if enemy.is_unit and !monstersArray[enemy_count].is_dead:
			print(enemy)
			var unitToHurt = $Friendlies.get_random_target()
			enemy.attack(unitToHurt.position)
			$stats_checking.unitTakingDamage(monstersArray[enemy_count], units[unitToHurt.place_ID-1])
			enemy.connect("AttackFinished", _enemy_attack_finished)
		enemy_count = enemy_count + 1

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
		total_allies = $stats_checking.areUnitsDead(units, true)
		if 0 == total_allies:
			print("Battle lost . . .")
			_when_battle_end()
		else:
			$BattleUI.release_attack_lockout()

func load_next_stage(stage: int):
	print("Next stage")
	var counter = 0
	total_enemies = 0
	var enemy_units = $Enemies
	enemy_units.clear_units()
	var enemiesList = []
	resetUnitsStats()
	for unit in zone.Stage[stage].monsters:
		if null != unit:
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
		_when_battle_end()


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
	
func resetUnitsStats():
	total_allies = 0
	for unit in units:
		if unit != null and !unit.is_dead:
			total_allies = total_allies + 1
			#unit.HP = 1000
			
func _when_unit_has_died(place_ID: int, isAlly: bool = false):
	print("signal the Unit %s it has died" % place_ID)
	var teamUnit = "Enemies" if !isAlly else "Friendlies"
	var deadUnit = get_node(str("./", teamUnit, "/Unit", place_ID))
	if isAlly:
		var deadUnitUI = get_node(str("./BattleUI/Unit", place_ID))
		deadUnitUI.unitHasDied()
	else:
		if place_ID == $Enemies.current_target:
			$Enemies.current_target = -1
	deadUnit.hide()

func _when_battle_end():
	print(get_parent())
	get_parent().loadScene("res://Menu/main_menu.tscn", true)
