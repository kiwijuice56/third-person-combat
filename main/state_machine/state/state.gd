extends Node
class_name State

export var owner_path: NodePath
onready var state_owner: Node = get_node(owner_path)

func physics_update(_delta) -> void:
	pass
