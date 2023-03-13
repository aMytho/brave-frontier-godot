extends ColorRect

@export var messages: Array = []
@onready var text_to_animate = $AnimatedText
@export var speed: float = 0.1

signal DialogueComplete(count: int)
signal FlashComplete

var count: int = 0

func _ready():
	animate_text()
	connect("DialogueComplete", _on_dialogue_complete)

func animate_text():
	$AnimatedText.visible_ratio = 0
	$AnimatedText.text = messages[count]
	
	var tween = create_tween()
	tween.tween_property($AnimatedText, "visible_ratio", 1, 8.0 * speed)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	#Only slow if not in dev mode
	if speed == 1.0:
		await get_tree().create_timer(9.0).timeout
	
	var new_tween = create_tween()
	new_tween.tween_property($AnimatedText, "theme_override_colors/font_color", Color(1, 1, 1, 0), 2.0 * speed)
	new_tween.tween_callback(emit_signal.bind("DialogueComplete"))

func fade_to_white():
	var tween = create_tween()
	tween.tween_property(self, "color", Color(1, 1, 1, 1), 4.0 * speed)
	$Particles.emitting = false
	tween.tween_callback(emit_signal.bind("FlashComplete"))

func _on_dialogue_complete():
	count = count + 1
	if count < messages.size():
		var new_tween = create_tween()
		new_tween.tween_property($AnimatedText, "theme_override_colors/font_color", Color(1, 1, 1, 1), 0.4 * speed)
		animate_text()
	else:
		fade_to_white()
