extends TextureRect

var ElementLocations = [
	Rect2(37, 919, 27, 27), #Fire
	Rect2(64, 919, 26, 26), #Water
	Rect2(92, 920, 25, 25), #Earth
	Rect2(118, 919, 26, 26), #Lightning
	Rect2(145, 920, 25, 25), #Light
	Rect2(172, 920, 26, 26) #Light
]

@export var unitIcon:CompressedTexture2D
@export var unitName:String = ""
@export var unitElement:String = "Fire"
@export var unitHP: int = 500


func create_unit(icon, uName, element, HP):
	print(icon, uName, element, HP)
	#Set props
	unitIcon = icon
	unitName = uName
	unitElement = element
	unitHP = HP
	#Get their actual values
	print(get_node("Element").texture.region)
	print(unitElement)
	print(setElement(unitElement))
	get_node("Element").texture.region = setElement(unitElement)
	get_node("Name").text = unitName
	get_node("HPContainer/Label").text = str(unitHP, "/", unitHP)
	get_node("PlayerFrame").texture = icon

func reset_placeholder():
	print("TODO")

func setElement(element):
	match element:
		"Fire":
			return ElementLocations[0]
		"Water":
			return ElementLocations[1]
		"Earth":
			return ElementLocations[2]
		"Lightning":
			return ElementLocations[3]
		"Dark":
			return ElementLocations[4]
		"Light":
			return ElementLocations[5]
	return ElementLocations[0]
