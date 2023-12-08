extends Area2D

var velocity = Vector2(0, 0)
var can_shoot = true
enum states {DEFAULT, OXYGEN_REFUEL, PEOPLE_REFUEL}
var state = states.DEFAULT
var is_shooting = false

const SPEED = Vector2(125, 90)

const OXYGEN_DECREASE_SPEED = 2.5
const OXYGEN_INCREASE_SPEED = 60
const OXYGEN_MOVE_SHORE_LINE_SPEED = 50
const OXYGEN_SHORE_LINE = 38
const OXYGEN_HIGH_LEVEL = 80

const MAX_X_POSITION = 248
const MIN_X_POSITION = 10
const MAX_Y_POSITION = 205
const MIN_Y_POSITION = OXYGEN_SHORE_LINE

const BULLET_OFFSET = 7
const PIECE_COUNT = 10

const ROTATION_STRENGTH = 15

const Bullet = preload("res://player/player_bullet/player_bullet.tscn")
const ShootSound = preload("res://player/player_bullet/player_shoot.ogg")
const OxygenFullSound = preload("res://user_interface/oxygen-bar/full_oxygen_alert.ogg")
const OxygenRefuelSound = preload("res://player/player_refuel_oxygen.ogg")
const SurfaceSound = preload("res://player/player_surface.ogg")
const OxygenExplosionSound = preload("res://player/explosion.ogg")
const ObjectPiece = preload("res://particles/object_piece/object_piece.tscn")
const PieceTexture = preload("res://player/player_pieces.png")

@onready var ReloadTimer = $ReloadTimer
@onready var sprite = $AnimatedSprite2D
@onready var decreasePeopleTimer = $DecreasePeopleTimer

func _ready():
	GameEvent.connect("game_over", Callable(self, "_game_over"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == states.DEFAULT:
		process_movement_input()
		direction_follows_input()
		rotate_to_movement()
		process_shoting()
		lose_oxygen(delta)
	elif state == states.OXYGEN_REFUEL:
		move_to_shore_line(delta)
		#if global_position.y <= OXYGEN_SHORE_LINE: 
		gain_oxygen(delta)
	elif state == states.PEOPLE_REFUEL:
		move_to_shore_line(delta)

func _physics_process(delta):
	if state == states.DEFAULT:
		movement(delta)
	clamp_postion()
	GameEvent.emit_signal("camera_follow_player", global_position.y)

func process_movement_input():
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized()

func direction_follows_input():
	if !is_shooting:
		if velocity.x > 0:
			sprite.flip_h = false
		elif velocity.x < 0:
			sprite.flip_h = true

func rotate_to_movement():
	var rotation_target
	if velocity.y == 0:
		rotation_target = velocity.x * ROTATION_STRENGTH
	else:
		rotation_target = velocity.y * ROTATION_STRENGTH
		if sprite.flip_h:
			rotation_target = -rotation_target
	
	rotation_degrees = lerp(rotation_degrees, rotation_target, 15 * get_physics_process_delta_time())

func process_shoting():
	if Input.is_action_pressed("shoot"):
		is_shooting = true
		if can_shoot:
			var bullet_instance = Bullet.instantiate()
			get_tree().current_scene.add_child(bullet_instance)
			
			SoundManager.play_sound_rnd_pitch(ShootSound)
			
			if sprite.flip_h:
				bullet_instance.flip_direction()
				bullet_instance.global_position = global_position - Vector2(BULLET_OFFSET, 0)
			else:	
				bullet_instance.global_position = global_position + Vector2(BULLET_OFFSET, 0)
			
			#print(bullet_instance.global_position)
			can_shoot = false
			$ReloadTimer.start()
	else:
		is_shooting = false

func lose_oxygen(delta):
	if Global.oxygen_level > 0:
		Global.oxygen_level -= OXYGEN_DECREASE_SPEED * delta
	else:
		death()

func gain_oxygen(delta):
	if Global.oxygen_level < 100:
		Global.oxygen_level += OXYGEN_INCREASE_SPEED * delta
	else:
		state = states.DEFAULT
		GameEvent.emit_signal("enemy_pause", false)
		sprite.play("default")
		SoundManager.play_sound(OxygenFullSound)

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

func remove_one_person():
	if Global.saved_people_count > 0:
		Global.saved_people_count -= 1
		GameEvent.emit_signal("update_collected_people_count")

func _on_oxygen_zone_area_entered(area):
	if area.is_in_group("Player"):
		SoundManager.play_sound(SurfaceSound)
		sprite.play("flash")
		if Global.oxygen_level > OXYGEN_HIGH_LEVEL:
			SoundManager.play_sound(OxygenExplosionSound)
			death()
		else:
			GameEvent.emit_signal("enemy_pause", true)
			if Global.saved_people_count >= Global.MAX_CREW:
				GameEvent.emit_signal("kill_all_enemies")
				state = states.PEOPLE_REFUEL
				decreasePeopleTimer.start()
			else:
				remove_one_person()
				SoundManager.play_sound(OxygenRefuelSound)
				state = states.OXYGEN_REFUEL

func _on_decrease_people_timer_timeout():
	remove_one_person()
	if Global.saved_people_count <= 0:
		decreasePeopleTimer.stop()
		SoundManager.play_sound(OxygenRefuelSound)
		state = states.OXYGEN_REFUEL

func death():
	GameEvent.emit_signal("enemy_pause", true)
	GameEvent.emit_signal("game_over")
	# Here I delete the player's death sound of the course
	# and moved to another place because the player now (cause
	# my modification) do differents sounds on each death
	instance_player_pieces()

func instance_player_pieces():
	for i in range(PIECE_COUNT):
		var piece_instance = ObjectPiece.instantiate()
		piece_instance.texture = PieceTexture
		piece_instance.hframes = PIECE_COUNT
		piece_instance.frame = i
		get_tree().current_scene.add_child(piece_instance)
		piece_instance.global_position = global_position

func _game_over():
	queue_free()
