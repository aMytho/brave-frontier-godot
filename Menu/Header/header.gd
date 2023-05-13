extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	#Set props
	var account = ActiveAccount.get_account_info()
	$TextureRect/Level.text = str(account[2])
	$TextureRect/RC.text = str(1)
	$TextureRect/Zel.text = str(account[7])
	$TextureRect/Karma.text = str(account[8])
	$TextureRect/Gems.text = str(account[6])
	$TextureRect/EnergyCounter.text = str(account[4], "/", 5)
	$TextureRect/Account.text = account[1]
	$TextureRect/Clan.text = account[1]
