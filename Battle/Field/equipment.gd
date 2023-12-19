extends AnimatedSprite2D

## Is the sprite flipped?
@export var is_flipped: bool = false
## The equipment of the unit
@export var unit_equipment: CharEquipment

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_properties(frames: SpriteFrames, equipment: CharEquipment, flip: bool):
	# Set the initial sprite_frames and equipment data
	unit_equipment = equipment
	sprite_frames = frames

	# Set the flip data
	flip_h = flip
	is_flipped = flip
	
	# The the initial values for the first (0) frame. Flip sprite if neccassary
	if is_flipped:
		position.x = unit_equipment.frames[0].position.x * -1
		position.y = unit_equipment.frames[0].position.y
	else:
		position = unit_equipment.frames[0].position
	# Set the initial rotation and z_index. Not affected by flipping
	rotation = unit_equipment.frames[0].rotation
	z_index = unit_equipment.frames[0].z_index


func _on_frame_changed():
	# Runs on every frame change. 0 is NOT included (starts at 1)
	# We only adjust the equipment if it is active, not waiting/shadow (waiting is waiting, shadow has 1 frame)
	var anim_name = get_animation()
	if anim_name == "Wait" or anim_name == "Shadow":
		return
		
	# On each frame, dynamically adjust the equipment to match the current unit frame
	# That data must be set on the unit equipment itself
	if is_flipped:
		position.x = unit_equipment.frames[frame].position.x * -1
		position.y = unit_equipment.frames[frame].position.y
	else:
		position = unit_equipment.frames[frame].position
	rotation = unit_equipment.frames[frame].rotation
	z_index = unit_equipment.frames[frame].z_index


func _on_animation_finished():
	# When the animation is done, play the wait animation so no equipment is visible
	print("Anim over")
	play("Wait")
	# Reset the initial values
	if is_flipped:
		position.x = unit_equipment.frames[0].position.x * -1
		position.y = unit_equipment.frames[0].position.y
	else:
		position = unit_equipment.frames[0].position
	rotation = unit_equipment.frames[0].rotation
	z_index = unit_equipment.frames[0].z_index
