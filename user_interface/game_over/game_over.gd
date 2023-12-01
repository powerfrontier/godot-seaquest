extends Control

@onready var score_label = $CurrentScoreLabel
@onready var game_over_timer = $GameOverDelay
@onready var highscore = $HighScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvent.connect("game_over", Callable(self, "_game_over_screen"))
	visible = false

func _process(delta):
	if Input.is_action_just_pressed("shoot") && visible:
		Global.saved_people_count = 0
		Global.oxygen_level = 100
		Global.current_points = 0
		get_tree().reload_current_scene()

func _game_over_screen():
	game_over_timer.start()
	score_label.text = "Score " + str(Global.current_points)
	if Global.current_points > Global.highscore:
		Global.highscore = Global.current_points
	highscore.text = "Highscore "  + str(Global.highscore)

func _on_game_over_delay_timeout():
	visible = true
