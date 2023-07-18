extends Control

@export var units: Array[Unit] = []:
	set(new_units):
		units = new_units
		setCharacter()

@export var selected_enemy: Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Its ready")
	setCharacter()

func setCharacter():
	var count = 1
	for unit in units:
		print(unit)
		var charPath = str("Unit", count)
		if unit == null:
			print(null, " sadly")
			get_node(charPath).reset_placeholder()
		else:
			get_node(charPath).create_unit(unit.battle_thumbnail, unit.name, unit.element, unit.HP)
		count = count + 1

func set_selected_enemy_health(enemy_unit: Resource):
	selected_enemy = enemy_unit
	var prcent_hp = int(float(selected_enemy.HP) / selected_enemy.max_HP * 100)
	$EnemyHealth/HP.set_text("HP : %s%s" % [prcent_hp if 0 <= prcent_hp else 0, "%"])
	$EnemyHealth/Name.text = selected_enemy.name
	var enemy_health_bar = $EnemyHealth/HPBar
	enemy_health_bar.max_value = selected_enemy.max_HP
	enemy_health_bar.value = selected_enemy.HP

func release_attack_lockout():
	# allow each unit to attack again
	$Unit1.allow_attacks()
	$Unit2.allow_attacks()
	$Unit3.allow_attacks()
	$Unit4.allow_attacks()
	$Unit5.allow_attacks()
	$Unit6.allow_attacks()
