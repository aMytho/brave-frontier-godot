extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().get_node("Game/BackgroundMusic").emit_signal("startPlaying", "res://Music/1-19 HAZAMA.mp3")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
