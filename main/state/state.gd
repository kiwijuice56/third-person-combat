extends Node
class_name State

@export var owner_path: NodePath
@onready var state_owner: Node
var state_machine: StateMachine = null

func _ready() -> void:
	state_owner = get_node(owner_path)

func physics_update(_delta) -> void:
	pass

func exit() -> void:
	pass

func enter(_msg: Dictionary = {}) -> void:
	pass
