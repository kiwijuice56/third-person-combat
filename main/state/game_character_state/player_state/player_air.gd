extends PlayerState
class_name PlayerAir

func physics_update(_delta) -> void:
	# Move the same as PlayerRun but apply gravity
	var input_direction: Vector2 = player.get_input_direction().normalized()
	var camera_basis: Basis = player.camera.global_transform.basis
	var old_y_vel = player.velocity.y
	
	player.accel_direction += input_direction * player.ACCEL
	player.velocity = (player.accel_direction.x * camera_basis.x + player.accel_direction.y * camera_basis.z) * player.MAX_SPEED
	player.velocity.y = old_y_vel + player.gravity
	player.move_and_slide()
	
	# Update targeting range rotation
	player.targeting_range.rotation.y = player.camera.rotation.y
	
	# Update mesh rotation
	if player.is_moving():
		player.mesh.rotation.y = player.camera.rotation.y - Vector2(0, -1).angle_to(input_direction)
	
	if player.is_on_floor():
		if not player.is_moving():
			state_machine.transition_to("PlayerIdle")
		else:
			state_machine.transition_to("PlayerRun")

func enter(msg: Dictionary = {}) -> void:
	player.velocity = msg["init_velocity"] if "init_velocity" in msg else Vector3(0, player.gravity, 0)
