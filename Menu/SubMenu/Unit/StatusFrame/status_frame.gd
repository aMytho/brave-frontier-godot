extends HBoxContainer

@export var description: int = 1
@export var value: String = "":
	set(new_value):
		$Center/HBoxContainer/Value.text = new_value
		value = new_value

# Called when the node enters the scene tree for the first time.
func _ready():
	#Desc is optional
	if description != null:
		#Set it
		$Center/HBoxContainer/Description.texture.region = get_region(description)
	#Sets the value
	$Center/HBoxContainer/Value.text = value

#Gets the region on the png corresponding to its position represented by a number (1-15)
func get_region(region: int):
	match region:
		0: return Rect2(0,0,1,1) #No image
		1: return Rect2(0, 1, 49, 30)
		2: return Rect2(0, 31, 43, 24)
		3: return Rect2(0, 61, 88, 24)
		4: return Rect2(0, 91, 51, 24)
		5: return Rect2(0, 120, 47, 26)
		6: return Rect2(0, 151, 49, 24)
		7: return Rect2(0, 181, 51, 25)
		8: return Rect2(0, 211, 71, 25)
		9: return Rect2(0, 242, 84, 25)
		10: return Rect2(0, 272, 38, 25)
		11: return Rect2(0, 304, 70, 25)
		12: return Rect2(0, 332, 89, 25)
		13: return Rect2(0, 361, 90, 25)
		14: return Rect2(0, 390, 92, 30)
		15: return Rect2(0, 421, 59, 25)
		# To-do: add cost to list
