extends Camera2D

const FOLLOW_SPEED = 9
const MIN_HEIGHT = 70
const MAX_HEIGHT = 145


var target_position = global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvent.connect("camera_follow_player", Callable(self, "_follow_player"))

func _physics_process(delta):
	#print(str(global_position.y) + " - " + str(target_position.y))
	global_position.y = lerp(global_position.y, target_position.y, FOLLOW_SPEED*delta)
	#print(global_position.y)

func _follow_player(player_y):
	target_position.y = clamp(player_y, MIN_HEIGHT, MAX_HEIGHT)

