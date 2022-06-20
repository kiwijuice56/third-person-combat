extends Node
class_name StateMachine

signal transitioned(state_name)

@export var state_enabled: bool = true
@export var initial_state: NodePath
@onready var state: State = get_node(initial_state)

func _ready():
	await owner.ready
	for child in get_children():
		var state_child: State = child as State
		assert(state_child != null)
		state_child.state_machine = self
	if not state_enabled:
		set_physics_process(false)
	else:
		state.enter()

func _physics_process(delta) -> void:
	state.physics_update(delta)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	assert(has_node(target_state_name))
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
