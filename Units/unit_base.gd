extends Resource
class_name Unit

@export_category("Identification")
# The DB id. This is unique across all accounts and has nothing to do with the official project
var id: int = 0
# The number of the unit. Used for identification
@export var unit_number: int = 0
# The data_id. This is usually the same as the unit_number, but it may differ. Links the unit to its assets
@export var data_id: int = 0
# Everything good has a name
@export var name: String = ""

@export_category("Stats")
# The element of the unit
@export_enum("Fire", "Water", "Earth", "Thunder", "Light", "Dark") var element: String = ""
# The gender of the unit. To-do - make enum
@export var gender: String = ""
# The rarity of the unit. Not sure what this is used for
@export var rarity: int = 1
# The cost of the unit to be in your squad. The higher the cost, the stronger the unit
@export var cost = 1
# IDK
@export var arena_type: int = 0
# The current level of the unit. Always positive
@export var level: int = 0
# The max level of the unit
@export var max_level:int = 0
# Used to determine state in a battle
@export var is_dead:bool = false

# Current health
@export var HP: int = 0
# Max health
@export var max_HP: int = 0
# Attack
@export var ATK: int = 0
# Defense
@export var DEF: int = 0
# Rec?
@export var REC: int = 0

# The abilities of the unit. To-do
@export var skills: Array[Resource] = []

@export_category("Assets")
# The thumbnail (appears in most menu/UIs)
@export var thumbnail: Texture2D = null
# Same as the thumbnail, but without a border
@export var battle_thumbnail: Texture2D = null
# The full sprite. Shown on the summon page and home page
@export var full_sprite: Texture2D = null
# The unit's spritesheet with their animations. We do these manually
@export var sprite_sheet: SpriteFrames = null
# Add additional sprites to the unit. Weapons, effects, etc. Only in IDLE state
@export var char_equipment: Array[CharEquipment] = []
# Same as above but only shows during attacks
@export var atk_equipment: Array[CharEquipment] = []
# Same as above but only shows during travel
@export var travel_equipment: Array[CharEquipment] = []

@export_category("Info")
# Snazzy comment
@export var quotes: Resource = null
# Unit story
@export var unit_lore: String = ""
