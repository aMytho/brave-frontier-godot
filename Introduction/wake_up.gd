extends ColorRect

var original = ""
@export var content: String = "Summmoner":
	set(new_content):
		content = str("[center]", new_content, "[/center]")
		original = new_content

var times: int = 0

signal ImAwake

# Called when the node enters the scene tree for the first time.
func _ready():
	animate_text(content)


func wake_up():
	# The summoner needs to wake up :)
	if times == 1:
		await get_tree().create_timer(1.5).timeout
		animate_text(str(content, "?"), 2.5)
	elif times == 2:
		await get_tree().create_timer(2.0).timeout
		animate_text(str("[shake rate=10 level=30]", str("[center]", original.to_upper(), "[/center]"), "[/shake]"), 0.5)
	else:
		emit_signal("ImAwake")


func animate_text(text, duration: float = 2.0):
	# Set the text content
	$RichTextLabel.clear()
	$RichTextLabel.append_text(text)
	
	# Show the text
	var tween = create_tween()
	tween.tween_property($RichTextLabel, "modulate", Color(1,1,1,1), 1.0)
	tween.tween_property($RichTextLabel, "visible_ratio", 1, duration)
	tween.set_trans(Tween.TRANS_CUBIC)
	# Hide it
	tween.tween_callback(hide_text)


func hide_text():
	# Fade text
	var tween = create_tween()
	tween.tween_property($RichTextLabel, "modulate", Color(1,1,1,0), 2.5)
	tween.tween_property($RichTextLabel, "visible_ratio", 0, 1.0)
	times = times + 1
	tween.tween_callback(wake_up)
