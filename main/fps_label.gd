extends Label
class_name FpsLabel

const UPDATE_TIME = 1.0

func _ready():
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.start(UPDATE_TIME)
	timer.connect("timeout", update_fps)


func update_fps() -> void:
	text = "fps: " + str(Engine.get_frames_per_second())
