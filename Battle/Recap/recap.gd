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
	var arg_names = ["sparks", "crits", "hc", "bc"]
	var arg_vals = [111, 222, 333, 444]
	$content_switcher.load_scene_with_props("res://Battle/Recap/QuestClear/CombatStats/combat_stats.tscn", 1, arg_names, arg_vals)
