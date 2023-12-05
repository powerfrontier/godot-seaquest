extends AudioStreamPlayer

func _ready():
	connect("finished", Callable(self, "_finished"))

func _finished():
	queue_free()
