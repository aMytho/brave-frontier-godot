extends Control

signal ResultComplete

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_victory():
	# Display the victory animations
	$BigBG.visible = true
	$MedBG.visible = true
	$SmallBG.visible = true
	$TopLetters.visible = true
	$AreaCleared.visible = true
	# Play animation
	$AnimationPlayer.play("Victory")

func play_failure():
	# The failure animation is already visible, play it
	$AnimationPlayer.play("Loss")

func _on_animation_player_animation_finished(_anim_name):
	# Listen for the animation completion. When done, the parent scene will fade out
	emit_signal("ResultComplete")
