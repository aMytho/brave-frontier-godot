extends Resource
class_name Area

@export var id: int = 0
@export var name: String = ""

@export var description: String = ""
@export var visible: bool = false
@export var completed: bool = false

@export var dungeons: Array[Dungeon] = []
