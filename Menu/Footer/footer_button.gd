@tool
extends Button

@export var button: CompressedTexture2D:
	set(btn):
		icon = btn
		button = btn

@export var id: int = 0
signal Clicked(id: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_pressed():
	emit_signal("Clicked", id)
