extends Control

## The unit thumbnail.
var thumbnail = preload("res://Menu/SubMenu/Unit/Display/unit_thumbnail.tscn").instantiate()

## Each ID represents a unitID that is playable.
@export var playable_units: Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get each playable unit
	var user_units: Array[Unit] = []
	for unit_id in playable_units:
		user_units.append(Lookups.get_unit_by_unit_number(unit_id)["unit"])
	
	# Display the units
	for unit in user_units:
		$UnitList.add_child(create_thumbnail(unit))
	
	# Add click event listeners
	for unit_thumbnial in $UnitList.get_children():
		if !unit_thumbnial.has_meta("is_remove"):
			unit_thumbnial.connect("Clicked", _on_unit_clicked)


# Creates a thumbnail for the unit
func create_thumbnail(unit: Unit):
	var new_thumbnail = thumbnail.duplicate()
	new_thumbnail.icon = unit.thumbnail
	new_thumbnail.unit = unit
	return new_thumbnail


# Add the unit to the DB, player will own them
func _on_unit_clicked(unit: Unit):
	Database.query(
		"INSERT INTO units (account_id, unit_id, level, hp, atk, def, rec) VALUES (%s, %s, %s, %s, %s, %s, %s)"
		% [ActiveAccount.id, unit.unit_number, unit.level, unit.HP, unit.ATK, unit.DEF, unit.REC])


# When back clicked, move to unit menu
func _on_back_section_clicked():
	get_parent().load_scene("res://Menu/SubMenu/Unit/unit_menu.tscn", 0)
