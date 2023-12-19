extends Resource
class_name Dungeon

@export var id: int = 0
@export var name: String = ""

## Zones for the dungeon. Add them in the order you want them displayed
@export var zones: Array[Zone] = []
@export var bg: CompressedTexture2D
@export var is_visible: bool = false
