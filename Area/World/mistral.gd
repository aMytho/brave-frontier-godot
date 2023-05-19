extends Node2D

var header: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.get_node("Game").get_child(0).emit_signal("startPlaying", "res://Music/1-03 Frontier.mp3")

func _on_button_pressed():
	print("Loading first zone of Mistral")
	#Load the header scene
	
	header = ResourceLoader.load("res://Menu/Header/header.tscn").instantiate()
	var level_loader = ResourceLoader.load("res://Area/UI/level_select.tscn").instantiate()
	var res = load("res://Area/Areas/Mistral/AdventurePrairie/adventure_prairie.tres")
	
	#Display next scene, set its position
	add_child(header)
	add_child(level_loader)
	level_loader.position.y = 163
	#Load the dungeon's zones
	level_loader.dungeon = res
	
	#Toggle it
	toggleUI(true)
	
	#Handle scene deletion
	var callable = Callable(self, "on_levels_selector_closed")
	level_loader.connect("Closed", callable)

func on_levels_selector_closed():
	#Close the header
	print("Level selector closed")
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
