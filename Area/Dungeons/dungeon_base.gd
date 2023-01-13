extends Resource
class_name Dungeon

@export var id: int = 0
@export var name: String = ""

@export var zones: Array[Zone] = []
@export var bg: CompressedTexture2D
@export var is_visible: bool = false
