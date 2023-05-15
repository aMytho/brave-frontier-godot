extends Control

# The current unit under attack. Will be used by parent nodes
@export var current_target: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_target_selected(id: int):
	# A target was made!
	print("Targeting enemy unit: ", id)
	
	# Remove all other targets
	for target in [$Unit1, $Unit2, $Unit3, $Unit4, $Unit5, $Unit6]:
		if target.place_ID != id:
			target.remove_target()
	
	# Set the current target
	current_target = id
