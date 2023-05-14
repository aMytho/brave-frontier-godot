extends Control

@export var units: Array[Unit] = []:
	set(new_units):
		units = new_units
		setCharacter()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Its ready")
	setCharacter()

func setCharacter():
	var count = 1
	for unit in units:
		print(unit)
		var charPath = str("Unit", count)
		if unit == null:
			print(null, " sadly")
			get_node(charPath).reset_placeholder()
		else:
			get_node(charPath).create_unit(unit.battle_thumbnail, unit.name, unit.element, unit.HP)
		count = count + 1

func release_attack_lockout():
	# allow each unit to attack again
	$Unit1.allow_attacks()
	$Unit2.allow_attacks()
	$Unit3.allow_attacks()
	$Unit4.allow_attacks()
	$Unit5.allow_attacks()
	$Unit6.allow_attacks()
