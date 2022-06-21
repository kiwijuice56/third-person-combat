extends PlayerState
class_name PlayerRun

const TURN_TWEEN_CUTOFF: float = PI/2

func physics_update(delta) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("PlayerAir")
		return
	if not player.is_moving():
		state_machine.transition_to("PlayerIdle")
		return
	
	# Take directional input and move in camera direction axis
	var input_direction: Vector2 = player.get_input_direction().normalized()
	var camera_basis: Basis = player.camera.global_transform.basis
	
	player.accel_direction += input_direction * player.ACCEL
	player.velocity = (player.accel_direction.x * camera_basis.x + player.accel_direction.y * camera_basis.z) * player.MAX_SPEED
	player.velocity.y = 0
	player.move_and_slide()
	
	# Update targeting range rotation
	player.targeting_range.rotation.y = player.camera.rotation.y
	
	# Update mesh rotation
	player.mesh.rotation.y = player.camera.rotation.y - Vector2(0, -1).angle_to(input_direction)
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("PlayerAir", {"init_velocity" : Vector3(0, player.JUMP_VELOCITY, 0)})
		return
	if Input.is_action_just_pressed("target") and len(player.targets) > 0:
		state_machine.transition_to("PlayerStrafe")
		return
