extends Control

@onready var score_label = $CurrentScoreLabel
@onready var game_over_timer = $GameOverDelay

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvent.connect("game_over", Callable(self, "_game_over_screen"))
	visible = false

func _process(delta):
	if Input.is_action_just_pressed("shoot") && visible:
		get_tree().reload_current_scene()

func _game_over_screen():
	game_over_timer.start()
	score_label.text = "Score " + str(Global.current_points)

func _on_game_over_delay_timeout():
	visible = true
