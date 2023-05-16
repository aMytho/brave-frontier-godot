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

func get_target_position():
	# Returns the target unit's position or a random unit if none is selected
	if current_target == 0:
		return get_random_target()
	return get_child(current_target - 1).position

func get_random_target():
	var children = get_children()
	
	# Remove any child that isn't a unit (empty slot)
	var counter = 0
	while counter < children.size():
		if children[counter].is_unit == false:
			children.remove_at(counter)
		else:
			# Only increment if a unit is found, otherwise it isn't accurate (children.size() updates when removed)
			counter += 1

	# Pick a random unit
	return children[randi() % children.size()].position
