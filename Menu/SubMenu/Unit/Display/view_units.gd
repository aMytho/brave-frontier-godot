extends Control

@export var units: Array[Unit] = []:
	set(new_units):
		units = new_units

var thumbnail = preload("res://Menu/SubMenu/Unit/Display/unit_thumbnail.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	var activeAccountId = ActiveAccount.id
	var unitDataResources = load("res://Database/resource_lookups.gd").new();
	var unitsOfCurrentUser = unitDataResources.get_units_by_account_id(activeAccountId)
	for unit in unitsOfCurrentUser:
		$UnitList.add_child(create_thumbnail(unitDataResources.get_unit_by_ID(unit["id"])["unit"]))
	
	#Handle each unit click event
	for child in $UnitList.get_children():
		child.connect("Clicked", _on_unit_pressed)
	
	#Get back button click event
	$BackSection.Clicked.connect(_on_back_pressed)

func create_thumbnail(unit: Unit):
	var new_thumbnail = thumbnail.duplicate()
	new_thumbnail.icon = unit.thumbnail
	new_thumbnail.unit = unit
	return new_thumbnail

func _on_unit_pressed(unit: Unit):
	print(unit)
	get_parent().load_scene_home("res://Menu/SubMenu/Unit/Display/unit_display.tscn")

func _on_back_pressed():
	get_parent().load_scene_home("res://Menu/SubMenu/Unit/unit_menu.tscn")
