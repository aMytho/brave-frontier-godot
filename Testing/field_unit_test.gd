extends Node2D

@onready var sprite = $"Field Unit"

@export var unit: Unit = null

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.set_properties(unit, false, unit.char_equipment, unit.atk_equipment, unit.travel_equipment)


func _on_button_pressed():
	sprite.attack(Vector2(self.position.x - 200, self.position.y - 200))



func _on_button_2_button_up():
	var sp = $"Field Unit".get_child(0)
	sp.stop()
	sp.frame = int($TextEdit.text)
	var atk_kids = sp.get_child(2)
	for kid in atk_kids.get_children():
		kid.stop()
		kid.frame = int($TextEdit.text)
	
