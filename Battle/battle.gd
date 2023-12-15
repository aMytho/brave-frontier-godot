extends Node2D

signal BattleFinished(is_victory: bool)

## Util functions
@onready var util = $util

@export var zone: Zone:
	set(new_zone):
		zone = new_zone
		$BG.texture = zone.BG

@export_category("Dev Info")
@export var current_stage: int = 0
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
	# Set the transition values (current stage, total stages, area, dungeon 
	$Transition.set_properties(1, zone.stage.size(), "Stylish Placeholder", zone.name)
	
	# Pass in the friendly units
	$BattleUI.units = units
	
	# Add signals
	listen_for_unit_atk()
	listen_for_damage()
	$stats_checking.FriendlyUnitHasTakenDamage.connect(_unit_UI_update)
	$Enemies.UpdateTarget.connect(_update_enemy_s_data)
	
	# Get the friendly node
	var friendly_units = $Friendlies
	# Display each unit on the field and start idle animations
	for i in range(friendly_units.get_child_count()):
		# Ensure the unit slot is filled
		if i < units.size() and units[i] != null:
			units[i].max_HP = units[i].HP
			# Add unit to field and don't flip the sprite (allies face left)
			friendly_units.get_child(i).set_properties(units[i], false)
		
	# Setup the environment
	load_next_stage(0)


func listen_for_unit_atk():
	$BattleUI/Unit1.Attack.connect(_unit_attack)
	$BattleUI/Unit2.Attack.connect(_unit_attack)
	$BattleUI/Unit3.Attack.connect(_unit_attack)
	$BattleUI/Unit4.Attack.connect(_unit_attack)
	$BattleUI/Unit5.Attack.connect(_unit_attack)
	$BattleUI/Unit6.Attack.connect(_unit_attack)


func listen_for_damage():
	for enemy in $Enemies.get_children():
		enemy.DamagingEnemy.connect(_damaging_targeted_unit)
	for friend in $Friendlies.get_children():
		friend.DamagingEnemy.connect(_damaging_targeted_unit)


# Called when the signal DamagingEnemy from field_unit is trigger
# Will get all the data needed to do the damage calculation and update
func _damaging_targeted_unit(damaging_unit_id: int, hurt_unit_id: int, quantity_of_damage: int):
	var monsters_list = zone.stage[current_stage - 1].monsters
	var percent_of_damage = quantity_of_damage / 100.0
	var damaging_unit
	var hurt_unit
	var friend_is_hurt
	
	if player_turn:
		damaging_unit = units[damaging_unit_id - 1]
		hurt_unit = monsters_list[hurt_unit_id - 1]
		friend_is_hurt = false
	else:
		damaging_unit = monsters_list[damaging_unit_id - 1]
		hurt_unit = units[hurt_unit_id - 1]
		friend_is_hurt = true
	
	$stats_checking.unit_taking_damage(damaging_unit.ATK * percent_of_damage, hurt_unit, friend_is_hurt)
	if hurt_unit == $BattleUI.selected_enemy:
		$BattleUI.set_selected_enemy_health(hurt_unit)


# Method runs when friendly unit (BattleUI) has been clicked
func _unit_attack(unit_place: int):
	# Check that the unit slot is filled and that the unit isn't dead
	if units[unit_place-1] != null and !units[unit_place-1].is_dead:
		# Gets a random target or the one specified by usr
		var target = $Enemies.get_target()
		var attaking_unit = get_node(str("./Friendlies/Unit", unit_place))
		target.time_being_targeted += 1
		attaking_unit.targeted_place_ID = target.place_ID
		
		# Play attack animation, listen for anim end
		attaking_unit.attack(target.position)
		attaking_unit.connect("AttackFinished", _unit_attack_finished)


# Each time a unit end their turn, we increment the number of units attacked
func _unit_attack_finished(unit_place: int):
	# Remove attack finished signal
	var friend_unit = get_node(str("./Friendlies/Unit", unit_place))
	friend_unit.disconnect("AttackFinished", _unit_attack_finished)
	# Check if the turn is over
	units_attacked = units_attacked + 1
	if !check_if_unit_is_dead(friend_unit, true):
		# A unit isn't dead, so we need to check if all friendly units have attacked
		check_if_player_turn_complete()


# Once the unit attack has ended, this method is called to see if the hurt unit is dead or not
func check_if_unit_is_dead(unit, is_friendly_attacking: bool):
	var hurted_unit_place_ID = unit.targeted_place_ID
	var hurted_field_unit = get_node(str("./Enemies/Unit", hurted_unit_place_ID)) if is_friendly_attacking else get_node(str("./Friendlies/Unit", hurted_unit_place_ID))
	var hurted_unit = zone.stage[current_stage - 1].monsters[hurted_unit_place_ID - 1] if is_friendly_attacking else units[hurted_unit_place_ID - 1]
	
	unit.targeted_place_ID = 0
	hurted_field_unit.time_being_targeted -= 1
	if 0 >= hurted_unit.HP and 0 >= hurted_field_unit.time_being_targeted:
		when_unit_has_died(hurted_unit_place_ID, !is_friendly_attacking)
		return true
	# The unit is still alive
	return false


func _update_enemy_s_data(place_ID: int):
	$BattleUI.set_selected_enemy_health(zone.stage[current_stage-1].monsters[place_ID-1])


# If all friendly units have attacked, we end the turn
func check_if_player_turn_complete():
	# If the player has had all units attack, end turn
	var enemy_unit_left = $stats_checking.are_all_units_dead(zone.stage[current_stage-1].monsters, $Enemies.get_children())
	if units_attacked == total_allies or enemy_unit_left == 0:
		# End our turn
		player_turn = false
		enemy_turn = true
		units_attacked = 0
		
		# If all enemies are dead, move to the next stage. Else, start enemy turn
		if enemy_unit_left == 0:
			move_to_next_stage()
		else:
			run_enemy_turn()


# Allow the enemy's unit to do a turn
func run_enemy_turn():
	print("Starting enemy turn.")
	var enemy_count = 0
	for enemy in $Enemies.get_children():
		# Only play animation for units that exist
		var monstersArray = zone.stage[current_stage-1].monsters
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
	check_if_unit_is_dead(attacking_unit, false)
	# Check if the turn is over
	enemies_attacked = enemies_attacked + 1
	print("Enemies Attacked: ", enemies_attacked)
	if (enemies_attacked == total_enemies):
		print("Enemy turn over.")
		enemy_turn = false
		player_turn = true
		enemies_attacked = 0
		total_allies = $stats_checking.are_all_units_dead(units, $Friendlies.get_children())
		if 0 == total_allies:
			print("Battle lost . . .")
			_when_battle_end(false)
		else:
			$BattleUI.release_attack_lockout()


# Set all props of the scene and reset some data (Enemies side in principal)
func load_next_stage(stage: int):
	print("Next stage is: ", stage)
	var counter = 0
	total_enemies = 0
	var enemy_units = $Enemies
	player_turn = true
	enemy_turn = false
	enemy_units.clear_units()
	reset_unit_stats()
	
	# Load next stage of monsters
	for unit in zone.stage[stage].monsters:
		if null != unit:
			unit.max_HP = unit.HP
			if 0 == total_enemies:
				$BattleUI.set_selected_enemy_health(unit)
			# Add enemy to field, start idle animation
			var child_node = enemy_units.get_child(counter)
			child_node.set_properties(unit, true)
			total_enemies = total_enemies + 1
			
		counter = counter + 1
	current_stage = current_stage + 1


func get_unit_count():
	# returns how many non null units exist (dead/alive)
	var counter = 0 
	for unit in units:
		if unit != null:
			counter = counter + 1
	return counter


# When triggered, we would move to the next stage of the level or make the end complete
func move_to_next_stage():
	# Check for next stage, if exists, the transition will load the next one
	if current_stage < zone.stage.size():
		print("Moving to next stage")
		$Transition.show_transition()
	else:
		print("Battle Complete!!!")
		_when_battle_end(true)


func _on_transition_hide():
	# Now that they can see, allow the player to attack.
	# All enemy units have now spawned in
	$BattleUI.release_attack_lockout()
	$BattleUI.allow_actions()


func _on_transition_show():
	# Prevent player actions
	$BattleUI.prevent_actions()
	
	# Load the next stage while the field is hidden
	load_next_stage(current_stage)
	# Show the stage in the transition
	$Transition.update_properties(current_stage)
	
	# Wait a few seconds, then return to combat
	await get_tree().create_timer(3.0).timeout
	$Transition.hide_transition()


# Set our attack counter back to 0 and reset total allies counter. It is recalculated in the event of unit deaths this round
func reset_unit_stats():
	units_attacked = 0
	total_allies = 0
	for unit in units:
		if unit != null and !unit.is_dead:
			total_allies = total_allies + 1


# Function who's trigger when the signal "unitHasDied" has been emitted
func when_unit_has_died(place_ID: int, is_ally: bool = false):
	var unit_side = "Enemies" if !is_ally else "Friendlies"
	var dead_unit = get_node(str("./", unit_side, "/Unit", place_ID))
	# Set the unit to a dead state
	dead_unit.is_dead = true
	
	if is_ally:
		# If our unit died, dim their icon in the UI
		var dead_unit_UI = get_node(str("./BattleUI/Unit", place_ID))
		dead_unit_UI.set_unit_dead()
		
		# Make the real unit dead
		units[place_ID - 1].is_dead = true
	else:
		var monsters_units = zone.stage[current_stage-1].monsters
		var new_UI_unit_update = util.get_next_non_dead_unit(monsters_units)
		monsters_units[place_ID - 1].is_dead = true
		if null != new_UI_unit_update and monsters_units[place_ID -1] == $BattleUI.selected_enemy:
			$BattleUI.set_selected_enemy_health(new_UI_unit_update)
		if place_ID == $Enemies.current_target:
			$Enemies.current_target = -1
			dead_unit.remove_target()
		total_enemies -= 1
	# Play the death animation, listen for its completion
	dead_unit.connect("DeathAnimationFinished", _on_death_animation_finished.bind(dead_unit))
	dead_unit.play_death_animation()


func _on_death_animation_finished(_place_id: int, is_friendly: bool, dead_unit):
	if !is_friendly:
		# If the player killed a monster, check if the turn is over after 1 second
		await get_tree().create_timer(1.0).timeout
		check_if_player_turn_complete()
	# Disconnect the signal
	dead_unit.disconnect("DeathAnimationFinished", _on_death_animation_finished)


# Ran when battle is over (win or loss)
func _when_battle_end(is_victory: bool):
	# Load result scene and set its position
	var result = ResourceLoader.load("res://Battle/UI/Result/battle_result.tscn").instantiate()
	result.position = Vector2(4, 200)
	add_child(result)
	
	# Play animation depending on win/loss
	if is_victory:
		result.play_victory()
	else:
		result.play_failure()
	# When animation is complete, emit the signal and wait to be switched to a new scene
	result.connect("ResultComplete", func(): emit_signal("BattleFinished", is_victory))


# Updates the unit HP in battleUI
func _unit_UI_update(unit: Resource):
	var place_ID = units.find(unit, 0) + 1
	get_node(str("./BattleUI/Unit", place_ID)).update_HP_container(unit.HP)
