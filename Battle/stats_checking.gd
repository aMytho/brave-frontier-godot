extends Node

signal unitHasDied(place_ID: int)

func unitTakingDamage(atkUnit: Resource, defUnit: Resource):
	defUnit.HP = defUnit.HP - atkUnit.ATK

func areUnitsDead(units: Array[Unit], isAllyUnits: bool = false):
	var unitLeft = 0
	var unitCount = 0
	for unit in units:
		unitCount += 1
		if null == unit:
			continue
		if 0 >= unit.HP:
			unit.is_dead = true
			emit_signal("unitHasDied", unitCount, isAllyUnits)
			print("The unit is dead")
		else:
			unitLeft = unitLeft + 1
			print("The unit is NOT dead")
	return unitLeft
