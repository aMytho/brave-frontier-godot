extends Control

@export var units: Array[Unit] = []:
	set(new_units):
		units = new_units

var thumbnail = preload("res://Menu/SubMenu/Unit/Display/unit_thumbnail.tscn").instantiate()
var vargas: Unit = preload("res://Units/Starter/1/fencer_vargas.tres")
var selena: Unit = preload("res://Units/Starter/5/selena.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	print(units)
	#Add units to tree
	var count = 0
	while count < 10:
		$UnitList.add_child(create_thumbnail(vargas))
		$UnitList.add_child(create_thumbnail(selena))
		count += 1
	
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
	get_parent().load_scene("res://Menu/SubMenu/Unit/Display/unit_display.tscn")

func _on_back_pressed():
	get_parent().load_scene("res://Menu/SubMenu/Unit/unit_menu.tscn")
