extends Control

signal MaterialsComplete

# TODO: Determine material structure, add to DB
# For the moment, all materials are a single string with a placeholder name and img
@export var materials: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the blank texture
	for iter_material in materials:
		var new_material = ResourceLoader.load("res://Common/UI/Collectables/collectable.tscn").instantiate()
		new_material.set_properties(iter_material.name, iter_material.img, 7, true)
		$MaterialContainer.add_child(new_material)
	await get_tree().create_timer(2.0).timeout
	show_materials()


func show_materials():
	var counter = 0
	for iter_material in materials:
		$MaterialContainer.get_child(counter).show_item()
		counter = counter + 1
		# Wait 0.3 seconds to show the next item
		await get_tree().create_timer(0.3).timeout
	await get_tree().create_timer(2.0).timeout
	emit_signal("MaterialsComplete")
