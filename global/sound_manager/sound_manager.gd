extends Node

const SoundScript = preload("res://global/sound_manager/sound.gd")

# Don't appears in the course but I wrote it to not repeat code
# on the two functions below
func create_audio_stream_player(sound):
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.set_script(SoundScript)
	audio_stream_player.stream = sound
	add_child(audio_stream_player)
	
	return audio_stream_player

func play_sound(sound):
	var audio_stream_player = create_audio_stream_player(sound)
	
	audio_stream_player.play()

# Don't appears in the course but I wrote it for modify the play_sound
# function above and not play all sound with random pitch
func play_sound_rnd_pitch(sound):
	var audio_stream_player = create_audio_stream_player(sound)
	
	audio_stream_player.pitch_scale = randf_range(0.8, 1.2)
	audio_stream_player.play()

