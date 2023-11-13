extends Node2D


@onready var left = $Left
@onready var right = $Right
const shark = preload("res://enemies/shark/shark.tscn")


func _on_timer_timeout():
	var rnd_spawn_side = bool(randi_range(0,1))
	var spawn_side = left
	if rnd_spawn_side:
		spawn_side = right
	var spawn_marker = randi_range(1, 4)
	
	var shark_instance = shark.instantiate()
	get_tree().current_scene.add_child(shark_instance)
	if rnd_spawn_side:
		shark_instance.flip_direction()
	var spawn_position = spawn_side.get_node(str(spawn_marker)).global_position
	
	shark_instance.global_position = spawn_position
	
	
