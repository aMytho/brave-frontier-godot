extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var account = Database.query("SELECT * FROM player_state WHERE id==" + str(1))[0]
	ActiveAccount.set_account_info(account.id, account.player_name, account.level, account.current_exp,
	account.energy, account.gems, account.zel, account.karma, account.arena_orbs)



func _on_button_pressed():
	print("Base: ")
	print("Current:", ActiveAccount.current_exp, "Max:", ActiveAccount.max_exp, "Level:", ActiveAccount.level)
	
	print(ActiveAccount.will_player_level_up(5))
	ActiveAccount.add_exp(5)
	
	print("Modified: ")
	print("Current:", ActiveAccount.current_exp, "Max:", ActiveAccount.max_exp, "Level:", ActiveAccount.level)


func _on_button_2_pressed():
	print("Base: ")
	print("Current:", ActiveAccount.current_exp, "Max:", ActiveAccount.max_exp, "Level:", ActiveAccount.level)
	
	print(ActiveAccount.will_player_level_up(100))
	ActiveAccount.add_exp(100)
	
	print("Modified: ")
	print("Current:", ActiveAccount.current_exp, "Max:", ActiveAccount.max_exp, "Level:", ActiveAccount.level)
