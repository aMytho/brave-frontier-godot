extends Control

# Array of units that are on display. It is the unit type, but the godot bug prevents it -___-
@export var units: Array[Unit] = []
@export var teams: Array = []
@export var current_team: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# Get all the teams for the user
	teams = Database.query("SELECT * FROM teams WHERE account_id = %s" % ActiveAccount.id)
	
	# Create a toggle for each team
	for team in teams:
		var icn = ResourceLoader.load("res://Common/UI/Toggles/content_toggle_button.tscn").instantiate()
		$ScrollContainer/TeamSelctionContainer.add_child(icn)
	
	set_team_info(current_team)

func set_team_info(team_id: int):
	# Load the first team
	$SquadContainer/SquadName.text = teams[team_id].name
	
	# Get each unit in the team based on their id, provided that the unit exists
	var possible_units: Array = []
	if teams[team_id].unit1 != null:
		possible_units.append(Lookups.get_unit_by_ID(teams[team_id].unit1))
	if teams[team_id].unit2 != null:
		possible_units.append(Lookups.get_unit_by_ID(teams[team_id].unit2))
	if teams[team_id].unit3 != null:
		possible_units.append(Lookups.get_unit_by_ID(teams[team_id].unit3))
	if teams[team_id].unit4 != null:
		possible_units.append(Lookups.get_unit_by_ID(teams[team_id].unit4))
	if teams[team_id].unit5 != null:
		possible_units.append(Lookups.get_unit_by_ID(teams[team_id].unit5))
	
	# Clear the current team and set the new units
	units = []
	var counter = 0
	while counter < possible_units.size():
		if possible_units[counter].valid == true:
			# A unit exists in this slot
			units.insert(counter, possible_units[counter].unit)
		else:
			units.insert(counter, null)
		counter = counter + 1
	
	# Display the units
	counter = 0
	while counter < units.size():
		if units[counter] != null:
			get_node("UnitTable%s" % str(counter + 1)).set_properties(units[counter])
		counter = counter + 1
	
	# Set the max cost (TO DO - lookup max cost per level)
	$Cost/Label.text = str(get_squad_cost(), " / ", "40")
	$ScrollContainer/TeamSelctionContainer.get_child(team_id).turn_on()
	current_team = team_id


func get_squad_cost():
	var total: int = 0
	for unit in units:
		if unit != null:
			total = total + unit.cost
	return total

func _on_back_section_clicked():
	get_parent().load_scene_home("res://Menu/SubMenu/Unit/unit_menu.tscn")


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
