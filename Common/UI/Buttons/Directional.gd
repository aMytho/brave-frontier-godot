@tool
extends Button

signal Clicked

@export var direction: String = "Left":
	set(dir):
		direction = dir


# Called when the node enters the scene tree for the first time.
func _ready():
	set_direction(direction)


func set_direction(dir):
	if dir == "Left":
		icon = ResourceLoader.load("res://Common/UI/Buttons/Textures/left.tres")
	else:
		icon = ResourceLoader.load("res://Common/UI/Buttons/Textures/right.tres")


func _on_pressed():
	emit_signal("Clicked")
