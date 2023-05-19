extends TextureRect

signal Selected(place_id: int)

@export var place_id: int = 0
@export var is_leader: bool = false:
	set(new_is_leader):
		$Leader.visible = new_is_leader
		is_leader = new_is_leader

const symbolEnum = preload("res://Menu/SubMenu/Home/Characters/symbolEnum.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_properties(unit: Unit):
	# Display sprite sheet
	$Unit.sprite_frames = unit.sprite_sheet
	# Play Idle animation
	$Unit.play("Idle")
	# Display element
	symbolEnum.set_symbol_pos(unit.element.to_lower(), $Element)
	
	# Set labels
	$PanelInfo/AtkLbl.text = str(unit.ATK)
	$PanelInfo/CostLbl.text = str(unit.cost)
	$PanelInfo/DefLbl.text = str(unit.DEF)
	$PanelInfo/Hplbl.text = str(unit.HP)
	$PanelInfo/LvLbl.text = str(unit.level)
	$PanelInfo/RecLbl.text = str(unit.REC)

func _on_gui_input(event):
	
	emit_signal("Selected", place_id)
