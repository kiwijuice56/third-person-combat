extends Node
class_name StateMachine

export var initial_state: NodePath
onready var state: State = get_node(initial_state)

func _physics_process(delta) -> void:
	state.physics_update(delta)
