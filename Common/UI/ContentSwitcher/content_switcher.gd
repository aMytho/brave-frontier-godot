extends Control

signal Switched(scn: Node)

# Animations - 
# 0 is slide, 1 is fade
# To-do: make that an enum

@export var current_scene: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func load_scene(scene: String, animation: int, new_position: Vector2 = Vector2(0,0)):
	print("Switching current scene to: ", scene)

	# Create the scene based on the path
	var new_scene = ResourceLoader.load(scene).instantiate()
	new_scene.position = new_position

	# Swap scenes
	animate_swap(new_scene, animation)

	# Set the new scene
	current_scene = new_scene

	# Let any listeners know we switched a scene. Usually, they will get the scene and set data
	emit_signal("Switched", current_scene)


func load_scene_with_props(scene: String, animation: int, keys, vals, pos: Vector2 = Vector2(0,0)):
	print("(With props) Switching current scene to: ", scene)
	var new_scene = ResourceLoader.load(scene).instantiate()
	new_scene.position = pos
	
	#Set props
	var count = 0
	for key in keys:
		new_scene[key] = vals[count]
		count = count + 1

	#Swap scenes
	animate_swap(new_scene, animation)

	#Set the new scene
	current_scene = new_scene
	
	#Let any listeners know we switched a scene. Usually, they will get the scene and set data
	emit_signal("Switched", current_scene)


func animate_swap(new_scene, animation: int):
	var tween = create_tween()
	# Only animate scene exit if there is really a scene!
	if current_scene != null:
		# Number determines animation type
		if animation == 0:
			tween.tween_property(current_scene, "position", Vector2(800, current_scene.position.y), 0.3)
			new_scene.position.x = 800
		else:
			tween.tween_property(current_scene, "modulate", Color(current_scene.modulate.r, current_scene.modulate.g, current_scene.modulate.b, 0.0), 0.1)
	
		#Delete the old scene and add the new
		tween.tween_callback(current_scene.queue_free)
		tween.tween_callback(add_child.bind(new_scene))
	else:
		add_child(new_scene)
	# Animate new scene entrance
	if animation == 0:
		tween.tween_property(new_scene, "position", Vector2(0, new_scene.position.y), 0.3)


# Loads a blank scene so another scene can be animated in
func _set_blank_scene():
	load_scene("res://Common/UI/ContentSwitcher/blank.tscn", 0)


# Returns active scene
func get_scene():
	return current_scene
