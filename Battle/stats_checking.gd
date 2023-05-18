extends Node

signal unitHasDied(place_ID: int)

func unitTakingDamage(atkUnit: Resource, defUnit: Resource):
	defUnit.HP = defUnit.HP - atkUnit.ATK

func areUnitsDead(units: Array[Unit]):
	var unitLeft = 0
	var unitCount = 1
	for unit in units:
		if null == unit:
			continue
		if 0 >= unit.HP:
			unit.is_dead = true
			emit_signal("unitHasDied", unitCount)
			print("The unit is dead")
		else:
			unitLeft = unitLeft + 1
			print("The unit is NOT dead")
		unitCount += 1
	return unitLeft
