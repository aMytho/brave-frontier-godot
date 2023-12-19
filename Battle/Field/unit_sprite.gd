extends AnimatedSprite2D

signal AnimationFinished(anim_name: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_animation_finished():
	# Emit the name of the finished animation
	emit_signal("AnimationFinished", get_animation())
