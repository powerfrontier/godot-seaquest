extends AnimatedSprite2D

var velocity = Vector2(0, 0)
var can_shoot = true

const SPEED = Vector2(125, 90)
const BULLET_OFFSET = 7
const Bullet = preload("res://player/player_bullet/player_bullet.tscn")

@onready var ReloadTimer = $ReloadTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized()
	
	if velocity.x > 0:
		flip_h = false
	elif velocity.x < 0:
		flip_h = true

	if Input.is_action_pressed("shoot") and can_shoot:
		var bullet_instance = Bullet.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		
		if flip_h:
			bullet_instance.flip_direction()
			bullet_instance.global_position = global_position - Vector2(BULLET_OFFSET, 0)
		else:	
			bullet_instance.global_position = global_position + Vector2(BULLET_OFFSET, 0)
		
		#print(bullet_instance.global_position)
		can_shoot = false
		$ReloadTimer.start()
		
		

func _physics_process(delta):
	global_position += velocity * SPEED * delta

func _on_reload_timer_timeout():
	can_shoot = true
