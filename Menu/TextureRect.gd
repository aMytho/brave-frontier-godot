extends TextureRect

var inactive = preload("res://Menu/Launch Icons/inactiveIcon.png")
var active = preload("res://Menu/Launch Icons/activeIcon.png")

@export var selectedItem:int = 0

@export var buttonPath: NodePath
@onready var buttons = get_node(buttonPath).get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_gui_input(event: Object):
	if event.get("double_click") == true:
		if selectedItem == 5:
			selectedItem = 0
		else:
			selectedItem = selectedItem + 1
		
		for icn in buttons:
			if selectedItem == icn.id:
				icn.set_texture(active)
			else:
				icn.set_texture(inactive)
		self.texture.set_current_frame(selectedItem)
		
		print("Done")
	elif event.get("pressed") == true:
		print("Loading sub menu")
		if selectedItem == 0:
			print("Loding vortex")
			get_tree().get_root().get_node("Game/GameContent").loadScene("res://Area/World/mistral.tscn")
		elif selectedItem == 1:
			print("Loading Quest")
			get_tree().get_root().get_node("Game/GameContent").loadScene("res://Menu/SubMenu/vortex.tscn")
