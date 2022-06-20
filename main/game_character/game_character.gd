extends CharacterBody3D
class_name GameCharacter

var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	$StateMachine.connect("transitioned", update_state_label)

func update_state_label(new_state_name: String) -> void:
	$StateLabel.text = new_state_name
