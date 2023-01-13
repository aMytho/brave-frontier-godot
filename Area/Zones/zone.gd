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
		add_child(dialogue)
		dialogue.connect("Complete", _on_beginning_complete)
	else:
		_on_beginning_complete()
	fade_control(1, zone.music)

func _on_beginning_complete(dialogue:Node = null):
	#Remove dialogue if it exists
	if dialogue:
		remove_child(dialogue)
	
	#Fade music
	fade_control(0)
	#Load battle
	var battle = ResourceLoader.load("res://Battle/battle.tscn").instantiate()
	battle.zone = zone
	battle.units = units
	#Play music
	battle.ready.connect(fade_control.bind(1, zone.music))
	add_child(battle)

	
func fade_control(action: int, music_file  = null):
	var tween = create_tween()
	if action == 0:
		tween.tween_property(music, "volume_db", -80.0, 1.5)
		tween.tween_callback(music.stop)
	else:
		if music_file != null:
			music.stream = music_file
		tween.tween_property(music, "volume_db", -10.0, 1.5)
		tween.tween_callback(music.play)
