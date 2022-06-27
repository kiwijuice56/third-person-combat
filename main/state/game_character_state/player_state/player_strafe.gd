extends PlayerState
class_name PlayerStrafe

# CONNECTIONS
# Idle <- input:target
# StrafeAir <- input:jump
# Air <- fall
# Attack <- input:attack

# Slowing of movement in different directions while strafing
const DRAG: float = 0.75
const HORIZONTAL_DRAG: float = 0.55
const BACKWARD_DRAG: float = 0.55
const SIDE_STEP_VELOCITY: Vector2 = Vector2(10, 12)

# Describes how far to offset camera when moving left or right
const HORIZONTAL_OFFSET: float = 1.5
# Describes the horizontal distance from the player to point the camera in neutral strafing for visibility
const NEUTRAL_HORIZONTAL_OFFSET: float = 0.8

func physics_update(_delta) -> void:
	# Return with no targets or prompt to untarget
	if len(player.targets) == 0 or Input.is_action_just_pressed("target"):
		player.camera.recenter()
		state_machine.transition_to("PlayerRun")
		stop_strafing()
		return
		
	# Take directional input and move in camera direction axis
	var input_direction: Vector2 = player.get_input_direction()
	if is_zero_approx(input_direction.length()):
		player.accel_direction -= player.accel_direction * player.ACCEL
	else:
		player.accel_direction += input_direction * player.ACCEL
	
	player.anim_tree.set("parameters/Strafe/Direction/blend_amount", player.accel_direction.x)
	
	var camera_basis: Basis = player.camera.global_transform.basis
	player.velocity = DRAG * player.MAX_SPEED * (
		(player.accel_direction.x * HORIZONTAL_DRAG * camera_basis.x) +
		((BACKWARD_DRAG if input_direction.y > 0.0 else 1.0) * player.accel_direction.y * camera_basis.z))
	player.velocity.y = 0
	player.move_and_slide()
	
	# Rotate camera and player components to face target
	if input_direction.x < 0:
		player.camera.look_at_target(player.targets[0], camera_basis.x * HORIZONTAL_OFFSET)
	elif input_direction.x > 0:
		player.camera.look_at_target(player.targets[0], -camera_basis.x * HORIZONTAL_OFFSET)
	else:
		var cam_to_target: Vector3 = (player.camera.global_transform.origin - player.targets[0].global_transform.origin).normalized()
		var cam_to_target_2d: Vector2 = Vector2(cam_to_target.x, cam_to_target.z).rotated(-player.camera.rotation.y).normalized()
		
		var cam_to_player: Vector3 = (player.camera.global_transform.origin - player.global_transform.origin).normalized()
		var cam_to_player_2d: Vector2 = Vector2(cam_to_player.x, cam_to_player.z).rotated(-player.camera.rotation.y).normalized()
		
		var angle_dif: float = cam_to_player_2d.angle_to(cam_to_target_2d)
		player.camera.look_at_target(player.targets[0], (1 if angle_dif > 0.0 else -1) * camera_basis.x * NEUTRAL_HORIZONTAL_OFFSET)
	
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
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("PlayerAttack", {"strafing": true})
		return

func enter(_msg: Dictionary = {}) -> void:
	player.camera.rotation_enabled = false
	player.anim_playback.travel("Strafe")
	player.emit_signal("strafe_state_changed", true)

func stop_strafing() -> void:
	player.camera.rotation_enabled = true
	player.emit_signal("strafe_state_changed", false)
