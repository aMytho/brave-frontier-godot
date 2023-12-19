extends Control

signal UnitsComplete

## The units the summoner acquired (these are placeholders atm)
@export var units: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the blank texture
	for unit in units:
		var new_unit = ResourceLoader.load("res://Common/UI/Collectables/collectable.tscn").instantiate()
		new_unit.set_properties(unit.unit.name, unit.unit.thumbnail, 1, false)
		$UnitsContainer.add_child(new_unit)
	await get_tree().create_timer(2.0).timeout
	show_units()


func show_units():
	var counter = 0
	for unit in units:
		$UnitsContainer.get_child(counter).show_item()
		counter = counter + 1
		# Wait 0.3 seconds to show the next unit
		await get_tree().create_timer(0.3).timeout
	await get_tree().create_timer(2.0).timeout
	emit_signal("UnitsComplete")
