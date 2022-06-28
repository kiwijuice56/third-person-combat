extends MeshInstance3D
class_name SwordTrail

@export var trail_effect_scene: PackedScene
@onready var sword_position: BoneAttachment3D = $"../SwordPosition"
var active: bool = false

func _process(_delta) -> void:
	if active:
		var new_trail = trail_effect_scene.instantiate()
		get_tree().get_root().add_child(new_trail)
		new_trail.global_transform = sword_position.global_transform
		new_trail.scale = Vector3(0.3, 0.3, -0.3)
