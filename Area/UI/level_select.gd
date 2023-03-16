
extends Control

signal Closed

# Called when the node enters the scene tree for the first time.
func _ready():
	var levels = [
		ResourceLoader.load("res://Area/UI/level.tscn").instantiate(),
		ResourceLoader.load("res://Area/UI/level.tscn").instantiate(),
		ResourceLoader.load("res://Area/UI/level.tscn").instantiate(),
		ResourceLoader.load("res://Area/UI/level.tscn").instantiate(),
		ResourceLoader.load("res://Area/UI/level.tscn").instantiate(),
		ResourceLoader.load("res://Area/UI/level.tscn").instantiate()
	]
	
	
	var count = 0
	for level in levels:
		var callable = Callable(self, "loadLevel")
		level.connect("Clicked", callable)
		#Set values
		var props = mockLevelLoader(count)
		level.setProperties(props.level, props.energy, props.battles, props.status, props.description)
		get_child(0).get_child(0).add_child(level)
		count = count + 1
		
func loadLevel():
	#TODO - Select team and items and friends and other stuff
	print("Loading level")
	emit_signal("Closed")
	get_tree().get_root().get_node("Game/GameContent").loadScene("res://Battle/battle.tscn", true)

func mockLevelLoader(count: int):
	var mockLevels = [
		{
			"level": "Shrubs and Greenery",
			"energy": 2,
			"battles": 5,
			"status": "incomplete",
			"description": "This is a long test about strings and how much length they use."
		},
		{
			"level": "A String Mockery",
			"energy": 2,
			"battles": 5,
			"status": "incomplete",
			"description": "More test strings. Easy, green, bushy.."
		},
		{
			"level": "Weed Wacker 9000",
			"energy": 3,
			"battles": 5,
			"status": "Complete",
			"description": "A semi-realistic amount of text. More data so it is more real. \n Need to lookup the library..."
		},
		{
			"level": "Shrubs and Greenery",
			"energy": 3,
			"battles": 5,
			"status": "incomplete",
			"description": "A semi-realistic amount of text. More data so it is more real. \n Need to lookup the library..."
		},
		{
			"level": "Shrubs and Greenery",
			"energy": 4,
			"battles": 5,
			"status": "incomplete",
			"description": "A semi-realistic amount of text. More data so it is more real. \n Need to lookup the library..."
		},
		{
			"level": "Tree Man",
			"energy": 5,
			"battles": 5,
			"status": "incomplete",
			"description": "Tree do be growing though"
		},
	]
	return mockLevels[count]


func _on_home_button_pressed():
	print("Home")
	get_tree().get_root().get_node("Game/GameContent").loadScene("res://Menu/main_menu.tscn", false)


func _on_back_button_pressed():
	emit_signal("Closed")
	self.queue_free()
