extends Control
signal LevelsComplete

@export var new_level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get level data
	var current_level = ActiveAccount.get_level_info(new_level)
	# Handle new players that start at level 1. This prevents a crash by not searching for lvl 0
	var last_level
	if new_level - 1 == 0:
		last_level = ActiveAccount.get_level_info(1)
	else:
		last_level = ActiveAccount.get_level_info(new_level - 1)
	
	# Hide any previous level data
	$BenefitsContainer/Friend.visible = false
	$BenefitsContainer/Energy.visible = false
	$BenefitsContainer/Cost.visible = false
	
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
		$BenefitsContainer/Friend.visible = true
	
	if energy != 0:
		$BenefitsContainer/Energy/EnergyAmount.text = str(energy)
		$BenefitsContainer/Energy.visible = true
	
	if cost != 0:
		$BenefitsContainer/Cost/CostAmount.text = str(cost)
		$BenefitsContainer/Cost.visible = true
	
	await get_tree().create_timer(5.0).timeout
	emit_signal("LevelsComplete")
