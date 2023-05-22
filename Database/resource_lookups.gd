extends Node
class_name ResourceLookups

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Gets a unit by their unit number.
func get_unit_by_unit_number(unit_id: int, db_id: int = -1):
	var res = ResourceLoader.load("res://Units/Res/%s/%s.tres" % [unit_id, unit_id]).duplicate()

	if res == null:
		print("Unit %s not found!" % unit_id)
	else:
		# Add the db id to the unit
		res.id = db_id
	return {"unit": res, "valid": res != null}

# Gets a unit by their ID in the database.
func get_unit_by_ID(id: int):
	# -1 symbolizes that it doesn't exist
	if id == -1:
		return {"unit": null, "valid": false}
	
	var unit = Database.query("SELECT * FROM units WHERE id = %s" % id)
	if unit == null or len(unit) == 0:
		print("Unit %s not found!" % id)
	return get_unit_by_unit_number(unit[0].unit_id, unit[0].id)
	
# Gets list of unit using the id of the current account
func get_units_by_account_id(account_id: int):
	if account_id == -1:
		return {"unit": null, "valid": false}
		
	var units = Database.query("SELECT * from units WHERE account_id = %s" % account_id)
	if units == null or len(units) == 0:
		print("No units found for account %s !" % account_id)
	return units
	
func get_first_team_by_account_id(account_id: int):
	if account_id == -1:
		return {"team": null}
		
	var team = Database.query("SELECT * from teams where account_id = %s limit 1" % account_id)
	if null == team or 0 == len(team):
		print("No team found for user %s . . ." % account_id)
	return team
