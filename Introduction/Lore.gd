extends Label

@export var lore: String = "My lore is pretty nifty":
	set(new_lore):
		set_lore(new_lore)
		lore = new_lore

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_lore(new_lore):
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 0.7)
	tween.tween_callback(show_lore.bind(new_lore))
	
func show_lore(new_lore):
	text = new_lore
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,1), 0.7)
