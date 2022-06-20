extends GameCharacter
class_name Player

const SPEED = 8.0
const JUMP_VELOCITY = 4.5

func get_input_direction() -> Vector2:
	return Vector2(
		-Input.get_action_strength("move_left") +
		Input.get_action_strength("move_right"),
		-Input.get_action_strength("move_forward") +
		Input.get_action_strength("move_backward"))

func get_camera_basis() -> Basis:
	return $Camera3D.global_transform.basis
