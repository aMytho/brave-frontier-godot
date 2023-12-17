extends Control

signal Clicked(zn: Zone)

@export var zone: Zone = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Update the UI if the player gets more energy
	ActiveAccount.connect("EnergyRecharged", can_start_level)

func _on_level_select_button_pressed():
	emit_signal("Clicked", zone)

func setProperties(zn: Zone):
	%LevelSelectButton/Label.text = zn.description
	%LevelSelectButton/BattleCount.text = str(len(zn.stage))
	%LevelSelectButton/EnergyAmount.text = str(zn.energy)
	%LevelSelectButton/LevelName.text = zn.name
	zone = zn
	
	can_start_level(ActiveAccount.energy)

func can_start_level(new_energy: int):
	# If the player doesn't have enough energy, disable the button
	if new_energy < zone.energy:
		# Dim the level
		modulate = Color(0.2,0.2,0.2, 1)
		# Change the cursor to a disabled one
		$LevelSelectButton.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
		# Show a disabled message
		$LevelSelectButton.tooltip_text = "You do not have enough energy to start this zone!"
		# Disable the button
		$LevelSelectButton.disabled = true
	else:
		modulate = Color(1,1,1,1)
		$LevelSelectButton.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		$LevelSelectButton.tooltip_text = ""
		$LevelSelectButton.disabled = false
