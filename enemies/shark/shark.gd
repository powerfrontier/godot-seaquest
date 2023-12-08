extends Area2D


var velocity = Vector2(1, 0)

@onready var sprite = $AnimatedSprite2D

const SPEED = 50
const AMPLITUDE = 0.5
const FREQUENCY = 0.15
const PIECE_COUNT = 2

const SharkDeathSound = preload("res://enemies/shark/shark_death.ogg")
const PlayerDeathSound = preload("res://player/player_death.ogg")
const ObjectPiece = preload("res://particles/object_piece/object_piece.tscn")
const PointValuePopup = preload("res://user_interface/point_value_popup/point_value_popup.tscn")

var offset = randf_range(0, 10)
var point_value = 25
enum states {DEFAULT, PAUSE}
var state = states.DEFAULT

func _ready():
	GameEvent.connect("enemy_pause", Callable(self, "_enemy_pause"))

func _process(delta):
	if global_position.x > Global.SCREEN_BOUND_MAX_X || global_position.x < Global.SCREEN_BOUND_MIN_X:
		queue_free()

func _physics_process(delta):
	if state == states.DEFAULT:
		velocity.y = sin(global_position.x * FREQUENCY + offset) * AMPLITUDE 
		global_position +=  velocity * SPEED * delta


func _on_area_entered(area):
	if area.is_in_group("PlayerBullet"):
		Global.current_points += point_value
		GameEvent.emit_signal("update_points")
		SoundManager.play_sound_rnd_pitch(SharkDeathSound)
		instance_death_pieces()
		instance_point_value_popup()
		area.queue_free()
		queue_free()
	
	if area.is_in_group("Player"):
		SoundManager.play_sound(PlayerDeathSound)
		area.death()

func flip_direction():
	velocity = -velocity
	sprite.flip_h = !sprite.flip_h

func instance_point_value_popup():
	var point_value_popup = PointValuePopup.instantiate()
	# El value se tiene que poner antes de añadirla al
	# arbol porque el _ready de point_value_popupse ejecuta
	# cuando se añade al arbol. Otra opción para no tener que
	# mantener este orden es hacer una funcion normal en
	# point_value_popup y llamarla con el valor como argumento
	point_value_popup.value = point_value
	get_tree().current_scene.add_child(point_value_popup)
	# It can be done the way below but its more "hardcoded"
	# and represents that you know the inner structure
	# of the popup scene
	#point_value_popup.get_node("Label").text = str(point_value)
	point_value_popup.global_position = global_position
	

func instance_death_pieces():
	for i in range(PIECE_COUNT):
		var piece_instance = ObjectPiece.instantiate()
		piece_instance.frame = i
		get_tree().current_scene.add_child(piece_instance)
		piece_instance.global_position = global_position

func _enemy_pause(pause):
	if pause:
		state = states.PAUSE
	else:
		state = states.DEFAULT

