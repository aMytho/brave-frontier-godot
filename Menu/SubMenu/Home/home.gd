extends Control
const symbolEnum = preload("res://Menu/SubMenu/Home/Characters/symbolEnum.gd")
const noCharBackground = preload("res://Menu/SubMenu/Home/home_character_frame_bg.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	#TODO --- Get character data
	
	var charTextureList = [
		$Character/TextureRect/Char1/Char1,
		$Character/TextureRect/Char2/Char2,
		$Character/TextureRect/Char3/Char3,
		$Character/TextureRect/Char4/Char4,
		$Character/TextureRect/Char5/Char5
	]

	var charBGList = [
		$Character/TextureRect/Char1/BG,
		$Character/TextureRect/Char2/BG,
		$Character/TextureRect/Char3/BG,
		$Character/TextureRect/Char4/BG,
		$Character/TextureRect/Char5/BG
	]
	
	var charElementList = [
		$Character/TextureRect/Char1/CharElement,
		$Character/TextureRect/Char2/CharElement,
		$Character/TextureRect/Char3/CharElement,
		$Character/TextureRect/Char4/CharElement,
		$Character/TextureRect/Char5/CharElement
	]
	
	var accountFirstTeam = Lookups.get_first_team_by_account_id(ActiveAccount.id)
	var unitNumber = 1
	var unitList = []
	
	while unitNumber <= 5:
		var variable = "unit%s"% unitNumber
		var unitId = accountFirstTeam[0].get("unit%s" % unitNumber)
		var currentCharTextute = charTextureList[unitNumber-1]
		var currentCharBG = charBGList[unitNumber-1]
		var currentCharElement = charElementList[unitNumber-1]
		
		if null == unitId:
			symbolEnum.set_symbol_pos("default", currentCharElement)
			currentCharBG.element = "none"
			currentCharBG.texture = noCharBackground
			currentCharTextute.texture = null
			unitNumber = unitNumber + 1
			continue
			
		var unit = Lookups.get_unit_by_ID(unitId)
		currentCharTextute.texture = load(unit.unit.full_sprite.get_load_path())
		currentCharTextute.expand_mode = 1
		currentCharTextute.stretch_mode = 0
		currentCharBG.element = unit.unit.element.to_lower()
		currentCharBG.texture = load("res://Menu/SubMenu/Home/Characters/background.png")
		symbolEnum.set_symbol_pos(unit.unit.element.to_lower(), currentCharElement)
		unitNumber = unitNumber + 1		
		
