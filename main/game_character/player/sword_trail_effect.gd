extends MeshInstance3D
class_name SwordTrailEffect

func _ready():
	$AnimationPlayer.connect("animation_finished", delete)

func delete(_anim: String) -> void:
	queue_free()
