extends Node

enum fire {
	fire_x = 0,
	fire_y = 0
}

enum water {
	water_x = 26,
	water_y = 0
}

enum earth {
	earth_x = 52,
	earth_y = 0
}

enum thunder {
	thunder_x = 78,
	thunder_y = 0
}

enum light {
	light_x = 104,
	light_y = 0
}

enum dark {
	dark_x = 130,
	dark_y = 0
}

# Allow the game to print the good symbol at the user (see home.tscn > Character > TextureRect > Char1 > CharElement for visual
static func set_symbol_pos(element: String, charElement: Sprite2D):
	var symbolPos = {"x": null, "y": null, "w": null, "h": null}
	
	match element:
		"fire":
			charElement.region_rect.position.x = fire.fire_x
			charElement.region_rect.position.y = fire.fire_y
		"water":
			charElement.region_rect.position.x = water.water_x
			charElement.region_rect.position.y = water.water_y
		"earth":
			charElement.region_rect.position.x = earth.earth_x
			charElement.region_rect.position.y = earth.earth_y
		"thunder":
			charElement.region_rect.position.x = thunder.thunder_x
			charElement.region_rect.position.y = thunder.thunder_y
		"light":
			charElement.region_rect.position.x = light.light_x
			charElement.region_rect.position.y = light.light_y
		"dark":
			charElement.region_rect.position.x = dark.dark_x
			charElement.region_rect.position.y = dark.dark_y
		"default":
			charElement.region_rect.position.x = 156
			charElement.region_rect.position.y = 156
			
	charElement.region_rect.size.x = 26
	charElement.region_rect.size.y = 26
