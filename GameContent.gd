extends Node

var loadWindow = preload("res://Title and Load/load.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func loadScene(scene:String, showLoadScreen: bool = false):
	if showLoadScreen:
		#display loading screen
		add_child(loadWindow.instantiate())
		await get_tree().create_timer(4.0).timeout
	#Load the next scene
	var nextScene = ResourceLoader.load(scene).instantiate()
	#Display next scene
	add_child(nextScene)
	#Unload last scene
	get_child(0).queue_free()
	if showLoadScreen:
		get_node("Load").queue_free()


func loadSceneWithProps(scene: String, names, props, showLoadScreen: bool = false):
	if showLoadScreen:
		#display loading screen
		add_child(loadWindow.instantiate())
		await get_tree().create_timer(4.0).timeout
	#Load the next scene
	var nextScene = ResourceLoader.load(scene).instantiate()
	
	var count = 0
	for key in names:
		nextScene[key] = props[count]
		count = count + 1
	
	#Display next scene
	add_child(nextScene)
	#Unload last scene
	get_child(0).queue_free()
	if showLoadScreen:
		get_node("Load").queue_free()
