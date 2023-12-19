extends TextureRect

@export var element: String = "fire":
	set(elem):
		set_element(elem)
		element = elem

# Called when the node enters the scene tree for the first time.
func _ready():
	set_element(element)


func set_element(elem: String):
	if elem == "none":
		# If no element is selected, load no background
		$anim1.texture = null
		$anim2.texture = null
		$anim3.texture = null
		$anim4.texture = null
		return
	
	# Holds the paths for the frames
	var paths = []
	
	# Sets the paths to the frames
	var beginPath = "res://Menu/SubMenu/Home/Characters/Glows/"
	paths.append(str(beginPath, elem, "_", 1, ".png"))
	paths.append(str(beginPath, elem, "_", 2, ".png"))
	paths.append(str(beginPath, elem, "_", 3, ".png"))
	paths.append(str(beginPath, elem, "_", 4, ".png"))
	
	# Display them
	$anim1.texture = ResourceLoader.load(paths[0])
	$anim2.texture = ResourceLoader.load(paths[1])
	$anim3.texture = ResourceLoader.load(paths[2])
	$anim4.texture = ResourceLoader.load(paths[3])
