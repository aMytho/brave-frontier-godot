extends Node2D

@export var loadingMessage: String = "Loading"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the loading message
	get_child(2).text = loadingMessage + "..."
