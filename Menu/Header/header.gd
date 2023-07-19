extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set props, connect signals
	$HeaderBG/Level.text = str(ActiveAccount.level)
	ActiveAccount.connect("LevelUpdated", _on_level_updated)
	# To-do - Raid orbs
	$HeaderBG/RC.text = str(1)
	
	$HeaderBG/Zel.text = str(ActiveAccount.zel)
	$HeaderBG/Karma.text = str(ActiveAccount.karma)
	$HeaderBG/Gems.text = str(ActiveAccount.gems)
	$HeaderBG/Account.text = ActiveAccount.player_name
	
	# To-do - Separate clan from name
	$HeaderBG/Clan.text = ActiveAccount.player_name
	
	# Set Energy
	var lvl_info = ActiveAccount.get_level_info(ActiveAccount.level)
	$HeaderBG/EnergyCounter.text = str(ActiveAccount.energy, "/", lvl_info.energy)
	$HeaderBG/EnergyBar.max_value = lvl_info.energy
	$HeaderBG/EnergyBar.value = ActiveAccount.energy
	$HeaderBG/Refill.set_properties(ActiveAccount.ENERGY_RECHARGE)
	ActiveAccount.connect("EnergyRecharged", _on_energy_recharged)
	
	# Set Exp
	$HeaderBG/ExpBar.max_value = lvl_info.next_exp
	$HeaderBG/ExpBar.value = ActiveAccount.current_exp
	ActiveAccount.connect("ExpUpdated", _on_exp_updated)

func _on_energy_recharged(new_energy: int):
	var lvl_info = ActiveAccount.get_level_info(ActiveAccount.level)
	$HeaderBG/EnergyCounter.text = str(new_energy, "/", lvl_info.energy)
	$HeaderBG/EnergyBar.value = ActiveAccount.energy
	$HeaderBG/Refill.reset_timer(ActiveAccount.ENERGY_RECHARGE)

func _on_exp_updated(current_exp: int, max_exp: int):
	$HeaderBG/ExpBar.value = max_exp
	$HeaderBG/ExpBar.value = current_exp

func _on_level_updated(new_lvl: int):
	$HeaderBG/Level.text = str(new_lvl)
