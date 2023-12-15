extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## Returns the first unit that isn't dead. Returns null if all are dead
func get_next_non_dead_unit(current_units: Array[Unit]):
	for unit in current_units:
		if null != unit and !unit.is_dead:
			return unit
	return null
