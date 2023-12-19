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
	# Set the bar. Don't show animation yet.
	# The bar value is multiplied by 50 to show progression. Moving by 1 doesn't animated much
	$ProgressBar.max_value = max_stages * 50
	$ProgressBar.value = new_stage * 50
	# Set the sword at the position for stage 1
	# The bar is 88 pixels from the x=0. We allign it to the center of the sword (57/2=28)
	# 475 (bar length) is divided by the max stages to get each increment. We want the last position (max_stages-1)
	# The Y axis never changes (360)
	$CurrentProgressSword.position = Vector2(88 - 28 + ((475 / max_stages) * (max_stages - 1)), 360)
	# Set the stage names
	$Name/Dungeon.text = dungeon_name
	$Name/Stage.text = zone_name


func update_progress(new_stage: int):
	print("Setting transition value to ", new_stage)
	$CurrentProgressLbl.text = str(new_stage)
	# TODO: Animate the bar
	var bar_tween = create_tween()
	var sword_tween = create_tween()
	# Same as above, but we don't move half of the sword length and we move to the new_stage, instead of the max - 1
	var ending_position = 88 + (475 / total_stages) * (total_stages - new_stage)
	# Animate properties
	bar_tween.tween_property($ProgressBar, "value", new_stage * 50, 0.7)
	sword_tween.tween_property($CurrentProgressSword, "position", Vector2(ending_position, 360), 0.7)
