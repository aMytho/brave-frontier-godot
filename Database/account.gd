extends Node

class_name Account

@export var id: int
@export var player_name: String
@export var level: int
@export var current_exp: float
@export var max_exp: float
@export var energy: int
@export var gems: int
@export var zel: int
@export var karma: int
@export var arena_orbs: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_account_info(new_id: int, new_player_name: String, new_level: int, new_exp: float, new_max_exp: float,
new_energy: int, new_gems: int, new_zel: int, new_karma: int, new_arena_orbs: int):
	self.id = new_id
	self.player_name = new_player_name
	self.level = new_level
	self.current_exp = new_exp
	self.max_exp = new_max_exp
	self.energy = new_energy
	self.gems = new_gems
	self.zel = new_zel
	self.karma = new_karma
	self.arena_orbs = new_arena_orbs
	
func get_account_info() -> Array:
	return [id, player_name, level, current_exp, max_exp, energy, gems, zel, karma, arena_orbs]

func account_is_active() -> bool:
	return player_name != ""
