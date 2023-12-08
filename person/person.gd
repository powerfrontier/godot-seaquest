extends Area2D

var velocity = Vector2(1, 0)
var point_value = 30
var point_penalty = -20
enum states {DEFAULT, PAUSE}
var state = states.DEFAULT

const SPEED = 25
const FULL_CREW = 7

const SavingPersonSound = preload("res://person/saving_person.ogg")
const PersonDeathSound = preload("res://person/scream.ogg")
const PersonFuckSound = preload("res://person/fuck.ogg")
const PointValuePopup = preload("res://user_interface/point_value_popup/point_value_popup.tscn")

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
	if area.is_in_group("Player") && Global.saved_people_count < FULL_CREW:
		Global.saved_people_count += 1
		GameEvent.emit_signal("update_collected_people_count")
		Global.current_points += point_value
		GameEvent.emit_signal("update_points")
		SoundManager.play_sound(SavingPersonSound)
		instance_point_value_popup(point_value)
		queue_free()
	elif area.is_in_group("PlayerBullet"):
		Global.current_points += point_penalty
		if Global.current_points < 0:
			Global.current_points = 0
		GameEvent.emit_signal("update_points")
		SoundManager.play_sound(PersonFuckSound)
		instance_point_value_popup(point_penalty)
		area.queue_free()
		queue_free()

func instance_point_value_popup(points):
	var point_value_popup = PointValuePopup.instantiate()
	point_value_popup.value = points
	if points < 0:
		point_value_popup.color = Color(1, 0, 0)
	get_tree().current_scene.add_child(point_value_popup)
	point_value_popup.global_position = global_position

func _enemy_pause(pause):
	if pause:
		state = states.PAUSE
	else:
		state = states.DEFAULT
