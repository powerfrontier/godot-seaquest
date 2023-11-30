extends Area2D

var velocity = Vector2(1, 0)
var point_value = 30

const SPEED = 25

@onready var sprite = $AnimatedSprite2D


func _process(delta):
	if global_position.x > Global.SCREEN_BOUND_MAX_X || global_position.x < Global.SCREEN_BOUND_MIN_X:
		queue_free()

func _physics_process(delta):
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
		queue_free()

