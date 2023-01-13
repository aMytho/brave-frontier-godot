extends TextureRect

signal Clicked

@export var heading: String = "Unit":
	set(newHeading):
		$SectionHeading.text = newHeading
		heading = newHeading

# Called when the node enters the scene tree for the first time.
func _ready():
	$SectionHeading.text = heading
	#TODO - This line may not work, causes it to reset...


func _on_back_pressed():
	emit_signal("Clicked")
