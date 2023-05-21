extends Control
# This file is very similar to enemies.gd.
# They should probably be merged at some point!

#@export var current_target: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_speed(new_speed: float):
	# loop through each unit and set its speed 
	for child in get_children():
		child.speed = new_speed
		
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
