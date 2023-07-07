extends Resource
class_name DialogueContent

## The message to display
@export var message: String = ""
## Integer representing the character to show when speaking. See the character index on the parent node
@export var character: int = 0
## Which character frame to display (emotion)
@export var frame: int = 0
## Add a wait period before the dialogue
@export var wait_before: int = 0
## Add a wait period after the dialogue
@export var wait_after: int = 0
