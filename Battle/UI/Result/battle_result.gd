extends Control

signal ResultComplete

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_victory():
	$AnimationPlayer.play("Victory")

# To-do: play failure, need to find an example on an archive
# Nobody posts losses :(

func _on_animation_player_animation_finished(anim_name):
	# Listen for the animation completion. When done, the parent scene will fade out
	emit_signal("ResultComplete")
