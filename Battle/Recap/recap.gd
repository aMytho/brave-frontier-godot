extends Control

@export var zone: Zone = null
@export var dungeon_name: String = ""
@export var rewards: Array = []
@export var friend: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# Play Music
	$AudioStreamPlayer.play()
	
	# set initial values
	$Dungeon.text = dungeon_name
	$Zone.text = '"' + zone.name + '"'
	
	# Load the rewards scene in the content switcher
	# To-do: Get the actual rewards to display them
	var arg_names = ["zel", "karma", "xp"]
	var arg_vals = [111, 222, 333]
	$content_switcher.load_scene_with_props("res://Battle/Recap/QuestClear/quest_clear.tscn", 0, arg_names, arg_vals)
	$content_switcher.get_scene().connect("RewardsComplete", _on_rewards_complete)

func _on_rewards_complete():
	# Show the reward screen with demo rewards
	var arg_names = ["materials"]
	var arg_vals = [[
		{"name": "leaf", "img": ResourceLoader.load("res://Items/102/item_thum_102.png")},
		{"name": "leaf", "img": ResourceLoader.load("res://Items/102/item_thum_102.png")},
		{"name": "leaf", "img": ResourceLoader.load("res://Items/102/item_thum_102.png")},
		]]
	$content_switcher.load_scene_with_props("res://Battle/Recap/Rewards/Materials/materials.tscn", 0, arg_names, arg_vals)
	$content_switcher.get_scene().connect("MaterialsComplete", _on_materials_complete)

func _on_materials_complete():
	print("Unit time!")
	var arg_names = ["units"]
	var arg_vals = [[
		Lookups.get_unit_by_unit_number(5), Lookups.get_unit_by_unit_number(49), Lookups.get_unit_by_unit_number(53)
		]]
	$content_switcher.load_scene_with_props("res://Battle/Recap/Rewards/Units/units.tscn", 0, arg_names, arg_vals)
	$content_switcher.get_scene().connect("UnitsComplete", _on_units_complete)

func _on_units_complete():
	print("Done?")
