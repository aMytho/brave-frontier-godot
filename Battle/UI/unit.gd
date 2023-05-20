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
@export var has_unit:bool = false
@export var unit_icon:CompressedTexture2D
@export var unit_name:String = ""
@export var unit_element:String = "Fire"
@export var unit_HP: int = 500
@export var live_unit_HP: int = 500
@export var is_dead: bool = false

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
	live_unit_HP = HP
	has_unit = true
	set_default_health_bar_data()
	set_live_health_bar_data()
	$HPContainer/HPNotFull.visible = false
	$HPContainer/HPDanger.visible = false
	
	print($HPContainer/Bar.value)
	print($HPContainer/Bar.value)
	
	#Get their actual values
	get_node("Element").texture.region = setElement(unit_element)
	get_node("Name").text = unit_name
	get_node("HPContainer/Label").text = str(live_unit_HP, "/", unit_HP)
	get_node("PlayerFrame").texture = icon


func set_default_health_bar_data():
	$HPContainer/HPNotFull.max_value = unit_HP
	$HPContainer/HPDanger.max_value = unit_HP
	$HPContainer/Bar.max_value = unit_HP
	
func set_live_health_bar_data():
	$HPContainer/HPNotFull.value = live_unit_HP
	$HPContainer/HPDanger.value = live_unit_HP
	$HPContainer/Bar.value = live_unit_HP

func reset_placeholder():
	# runs when a unit isn't in a slot. Reset all values
	unit_icon = null
	unit_name = ""
	unit_element = "Fire"
	unit_HP = 500
	is_dead = false
	#Reset viewable stats
	self.modulate = Color(0.29, 0.29, 0.29)
	get_node("Element").texture.region = Rect2(0,0,0,0)
	$Name.visible = false
	$HPContainer.visible = false
	$HPContainer/HPNotFull.visible = false
	$HPContainer/HPDanger.visible = false
	$BBAnimation.visible = false
	$BBContainer.visible = false
	$HPContainer.visible = false
	$PlayerFrame.visible = false

func update_HP_container(new_HP: int):
	print("HP container updated")
	live_unit_HP = new_HP if new_HP > 0 else 0
	get_node("HPContainer/Label").text = str(live_unit_HP, "/", unit_HP)
	set_live_health_bar_data()
	if (unit_HP == live_unit_HP):
		print("full HP")
		$HPContainer/Bar.visible = true
		$HPContainer/HPNotFull.visible = false
		$HPContainer/HPDanger.visible = false
	elif int(unit_HP/3) <= live_unit_HP:
		$HPContainer/Bar.visible = false
		$HPContainer/HPNotFull.visible = true
		$HPContainer/HPDanger.visible = false
		print("not full but no danger")
	else:
		$HPContainer/Bar.visible = false
		$HPContainer/HPNotFull.visible = false
		$HPContainer/HPDanger.visible = true
		print("DANGER")

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
	if event.is_pressed() and has_unit and has_attacked == false and false == is_dead:
		print("Attack!")
		has_attacked = true
		# Dim the border
		texture.region = attacked_border
		# Emit event
		emit_signal("Attack", place_ID)

func allow_attacks():
	if false == is_dead and has_unit:
		texture.region = normal_border
		has_attacked = false
		
# This function could be used to update all the data about the unit when it dies
# For example : 
## Remember the unit is dead
## Fade the sprite out
## make the unit button darker, meaning it has died, or something similar
func unitHasDied():
	is_dead = true
