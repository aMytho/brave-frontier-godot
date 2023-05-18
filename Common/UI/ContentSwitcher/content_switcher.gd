extends Control

signal Switched(scn: Node)

@export var current_scene: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_scene(scene: String, animation: int, new_scene: Control = null):
	print("Switching current scene to: ", scene)
	if null == new_scene :
		new_scene = ResourceLoader.load(scene).instantiate()

	#Swap scenes
	animate_swap(new_scene, animation)

	#Set the new scene
	current_scene = new_scene
	
	#Let any listeners know we switched a scene. Usually, they will get the scene and set data
	emit_signal("Switched", current_scene)

func load_scene_home(scene: String, animation: int = 0):
	var new_scene = ResourceLoader.load(scene).instantiate()
	new_scene.position.y = 163
	load_scene(scene, animation, new_scene)

func load_scene_home_with_props(scene: String, animation: int, keys, vals):
	print("Switching home scene with properties to: ", scene)
	var new_scene = ResourceLoader.load(scene).instantiate()
	new_scene.position.y = 163
	
	#Set props
	var count = 0
	for key in keys:
		new_scene[key] = vals[count]
		count = count + 1
	
	load_scene(scene, animation, new_scene)

func load_scene_with_props(scene: String, animation: int, keys, vals):
	print("Switching to the following scene with properties: ", scene)
	var new_scene = ResourceLoader.load(scene).instantiate()
	
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

# Returns active scene
func get_scene():
	return current_scene
