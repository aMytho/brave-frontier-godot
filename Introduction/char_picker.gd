extends ColorRect

signal CharSelected(unit: Unit)

@export var selected_index: int = 0:
	set(new_index):
		load_unit(new_index)
		selected_index = new_index


var units: Array[Unit] = [
	preload("res://Units/Res/1/1.tres"), # Vargas
	preload("res://Units/Res/5/5.tres"), # Selena
	preload("res://Units/Res/9/9.tres"), # Lance
	preload("res://Units/Res/13/13.tres"), # Eze
	preload("res://Units/Res/17/17.tres"), # Atro
	preload("res://Units/Res/21/21.tres") # Magress
]

# Called when the node enters the scene tree for the first time.
func _ready():
	load_unit(0)
	

func load_unit(index):
	#Fade out
	var tween = create_tween()
	tween.tween_property($Unit, "modulate", Color(1,1,1,0), 2.0)
	
	#Switch
	tween.tween_callback(switch_unit.bind(units[index].full_sprite, index))
	
func switch_unit(sprite, index):
	$Unit.texture = sprite
	
	#Fade in
	var tween_in = create_tween()
	tween_in.tween_property($Unit, "modulate", Color(1,1,1,1), 1)
	$Lore.lore = units[index].unit_lore


func _on_left_clicked():
	if selected_index - 1 < 0:
		selected_index = 5
	else:
		selected_index = selected_index -1


func _on_right_clicked():
	if selected_index + 1 > 5:
		selected_index = 0
	else:
		selected_index = selected_index + 1


func _on_button_clicked(_id):
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(0,0,0,0), 4.0)
	tween.tween_callback(emit_signal.bind("CharSelected", units[selected_index]))
