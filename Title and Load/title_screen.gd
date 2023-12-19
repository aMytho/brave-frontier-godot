extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Play BGM
	var music = $Music
	music.stream = load("res://Music/1-01 Song of the Hero.mp3")
	music.play()
	
	# Show account on account btn click
	$AccountBtn.Clicked.connect(show_accounts)
	
	# Allow randomization across the project
	randomize()


# When title clicked, load main menu or start a new account
func _on_touch_screen_gui_input(event):
	if event.get("pressed") == true:
		print("Starting the Game!")
		
		# If an account is not selected, start a new one
		if !ActiveAccount.account_is_active():
			get_node("%GameContent").loadScene("res://Introduction/introduction.tscn", true)
		else:
			# Load main menu since account is selected
			get_node("%GameContent").loadScene("res://Menu/main_menu.tscn", true)
		
		# Fade music
		var tween = create_tween()
		tween.tween_property($Music, "volume_db", -80.0, 3.0)


# Listens for keypress of letter A, shows accounts
func _input(event):
	if event is InputEventKey:
		print(event.keycode)
		if event.pressed and event.keycode == KEY_A:
			show_accounts(0)


func close_accounts(accounts: Node):
	accounts.queue_free()


func close_by_selection(acc: Node, _new_name: String, _id: int ):
	acc.queue_free()


func show_accounts(_id: int):
	print("Showing account selection screen")
	var accounts: Node = ResourceLoader.load("res://Menu/Accounts/account.tscn").instantiate()
	add_child(accounts)
	accounts.connect("NoSelection", close_accounts)
	accounts.connect("AccountSelected", close_by_selection)
