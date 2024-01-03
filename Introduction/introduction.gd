extends Control

var count = 0
var player_name = ""
var player_id: int
var main_character: Unit = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.stream = load("res://Music/3-01 World of God.mp3")
	$Music.play()
	var intro = load("res://Area/Creation/creator.tscn").instantiate()
	intro.messages = [
		"I am Lucius, the god who controls this gate..",
		"I have been waiting for the day you would come..",
		"O Chosen One. What is your name?"
	]
	print("Intro scene messages:", intro.messages)
	add_child(intro)
	intro.connect("FlashComplete", _on_flash_complete)


func _on_flash_complete():
	if count == 0:
		var name_picker = load("res://Introduction/name_entry.tscn").instantiate()
		add_child(name_picker)
		name_picker.connect("NameChosen", _on_name_chosen)
	elif count == 1:
		var char_picker = load("res://Introduction/char_picker.tscn").instantiate()
		add_child(char_picker)
		char_picker.connect("CharSelected", _on_char_chosen)
	else:
		var tutorial = load("res://Introduction/wake_up.tscn").instantiate()
		tutorial.content = player_name
		add_child(tutorial)
		tutorial.connect("ImAwake", _on_wake_up)
		var tween = create_tween()
		tween.tween_property($Music, "volume_db", -80.0, 3.0)
		tween.tween_callback($Music.stop)
	count += 1


func _on_name_chosen(nm: String):
	player_name = nm
	remove_child($Creator)
	
	var intro = load("res://Area/Creation/creator.tscn").instantiate()
	var msg1 = str(player_name, " ...")
	intro.messages = [
		msg1,
		"Rely on your own power. Summon your hero",
	]
	add_child(intro)
	intro.connect("FlashComplete", _on_flash_complete)


func _on_char_chosen(character: Unit):
	print("The summoner picked the starter unit:", character)
	main_character = character
	remove_child($Creator)
	
	var intro = load("res://Area/Creation/creator.tscn").instantiate()
	intro.messages = [
		"Let go. May your power be the gospel of this world. Keep moving forward...",
	]
	add_child(intro)
	intro.connect("FlashComplete", _on_flash_complete)
	
	# Save the changes
	# Add player, get unique ID
	Database.query("INSERT INTO player_state ( arena_orbs, karma, zel, gems, energy, current_exp, level, player_name ) VALUES ( 3, 100, 100, 5, 5, 0, 1, '%s' );" % player_name)
	player_id = Database.query("SELECT id from player_state WHERE player_name == '%s'" % player_name)[0].id
	
	# Add starter units, get unit id
	Database.query(
		"INSERT INTO units (account_id, unit_id, level, hp, atk, def, rec) VALUES (%s, %s, %s, %s, %s, %s, %s)"
		% [player_id, character.unit_number, character.level, character.HP, character.ATK, character.DEF, character.REC])
	
	# Mark first 2 zones as always visible
	Database.query(
		"INSERT INTO zones (player_id, zone_id, is_complete) VALUES (%s, 1, 1)"
		% player_id
	)
	Database.query(
		"INSERT INTO zones (player_id, zone_id, is_complete) VALUES (%s, 1, 2)"
		% player_id
	)
	
	# Set the active account
	var account = Database.query("SELECT * FROM player_state WHERE id==" + str(player_id))[0]
	ActiveAccount.set_account_info(account.id, account.player_name, account.level, account.current_exp,
	account.energy, account.gems, account.zel, account.karma, account.arena_orbs)


func _on_wake_up():
	print("Summoner is awake, start tutorial 1")
	
	# Load other starter units
	var sparky:Unit = load("res://Units/Res/49/49.tres")
	var burny:Unit = load("res://Units/Res/43/43.tres")
	
	# Add units to unit table
	Database.query(
		"INSERT INTO units (account_id, unit_id, level, hp, atk, def, rec) VALUES (%s, %s, %s, %s, %s, %s, %s), (%s, %s, %s, %s, %s, %s, %s)"
		% [
			player_id, burny.unit_number, burny.level, burny.HP, burny.ATK, burny.DEF, burny.REC,
			player_id, sparky.unit_number, sparky.level, sparky.HP, sparky.ATK, sparky.DEF, sparky.REC
		])
	
	# Get units id so we can add to team
	var units_ids = Database.query("SELECT id FROM units WHERE account_id == %s" % player_id)
	print(units_ids)
	
	# Add to team
	Database.query(
		"INSERT INTO teams (name, unit1, unit2, unit3, account_id, leader) VALUES ('Default', %s, %s, %s, %s, 2)"
		% [units_ids[1].id, units_ids[0].id, units_ids[2].id, player_id]
	)
	
	# Load the battle scene, insert units. The journey begins!
	var zone = ResourceLoader.load("res://Area/Areas/Mistral/AdventurePrairie/Zones/basics_of_battle.tres")
	var arg1 = ["zone", "units"]
	var subArg: Array[Unit] = [burny, main_character, sparky, null, null, null]
	# Get a unique instance for every monster in the stage
	for stage in zone.stage:
		var enemies_list: Array[Unit] = []
		for unit in stage.monsters:
			if null != unit:
				enemies_list.append(Lookups.get_unit_by_unit_number(unit.unit_number)["unit"])
			else:
				enemies_list.append(null)
		stage.monsters = enemies_list
	var arg2 = [zone, subArg]
	get_tree().get_root().get_node("Game/GameContent").loadSceneWithProps("res://Area/Zones/zone.tscn", arg1, arg2)
