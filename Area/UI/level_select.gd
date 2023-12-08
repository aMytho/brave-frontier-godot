extends Control

signal Closed

@export var dungeon: Dungeon:
	set(new_dungeon):
		display_zones(new_dungeon)
		dungeon = new_dungeon
@export var zone: Zone

@onready var container = $content_switcher

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func display_zones(dun: Dungeon):
	$content_switcher._set_blank_scene()
	# Display the level scene in the switcher
	$content_switcher.load_scene("res://Area/UI/LevelPrep/level_scrollable.tscn", 1, Vector2(10, 0))
	# Display the levels
	$content_switcher.get_scene().set_level(dun)
	# When a level is selected, load the teams page
	$content_switcher.get_scene().ZoneSelected.connect(loadLevel)

func loadLevel(zn: Zone):
	print("Zone Selected!")
	zone = zn
	
	var acc = ActiveAccount.get_account_info()
	# Get account teams
	var teams: Array = Database.query("SELECT * FROM teams WHERE account_id = %s" % acc[0])
	print(teams)
	
	# Load team selector
	$content_switcher.load_scene("res://Area/UI/LevelPrep/team_selector.tscn", 1)
	# Send it the teams
	$content_switcher.get_scene().set_team_info(teams)
	# Listen for PlayerReady signal
	$content_switcher.get_scene().PlayerReady.connect(_on_player_ready)

func _on_home_button_pressed():
	print("Home")
	get_tree().get_root().get_node("Game/GameContent").loadScene("res://Menu/main_menu.tscn", false)

func _on_back_button_pressed():
	emit_signal("Closed")
	self.queue_free()

func _on_player_ready(units):
	# Stop the music
	get_tree().root.get_node("Game").get_child(0).emit_signal("stopPlaying")
	# Get the stage and load the battle!
	var arg_names = ["units", "zone"]
	
	for stage in zone.stage:
		var enemies_list: Array[Unit] = []
		for unit in stage.monsters:
			if null != unit:
				enemies_list.append(Lookups.get_unit_by_unit_number(unit.unit_number)["unit"])
			else:
				enemies_list.append(null)
		stage.monsters = enemies_list
	
	# Remove energy from player
	ActiveAccount.energy = ActiveAccount.energy - zone.energy
	
	var arg_props = [units, zone]
	emit_signal("Closed")
	get_tree().get_root().get_node("Game/GameContent").loadSceneWithProps("res://Area/Zones/zone.tscn", arg_names, arg_props, true )
