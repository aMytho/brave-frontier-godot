extends Node2D

var header: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.get_node("Game").get_child(0).emit_signal("startPlaying", "res://Music/1-03 Frontier.mp3")


func _on_button_pressed():
	print("Loading green biome")
	#Load the header scene
	
	#TODO - Load header in level loader :)
	header = ResourceLoader.load("res://Menu/Header/header.tscn").instantiate()
	var levelLoader = ResourceLoader.load("res://Area/UI/level_select.tscn").instantiate()
	
	#Display next scene
	add_child(header)
	add_child(levelLoader)
	levelLoader.position.y = 175
	
	#Toggle it
	toggleUI(true)
	
	#Handle scene deletion
	var callable = Callable(self, "on_levels_selector_closed")
	levelLoader.connect("Closed", callable)

func on_levels_selector_closed():
	#Close the header
	print("It was closed")
	toggleUI(false)

func toggleUI(should_hide = false):
	if should_hide:
		#Darken Background
		get_child(0).self_modulate = Color(0.23, 0.23, 0.23, 1.0)
		#Hide children buttons
		for btn in get_child(0).get_children():
			btn.hide()
	else:
		#Darken Background
		get_child(0).self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		#Hide children buttons
		for btn in get_child(0).get_children():
			btn.show()
		header.queue_free()
