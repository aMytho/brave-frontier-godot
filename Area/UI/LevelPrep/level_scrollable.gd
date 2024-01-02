extends ScrollContainer

signal ZoneSelected(level)

var zones: Array[Zone] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_level(dun: Dungeon):
	# Store a copy of the zones
	zones = dun.zones
	
	# For each zone, display it
	var index = 0
	for zone in dun.zones:
		if zone == null : continue
		# Don't show hidden zones (likely in development)
		if zone.is_visible == false:
			index = index + 1
			continue
		
		# Zone may require previous zone to be completed
		if zone.require_past_completion and _is_past_zone_complete(index - 1) == false:
			index = index + 1
			continue
		
		var selectable_level = ResourceLoader.load("res://Area/UI/level.tscn").instantiate()
		selectable_level.setProperties(zone)
		# When clicked, emit selection
		selectable_level.Clicked.connect(_on_zone_selected)
		get_child(0).add_child(selectable_level)
		
		index = index + 1
	
	# Add space after the last item so it isn't cut off
	get_child(0).add_spacer(false)


func _is_past_zone_complete(index: int) -> bool:
	# If the first zone is checked, this is negative. First is always available
	if index < 0:
		return true
	
	# Check that a previous zone exists and is complete
	if zones[index] != null and zones[index].is_complete:
		return true
	
	# Doesn't exist or not complete
	return false


func _on_zone_selected(zone):
	# Player clicked a zone
	emit_signal("ZoneSelected", zone)
