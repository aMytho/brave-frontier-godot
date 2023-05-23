extends Node

signal FriendlyUnitHasTakenDamage(place_ID: int)

# Make the defUnit lost HP
# Right now, it only use the ATK stat of the atkUnit to reduce their HP
# But in the future, we could use DEF and buff from unit
func unit_taking_damage(atk_unit_atk: int, def_unit: Resource, friend_is_hurt: bool = false):
	def_unit.HP = def_unit.HP - atk_unit_atk
	if friend_is_hurt:
		emit_signal("FriendlyUnitHasTakenDamage", def_unit)

# Function call at the end of each turn
# It check if a every unit of a team (units) still have enought HP
# If not, it emit the signal "unitHasDied" which is catch by battle.gd
func are_all_units_dead(units: Array[Unit], field_units: Array[Node]):
	var unitLeft = 0
	var unit_counter = 0
	for unit in units:
		if null == unit:
			unit_counter += 1
			continue
		if 0 < unit.HP or 0 < field_units[unit_counter].time_being_targeted:
			unitLeft = unitLeft + 1
		unit_counter += 1
	return unitLeft
