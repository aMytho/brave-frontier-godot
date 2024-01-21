extends Control

var area: Area:
	set(new_area):
		area = new_area
		show_area()

var header: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.get_node("Game").get_child(0).emit_signal("startPlaying", "res://Music/1-03 Frontier.mp3")


func show_area():
	# Load the background if one exists
	if area.background != null:
			$Background.texture = area.background
	show_dungeons()


func show_dungeons():
	for dungeon in area.dungeons:
		var btn = _create_dungeon_button(dungeon)
		$Background.add_child(btn)


# Create dungeon button, assign text/position, listen for click
func _create_dungeon_button(dungeon: DungeonPlacement) -> Button:
	var btn = ResourceLoader.load("res://Area/Areas/dungeon_placement_button.tscn").instantiate()
	btn.text = dungeon.name
	btn.position = dungeon.coordinates
	btn.connect("button_down", _on_dungeon_selected.bind(dungeon.dungeon))
	
	return btn


func _on_dungeon_selected(dungeon: Dungeon):
	print("Loading zones for: ", dungeon.name)
	
	# Lod the header, level loader, and area
	header = ResourceLoader.load("res://Menu/Header/header.tscn").instantiate()
	var level_loader = ResourceLoader.load("res://Area/UI/level_select.tscn").instantiate()
	var res = load(dungeon.resource_path)
	
	level_loader.get_node('TextureRect').get_node('AreaName').text = dungeon.name

	# Display header and level loader, set its position
	add_child(header)
	add_child(level_loader)
	level_loader.position.y = 163
	# Load the dungeon's zones
	level_loader.dungeon = res
	
	# Toggle it
	toggle_zone_selector(true)
	
	# Handle scene deletion
	var callable = Callable(self, "on_levels_selector_closed")
	level_loader.connect("Closed", callable)


func on_levels_selector_closed():
	# Close the header
	toggle_zone_selector(false)


func toggle_zone_selector(should_hide = false):
	if should_hide:
		# Darken Background
		get_child(0).self_modulate = Color(0.23, 0.23, 0.23, 1.0)
		# Hide children buttons
		for btn in get_child(0).get_children():
			btn.hide()
	else:
		# Lighten Background
		get_child(0).self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		# Show children buttons
		for btn in get_child(0).get_children():
			btn.show()
		header.queue_free()
