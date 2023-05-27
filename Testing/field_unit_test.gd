extends Node2D

@onready var sprite = $"Field Unit"

@export var unit: Unit = null

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.set_properties(unit, false, unit.char_equipment, unit.atk_equipment, unit.travel_equipment)


func _on_button_pressed():
	sprite.attack(Vector2(self.position.x - 200, self.position.y - 200))
