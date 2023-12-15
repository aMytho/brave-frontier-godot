extends TextureRect

# The health bars for good, meh, and bad HPs
const green_bar = Rect2(2, 545, 176, 10)
const yellow_bar = Rect2(2, 560, 176, 11)
const red_bar = Rect2(2, 575, 176, 12)

# The atlastexture coordinates for the elemental symbol 
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

## Attack a unit with a given placeID
signal Attack(place: int)

# Unimplemented (for now)
signal BraveBurstReady
signal BraveBurst

# Occurs on death
signal Die

@export_category("Unit Stats")
@export var has_unit:bool = false
@export var unit_icon:CompressedTexture2D
@export var unit_name:String = ""
@export var unit_element:String = "Fire"
@export var unit_HP: int = 500
@export var live_unit_HP: int = 500
@export var is_dead: bool = false

## This info is what we add to the units for additional identification and logic
@export_category("Unit Dev Info")
@export var place_ID: int = 0
@export var has_attacked: bool = false


func create_unit(icon, new_unit_name, element, HP):
	print("Creating Unit: ", new_unit_name)
	
	# Set props
	unit_icon = icon
	unit_name = new_unit_name
	unit_element = element
	unit_HP = HP
	live_unit_HP = HP
	has_unit = true
	$HPContainer/Bar.max_value = unit_HP
	$HPContainer/Bar.value = live_unit_HP
	
	# Show the properties in the UI
	get_node("Element").texture.region = get_element_icon_region(unit_element)
	get_node("Name").text = unit_name
	get_node("PlayerFrame").texture = icon
	update_HP_container(live_unit_HP)


# Runs when a unit isn't in a slot. Reset all values
func reset_placeholder():
	unit_icon = null
	unit_name = ""
	unit_element = "Fire"
	unit_HP = 500
	is_dead = false
	
	# Reset viewable stats
	self.modulate = Color(0.29, 0.29, 0.29)
	get_node("Element").texture.region = Rect2(0,0,0,0)
	$Name.visible = false
	$HPContainer.visible = false
	$BBAnimation.visible = false
	$BBContainer.visible = false
	$HPContainer.visible = false
	$PlayerFrame.visible = false


# When called, update the unit HP
func update_HP_container(new_HP: int):
	var HP_bar = $HPContainer/Bar
	live_unit_HP = new_HP if new_HP > 0 else 0
	HP_bar.value = live_unit_HP
	get_node("HPContainer/Label").text = str(live_unit_HP, "/", unit_HP)
	
	# based on the HP, show the correct color of HP bar
	if (unit_HP == live_unit_HP):
		HP_bar.texture_progress.region = green_bar
	elif int(unit_HP/3.0) <= live_unit_HP:
		HP_bar.texture_progress.region = yellow_bar
	else:
		HP_bar.texture_progress.region = red_bar


func get_element_icon_region(element):
	match element:
		"Fire":
			return ElementLocations[0]
		"Water":
			return ElementLocations[1]
		"Earth":
			return ElementLocations[2]
		"Thunder":
			return ElementLocations[3]
		"Light":
			return ElementLocations[4]
		"Dark":
			return ElementLocations[5]
	return ElementLocations[0]


func _on_gui_input(event: InputEvent):
	# If clicked, attack if possible
	if event.is_pressed() and has_unit and has_attacked == false and is_dead == false:
		print("Unit ordered to attack.")
		has_attacked = true
		# Dim the border
		texture.region = attacked_border
		# Emit event
		emit_signal("Attack", place_ID)


# Allow the unit to attack again (if not dead)
func allow_attacks():
	if is_dead == false and has_unit:
		texture.region = normal_border
		has_attacked = false


func set_unit_dead():
	is_dead = true
