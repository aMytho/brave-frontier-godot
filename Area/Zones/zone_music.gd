extends AudioStreamPlayer

## The state of the music player
enum MusicState {
	## Start the music
	START,
	## Stop the music
	STOP
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Start or stop the music
func fade_control(action: MusicState, music_file = null):
	var tween = create_tween()
	match action:
		MusicState.STOP:
			# Stop the music
			tween.tween_property(self, "volume_db", -80.0, 2.0)
			tween.tween_callback(self.stop)
		MusicState.START:
			# Play the music
			if music_file != null:
				self.stream = music_file
			tween.tween_property(self, "volume_db", -10.0, 2.0)
			tween.tween_callback(self.play)
