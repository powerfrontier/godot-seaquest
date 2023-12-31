extends Node

const MAX_CREW = 7
const SCREEN_BOUND_MAX_X = 300
const SCREEN_BOUND_MIN_X = -50

var saved_people_count = 0
var oxygen_level = 100
var current_points = 0
var highscore = 0

func _ready():
	var file = FileAccess.open("user://highscore.dat", FileAccess.READ)
	highscore = file.get_32()

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
