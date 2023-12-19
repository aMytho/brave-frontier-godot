extends Control

# The currant table that is selected. Used for replacing units
@export var current_table: int = 0
# Array of units that are on display. It is the unit type, but the godot bug prevents it -___-
@export var units: Array[Unit] = [null, null, null, null, null]
@export var teams = []
@export var current_team: int = 0
# Flags for changing the leader or moving a unit
@export var is_changing_leader: bool = false
@export var is_changing_unit: bool = false
# Holds positions of units for swapping positions
@export var unit_position = {
	"old": null,
	"new": null
}


# Called when the node enters the scene tree for the first time.
func _ready():
	# Get all the teams for the user
	teams = Database.query("SELECT * FROM teams WHERE account_id = %s" % ActiveAccount.id)
	
	# Create a toggle for each team
	for team in teams:
		var icn = ResourceLoader.load("res://Common/UI/Toggles/content_toggle_button.tscn").instantiate()
		$ScrollContainer/TeamSelctionContainer.add_child(icn)
	
	# Load the first team
	set_team_info(current_team)
	
	# Load the unit selection scene and listen for events
	$UnitSelectBG/content_switcher.load_scene_with_props("res://Menu/SubMenu/Unit/Display/view_units.tscn", 0, ["use_signals", "remove_button"], [true, true])
	$UnitSelectBG/content_switcher.get_scene().connect("BackPressed", _on_unit_select_back_section)
	$UnitSelectBG/content_switcher.get_scene().connect("UnitSelected", _on_unit_select_unit_selected)
	$UnitSelectBG/content_switcher.get_scene().connect("RemoveUnitPressed",_on_remove_unit)


func set_team_info(team_id: int):
	# Set the name
	$SquadContainer/SquadName.text = teams[team_id].name
	
	# Get each unit in the team based on their id, provided that the unit exists
	var possible_units: Array = [
		Lookups.get_unit_by_ID(unit_not_null(teams[team_id].unit1)),
		Lookups.get_unit_by_ID(unit_not_null(teams[team_id].unit2)),
		Lookups.get_unit_by_ID(unit_not_null(teams[team_id].unit3)),
		Lookups.get_unit_by_ID(unit_not_null(teams[team_id].unit4)),
		Lookups.get_unit_by_ID(unit_not_null(teams[team_id].unit5))
	]
	
	# Clear the current team and set the new units
	units = []
	var counter = 0
	while counter < 5:
		if possible_units[counter].valid == true:
			# A unit exists in this slot
			units.insert(counter, possible_units[counter].unit)
		else:
			units.insert(counter, null)
		counter = counter + 1
	
	# Display the units
	counter = 0
	while counter < 5:
		if counter < units.size() and units[counter] != null:
			get_node("UnitTable%s" % str(counter + 1)).set_properties(units[counter])
		else:
			get_node("UnitTable%s" % str(counter + 1)).reset_properties()
		counter = counter + 1
	# Clear the past leader
	get_node("UnitTable1").is_leader = false
	get_node("UnitTable2").is_leader = false
	get_node("UnitTable3").is_leader = false
	get_node("UnitTable4").is_leader = false
	get_node("UnitTable5").is_leader = false
	# Set the new leader if one exists
	if teams[team_id].leader != null:
		get_node("UnitTable%s" % teams[team_id].leader).is_leader = true
	
	# Set the max cost (TO DO - lookup max cost per level)
	$Cost/Label.text = str(get_squad_cost(), " / ", "40")
	$ScrollContainer/TeamSelctionContainer.get_child(team_id).turn_on()
	current_team = team_id


func get_squad_cost():
	# Returns the current cost of the squad
	var total: int = 0
	for unit in units:
		if unit != null:
			total = total + unit.cost
	return total


func _on_select_last_team_clicked():
	# Switch to the last team
	if current_team - 1 >= 0 and current_team - 1 < teams.size():
		# Deactivate old btn
		$ScrollContainer/TeamSelctionContainer.get_child(current_team).turn_off()
		# Switch team
		set_team_info(current_team - 1)


func _on_select_next_team_clicked():
	# Switch to the next team
	if current_team + 1 < teams.size():
		# Deactivate old btn
		$ScrollContainer/TeamSelctionContainer.get_child(current_team).turn_off()
		# Switch team
		set_team_info(current_team + 1)


func _on_unit_table_selected(place_id):
	if is_changing_leader:
		# Set a new leader
		Database.query("UPDATE teams SET leader = %s WHERE id = %s" % [place_id, teams[current_team].id])
		print("Set new leader")
		# Prevent future changes
		is_changing_leader = false
		# Get new team from DB
		var team_id = teams[current_team].id
		teams.remove_at(current_team)
		teams.insert(current_team, Database.query("SELECT * from TEAMS where id = %s" % team_id)[0])
		set_team_info(current_team)
		# End the selection
		is_changing_leader = false
		undim_ui()
	elif is_changing_unit:
		if unit_position.old == null:
			# pick a unit to move
			unit_position.old = place_id - 1
		else:
			unit_position.new = place_id - 1
			# Move the unit
			var is_switch = units[unit_position.new] == null

			# Save the revelant positions and unit IDs. Move them in our local array
			var old_unit_id = teams[current_team]["unit%s" % (unit_position.old + 1)]
			var new_unit_id = teams[current_team]["unit%s" % (unit_position.new + 1)]
			units[unit_position.new] = units[unit_position.old]
			units[unit_position.old] = null

			# Switch or move the unit in the DB
			if is_switch:
				Database.query(
						"UPDATE teams SET unit%s = %s, unit%s = null WHERE id = %s"
						% [place_id, old_unit_id, unit_position.old + 1, teams[current_team].id])
			else:
				Database.query(
						"UPDATE teams SET unit%s = %s, unit%s = %s WHERE id = %s"
						% [place_id, old_unit_id, unit_position.old + 1, new_unit_id, teams[current_team].id])

			print("Moved/Switched a unit/s")
			# Reload the UI
			unit_position = {"new": null, "old": null}
			is_changing_unit = false
			undim_ui()
			teams = Database.query("SELECT * FROM teams WHERE account_id = %s" % ActiveAccount.id)
			set_team_info(current_team)
	else:
		# Load a new unit
		$UnitSelectBG.visible = true
		current_table = place_id


func _on_change_clicked(id):
	# Check if a button is already selected. If so, unfim the UI and cancel changes
	if is_changing_leader or is_changing_unit:
		is_changing_leader = false
		is_changing_unit = false
		undim_ui()
		return
	
	# Based on the id, choose a new leader or move a unit
	if id == 1:
		print("Player is changing their leader")
		is_changing_leader = true
		is_changing_unit = false
		dim_ui()
	else:
		print("Player is changing their unit's positions")
		is_changing_leader = false
		is_changing_unit = true
		dim_ui()
	# Reset the unit position
	unit_position = {"new": null, "old": null}


func dim_ui():
	# Put the visual focus on the tables
	$ColorRect.material.blend_mode = CanvasItemMaterial.BLEND_MODE_MUL
	$ColorRect.visible = true


func undim_ui():
	# Return to normal focus
	$ColorRect.material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
	$ColorRect.visible = false


func unit_not_null(possible_unit):
	if possible_unit == null:
		return -1
	else:
		return possible_unit


func _on_back_section_clicked():
	get_parent().load_scene("res://Menu/SubMenu/Unit/unit_menu.tscn", 0)


func _on_unit_select_back_section():
	# Menu closed without choosing a unit, hide it
	$UnitSelectBG.visible = false


func _on_unit_select_unit_selected(id: int):
	# A unit was chosen
	$UnitSelectBG.visible = false
	
	# Check that the unit isn't already in the team
	var is_duplicate = false
	var counter: int = 0
	var old_place: int = 0
	for unit in units:
		if unit != null and unit.id == id:
			print("Unit is already in the party.")
			is_duplicate = true
			old_place = counter
			break
		counter = counter + 1
	
	# Load the new unit
	if !is_duplicate:
		# Modify the DB
		Database.query(
				"UPDATE teams SET unit%s = %s WHERE id = %s"
				% [current_table, id, teams[current_team].id])
	else:
		# Swap the unit
		Database.query(
				"UPDATE teams SET unit%s = %s, unit%s = null WHERE id = %s"
				% [current_table, id, old_place + 1, teams[current_team].id])
	# Update the teams and units
	teams = Database.query("SELECT * FROM teams WHERE account_id = %s" % ActiveAccount.id)
	print("Unir swapped/added to the team")
	set_team_info(current_team)


func _on_remove_unit():
	# Remove the selected unit
	print("Removing a unit")
	Database.query(
			"UPDATE teams SET unit%s = null WHERE id = %s"
			% [current_table, teams[current_team].id])
	# Update the teams and units
	teams = Database.query("SELECT * FROM teams WHERE account_id = %s" % ActiveAccount.id)
	set_team_info(current_team)
	$UnitSelectBG.visible = false
