extends Control

# The current unit under attack. Will be used by parent nodes
@export var current_target: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Function triggered when the user select an enemy unit
func _on_target_selected(id: int):
	# A target was made!
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

# Get the target in the enemy team
### If no target, then we choose a random target
func get_target():
	# Returns the target unit or a random unit if none is selected
	if current_target == -1:
		return get_random_target()
	return get_child(current_target - 1)

# Get a random target in the enemies list depending if they are alive or not
# In the end, we take a random unit in the Children list that has been purge
func get_random_target():
	var children = get_children()
	
	# Remove any child that isn't a unit (empty slot)
	var counter = 0
	while counter < children.size():
		if children[counter].is_unit == false or children[counter].is_dead:
			children.remove_at(counter)
		else :
			# Only increment if a unit is found, otherwise it isn't accurate (children.size() updates when removed)
			counter += 1

	# Pick a random unit
	return children[randi_range(1, children.size()) -1]

func clear_units():
	print(get_children())
	for child in get_children():
		child.is_unit = false
		child.reset_spritesheet()
		child.show()
		child.remove_target()

func set_speed(new_speed: float):
	# Loop through each unit and set its speed
	for child in get_children():
		child.speed = new_speed
