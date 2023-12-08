extends Button
@export var unit: Unit

## Wrapper for the on_pressed signal
signal Clicked(unit: Unit)

func _on_pressed():
	emit_signal("Clicked", unit)
