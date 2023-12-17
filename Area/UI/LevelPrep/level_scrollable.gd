extends ScrollContainer

signal ZoneSelected(level) 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_level(dun: Dungeon):
	#For each zone, display it
	for zone in dun.zones:
		# Don't show hidden zones (likely in development)
		if zone.is_visible == false:
			continue
		
		var selectable_level = ResourceLoader.load("res://Area/UI/level.tscn").instantiate()
		selectable_level.setProperties(zone)
		# When clicked, emit up
		selectable_level.Clicked.connect(_on_zone_selected)
		get_child(0).add_child(selectable_level)
	# Add space after the last item so it isn't cut off (probably a bug)
	get_child(0).add_spacer(false)


func _on_zone_selected(zone):
	# Someone clicked a zone
	emit_signal("ZoneSelected", zone)
