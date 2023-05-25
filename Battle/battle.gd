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
	$stats_checking.UnitHasDied.connect(_when_unit_has_died)
	$stats_checking.FriendlyUnitHasTakenDamage.connect(_unit_UI_update)
	$Enemies.UpdateTarget.connect(_update_enemy_s_data)
	
	# Get the friendly node
	var freindly_units = $Friendlies
	# Display each unit on the field and start idle animations
	for i in range(freindly_units.get_child_count()):
		# Ensure the unit exists
		if i < units.size() and units[i] != null:
			units[i].max_HP = units[i].HP
			var child_node = freindly_units.get_child(i)
			child_node.set_properties(
				units[i].sprite_sheet, false, units[i].char_equipment, units[i].atk_equipment)
	# Setup the environment
	load_next_stage(0)

func battleUIUnitAttackConnect():
	$BattleUI/Unit1.Attack.connect(_unit_attack)
	$BattleUI/Unit2.Attack.connect(_unit_attack)
	$BattleUI/Unit3.Attack.connect(_unit_attack)
	$BattleUI/Unit4.Attack.connect(_unit_attack)
	$BattleUI/Unit5.Attack.connect(_unit_attack)
	$BattleUI/Unit6.Attack.connect(_unit_attack)

# Method trigger when the BattleUI of a friendly unit has been clicked (see res://Battle/UI/unit.gd for more
# In this function, if a unit is not dead and exist, we would call the function attack to active the animation
# We also call a function to lower the HP of the attacked unit
func _unit_attack(unit_place: int):
	# Play attack animation, listen for anim end
	if null != units[unit_place-1] and !units[unit_place-1].is_dead:
		var target = $Enemies.get_target()
		var target_monster = zone.Stage[current_stage-1].monsters[target.place_ID - 1]
		get_node(str("./Friendlies/Unit", unit_place)).attack(target.position)
		$stats_checking.unit_taking_damage(units[unit_place-1], zone.Stage[current_stage-1].monsters[target.place_ID - 1])
		if target_monster == $BattleUI.selected_enemy:
			$BattleUI.set_selected_enemy_health(target_monster)
		get_node(str("./Friendlies/Unit", unit_place)).connect("AttackFinished", _unit_attack_finished)

# Each time a unit end their turn, we increment the number of units attacked
func _unit_attack_finished(unit_place: int):
	# Disconnect the signal
	get_node(str("./Friendlies/Unit", unit_place)).disconnect("AttackFinished", _unit_attack_finished)
	# Check if the turn is over
	units_attacked = units_attacked + 1
	check_if_player_turn_complete()

func _update_enemy_s_data(place_ID: int):
	$BattleUI.set_selected_enemy_health(zone.Stage[current_stage-1].monsters[place_ID-1])

# If all the alive friendly unit has attacked, we end the friendly turn and do a check
### Are all enemies dead ?
### if yes, next stage
### if not, enemy turn start
func check_if_player_turn_complete():
	# If the player has had all units attack, end turn
	if units_attacked == total_allies:
		print("Ready for enemy turn")
		player_turn = false
		enemy_turn = true
		units_attacked = 0
		total_enemies = $stats_checking.are_units_dead(zone.Stage[current_stage-1].monsters)
		# Dev only. This allows us to progress after 3 attacks
		# When the battle system is done, this will need to be changed
		if 0 == total_enemies:
			move_to_next_stage()
			temp_counter = 0
		else:
			temp_counter = temp_counter + 1
			run_enemy_turn()

# Allow the enemy's unit to do a turn
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
			$stats_checking.unit_taking_damage(monstersArray[enemy_count], units[unitToHurt.place_ID-1], true)
			enemy.connect("AttackFinished", _enemy_attack_finished)
		enemy_count = enemy_count + 1

# When trigger, see if all alive enemies have made a move and will trigger the next friendly unit round or end the level
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
		total_allies = $stats_checking.are_units_dead(units, true)
		if 0 == total_allies:
			print("Battle lost . . .")
			_when_battle_end()
		else:
			$BattleUI.release_attack_lockout()

# Set all props of the scene and reset some data (Enemies side in principal)
func load_next_stage(stage: int):
	print("Next stage")
	var counter = 0
	total_enemies = 0
	var enemy_units = $Enemies
	enemy_units.clear_units()
	resetUnitsStats()
	for unit in zone.Stage[stage].monsters:
		if null != unit:
			unit.max_HP = unit.HP
			if 0 == total_enemies:
				$BattleUI.set_selected_enemy_health(unit)
			# Add enemy to field, start idle animation
			var child_node = enemy_units.get_child(counter)
			child_node.set_properties(unit.sprite_sheet, true, unit.char_equipment, unit.atk_equipment)
			total_enemies = total_enemies + 1
			
		counter = counter + 1
	current_stage = current_stage + 1

func get_unit_count():
	# returns how many non null units exist (down or active)
	var counter = 0 
	for unit in units:
		if unit != null:
			counter = counter + 1
	return counter

# When triggered, we would move to the next stage of the level or make the end complete
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
	
# This function were added when in development.
# It would allow the unit to revive and so we should have every unit each round
### Maybe this is a useless function
func resetUnitsStats():
	total_allies = 0
	for unit in units:
		if unit != null and !unit.is_dead:
			total_allies = total_allies + 1
			
# Function who's trigger when the signal "unitHasDied" has been emited
# It will do some update like
### Hide the sprite of a unit
### Make the unit considered DEAD
func _when_unit_has_died(place_ID: int, is_ally: bool = false):
	print("signal the Unit %s has died" % place_ID)
	var team_unit = "Enemies" if !is_ally else "Friendlies"
	var dead_unit = get_node(str("./", team_unit, "/Unit", place_ID))
	if is_ally:
		var dead_unit_UI = get_node(str("./BattleUI/Unit", place_ID))
		dead_unit_UI.unitHasDied()
	else:
		var monsterUnits = zone.Stage[current_stage-1].monsters
		var new_UI_unit_update = get_next_non_dead_unit(monsterUnits)
		if null != new_UI_unit_update and monsterUnits[place_ID -1] == $BattleUI.selected_enemy:
			$BattleUI.set_selected_enemy_health(new_UI_unit_update)
		if place_ID == $Enemies.current_target:
			$Enemies.current_target = -1
	dead_unit.hide()
	dead_unit.is_dead = true


func get_next_non_dead_unit(units: Array[Unit]):
	for unit in units:
		if null != unit and !unit.is_dead:
			return unit
	return null

# Method call when the battle has ended
# It can be a victory or a loose
func _when_battle_end():
	print(get_parent())
	get_parent().loadScene("res://Menu/main_menu.tscn", true)
	
func _unit_UI_update(unit: Resource):
	print("update unit UI HP")
	var place_ID = units.find(unit, 0) + 1
	get_node(str("./BattleUI/Unit", place_ID)).update_HP_container(unit.HP)
