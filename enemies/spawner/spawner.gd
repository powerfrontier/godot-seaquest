extends Node2D


@onready var left = $Left
@onready var right = $Right
const shark = preload("res://enemies/shark/shark.tscn")
const person = preload("res://person/person.tscn")


func _on_enemy_timer_timeout():
	for i in range(4):
		#print(i)
		spawn_enemy(i+1)
		
	
	
func spawn_enemy(level):
	var rnd_spawn_side = bool(randi_range(0,1))
	var spawn_side = left
	if rnd_spawn_side:
		spawn_side = right
	#var spawn_marker = randi_range(1, 4)
	
	var shark_instance = shark.instantiate()
	get_tree().current_scene.add_child(shark_instance)
	if rnd_spawn_side:
		shark_instance.flip_direction()
	#var spawn_position = spawn_side.get_node(str(spawn_marker)).global_position
	var spawn_position = spawn_side.get_node(str(level)).global_position
	
	shark_instance.global_position = spawn_position


func _on_person_timer_timeout():
	#print("person")
	var rnd_spawn_side = bool(randi_range(0,1))
	var spawn_side = left
	if rnd_spawn_side:
		spawn_side = right
	var spawn_marker = randi_range(1, 4)
	
	var person_instance = person.instantiate()
	get_tree().current_scene.add_child(person_instance)
	if rnd_spawn_side:
		person_instance.flip_direction()
	var spawn_position = spawn_side.get_node(str(spawn_marker)).global_position	
	
	person_instance.global_position = spawn_position
