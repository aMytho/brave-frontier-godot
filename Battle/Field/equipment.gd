extends AnimatedSprite2D

@export var unit_equipment: CharEquipment
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_properties(frames: SpriteFrames, equipment: CharEquipment, flip: bool):
	print(flip)
	# Set the initial sprite_frames and equipment data
	flip_h = flip
	unit_equipment = equipment
	self.sprite_frames = frames
	# The the initial values for the first (0) frame
	self.position = unit_equipment.frames[0].position
	self.rotation = unit_equipment.frames[0].rotation
	self.z_index = unit_equipment.frames[0].z_index


func _on_frame_changed():
	# Runs on every frame change. 0 is NOT included (starts at 1)
	# We only adjust the equipment if it is active, not waiting/shadow (waiting is waiting, shadow has 1 frame)
	var anim_name = get_animation()
	if anim_name == "Wait" or anim_name == "Shadow":
		return
	print(anim_name, unit_equipment.name, frame)
	# On each frame, dynamically adjust the equipment to match the current unit frame
	# Data must be set on the unit itself
	self.position = unit_equipment.frames[frame].position
	self.rotation = unit_equipment.frames[frame].rotation
	self.z_index = unit_equipment.frames[frame].z_index
	print("Equipment is changing", position, frame)


func _on_animation_finished():
	# When the animation is done, play the wait animation so no equipment is visible
	print("Anim over")
	play("Wait")
	# Reset the initial values
	self.position = unit_equipment.frames[0].position
	self.rotation = unit_equipment.frames[0].rotation
	self.z_index = unit_equipment.frames[0].z_index
