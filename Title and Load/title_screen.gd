extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# play BGM
	var music = $Music
	music.stream = load("res://Music/1-01 Song of the Hero.mp3")
	music.play()
	
	#Listen to account btn press
	$AccountBtn.Clicked.connect(show_accounts)
	
	# Allow randomization across the project
	randomize()

func _on_touch_screen_gui_input(event):
	if event.get("pressed") == true:
		print("Starting the Game!")
		if !ActiveAccount.account_is_active():
			get_node("%GameContent").loadScene("res://Introduction/introduction.tscn", true)
		else:
			get_node("%GameContent").loadScene("res://Menu/main_menu.tscn", true)
		var tween = create_tween()
		tween.tween_property($Music, "volume_db", -80.0, 3.0)

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
