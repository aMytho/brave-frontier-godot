extends Control

@export var new_level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print(ActiveAccount.get_level_info(new_level))
