extends Area2D

var velocity = Vector2(1, 0)
var point_value = 30
var point_penalty = 20
enum states {DEFAULT, PAUSE}
var state = states.DEFAULT

const SPEED = 25

const SavingPersonSound = preload("res://person/saving_person.ogg")
const PersonDeathSound = preload("res://person/scream.ogg")
const PersonFuckSound = preload("res://person/fuck.ogg")

@onready var sprite = $AnimatedSprite2D

func _ready():
	GameEvent.connect("enemy_pause", Callable(self, "_enemy_pause"))


func _process(delta):
	if global_position.x > Global.SCREEN_BOUND_MAX_X || global_position.x < Global.SCREEN_BOUND_MIN_X:
		queue_free()

func _physics_process(delta):
	if state == states.DEFAULT:
		global_position += velocity * SPEED * delta

func flip_direction():
	velocity = -velocity
	sprite.flip_h = !sprite.flip_h
	
	
func _on_area_entered(area):
	if area.is_in_group("Player"):
		Global.saved_people_count += 1
		GameEvent.emit_signal("update_collected_people_count")
		Global.current_points += point_value
		GameEvent.emit_signal("update_points")
		SoundManager.play_sound(SavingPersonSound)
		queue_free()
	elif area.is_in_group("PlayerBullet"):
		Global.current_points -= point_penalty
		GameEvent.emit_signal("update_points")
		SoundManager.play_sound(PersonFuckSound)
		area.queue_free()
		queue_free()

func _enemy_pause(pause):
	if pause:
		state = states.PAUSE
	else:
		state = states.DEFAULT
