extends Button

signal Clicked(id: int)

@export var button_content: CompressedTexture2D:
	set(res):
		icon = res

@export var id: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#Emits the signal with the ID. The parent entered the ID so it knows which was clicked
func _on_pressed():
	emit_signal("Clicked", id)
