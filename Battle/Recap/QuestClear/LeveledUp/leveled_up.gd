extends Control
signal LevelsComplete

@export var new_level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_level = ActiveAccount.get_level_info(new_level)
	var last_level = ActiveAccount.get_level_info(new_level -1 )
	# Display the data
	set_values(
		current_level.friends - last_level.friends, current_level.energy - last_level.energy,
		current_level.cost - last_level.cost
	)

func set_values(friends: int, energy: int, cost: int):
	# Set the label values
	$Lv/LvAmount.text = str(new_level)
	
	# Set labels, show in v box
	if friends != 0:
		$BenefitsContainer/Friend/FriendAmount.text = str(friends)
		$BenefitsContainer/Friend/FriendAmount.visible = true
	
	if energy != 0:
		$BenefitsContainer/Energy/EnergyAmount.text = str(energy)
		$BenefitsContainer/Energy/EnergyAmount.visible = true
	
	if cost != 0:
		$BenefitsContainer/Cost/CostAmount.text = str(cost)
		$BenefitsContainer/Cost/CostAmount.visible = true
	
	await get_tree().create_timer(5.0).timeout
	emit_signal("LevelsComplete")
