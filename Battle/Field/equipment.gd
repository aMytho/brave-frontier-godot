extends AnimatedSprite2D

@export var unit_equipment: CharEquipment

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_properties(frames: SpriteFrames, equipment: CharEquipment):
	# Set the initial sprite_frames and equipment data
	unit_equipment = equipment
	self.sprite_frames = frames


func _on_frame_changed():
	# On each frame, dynamically adjust the equipment to match the current unit frame
	# Data must be set on the unit itself@
	self.position = unit_equipment.frames[frame].position
	self.rotation = unit_equipment.frames[frame].rotation
	self.z_index = unit_equipment.frames[frame].z_index
	print("Equipment is changing")
