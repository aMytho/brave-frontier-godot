extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Menu Ready")
	# Start the summoner OST
	get_tree().root.get_node("Game").get_child(0).emit_signal("startPlaying", "res://Music/1-02 The Summoner.mp3")
	# Load the home screen by default
	$content_switcher.load_scene("res://Menu/SubMenu/Home/home.tscn", 0)


# Load the new menu when a footer btn is clicked
func _on_footer_btn_clicked(id:int):
	match id:
		1: $content_switcher.load_scene("res://Menu/SubMenu/Home/home.tscn", 1)
		2: $content_switcher.load_scene("res://Menu/SubMenu/Unit/unit_menu.tscn", 1)
