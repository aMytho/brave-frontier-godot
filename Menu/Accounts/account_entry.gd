extends Control

signal LoadAccount(id: int, name: String)
@export var id = 0
@export var acc_name: String = "null"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Load.pressed.connect(_on_account_selected)

func set_account_info(name: String, id: int):
	$Label2.text = name
	self.id = id
	self.name = name

func _on_account_selected():
	emit_signal("LoadAccount", id, name)
