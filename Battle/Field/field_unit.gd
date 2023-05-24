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
#Let the game know if the unit is dead or not
@export var is_dead: bool = false
# The sprite for the unit
@onready var sprite = $Sprite
# Store the equipment for the unit
@export var idle_equipment: Array[CharEquipment] = []
@export var attack_equipment: Array[CharEquipment] = []
# Used to allow the unit to return to their initial spot
var initial_position = Vector2(0,0)

var speed: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the target selection
	connect("input_event", _on_input_event)
	# Always find a way back home...
	initial_position = position

func set_properties(frames, flip: bool, use_shadow: bool, new_idle_equipment, new_attack_equipment):
	# Show the correct unit
	sprite.sprite_frames = frames
	
	# A unit is here!
	is_unit = true
	is_dead = false
	
	# Face the correct direction
	if flip:
		sprite.flip_h = true
		# Only enemies face this direction
		is_friendly = false
	
	# Show the shadow
	if use_shadow:
		# Set the position based on the height of the unit
		var shadow = $Sprite/Shadow
		shadow.sprite_frames = frames
		shadow.position.y = frames.get_frame_texture("Idle", 0).get_height() / 2
		#shadow.position.x = frames.get_frame_texture("Idle", 0).get_width() / 2
		shadow.play("Shadow")
	
	# For each piece of equipment, make a sprite and align it
	for equipment_piece in new_idle_equipment:
		print(equipment_piece)
		idle_equipment.append(equipment_piece)
		var new_sprite = AnimatedSprite2D.new()
		
		# Add to the tree
		$Sprite/EquipmentContainer.add_child(new_sprite)
		new_sprite.play("IdleEquipment")
	
	for equipment_piece in new_attack_equipment:
		# Store the piece
		attack_equipment.append(equipment_piece)
		# Load the equipment scene and set its properties
		var new_sprite = ResourceLoader.load("res://Battle/Field/equipment.tscn").instantiate()
		new_sprite.set_properties(frames, equipment_piece)
		new_sprite.play("Wait")
		# Add to tree
		$Sprite/AtkEquipmentContainer.add_child(new_sprite)
	# Play the idle animation
	sprite.play("Idle")


func reset_spritesheet():
	sprite.sprite_frames = null
	$Sprite/Shadow.sprite_frames = null

# This method move the attacking unit to the target unit (depending the position)
func attack(enemy_position: Vector2):
	print("Attack animation")
	# Move towards enemy
	var tween = create_tween()
	tween.tween_property(self, "position", enemy_position, 1.0 * speed)
	tween.tween_callback(_on_move_finished.bind(true))

func _on_move_finished(play_atk_animation: bool):
	# Plays an attack animation or returns home
	if play_atk_animation:
		sprite.play("Attack")
		var counter = 0
		for equipment in attack_equipment:
			$Sprite/AtkEquipmentContainer.get_child(counter).play(equipment.name)
	else:
		var tween = create_tween()
		tween.tween_property(self, "position", initial_position, 1.0 * speed)
		tween.tween_callback(_on_attack_finished)

func _on_attack_finished():
	emit_signal("AttackFinished", place_ID)

func _on_animation_finished():
	# Attack finished, switch to idle animatin
	sprite.play("Idle")
	# Move away from enemy
	_on_move_finished(false)

# This method remove the target of the unit (because the user select it again or the unit has died)
func remove_target():
	is_targeted = false
	$Target.visible = false

# This event is trigger when the user click on a unit.
# If it's an enemy unit (!is_friendly), this will add a target on it, if the unit is not dead
func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx):
	# Listen for clicks or taps
	# to do - allow number pad for unit target (1 targets unit1, 2 targets unit2, etc)
	if ((event is InputEventMouseButton and event.is_pressed()) or event is InputEventScreenTouch) and !is_friendly and !is_dead:
		is_targeted = true
		$Target.visible = true
		emit_signal("TargetSelected", place_ID)
