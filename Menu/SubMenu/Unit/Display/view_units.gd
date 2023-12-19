extends Control

signal UnitSelected(id: int)
signal RemoveUnitPressed
signal BackPressed

@export var units: Array[Unit] = []
@export var use_signals: bool = false
@export var remove_button: bool = false

var thumbnail = preload("res://Menu/SubMenu/Unit/Display/unit_thumbnail.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Show remove button if enabled
	if remove_button:
		$UnitList/RemoveUnit.visible = true
	
	var user_units = Lookups.get_units_by_account_id(ActiveAccount.id)
	for unit in user_units:
		$UnitList.add_child(create_thumbnail(Lookups.get_unit_by_ID(unit["id"])["unit"]))

	# Handle each unit click event
	for child in $UnitList.get_children():
		# Only connect units, not the remove unit button
		if !child.has_meta("is_remove"):
			child.connect("Clicked", _on_unit_pressed)
	
	# Get back button click event
	$BackSection.Clicked.connect(_on_back_pressed)


func create_thumbnail(unit: Unit):
	var new_thumbnail = thumbnail.duplicate()
	new_thumbnail.icon = unit.thumbnail
	new_thumbnail.unit = unit
	return new_thumbnail


func _on_unit_pressed(unit: Unit):
	if use_signals:
		emit_signal("UnitSelected", unit.id)
	else:
		get_parent().load_scene_with_props("res://Menu/SubMenu/Unit/Display/unit_display.tscn", 1, ["unit"], [unit])


func _on_back_pressed():
	if use_signals:
		emit_signal("BackPressed")
	else:
		get_parent().load_scene("res://Menu/SubMenu/Unit/unit_menu.tscn", 0)


func _on_remove_unit_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("RemoveUnitPressed")
