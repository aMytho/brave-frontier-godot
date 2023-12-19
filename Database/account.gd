extends Node

class_name Account

signal EnergyRecharged(new_energy: int)
signal ExpUpdated(current_exp: int, max_exp: int)
signal LevelUpdated(new_lvl: int)

## The ID of the player
@export var id: int
## The name of the palyer
@export var player_name: String
## The level of the player
@export var level: int
## The current amount of exp the player has
@export var current_exp: int
## The max amount of exp for the current level
@export var max_exp: int
## The amount of energy the player has
@export var energy: int
## Gem amount
@export var gems: int
## Zel amount
@export var zel: int
## Karma amount
@export var karma: int
## The amount of arena orbs (1-3)
@export var arena_orbs: int
## The amount of time per energy recharge in seconds
@export var ENERGY_RECHARGE = 60
## The energy recharge timer
var timer: SceneTreeTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_account_info(new_id: int, new_player_name: String, new_level: int, new_exp: int,
new_energy: int, new_gems: int, new_zel: int, new_karma: int, new_arena_orbs: int):
	self.id = new_id
	self.player_name = new_player_name
	self.level = new_level
	self.current_exp = new_exp
	
	# Get the max exp from the levels table. Later we can get friends, cost, etc.
	var level = Database.query("SELECT next_exp FROM player_level WHERE id = %s" % new_level)[0]
	self.max_exp = level.next_exp
	
	self.energy = new_energy
	self.gems = new_gems
	self.zel = new_zel
	self.karma = new_karma
	self.arena_orbs = new_arena_orbs
	
	# Setup the energy recharge system
	timer = get_tree().create_timer(ENERGY_RECHARGE)
	timer.connect("timeout", _on_energy_recharged)


func get_account_info() -> Array:
	return [id, player_name, level, current_exp, max_exp, energy, gems, zel, karma, arena_orbs]


func account_is_active() -> bool:
	return player_name != ""


func will_player_level_up(new_exp: int) -> bool:
	# Returns a bool indicating if adding an exp amount will trigger a level up. Does not affect DB/state
	if new_exp + self.current_exp > self.max_exp:
		return true
	return false


func add_exp(new_exp: int):
	print("Adding ", new_exp, " exp to summoner!")
	if !will_player_level_up(new_exp):
		# The player won't level up, add the exp normally
		self.current_exp = self.current_exp + new_exp
		Database.query("UPDATE player_state SET current_exp = %s WHERE id = %s" %[new_exp, self.id])
		# Emit the changes
		emit_signal("ExpUpdated", self.current_exp, self.max_exp)
	else:
		# The player will level up, we need to do that and then add the remainder.
		var overflow = self.current_exp + new_exp - self.max_exp
		print("Overflow exp amount:", overflow)
		# Save the new level
		self.level = self.level + 1
		self.current_exp = 0
		Database.query("UPDATE player_state SET level = %s"% [self.level])
		# Emit the signal
		emit_signal("LevelUpdated", self.level)
		# Set the new max exp
		var new_level = Database.query("SELECT * FROM player_level WHERE id = %s" % self.level)[0]
		self.max_exp = new_level.next_exp
		print("The new max exp is:", new_level.next_exp)
		# Set the new max energy
		self.energy = new_level.energy
		# Check that we didn't level up more than once
		if overflow > new_level.next_exp:
			# If we are still overflowing, run the function again
			add_exp(overflow)
		else:
			# We can add the overflow without leveling again
			self.current_exp = overflow
			Database.query("UPDATE player_state SET current_exp = %s, energy = %s"
				% [self.current_exp, new_level.energy]
			)


func get_level_info(new_level: int):
	return Database.query("SELECT * from player_level where id = %s" % new_level)[0]


func _on_energy_recharged():
	# Get the current lvl info
	var current_lvl = Database.query("SELECT energy FROM player_level WHERE id = %s" % level)[0]
	# Add 1 energy if possible
	if (energy + 1 <= current_lvl.energy):
		energy = energy + 1
		print("Energy has recharged. New amount: ", energy)
	else:
		print("Energy timer complete, already at max energy.")
	
	# Emit the event. The header listens for this to update the energy progress bar
	emit_signal("EnergyRecharged", energy)
	
	# Start another timer
	timer = get_tree().create_timer(ENERGY_RECHARGE)
	timer.connect("timeout", _on_energy_recharged)
