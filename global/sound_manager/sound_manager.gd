extends Node

const SoundScript = preload("res://global/sound_manager/sound.gd")

func play_sound(sound):
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.set_script(SoundScript)
	audio_stream_player.stream = sound
	add_child(audio_stream_player)	
	
	audio_stream_player.pitch_scale = randf_range(0.8, 1.2)
	audio_stream_player.play()

