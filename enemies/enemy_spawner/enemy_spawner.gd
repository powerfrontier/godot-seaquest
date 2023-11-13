extends Marker2D

const Shark = preload("res://enemies/shark/shark.tscn")

@onready var timer = $Timer

@export var reverse = false

func _ready():
	timer.wait_time = randf_range(0.5, 5)
	timer.start()

func _on_timer_timeout():
	var shark_instance = Shark.instantiate()
	get_tree().current_scene.add_child(shark_instance)
	shark_instance.global_position = global_position
	timer.wait_time = randf_range(0.5, 5)
	if reverse:
		shark_instance.flip_direction()
