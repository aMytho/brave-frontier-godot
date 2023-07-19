extends Resource
class_name Dialogue

## ID of the dialogue entry
@export var id: int = 0
## The characters that are involved in the dialogue
@export var characters: Array[Character] = []
## The dialogue content
@export var content: Array[DialogueContent] = []
## The music for the dialogue
@export var music: AudioStreamMP3
