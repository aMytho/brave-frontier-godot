extends Node2D

@export var zone: Zone:
	set(new_zone):
		zone = new_zone
		$BG.texture = zone.BG

@export var units: Array[Unit] = [null, null, null, null, null, null]
@export var enemies: Array[Unit] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#Pass in the units
	$BattleUI.units = units
	
	$BattleUI/Unit1.Attack.connect(_unit_attack)
	$BattleUI/Unit2.Attack.connect(_unit_attack)
	$BattleUI/Unit3.Attack.connect(_unit_attack)
	$BattleUI/Unit4.Attack.connect(_unit_attack)
	$BattleUI/Unit5.Attack.connect(_unit_attack)
	$BattleUI/Unit6.Attack.connect(_unit_attack)
	
	# get the parent node
	var battle_UI = $Friendlies
	# Display each unit on the field and start idle animations
	for i in range(battle_UI.get_child_count()):
		if i < units.size() and units[i] != null:
			var child_node = battle_UI.get_child(i)
			child_node.sprite_frames = units[i].sprite_sheet
			child_node.play("Idle")

func _unit_attack(unit_place: int):
	var path = str("./Friendlies/Unit", unit_place)
	print(path)
	get_node(path).attack()
