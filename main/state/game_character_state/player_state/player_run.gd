extends PlayerState
class_name PlayerRun

func physics_update(delta) -> void:
	# Take directional input and move in camera direction axis
	var input_direction: Vector2 = player.get_input_direction().normalized()
	var camera_basis: Basis = player.camera.global_transform.basis
	player.velocity = player.SPEED * (input_direction.x * camera_basis.x) + player.SPEED * (input_direction.y * camera_basis.z)
	player.velocity.y = 0
	player.move_and_slide()
	
	if player.is_moving():
		player.mesh.rotation.y = player.camera.rotation.y - Vector2(1, 0).angle_to(input_direction)
	
	if not player.is_on_floor():
		state_machine.transition_to("PlayerAir")
		return
	if not player.is_moving():
		state_machine.transition_to("PlayerIdle")
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("PlayerAir", {"init_y_vel" : player.JUMP_VELOCITY})
		return
	if Input.is_action_just_pressed("target"):
		state_machine.transition_to("PlayerStrafe")
