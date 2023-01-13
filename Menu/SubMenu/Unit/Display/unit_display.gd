extends Control

@export var unit: Unit = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Type.value = "Guardian"
	$Lv.value = "150 / 150"
	$NextLv.value = "_ _ _"
	$Hp.value = str(unit.HP)
	$Atk.value = str(unit.ATK)
	$Def.value = str(unit.DEF)
	$Rec.value = str(unit.REC)
	$Cost.value = str(unit.cost)
	$Sp.value = "100"
	$Item1Frame.value = "Empty"
	$Item2Frame.value = "Empty"
	$Character.texture = unit.full_sprite
