extends Control

# The current unit under attack. Will be used by parent nodes
@export var current_target: int = -1
#@export var random_target: int = -1

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
		elif current_target == target.place_ID:
			target.remove_target()
			current_target = -1
		else:
			# Set the current target
			current_target = id

func get_target():
	# Returns the target unit or a random unit if none is selected
	if current_target == -1:
		return get_random_target()
	return get_child(current_target - 1).position

func get_random_target():
	var children = get_children()
	var battleNode = get_parent()
	var unitArray = battleNode.zone.Stage[battleNode.current_stage-1].monsters
	
	# Remove any child that isn't a unit (empty slot)
	var counter = 0
	var unitCounter = 0
	while counter < children.size():
		if children[counter].is_unit == false or unitArray[unitCounter].is_dead:
			children.remove_at(counter)
		else :
			# Only increment if a unit is found, otherwise it isn't accurate (children.size() updates when removed)
			counter += 1
		unitCounter += 1
		
	var randomIndex = randi_range(1, children.size()) -1
	#random_target = randomIndex

	# Pick a random unit
	return children[randomIndex]

func clear_units():
	print(get_children())
	for child in get_children():
		child.is_unit = false
		child.reset_spritesheet()

func set_speed(new_speed: float):
	# Loop through each unit and set its speed
	for child in get_children():
		child.speed = new_speed
