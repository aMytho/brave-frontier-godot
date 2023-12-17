extends Resource
class_name Area

@export var id: int = 0
@export var name: String = ""

@export var description: String = ""

## You can hide an area if parts of it are not yet playable
@export var visible: bool = false

## Had the player completed this level?
@export var completed: bool = false

## The dungeons for the area
@export var dungeons: Array[DungeonPlacement] = []

## The area background image. Uses mistral as default if none provided
@export var background: CompressedTexture2D
