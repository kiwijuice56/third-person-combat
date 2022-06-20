extends Camera3D
class_name PlayerCamera

const TARGET_Z: float = 2.0
const TARGET_Y: float = 2.0
const NORMAL_DIST: float = 3.0
const NORMAL_Y: float = 2.0
const ROTATE_SPEED: float = 3.0

@onready var player: Player = get_parent()

var rotation_enabled: bool = true

func _ready() -> void:
	recenter()

func _process(delta) -> void:
	if not rotation_enabled:
		return
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

func recenter() -> void:
	var player_to_camera: Vector3 = player.global_transform.origin.direction_to(global_transform.origin)
	var plane_direction: Vector2 = Vector2(player_to_camera.x, player_to_camera.z).normalized()
	position = Vector3(plane_direction.x * NORMAL_DIST, NORMAL_Y, plane_direction.y * NORMAL_DIST)
	look_at(get_parent().global_transform.origin)

func look_at_target(target: Node3D) -> void:
	var target_to_player: Vector3 = target.global_transform.origin.direction_to(player.global_transform.origin)
	position = target_to_player * TARGET_Z
	position.y = TARGET_Y
	look_at(target.position)
