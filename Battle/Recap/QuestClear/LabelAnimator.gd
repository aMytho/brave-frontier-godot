extends Node

@export var current_val: int = 0:
	set(new_val):
		current_val = new_val
		update_label()
@export var total_val: int = 0
@export var label: Label = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_properties(initial_val: int, final_fal: int, new_label: Label):
	label = new_label
	total_val = final_fal
	current_val = initial_val

func update_label():
	label.text = str(current_val)
