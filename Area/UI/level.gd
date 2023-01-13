extends Control

signal Clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_level_select_button_pressed():
	emit_signal("Clicked")


func setProperties(level: String, energy:int, battles:int,status:String, description:String):
	%LevelSelectButton/Label.text = description
	%LevelSelectButton/BattleCount.text = str(battles)
	%LevelSelectButton/EnergyAmount.text = str(energy)
	%LevelSelectButton/LevelName.text = level
