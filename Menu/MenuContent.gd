extends Control

@onready var current_scene = $Home

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_scene(scene: String, animation: int = 0):
	print("Loading sub menu ", scene)
	var new_scene = ResourceLoader.load(scene).instantiate()
	new_scene.position.y = 163
	
	var tween = create_tween()
	if animation == 0:
		tween.tween_property(current_scene, "position", Vector2(800, current_scene.position.y), 0.3)
		new_scene.position.x = 800
	else:
		tween.tween_property(current_scene, "modulate", Color(current_scene.modulate.r, current_scene.modulate.g, current_scene.modulate.b, 0.0), 0.1)
	
	#Delete the old scene and add the new
	tween.tween_callback(current_scene.queue_free)
	tween.tween_callback(add_child.bind(new_scene))
	#Animate new scene
	if animation == 0:
		tween.tween_property(new_scene, "position", Vector2(0, new_scene.position.y), 0.3)

	#Set the new scene
	current_scene = new_scene
