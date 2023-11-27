extends Area2D

var velocity = Vector2(0, 0)
var can_shoot = true
var state = "default"

const SPEED = Vector2(125, 90)

const OXYGEN_DECREASE_SPEED = 2.5
const OXYGEN_INCREASE_SPEED = 60
const OXYGEN_MOVE_SHORE_LINE_SPEED = 50
const OXYGEN_SHORE_LINE = 38

const MAX_X_POSITION = 248
const MIN_X_POSITION = 10
const MAX_Y_POSITION = 205
const MIN_Y_POSITION = OXYGEN_SHORE_LINE

const BULLET_OFFSET = 7
const Bullet = preload("res://player/player_bullet/player_bullet.tscn")

@onready var ReloadTimer = $ReloadTimer
@onready var sprite = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == "default":
		process_movement_input()
		direction_follows_input()
		process_shoting()
		lose_oxygen(delta)
	elif state == "less people oxygen refuel":
		gain_oxygen(delta)
		move_to_shore_line(delta)
	elif state == "full people oxygen refuel":
		gain_oxygen(delta)
		move_to_shore_line(delta)

func _physics_process(delta):
	if state == "default":
		movement(delta)
	clamp_postion()

func process_movement_input():
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized()

func direction_follows_input():
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func process_shoting():
	if Input.is_action_pressed("shoot") and can_shoot:
		var bullet_instance = Bullet.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		
		if sprite.flip_h:
			bullet_instance.flip_direction()
			bullet_instance.global_position = global_position - Vector2(BULLET_OFFSET, 0)
		else:	
			bullet_instance.global_position = global_position + Vector2(BULLET_OFFSET, 0)
		
		#print(bullet_instance.global_position)
		can_shoot = false
		$ReloadTimer.start()

func lose_oxygen(delta):
	if Global.oxygen_level > 0:
		Global.oxygen_level -= OXYGEN_DECREASE_SPEED * delta

func gain_oxygen(delta):
	if Global.oxygen_level < 100:
		Global.oxygen_level += OXYGEN_INCREASE_SPEED * delta
	else:
		state = "default"

func movement(delta):
	global_position += velocity * SPEED * delta

func clamp_postion():
	global_position.x = clamp(global_position.x, MIN_X_POSITION, MAX_X_POSITION)
	global_position.y = clamp(global_position.y, MIN_Y_POSITION, MAX_Y_POSITION)

func move_to_shore_line(delta):
	global_position.y = move_toward(global_position.y, OXYGEN_SHORE_LINE, OXYGEN_MOVE_SHORE_LINE_SPEED * get_process_delta_time())
	# igual pero sin el mov_towards
	#if (global_position.y > OXYGEN_SHORE_LINE):
	#	global_position.y -= OXYGEN_MOVE_SHORE_LINE_SPEED * delta 

func _on_reload_timer_timeout():
	can_shoot = true

func _on_oxygen_zone_area_entered(area):
	if area.is_in_group("Player"):
		if Global.saved_people_count >= Global.MAX_CREW:
			state = "full people oxygen refuel"
		else:
			state = "less people oxygen refuel"
