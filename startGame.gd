extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# play BGM
	var music = $Music
	music.stream = load("res://Music/1-01 Song of the Hero.mp3")
	music.play()

func _on_touch_screen_gui_input(event):
	if event.get("pressed") == true:
		print("startGame")
		if true:
			get_node("%GameContent").loadScene("res://Introduction/introduction.tscn", true)
		else:
			get_node("%GameContent").loadScene("res://Menu/main_menu.tscn", true)
		var tween = create_tween()
		tween.tween_property($Music, "volume_db", -80.0, 3.0)
