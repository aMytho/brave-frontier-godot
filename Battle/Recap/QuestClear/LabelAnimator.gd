extends Node

## The current value
@export var current_val: int = 0:
	set(new_val):
		current_val = new_val
		update_label()
## The end value
@export var total_val: int = 0
## Label which will display the animation
@export var label: Label = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Set the initial, final, and label variables
func set_properties(initial_val: int, final_fal: int, new_label: Label):
	label = new_label
	total_val = final_fal
	current_val = initial_val


# Show the current value
func update_label():
	label.text = str(current_val)
