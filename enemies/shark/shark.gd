extends Area2D


var velocity = Vector2(1, 0)

@onready var sprite = $AnimatedSprite2D

const SPEED = 50
const AMPLITUDE = 0.5
const FREQUENCY = 0.15
var offset = randf_range(0, 10)

func _physics_process(delta):
	velocity.y = sin(global_position.x * FREQUENCY + offset) * AMPLITUDE 
	global_position +=  velocity * SPEED * delta
	

func _on_area_entered(area):
	if area.is_in_group("PlayerBullet"):
		area.queue_free()
		queue_free()

func flip_direction():
	velocity = -velocity
	sprite.flip_h = !sprite.flip_h

func _on_screen_exited():
	queue_free()
