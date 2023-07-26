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

func _on_back_section_clicked():
	# This needs to be a fade effect because the footer buttons are still visible.
	# It looks really weird if its a slide transition
	get_parent().load_scene("res://Menu/SubMenu/Unit/Display/view_units.tscn", 1, Vector2(0, 163))
