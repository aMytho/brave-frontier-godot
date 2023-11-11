extends Resource
class_name Stage

@export_category("General")
@export var id: int = 0
@export var is_boss: bool = false
## A monster is just a unit with potentialyl overwritten stats
@export var monsters: Array[Unit] = []


## These don't do anything yet, but they might in the future
## The "real" game had mimic data for each stage
@export_category("Mimics")
@export var mimic_count: int = 0
@export var mimic_chance: float = 0.0
@export var minic_types: Array = []
