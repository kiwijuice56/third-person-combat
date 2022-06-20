extends Camera3D
class_name PlayerCamera

const ROTATE_SPEED: float = 3.0

func _process(delta) -> void:
	var rotate_axis = Vector3(0, get_input_direction().x, 0).normalized()
	if is_equal_approx(rotate_axis.y, 0.0):
		return
	var pivot_point = get_parent().global_transform.origin
	var pivot_radius = global_transform.origin - pivot_point
	var pivot_transform = Transform3D(transform.basis, pivot_point)
	global_transform = pivot_transform.rotated(rotate_axis, delta*ROTATE_SPEED)
	global_transform.origin = pivot_point + pivot_radius.rotated(rotate_axis, delta*ROTATE_SPEED)

func get_input_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("cam_left") -
		Input.get_action_strength("cam_right"),
		0)
