extends Area2D

signal AttackFinished(id: int)
signal TargetSelected(id: int)
# Flag to let parent scenes check if a unit is in this slot
@export var is_unit = false
# Corresponds to the unit placement in unit_display
@export var place_ID: int = 0
# Is the unit currently being targeted?
@export var is_targeted: bool = false
# Is this our unit, or an enemy?
@export var is_friendly: bool = true
# The sprite for the unit
@onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the target selection
	connect("input_event", _on_input_event)

func set_properties(frames, flip):
	# Show the correct unit
	sprite.sprite_frames = frames
	
	# A unit is here!
	is_unit = true
	
	# Face the correct direction
	if flip:
		sprite.flip_h = true
		# Only enemies face this direction
		is_friendly = false
	
	# Play the idle animation
	sprite.play("Idle")

func attack():
	print("Attack animation")
	# to do - move torwards enemy
	sprite.play("Attack")

func _on_animation_finished():
	#attack finished, switch to idle
	sprite.play("Idle")
	emit_signal("AttackFinished", place_ID)

func remove_target():
	is_targeted = false
	$Target.visible = false

func _on_input_event(viewport: Viewport, event: InputEvent, shape_idx):
	# Listen for clicks or taps
	# to do - allow number pad for unit target (1 targets unit1, 2 targets unit2, etc)
	if ((event is InputEventMouseButton and event.is_pressed()) or event is InputEventScreenTouch) and !is_friendly:
		is_targeted = true
		$Target.visible = true
		emit_signal("TargetSelected", place_ID)
