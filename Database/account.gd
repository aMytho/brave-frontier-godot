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

func set_account_info(new_id: int, new_player_name: String, new_level: int, new_exp: float,
new_energy: int, new_gems: int, new_zel: int, new_karma: int, new_arena_orbs: int):
	self.id = new_id
	self.player_name = new_player_name
	self.level = new_level
	self.current_exp = new_exp
	
	# Get the max exp from the levels table. Later we can get friends, cost, etc.
	var db_max_exp = Database.query("SELECT next_exp FROM player_level WHERE id = %s" % new_level)[0].next_exp
	self.max_exp = db_max_exp
	
	self.energy = new_energy
	self.gems = new_gems
	self.zel = new_zel
	self.karma = new_karma
	self.arena_orbs = new_arena_orbs
	
func get_account_info() -> Array:
	return [id, player_name, level, current_exp, max_exp, energy, gems, zel, karma, arena_orbs]

func account_is_active() -> bool:
	return player_name != ""

func will_player_level_up(new_exp: float) -> bool:
	# Returns a bool indicating if adding an exp amount will trigger a level up. Does not affect DB/state
	if new_exp + self.current_exp > self.max_exp:
		return true
	return false

func add_exp(new_exp: float):
	print("Adding ", new_exp, " exp to summoner!")
	if !will_player_level_up(new_exp):
		# The player won't level up, add the exp normally
		self.current_exp = self.current_exp + new_exp
		Database.query("UPDATE player_state SET current_exp = %s WHERE id = %s" %[new_exp, self.id])
	else:
		# The player will level up, we need to do that and then add the remainder.
		var overflow = self.current_exp + new_exp - self.max_exp
		print("Overflow exp amount:", overflow)
		# Save the new level
		self.level = self.level + 1
		self.current_exp = 0
		Database.query("UPDATE player_state SET level = %s"% [self.level])
		# Set the new max exp
		var new_max_exp = Database.query("SELECT next_exp FROM player_level WHERE id = %s" % self.level)[0].next_exp
		self.max_exp = new_max_exp
		print("The new max exp is:", new_max_exp)
		# Check that we didn't level up more than once
		if overflow > new_max_exp:
			# If we are still overflowing, run the function again
			add_exp(overflow)
		else:
			# We can add the overflow without leveling again
			self.current_exp = overflow
			Database.query("UPDATE player_state SET current_exp = %s"% [self.current_exp])
