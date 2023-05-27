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
	set_damaging_signal()
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
				units[i], false, units[i].char_equipment,
				units[i].atk_equipment, units[i].travel_equipment)
	# Setup the environment
	load_next_stage(0)

func set_damaging_signal():
	for enemy in $Enemies.get_children():
		enemy.DamagingEnemy.connect(_damaging_targeted_unit)
	for friend in $Friendlies.get_children():
		friend.DamagingEnemy.connect(_damaging_targeted_unit)

func battleUIUnitAttackConnect():
	$BattleUI/Unit1.Attack.connect(_unit_attack)
	$BattleUI/Unit2.Attack.connect(_unit_attack)
	$BattleUI/Unit3.Attack.connect(_unit_attack)
	$BattleUI/Unit4.Attack.connect(_unit_attack)
	$BattleUI/Unit5.Attack.connect(_unit_attack)
	$BattleUI/Unit6.Attack.connect(_unit_attack)

# Called when the signal DamagingEnemy from field_unit is trigger
# Will get all the data needed to do the damage calculation and update
func _damaging_targeted_unit(damaging_unit_id: int, hurt_unit_id: int, quantity_of_damage: int):
	var monsters_list = zone.Stage[current_stage - 1].monsters	
	var damaging_field_unit
	var damaging_unit
	var hurt_field_unit
	var hurt_unit
	var friend_is_hurt
	var percent_of_damage = quantity_of_damage / 100.0
	
	if player_turn:
		damaging_field_unit = get_node(str("./Friendlies/Unit", damaging_unit_id))
		damaging_unit = units[damaging_unit_id - 1]
		hurt_field_unit = get_node(str("./Enemies/Unit", hurt_unit_id))
		hurt_unit = monsters_list[hurt_unit_id - 1]
		friend_is_hurt = false
	else:
		damaging_field_unit = get_node(str("./Enemies/Unit", damaging_unit_id))
		damaging_unit = monsters_list[damaging_unit_id - 1]
		hurt_field_unit = get_node(str("./Friendlies/Unit", hurt_unit_id))
		hurt_unit = units[hurt_unit_id - 1]
		print(hurt_field_unit)
		friend_is_hurt = true
	
	$stats_checking.unit_taking_damage(damaging_unit.ATK * percent_of_damage, hurt_unit, friend_is_hurt)
	if hurt_unit == $BattleUI.selected_enemy:
		$BattleUI.set_selected_enemy_health(hurt_unit)

# Method trigger when the BattleUI of a friendly unit has been clicked (see res://Battle/UI/unit.gd for more
# In this function, if a unit is not dead and exist, we would call the function attack to active the animation
# We also call a function to lower the HP of the attacked unit
func _unit_attack(unit_place: int):
	# Play attack animation, listen for anim end
	if null != units[unit_place-1] and !units[unit_place-1].is_dead:
		var target = $Enemies.get_target()
		var attaking_unit = get_node(str("./Friendlies/Unit", unit_place))
		var target_monster = zone.Stage[current_stage-1].monsters[target.place_ID - 1]
		target.time_being_targeted += 1
		attaking_unit.targeted_place_ID = target.place_ID
		attaking_unit.attack(target.position)
		attaking_unit.connect("AttackFinished", _unit_attack_finished)

# Each time a unit end their turn, we increment the number of units attacked
func _unit_attack_finished(unit_place: int):
	# Disconnect the signal
	var friend_unit = get_node(str("./Friendlies/Unit", unit_place))
	friend_unit.disconnect("AttackFinished", _unit_attack_finished)
	# Check if the turn is over
	units_attacked = units_attacked + 1
	check_if_unit_is_dead(friend_unit, true)
	check_if_player_turn_complete()

# Once the unit attack has ended, this method is called to see if the hurt unit is dead or not
func check_if_unit_is_dead(unit, is_friendly_attacking: bool = false):
	print("Is the unit dead ?")
	var hurted_unit_place_ID = unit.targeted_place_ID
	var hurted_field_unit = get_node(str("./Enemies/Unit", hurted_unit_place_ID)) if is_friendly_attacking else get_node(str("./Friendlies/Unit", hurted_unit_place_ID))
	var hurted_unit = zone.Stage[current_stage - 1].monsters[hurted_unit_place_ID - 1] if is_friendly_attacking else units[hurted_unit_place_ID - 1]
	
	unit.targeted_place_ID = 0
	hurted_field_unit.time_being_targeted -= 1
	if 0 >= hurted_unit.HP and 0 >= hurted_field_unit.time_being_targeted:
		when_unit_has_died(hurted_unit_place_ID, !is_friendly_attacking)

func _update_enemy_s_data(place_ID: int):
	$BattleUI.set_selected_enemy_health(zone.Stage[current_stage-1].monsters[place_ID-1])

# If all the alive friendly unit has attacked, we end the friendly turn and do a check
### Are all enemies dead ?
### if yes, next stage
### if not, enemy turn start
func check_if_player_turn_complete():
	# If the player has had all units attack, end turn
	var enemy_unit_left = $stats_checking.are_all_units_dead(zone.Stage[current_stage-1].monsters, $Enemies.get_children())
	if units_attacked == total_allies or 0 == enemy_unit_left:
		print("Ready for enemy turn")
		player_turn = false
		enemy_turn = true
		units_attacked = 0
		# Dev only. This allows us to progress after 3 attacks
		# When the battle system is done, this will need to be changed
		if 0 == enemy_unit_left:
			move_to_next_stage()
			temp_counter = 0
		else:
			temp_counter = temp_counter + 1
			run_enemy_turn()

# Allow the enemy's unit to do a turn
func run_enemy_turn():
	print("Enemy turn!")
	print($Friendlies.get_children())
	print($Enemies.get_children())
	var enemy_count = 0
	for enemy in $Enemies.get_children():
		# Only play animation for units that exist
		var monstersArray = zone.Stage[current_stage-1].monsters
		if enemy.is_unit and !monstersArray[enemy_count].is_dead:
			var unit_to_hurt = $Friendlies.get_random_target()
			unit_to_hurt.time_being_targeted += 1
			print(unit_to_hurt.time_being_targeted)
			enemy.targeted_place_ID = unit_to_hurt.place_ID
			enemy.attack(unit_to_hurt.position)
			enemy.connect("AttackFinished", _enemy_attack_finished)
		enemy_count = enemy_count + 1

# When trigger, see if all alive enemies have made a move and will trigger the next friendly unit round or end the level
func _enemy_attack_finished(unit_place: int):
	# Disconnect the signal
	var attacking_unit = get_node(str("./Enemies/Unit", unit_place))
	attacking_unit.disconnect("AttackFinished", _enemy_attack_finished)
	check_if_unit_is_dead(attacking_unit)
	# Check if the turn is over
	enemies_attacked = enemies_attacked + 1
	print(total_enemies)
	if (enemies_attacked == total_enemies):
		print("Enemy turn over")
		enemy_turn = false
		player_turn = true
		enemies_attacked = 0
		total_allies = $stats_checking.are_all_units_dead(units, $Friendlies.get_children())
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
	player_turn = true
	enemy_turn = false
	enemy_units.clear_units()
	resetUnitsStats()
	for unit in zone.Stage[stage].monsters:
		if null != unit:
			unit.max_HP = unit.HP
			if 0 == total_enemies:
				$BattleUI.set_selected_enemy_health(unit)
			# Add enemy to field, start idle animation
			var child_node = enemy_units.get_child(counter)
			child_node.set_properties(unit, true,
				unit.char_equipment, unit.atk_equipment, unit.travel_equipment)
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
	units_attacked = 0
	total_allies = 0
	for unit in units:
		if unit != null and !unit.is_dead:
			total_allies = total_allies + 1
			
# Function who's trigger when the signal "unitHasDied" has been emited
# It will do some update like
### Hide the sprite of a unit
### Make the unit considered DEAD
func when_unit_has_died(place_ID: int, is_ally: bool = false):
	var team_unit = "Enemies" if !is_ally else "Friendlies"
	print("signal the %s Unit %s has died" % [team_unit, place_ID])
	var dead_unit = get_node(str("./", team_unit, "/Unit", place_ID))
	dead_unit.is_dead = true
	if is_ally:
		var dead_unit_UI = get_node(str("./BattleUI/Unit", place_ID))
		dead_unit_UI.unitHasDied()
		units[place_ID - 1].is_dead = true
	else:
		var monsters_units = zone.Stage[current_stage-1].monsters
		var new_UI_unit_update = get_next_non_dead_unit(monsters_units)
		monsters_units[place_ID - 1].is_dead = true
		if null != new_UI_unit_update and monsters_units[place_ID -1] == $BattleUI.selected_enemy:
			$BattleUI.set_selected_enemy_health(new_UI_unit_update)
		if place_ID == $Enemies.current_target:
			$Enemies.current_target = -1
		total_enemies -= 1
	dead_unit.hide()
	dead_unit.is_dead = true


func get_next_non_dead_unit(current_units: Array[Unit]):
	for unit in current_units:
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
