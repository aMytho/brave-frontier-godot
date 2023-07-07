extends Resource
class_name Character

## ID of the character
@export var id: int = 0
## Name of the character. Displayed in the dialogue box
@export var name: String = ""

## The character animation frames. Each frame is usually a different emotion (shouting, happy, etc.)
@export var frames: Array[CompressedTexture2D] = []
