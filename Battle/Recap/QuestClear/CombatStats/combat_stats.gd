extends Control

@export var sparks: int = 0
@export var crits: int = 0
@export var bc: int = 0
@export var hc: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# Show the combat stats on the recap view
	$SparkAmount.text = str(sparks)
	$CritAmount.text = str(crits)
	$BCDropAmount.text = str(bc)
	$HCDropCountAmount.text = str(hc)
