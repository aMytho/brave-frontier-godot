extends Label

@export var counter:int = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	while counter > 0:
		counter = counter - 1
		text = str("REFILL IN 1", ":", counter)
		await get_tree().create_timer(1.0).timeout
