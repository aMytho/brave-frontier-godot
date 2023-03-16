extends TextureRect

var ElementLocations = [
	Rect2(37, 919, 27, 27), #Fire
	Rect2(64, 919, 26, 26), #Water
	Rect2(92, 920, 25, 25), #Earth
	Rect2(118, 919, 26, 26), #Lightning
	Rect2(145, 920, 25, 25), #Light
	Rect2(172, 920, 26, 26) #Light
]

signal Attack(place: int)
signal BraveBurstReady
signal BraveBurst
signal Die

@export_category("Unit Stats")
@export var unitIcon:CompressedTexture2D
@export var unitName:String = ""
@export var unitElement:String = "Fire"
@export var unitHP: int = 500

@export_category("Unit Dev Info")
@export var placeID: int = 0
@export var hasAttacked: bool = false


func create_unit(icon, uName, element, HP):
	print(icon, uName, element, HP)
	#Set props
	unitIcon = icon
	unitName = uName
	unitElement = element
	unitHP = HP
	#Get their actual values
	print(unitElement)
	get_node("Element").texture.region = setElement(unitElement)
	get_node("Name").text = unitName
	get_node("HPContainer/Label").text = str(unitHP, "/", unitHP)
	get_node("PlayerFrame").texture = icon

func reset_placeholder():
	# runs when a unit isn't in a slot. Reset all values
	unitIcon = null
	unitName = ""
	unitElement = "Fire"
	unitHP = 500
	#Reset viewable stats
	self.modulate = Color(0.29, 0.29, 0.29)
	get_node("Element").texture.region = Rect2(0,0,0,0)
	$Name.visible = false
	$HPContainer.visible = false
	$BBAnimation.visible = false
	$BBContainer.visible = false
	$HPContainer.visible = false
	$PlayerFrame.visible = false

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

func _on_gui_input(event: InputEvent):
	#If clicked, attack if possible
	if event.is_pressed() and hasAttacked == false:
		print("Attack!")
		emit_signal("Attack", placeID)
