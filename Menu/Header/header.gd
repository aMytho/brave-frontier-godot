extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	#Set props
	$TextureRect/Level.text = str(ActiveAccount.level)
	$TextureRect/RC.text = str(1)
	$TextureRect/Zel.text = str(ActiveAccount.zel)
	$TextureRect/Karma.text = str(ActiveAccount.karma)
	$TextureRect/Gems.text = str(ActiveAccount.gems)
	$TextureRect/EnergyCounter.text = str(ActiveAccount.energy, "/", 5)
	$TextureRect/Account.text = ActiveAccount.player_name
	$TextureRect/Clan.text = ActiveAccount.player_name
