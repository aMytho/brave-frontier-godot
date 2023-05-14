extends AnimatedSprite2D

signal AttackFinished(id: int)
# Flag to let parent scenes check if a unit is in this slot
@export var is_unit = false
# Corresponds to the unit placement in unit_display
@export var place_ID: int = 0

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
	emit_signal("AttackFinished", place_ID)
