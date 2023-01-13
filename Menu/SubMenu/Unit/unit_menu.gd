extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	#Get each unit button click events
	var count = 1
	while count < 7:
		get_node(str("Button", count)).Clicked.connect(_on_button_pressed)
		count += 1
	#Get back button click event
	$BackSection.Clicked.connect(_on_back_pressed)

func _on_button_pressed(button: int):
	#Load the related submenu
	match button:
		1:
			get_parent().load_scene("res://Menu/SubMenu/Unit/Display/view_units.tscn")

func _on_back_pressed():
	get_parent().load_scene("res://Menu/SubMenu/Home/home.tscn")
