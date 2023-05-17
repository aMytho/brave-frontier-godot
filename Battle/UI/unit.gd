extends TextureRect

var ElementLocations = [
	Rect2(37, 919, 27, 27), # Fire
	Rect2(64, 919, 26, 26), # Water
	Rect2(92, 920, 25, 25), # Earth
	Rect2(118, 919, 26, 26), # Thunder
	Rect2(145, 920, 25, 25), # Light
	Rect2(172, 920, 26, 26) # Dark
]

var normal_border = Rect2(2, 2, 320, 117)
var attacked_border = Rect2(3, 122, 319, 116)

signal Attack(place: int)
signal BraveBurstReady
signal BraveBurst
signal Die

@export_category("Unit Stats")
@export var unit_icon:CompressedTexture2D
@export var unit_name:String = ""
@export var unit_element:String = "Fire"
@export var unit_HP: int = 500

@export_category("Unit Dev Info")
@export var place_ID: int = 0
@export var has_attacked: bool = false


func create_unit(icon, uName, element, HP):
	print(icon, uName, element, HP)
	#Set props
	unit_icon = icon
	unit_name = uName
	unit_element = element
	unit_HP = HP
	#Get their actual values
	get_node("Element").texture.region = setElement(unit_element)
	get_node("Name").text = unit_name
	get_node("HPContainer/Label").text = str(unit_HP, "/", unit_HP)
	get_node("PlayerFrame").texture = icon

func reset_placeholder():
	# runs when a unit isn't in a slot. Reset all values
	unit_icon = null
	unit_name = ""
	unit_element = "Fire"
	unit_HP = 500
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
		"Thunder":
			return ElementLocations[3]
		"Dark":
			return ElementLocations[4]
		"Light":
			return ElementLocations[5]
	return ElementLocations[0]

func _on_gui_input(event: InputEvent):
	#If clicked, attack if possible
	if event.is_pressed() and has_attacked == false:
		print("Attack!")
		has_attacked = true
		# Dim the border
		texture.region = attacked_border
		# Emit event
		emit_signal("Attack", place_ID)

func allow_attacks():
	texture.region = normal_border
	has_attacked = false
