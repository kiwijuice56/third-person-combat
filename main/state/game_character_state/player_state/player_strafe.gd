extends PlayerState
class_name PlayerStrafe

const DRAG: float = 0.85
const HORIZONTAL_DRAG: float = 0.65
const BACKWARD_DRAG: float = 0.85

func physics_update(_delta) -> void:
	# Return with no targets or prompt to untarget
	if len(player.targets) == 0 or Input.is_action_just_pressed("target"):
		player.camera.recenter()
		state_machine.transition_to("PlayerRun")
		return
	
	# Take directional input and move in camera direction axis
	var input_direction: Vector2 = player.get_input_direction().normalized()
	var camera_basis: Basis = player.camera.global_transform.basis
	player.velocity = DRAG * player.SPEED * (
		(HORIZONTAL_DRAG * input_direction.x * camera_basis.x) +
		((BACKWARD_DRAG if input_direction.y > 0.0 else 1.0) * input_direction.y * camera_basis.z))
	player.velocity.y = 0
	player.move_and_slide()
	
	# Rotate camera and player components to face target
	player.camera.look_at_target(player.targets[0])
	
	player.mesh.look_at(player.targets[0].global_transform.origin)
	player.mesh.rotation = Vector3(0, player.mesh.rotation.y, 0)
	player.shape.look_at(player.targets[0].global_transform.origin)
	player.shape.rotation = Vector3(0, player.shape.rotation.y, 0)
	player.targeting_range.look_at(player.targets[0].global_transform.origin)
	player.targeting_range.rotation = Vector3(0, player.targeting_range.rotation.y, 0)
	
	if not player.is_on_floor():
		state_machine.transition_to("PlayerAir")
		player.camera.recenter()
		return
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("PlayerAir", {"init_y_vel" : player.JUMP_VELOCITY})
		player.camera.recenter()
		return

func enter(_msg: Dictionary = {}) -> void:
	player.camera.rotation_enabled = false

func exit() -> void:
	player.camera.rotation_enabled = true
