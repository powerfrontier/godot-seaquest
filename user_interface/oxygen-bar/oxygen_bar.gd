extends Node2D

const OxygenAlert = preload("res://user_interface/oxygen-bar/oxygen_alert.ogg")

@onready var texture_progress = $TextureProgress
@onready var flash_timer = $FlashTimer

var previous_value = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	texture_progress.value = Global.oxygen_level
	
	var current_value = round(Global.oxygen_level)
	
	if current_value != previous_value:
		if current_value == 25:
			alert(1.25, 5)
		elif current_value == 15:
			alert(1.3, 7)
		elif current_value == 10:
			alert(1.35, 10)
		elif current_value == 7:
			alert(1.4, 15)
		elif current_value == 5:
			alert(1.5, 20)
		elif current_value == 2:
			alert(1.6, 25)
		elif current_value == 1:
			alert(1.8, 35)
		
		previous_value = current_value

func _physics_process(delta):
	scale = lerp(scale, Vector2(1, 1), 6 * delta)
	rotation_degrees = lerp(rotation, 0.0, 6 * delta)

func alert(scale_value, rotation_value):
	scale = Vector2(scale_value, scale_value)
	rotation_degrees = randf_range(-rotation_value, rotation_value)
	modulate = Color(20, 20, 20)
	flash_timer.start()
	SoundManager.play_sound(OxygenAlert)

func _on_flash_timer_timeout():
	modulate = Color(1, 1, 1)
