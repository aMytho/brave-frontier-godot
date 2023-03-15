extends Control

var count = 0
var player_name = ""
var main_character: Unit = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.stream = load("res://Music/3-01 World of God.mp3")
	$Music.play()
	var intro = load("res://Area/Creation/creator.tscn").instantiate()
	print(intro.messages)
	intro.messages = [
		"I am Lucius, the god who controls this gate..",
		"I have been waiting for the day you would come..",
		"O Chosen One. What is your name?"
	]
	add_child(intro)
	intro.connect("FlashComplete", _on_flash_complete)

func _on_flash_complete():
	if count == 0:
		var name_picker = load("res://Introduction/name_entry.tscn").instantiate()
		add_child(name_picker)
		name_picker.connect("NameChosen", _on_name_chosen)
	elif count == 1:
		var char_picker = load("res://Introduction/char_picker.tscn").instantiate()
		add_child(char_picker)
		char_picker.connect("CharSelected", _on_char_chosen)
	else:
		var tutorial = load("res://Introduction/wake_up.tscn").instantiate()
		tutorial.content = player_name
		add_child(tutorial)
		tutorial.connect("ImAwake", _on_wake_up)
		var tween = create_tween()
		tween.tween_property($Music, "volume_db", -80.0, 3.0)
		tween.tween_callback($Music.stop)
	count += 1

func _on_name_chosen(nm: String):
	player_name = nm
	remove_child($Creator)
	
	var intro = load("res://Area/Creation/creator.tscn").instantiate()
	var msg1 = str(player_name, " ...")
	intro.messages = [
		msg1,
		"Rely on your own power. Summon your hero",
	]
	add_child(intro)
	intro.connect("FlashComplete", _on_flash_complete)

func _on_char_chosen(character: Unit):
	print(character)
	main_character = character
	remove_child($Creator)
	
	var intro = load("res://Area/Creation/creator.tscn").instantiate()
	intro.messages = [
		"Let go. May your power be the gospel of this world. Keep moving forward...",
	]
	add_child(intro)
	intro.connect("FlashComplete", _on_flash_complete)
	#Save the changes
	Database.query("INSERT INTO player_state ( arena_orbs, karma, zel, gems, energy, max_exp, exp, level, player_name ) VALUES ( 3, 100, 100, 5, 5, 1, 0, 1, '%s' );" % player_name)

func _on_wake_up():
	print("Summoner is awake, start tutorial 1")
	
	var zone = ResourceLoader.load("res://Area/Areas/Mistral/AdventurePrairie/Zones/basics_of_battle.tres")
	var arg1 = ["zone", "units"]
	var subArg: Array[Unit] = [null, null, main_character, null, null, null]
	var arg2 = [zone, subArg]
	get_tree().get_root().get_node("Game/GameContent").loadSceneWithProps("res://Area/Zones/zone.tscn", arg1, arg2)
	
