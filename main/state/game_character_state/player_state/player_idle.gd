extends PlayerState
class_name PlayerIdle

func physics_update(_delta) -> void:
	if player.is_moving():
		state_machine.transition_to("PlayerRun")
		return
	if not player.is_on_floor():
		state_machine.transition_to("PlayerAir")
		return
	
	# Keep colliding but cancel velocity
	player.accel_direction -= player.accel_direction * player.ACCEL
	
	var camera_basis: Basis = player.camera.global_transform.basis
	player.velocity = (player.accel_direction.x * camera_basis.x + player.accel_direction.y * camera_basis.z) * player.MAX_SPEED
	player.velocity.y = 0
	player.move_and_slide()
	
	# Update targeting range rotation
	player.targeting_range.rotation.y = player.camera.rotation.y
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("PlayerAir",  {"init_velocity" : Vector3(0, player.JUMP_VELOCITY, 0)})
		return
	if Input.is_action_just_pressed("target") and len(player.targets) > 0:
		state_machine.transition_to("PlayerStrafe")

func enter(_msg: Dictionary = {}) -> void:
	player.anim_playback.travel("Idle")
