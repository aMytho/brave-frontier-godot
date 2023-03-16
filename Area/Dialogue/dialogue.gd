extends Control

@export var speed: float = 1.0
@export var area: CompressedTexture2D:
	set(new_area):
		$BG.texture = new_area
		area = new_area
@export var dialogue: Dialogue

signal Section
signal Complete


# Called when the node enters the scene tree for the first time.
func _ready():
	for interaction in dialogue.content:
		$ColorRect/Message.modulate = Color(1,1,1,1)
		$Frame/Speaker.text = dialogue.characters[interaction.character].name
		$ColorRect/Message.text = interaction.message
		$Person1.texture = dialogue.characters[interaction.character].frames[interaction.frame]
		
		var tween = create_tween()
		tween.tween_property($ColorRect/Message, "visible_ratio", 1, 4.0 * speed)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_callback(hide_text)
		
		await Section
	emit_signal("Complete", self)

func hide_text():
	await get_tree().create_timer(2.5).timeout
	var tween = create_tween()
	tween.tween_property($ColorRect/Message, "modulate", Color(1,1,1,0), 1.0)
	tween.tween_callback(emit_signal.bind("Section"))

func _on_section_complete():
	$ColorRect/Message.text = ""
	$ColorRect/Message.visible_ratio = 0
