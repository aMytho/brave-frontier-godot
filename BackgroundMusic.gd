extends AudioStreamPlayer

signal startPlaying(song: String)
signal stopPlaying

var nextSong: String = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_start_playing(song):
	var fadeController:AnimationPlayer = get_child(0)
	if is_playing():
		#Stop
		fadeController.play("Stop")
		print("Stopping the music")
		nextSong = song
	else:
		#load it
		stream = load(song)
		#Increase volume so it can be heard
		fadeController.play("Start")
		print("Starting the music")
		#play it -- the animm has already started so this may need reworking
		play()
		nextSong = ""

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Stop":
		print("Done with music fade/grow")
		#stop audio playback
		stop()
		
		#See if another song is needed to start
		if nextSong != "":
			_on_start_playing(nextSong)

func _on_stop_playing():
	var fadeController:AnimationPlayer = get_child(0)
	fadeController.play("Stop")
	nextSong = ""
