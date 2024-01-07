extends Resource
class_name Zone

@export_category("General")
@export var id: int = 0
@export var name: String = ""
@export var description: String = ""
## Energy cost for this zone
@export var energy: int = 5
## The stages to use. Make a new zone and add it to the Zones folder
@export var stage: Array[Stage] = []
## If false, will never show to player. Set false while in development (incomplete zone)
@export var can_be_visible: bool = true
## If true, this level will only be visible if the past stage is completed.
@export var require_past_completion: bool = true
## The completion state of the zone. This is automatically set when a user wins in a zone.
@export var is_complete: bool = false

@export_category("Assets")
@export var BG: CompressedTexture2D
## This music plays on normal stages
@export var music: AudioStreamMP3
## This music will only play on boss stages
@export var boss_music = AudioStreamMP3

@export_category("Risk / Reward")
## An arbitary number that doesn't do anything (yet)
@export var difficulty: int = 1
@export var xp: float = 1.0
@export var karma: int = 1
@export var zel: int = 1

@export_category("Cutscenes")
## Optional, may leave blank if not desired
@export var beginning_cutscene: Dialogue
## Optional, may leave blank if not desired
@export var ending_cutscene: Dialogue


## If the zone is visible and doesn't require past completions, it's playable
func is_playable_by_default() -> bool:
	return can_be_visible and require_past_completion == false
