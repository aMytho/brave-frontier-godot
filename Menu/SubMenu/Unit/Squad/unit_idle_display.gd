extends Control

@onready var unit_sprite = $Unit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_properties(unit: Unit):
	# clear any other sprites
	reset()
	
	# Set the sprite sheet
	unit_sprite.sprite_frames = unit.sprite_sheet
	var frames = unit.sprite_sheet
	# For each piece of equipment, make a sprite for it
	for equipment_piece in unit.char_equipment:
		var new_sprite = ResourceLoader.load("res://Battle/Field/equipment.tscn").instantiate()
		new_sprite.set_properties(frames, equipment_piece, false)
		new_sprite.play(equipment_piece.name)
		# Add to tree
		unit_sprite.get_child(0).add_child(new_sprite)
	
	# Play the idle animation
	$Unit.play("Idle")


func reset():
	# Reset main unit
	unit_sprite.sprite_frames = null
	# Reset equipment
	for child in $Unit/IdleEquipmentContainer.get_children():
		child.queue_free()
