extends Label


func _ready():
	GameEvent.connect("update_points", Callable(self, "_points_updated"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _points_updated():
	text = str(Global.current_points)
