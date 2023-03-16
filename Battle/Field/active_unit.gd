extends AnimatedSprite2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attack():
	print("Attack animation")
	# to do - move torwards enemy
	play("Attack")


func _on_animation_finished():
	#attack finished, switch to idle
	play("Idle")
