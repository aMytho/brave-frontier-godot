extends Node

signal UnitHasDied(place_ID: int)

# Make the defUnit lost HP
# Right now, it only use the ATK stat of the atkUnit to reduce their HP
# But in the future, we could use DEF and buff from unit
func unit_taking_damage(atkUnit: Resource, defUnit: Resource):
	defUnit.HP = defUnit.HP - atkUnit.ATK

# Function call at the end of each turn
# It check if a every unit of a team (units) still have enought HP
# If not, it emit the signal "unitHasDied" which is catch by battle.gd
func are_units_dead(units: Array[Unit], isAllyUnits: bool = false):
	var unitLeft = 0
	var unitCount = 0
	for unit in units:
		unitCount += 1
		if !isAllyUnits:
			print(unit)
		if null == unit:
			continue
		if 0 >= unit.HP:
			unit.is_dead = true
			emit_signal("UnitHasDied", unitCount, isAllyUnits)
			print("The unit is dead")
		else:
			unitLeft = unitLeft + 1
			print("The unit is NOT dead")
	return unitLeft
