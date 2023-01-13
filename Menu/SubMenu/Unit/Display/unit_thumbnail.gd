extends Button
@export var unit: Unit

signal Clicked(unit: Unit)

func _on_pressed():
	emit_signal("Clicked", unit)
