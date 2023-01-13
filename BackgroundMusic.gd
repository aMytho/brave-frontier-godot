extends AudioStreamPlayer

signal startPlaying(song: String)

var nextSong: String = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_playing(song):
	print(song)
	var fadeController:AnimationPlayer = get_child(0)
	if is_playing():
		#Stop
		fadeController.play("Stop")
		print("Stopping!")
		nextSong = song
	else:
		#load it
		stream = load(song)
		#Increase volume so it can be heard
		fadeController.play("Start")
		print("Finished starting")
		#play it -- the animm has already started so this may need reworking
		play()
		nextSong = ""


func _on_animation_player_animation_finished(anim_name):
	print(anim_name)
	print("Running anim")
	if anim_name == "Stop":
		print("Done with animation")
		#stop audio playback
		stop()
		
		#See if another song is needed to start
		if nextSong != "":
			_on_start_playing(nextSong)
