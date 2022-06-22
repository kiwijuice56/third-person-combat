extends PlayerState
class_name PlayerStrafe

# Slowing of movement in different directions while strafing
const DRAG: float = 0.75
const HORIZONTAL_DRAG: float = 0.55
const BACKWARD_DRAG: float = 0.55

const SIDE_STEP_VELOCITY: Vector2 = Vector2(10, 12)

# How far to offset camera when moving left or right
const HORIZONTAL_OFFSET: float = 0.65

func physics_update(_delta) -> void:
	# Return with no targets or prompt to untarget
	if len(player.targets) == 0 or Input.is_action_just_pressed("target"):
		player.camera.recenter()
		state_machine.transition_to("PlayerRun")
		return
	
	# Take directional input and move in camera direction axis
	var input_direction: Vector2 = player.get_input_direction().normalized()
	var camera_basis: Basis = player.camera.global_transform.basis
	player.velocity = DRAG * player.MAX_SPEED * (
		(HORIZONTAL_DRAG * input_direction.x * camera_basis.x) +
		((BACKWARD_DRAG if input_direction.y > 0.0 else 1.0) * input_direction.y * camera_basis.z))
	player.velocity.y = 0
	player.move_and_slide()
	
	# Rotate camera and player components to face target
	if input_direction.x < 0:
		player.camera.look_at_target(player.targets[0], camera_basis.x * HORIZONTAL_OFFSET)
	elif input_direction.x > 0:
		player.camera.look_at_target(player.targets[0], -camera_basis.x * HORIZONTAL_OFFSET)
	else:
		player.camera.look_at_target(player.targets[0])
	
	player.mesh.look_at(player.targets[0].global_transform.origin)
	player.shape.look_at(player.targets[0].global_transform.origin)
	player.targeting_range.look_at(player.targets[0].global_transform.origin)
	
	# Cancel all but y rotation
	player.mesh.rotation = Vector3(0, player.mesh.rotation.y, 0)
	player.shape.rotation = Vector3(0, player.shape.rotation.y, 0)
	player.targeting_range.rotation = Vector3(0, player.targeting_range.rotation.y, 0)
	
	if not player.is_on_floor():
		state_machine.transition_to("PlayerAir")
		player.camera.recenter()
		return
	
	if Input.is_action_just_pressed("jump"):
		var flip_direction: Vector2
		if Input.is_action_pressed("move_left"):
			flip_direction = Vector2(-1, -0.7).normalized()
		if Input.is_action_pressed("move_right"):
			flip_direction = Vector2(1, -0.7).normalized()
		if Input.is_action_pressed("move_backward"):
			flip_direction = Vector2(0, 1).normalized()
		state_machine.transition_to("PlayerStrafeAir", {"init_velocity" : Vector3(0, SIDE_STEP_VELOCITY.y, 0), "flip_direction": flip_direction})
		return

func enter(_msg: Dictionary = {}) -> void:
	player.camera.rotation_enabled = false

func exit() -> void:
	player.camera.rotation_enabled = true
