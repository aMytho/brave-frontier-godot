extends Node

static func unitTakingDamage(atkUnit: Resource, defUnit: Resource):
	#print("-------------------")
	#print("Atk unit : ")
	#print(atkUnit)
	#print(atkUnit.ATK)
	defUnit.HP = defUnit.HP - atkUnit.ATK
	#print("Def unit : ")
	#print(defUnit)
	#print(defUnit.HP)
	#print("-------------------")

static func areUnitsDead(units: Array[Unit]):
	var unitLeft = 0
	for unit in units:
		if null == unit:
			continue
		if 0 >= unit.HP:
			unit.is_dead = true
			print("The unit is dead")
		else:
			unitLeft = unitLeft + 1
			print("The unit is NOT dead")
	
	return unitLeft
