extends Control

signal AccountSelected(acc: Node, account: String, id: int)
signal NoSelection(acc: Node)

# Called when the node enters the scene tree for the first time.
func _ready():
	%Close.pressed.connect(_close_button_clicked)
	
	#Load each account in the DB.
	var accounts = Database.query("SELECT * FROM player_state")
	for account in accounts:
		var acc = ResourceLoader.load("res://Menu/Accounts/account_entry.tscn").instantiate()
		acc.set_account_info(account.player_name, account.id)
		$ScrollContainer/BoxContainer.add_child(acc)
		acc.LoadAccount.connect(_on_account_selected)
		
func _close_button_clicked():
	emit_signal("NoSelection", self)

func _on_account_selected(id: int, name: String):
	print("Loading account with id:", id)
	var account = Database.query("SELECT * FROM player_state WHERE id==" + str(id))[0]
	ActiveAccount.set_account_info(account.id, account.player_name, account.level, account.exp,
	account.max_exp, account.energy, account.gems, account.zel, account.karma, account.arena_orbs)

	emit_signal("AccountSelected", self, name, id)
