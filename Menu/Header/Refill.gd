extends Label

## This value is how long the energy countdown starts at. Header.gd sets this value
@export var counter:int = 60
## The current value of the counter
var current_seconds: int = counter

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_properties(new_counter: int):
	# Set the max val of the counter
	counter = new_counter
	# Get the time left to energy recharge
	current_seconds = ActiveAccount.timer.time_left
	# Make the countdown visible now that we have something to display
	_on_energy_checker_timeout()
	visible = true

func timer_to_string(seconds):
	var minutes = int(seconds / 60)
	var remaining_seconds = int(seconds % 60)
	return str(minutes, ":", ("0" if remaining_seconds < 10 else ""), remaining_seconds)

func _on_energy_checker_timeout():
	# Function runs every second to update the energy countdown. We -1 so it can reach 0:00
	var formatted_time = timer_to_string(current_seconds)
	text = str("REFILL IN ", formatted_time)
	
	# Decrement the counter
	# Don't display negative numbers. The rechage timer isn't alligned with this one!
	if current_seconds - 1 != -1:
		current_seconds = current_seconds - 1

func reset_timer(new_val: int):
	# Resets the timer
	current_seconds = new_val
	text = str("REFILL IN ", timer_to_string(current_seconds))
