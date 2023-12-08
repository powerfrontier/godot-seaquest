extends Node2D

var value = 0
var color = Color(1, 1, 1)

const SPEED = 20

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = str(value)
	label.add_theme_color_override("font_color", color)
	rotation_degrees = randf_range(0, 360)

func _physics_process(delta):
	rotation_degrees = lerp(rotation_degrees, 0.0, 18 * delta)
	global_position.y -= SPEED * delta
	




