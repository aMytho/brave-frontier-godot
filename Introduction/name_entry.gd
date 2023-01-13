extends ColorRect

signal NameChosen(name: String)

var first_time = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_button_pressed():
	var input = $TextEdit.text
	if len(input) > 0:
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(0,0,0,0), 4.0)
		tween.tween_callback(emit_signal.bind("NameChosen", input))


func _on_text_edit_focus_entered():
	print(1)
	if first_time == true:
		first_time = false
		var tween = create_tween()
		tween.tween_property($Button, "modulate", Color(1,1,1,1), 1.5)
