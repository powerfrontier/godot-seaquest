extends Sprite2D

@export var order_number = 1

const FULL_TEXTURE = preload("res://user_interface/people-count/person_ui.png")

func _ready():
	GameEvent.connect("update_collected_people_count", Callable(self, "_update"))
	
func _update():
	if Global.saved_people_count >= order_number:
		texture = FULL_TEXTURE
