extends Node
class_name ResourceLookups

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Gets a unit by their unit number.
func get_unit_by_unit_number(id:int):
	var res = ResourceLoader.load("res://Units/Res/%s/%s.tres" % [id,id])
	if res == null:
		print("Unit %s not found!" % id)
	return {"unit": res, "valid": res != null}

# Gets a unit by their ID in the database.
func get_unit_by_ID(id: int):
	# -1 symbolizes that it doesn't exist
	if id == -1:
		return {"unit": null, "valid": false}
	
	var unit = Database.query("SELECT * FROM units WHERE id = %s" % id)
	if unit == null or len(unit) == 0:
		print("Unit %s not found!" % id)
	return get_unit_by_unit_number(unit[0].unit_id)
	
# Gets list of unit using the id of the current account
func get_units_by_account_id(account_id: int):
	if account_id == -1:
		return {"unit": null, "valid": false}
		
	var units = Database.query("SELECT * from units WHERE account_id = %s" % account_id)
	if units == null or len(units) == 0:
		print("No units found for account %s !" % account_id)
	return units
