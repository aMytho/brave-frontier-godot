extends Node2D

@export var zone: Zone:
	set(new_zone):
		zone = new_zone
		$BG.texture = zone.BG

@export var units: Array[Unit] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#Pass in the units
	$BattleUI.units = units
	print(units)
