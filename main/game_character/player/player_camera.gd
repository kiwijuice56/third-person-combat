extends Camera3D
class_name PlayerCamera

const TRANSITION_TIME: float = 0.25
const ROTATE_SPEED: float = 3.5
# Describes position of camera in targeting with (horizontal distance away from player colinear with the player and target, y distance above player)
const TARGETING_OFFSET: Vector2 = Vector2(2.0, 2.4)
# Describes position of neutral camera with (horizontal distance away from player, y distance above player)
const NORMAL_OFFSET: Vector2 = Vector2(3, 2.8)
# Describes the y distance above the player to aim at in neutral camera
const NORMAL_LOOK_OFFSET: float = 2.0

@onready var player: Player = get_parent()
var transition_tween: Tween

var rotation_enabled: bool = true

func _ready() -> void:
	transition_tween = get_tree().create_tween()
	recenter()

func _process(delta) -> void:
	if not rotation_enabled:
		return
	var input_direction: Vector2 =  get_input_direction()
	var rotate_axis = Vector3(0, input_direction.x, 0).normalized()
	if is_equal_approx(rotate_axis.y, 0.0):
		return
	var pivot_point = player.global_transform.origin
	var pivot_radius = global_transform.origin - pivot_point
	var pivot_transform = Transform3D(transform.basis, pivot_point)
	global_transform = pivot_transform.rotated(rotate_axis, delta * ROTATE_SPEED * min(1.0, abs(input_direction.x)))
	global_transform.origin = pivot_point + pivot_radius.rotated(rotate_axis, delta * ROTATE_SPEED * min(1.0, abs(input_direction.x)))

func get_input_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("cam_left") -
		Input.get_action_strength("cam_right"),
		0)

# Revert to normal positioning
func recenter() -> void:
	var player_to_camera: Vector3 = player.global_transform.origin.direction_to(global_transform.origin)
	var plane_direction: Vector2 = Vector2(player_to_camera.x, player_to_camera.z).normalized()
	
	var old_basis: Basis = basis
	var old_position: Vector3 = position
	position = Vector3(plane_direction.x * NORMAL_OFFSET.x, NORMAL_OFFSET.y, plane_direction.y * NORMAL_OFFSET.x)
	look_at(get_parent().global_transform.origin + Vector3(0, NORMAL_LOOK_OFFSET, 0))
	var new_basis: Basis = basis
	basis = old_basis
	position = old_position
	
	transition_tween.kill()
	transition_tween = get_tree().create_tween()
	transition_tween.tween_property(self, "transform:basis", new_basis, TRANSITION_TIME)
	transition_tween.parallel().tween_property(self, "position", Vector3(plane_direction.x * NORMAL_OFFSET.x, NORMAL_OFFSET.y, plane_direction.y * NORMAL_OFFSET.x), TRANSITION_TIME)

# Position and aim the camera to face a target while aligning with the player
func look_at_target(target: Node3D, offset: Vector3 = Vector3()) -> void:
	var target_to_player: Vector3 = target.global_transform.origin.direction_to(player.global_transform.origin)
	var targeting_position: Vector3 = Vector3(target_to_player.x * TARGETING_OFFSET.x, TARGETING_OFFSET.y, target_to_player.z * TARGETING_OFFSET.x) 
	targeting_position += offset
	
	var old_basis: Basis = basis
	var old_position: Vector3 = position
	position = targeting_position
	look_at(target.global_transform.origin)
	var new_basis: Basis = basis
	basis = old_basis
	position = old_position
	
	transition_tween.kill()
	transition_tween = get_tree().create_tween()
	transition_tween.tween_property(self, "transform:basis", new_basis, TRANSITION_TIME)
	transition_tween.parallel().tween_property(self, "position", targeting_position, TRANSITION_TIME)
