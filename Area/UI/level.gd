extends Control

signal Clicked(zn: Zone)

@export var zone: Zone = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_level_select_button_pressed():
	emit_signal("Clicked", zone)

func setProperties(zn: Zone):
	%LevelSelectButton/Label.text = zn.description
	%LevelSelectButton/BattleCount.text = str(zn.stages)
	%LevelSelectButton/EnergyAmount.text = str(zn.energy)
	%LevelSelectButton/LevelName.text = zn.name
	zone = zn
