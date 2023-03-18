extends Resource
class_name Stage

@export_category("General")
@export var id: int = 0
@export var is_boss: bool = false
@export var monsters: Array[Unit] = []


@export_category("Mimics")
@export var mimic_count: int = 0
@export var mimic_chance: float = 0.0
@export var minic_types: Array = []
