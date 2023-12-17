extends Control

signal UpdateTarget(place_ID: int)

# The current unit under attack. Will be used by parent nodes
@export var current_target: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Function triggered when the user select an enemy unit
func _on_target_selected(id: int):
	print("Targeting enemy unit: ", id)
	
	# Remove all other targets
	for target in [$Unit1, $Unit2, $Unit3, $Unit4, $Unit5, $Unit6]:
		if target.place_ID != id:
			target.remove_target()
		elif current_target == target.place_ID:
			target.remove_target()
			current_target = -1
		else:
			# Set the current target
			current_target = id
			emit_signal("UpdateTarget", target.place_ID)


# Returns the target unit or a random unit if none is selected
func get_target():
	if current_target == -1:
		return get_random_target()
	return get_child(current_target - 1)


# Get a random target from the existing units
func get_random_target():
	var children = get_children()
	
	# Remove any child that isn't a unit (empty slot) or dead
	var counter = 0
	while counter < children.size():
		if children[counter].is_unit == false or children[counter].is_dead:
			children.remove_at(counter)
		else:
			# Only increment if a unit is found, otherwise it isn't accurate (children.size() updates when removed)
			counter += 1

	# If the player attacks after unit has died, but before atks are disabled,
	# there may be no more units left.
	# We return null in this case. It is caught by the calling function.
	if len(children) == 0:
		print("No enemies available to target.")
		return null

	# Pick a random unit
	return children[randi_range(1, children.size()) -1]


func clear_units():
	for child in get_children():
		child.is_unit = false
		child.is_dead = false
		child.reset_spritesheet()
		child.show()
		child.remove_target()


func set_speed(new_speed: float):
	# Loop through each unit and set its speed
	for child in get_children():
		child.speed = new_speed
