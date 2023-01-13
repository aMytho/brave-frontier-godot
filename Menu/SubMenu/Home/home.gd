extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	#TODO --- Get character data
	$Character/TextureRect/Char1/BG.element = "earth"
	$Character/TextureRect/Char2/BG.element = "dark"
	$Character/TextureRect/Char3/BG.element = "dark"
	$Character/TextureRect/Char4/BG.element = "earth"
	$Character/TextureRect/Char5/BG.element = "fire"
