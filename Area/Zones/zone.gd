extends Control

@export var zone: Zone:
	set(new_zone):
		zone = new_zone
@export var units: Array[Unit]

@onready var music = $ZoneMusic

# Called when the node enters the scene tree for the first time.
func _ready():
	if zone.beginning_cutscene:
		print("Loading cutscene...")
		var dialogue = ResourceLoader.load("res://Area/Dialogue/dialogue.tscn").instantiate()
		dialogue.dialogue = zone.beginning_cutscene
		add_child(dialogue)
		dialogue.connect("Complete", _on_beginning_complete)
		music.fade_control(music.MusicState.START, zone.beginning_cutscene.music)
	else:
		_on_beginning_complete()


func _on_beginning_complete(dialogue:Node = null):
	# Remove dialogue if it exists
	if dialogue:
		remove_child(dialogue)
	
	# Fade music
	music.fade_control(music.MusicState.STOP)
	# Load battle
	var battle = ResourceLoader.load("res://Battle/battle.tscn").instantiate()
	battle.zone = zone
	battle.units = units
	# Play music when the battle is loaded
	battle.ready.connect(music.fade_control.bind(music.MusicState.START, zone.music))
	add_child(battle)
	
	# Listen for stage start
	battle.StageStarted.connect(_on_stage_started)
	# Listen for ending
	battle.BattleFinished.connect(_on_battle_complete)


func _on_battle_complete(is_victory: bool):
	print("Victory: ", is_victory)
	get_node("Battle").queue_free()
	
	# Stop the music
	music.fade_control(music.MusicState.STOP)
	
	# If loss, exit here before rewards and cutscenes
	if is_victory == false:
		get_tree().get_root().get_node("Game/GameContent").loadScene("res://Menu/main_menu.tscn", true)
		return
	
	# If the zone is not complete, make it so
	if not zone.is_complete:
		# Mark the zone as complete
		zone.is_complete = true
		# Save completion to DB
		Database.query(
			"INSERT INTO zones (player_id, zone_id, is_complete) VALUES (%s, %s, 1)"
			% [ActiveAccount.id, zone.id]
		)
	
	# Display a custscene (if any) or go to recap
	if zone.ending_cutscene:
		print("There is an ending cutscene")
		var dialogue = ResourceLoader.load("res://Area/Dialogue/dialogue.tscn").instantiate()
		dialogue.dialogue = zone.ending_cutscene
		add_child(dialogue)
		dialogue.connect("Complete", _on_end_complete)
		music.fade_control(music.MusicState.START, zone.ending_cutscene.music)
	else:
		print("Showing recap view")
		# To-do: Move to content switcher?
		var recap = ResourceLoader.load("res://Battle/Recap/recap.tscn").instantiate()
		recap.zone = zone
		recap.dungeon_name = "Stylish Placeholder"
		add_child(recap)
		recap.connect("RecapComplete", _on_recap_complete)


func _on_end_complete(_dialogue: Node = null):
	print("Dialogue is over, showing recap view")
	
	# Stop the music
	music.fade_control(music.MusicState.STOP)
	
	# To-do: Move to content switcher?
	var recap = ResourceLoader.load("res://Battle/Recap/recap.tscn").instantiate()
	recap.zone = zone
	recap.dungeon_name = zone.name
	add_child(recap)
	recap.connect("RecapComplete", _on_recap_complete)


func _on_recap_complete():
	print("Recap is complete")
	# Load the home page
	get_tree().get_root().get_node("Game/GameContent").loadScene("res://Menu/main_menu.tscn", true)


func _on_stage_started(stage: Stage):
	# When a stage is loading, we check if it needs boss music
	if stage.is_boss:
		music.fade_control(music.MusicState.START, zone.boss_music)
