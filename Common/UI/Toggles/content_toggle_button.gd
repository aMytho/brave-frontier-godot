extends TextureRect

signal Clicked(id: int)

@export var id: int = 0
## Off by default
@export var active: bool = false
# Icons are set via inspector
@export var icon_on = preload("res://Menu/Launch Icons/activeIcon.png")
@export var icon_off = preload("res://Menu/Launch Icons/inactiveIcon.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func turn_on():
	texture = icon_on
	active = true
	print("Content toggle on")


func turn_off():
	texture = icon_off
	active = false
	print("Content toggle off")
