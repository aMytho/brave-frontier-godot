extends Control

signal Closed

@export var dungeon: Dungeon:
	set(new_dungeon):
		set_level(new_dungeon)
		dungeon = new_dungeon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_level(dun: Dungeon):
	for zone in dun.zones:
		var selectable_level = ResourceLoader.load("res://Area/UI/level.tscn").instantiate()
		selectable_level.setProperties(zone)
		selectable_level.Clicked.connect(loadLevel)
		get_child(0).get_child(0).add_child(selectable_level)

func loadLevel(zn: Zone):
	print("Loading level")
	# Get the first team and its corresponding units. TO DO - Let user select/make teams
	var units: Array = Database.query(
		"SELECT units.* FROM units JOIN team ON units.id = team.unit1 OR units.id = team.unit2 OR units.id = team.unit3 OR units.id = team.unit4 OR units.id = team.unit5 WHERE team.id = 2 ORDER BY CASE units.id WHEN team.unit1 THEN 1 WHEN team.unit2 THEN 2 WHEN team.unit3 THEN 3 WHEN team.unit4 THEN 4 WHEN team.unit5 THEN 5 END;"
		)

	# Add units to the list
	var battle_units: Array[Unit] = []
	if len(units) > 0:
		for unit in units:
			print(unit)
			if unit != null:
				battle_units.append(load(str("res://Units/Res/", unit.unit_id, "/", unit.unit_id, ".tres")))
	# If a user doesn't have full team, replace with null
	while len(battle_units) < 6:
		battle_units.append(null)
	print(battle_units)
	
	# Get the stage and load the battle!
	var arg_names = ["units", "zone"]
	var arg_props = [battle_units, zn]
	emit_signal("Closed")
	get_tree().get_root().get_node("Game/GameContent").loadSceneWithProps("res://Battle/battle.tscn", arg_names, arg_props, true )

func _on_home_button_pressed():
	print("Home")
	get_tree().get_root().get_node("Game/GameContent").loadScene("res://Menu/main_menu.tscn", false)

func _on_back_button_pressed():
	emit_signal("Closed")
	self.queue_free()
