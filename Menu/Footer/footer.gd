@tool
extends Control

signal BtnClicked(id: int)

@export var footer_message: String = "Hello World!":
	set(msg):
		$Label.text = msg
		footer_message = msg

# Called when the node enters the scene tree for the first time.
func _ready():
	# Listen for all footer btn clicks
	for child in $FooterContainer.get_children():
		child.Clicked.connect(_footer_button_clicked)


func _footer_button_clicked(id: int):
	emit_signal("BtnClicked", id)
	print("Footer button with id", id, " was clicked")
