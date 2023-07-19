extends Control

## The state of the music player
enum Music {
	## Start the music
	START,
	## Stop the music
	STOP
}

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
		fade_control(Music.START, zone.beginning_cutscene.music)
	else:
		_on_beginning_complete()

func _on_beginning_complete(dialogue:Node = null):
	# Remove dialogue if it exists
	if dialogue:
		remove_child(dialogue)
	
	# Fade music
	fade_control(Music.STOP)
	# Load battle
	var battle = ResourceLoader.load("res://Battle/battle.tscn").instantiate()
	battle.zone = zone
	battle.units = units
	# Play music when the battle is loaded
	battle.ready.connect(fade_control.bind(Music.START, zone.music))
	add_child(battle)
	
	# Listen for ending
	battle.BattleFinished.connect(_on_battle_complete)

func _on_battle_complete(is_victory: bool):
	print("Victory: ", is_victory)
	get_node("Battle").queue_free()
	
	# Stop the music
	fade_control(Music.STOP)
	
	if zone.ending_cutscene:
		print("There is an ending cutscene")
		var dialogue = ResourceLoader.load("res://Area/Dialogue/dialogue.tscn").instantiate()
		dialogue.dialogue = zone.ending_cutscene
		add_child(dialogue)
		dialogue.connect("Complete", _on_end_complete)
		fade_control(Music.START, zone.ending_cutscene.music)
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
	fade_control(Music.STOP)
	
	# To-do: Move to content switcher?
	var recap = ResourceLoader.load("res://Battle/Recap/recap.tscn").instantiate()
	recap.zone = zone
	recap.dungeon_name = "Stylish Placeholder"
	add_child(recap)
	recap.connect("RecapComplete", _on_recap_complete)

func _on_recap_complete():
	print("Recap is complete")
	# Load the home page
	get_tree().get_root().get_node("Game/GameContent").loadScene("res://Menu/main_menu.tscn", true)

func fade_control(action: Music, music_file = null):
	var tween = create_tween()
	match action:
		Music.STOP:
			# Stop the music
			tween.tween_property(music, "volume_db", -80.0, 1.5)
			tween.tween_callback(music.stop)
		Music.START:
			# Play the music
			if music_file != null:
				music.stream = music_file
			tween.tween_property(music, "volume_db", -10.0, 1.5)
			tween.tween_callback(music.play)
