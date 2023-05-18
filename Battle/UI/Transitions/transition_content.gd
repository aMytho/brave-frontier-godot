extends ColorRect

@export var stage: int = 0
@export var total_stages: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_properties(new_stage, max_stages, dungeon_name: String, zone_name: String):
	# Sets the initial properties without showing the animations
	stage = new_stage
	total_stages = max_stages
	
	# Set the labels
	$CurrentProgressLbl.text = str(new_stage)
	$TotalProgressLbl.text = str(max_stages)
	# Set the bar. Don't show animation yet]
	$ProgressBar.max_value = max_stages
	$ProgressBar.value = new_stage
	# Set the stage names
	$Name/Dungeon.text = dungeon_name
	$Name/Stage.text = zone_name

func update_progress(new_stage: int):
	print("Setting transition value to ", new_stage)
	$CurrentProgressLbl.text = str(new_stage)
	# To-do: Animate the bar
	$ProgressBar.value = new_stage
