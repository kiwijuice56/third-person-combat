extends PlayerState
class_name PlayerStrafe

func physics_update(delta) -> void:
	if len(player.targets) == 0 or Input.is_action_just_pressed("target"):
		player.camera.recenter()
		state_machine.transition_to("PlayerRun")
		return
	
	# Take directional input and move in camera direction axis
	var input_direction: Vector2 = player.get_input_direction().normalized()
	var camera_basis: Basis = player.camera.global_transform.basis
	player.velocity = player.SPEED * (input_direction.x * camera_basis.x) + player.SPEED * (input_direction.y * camera_basis.z)
	player.velocity.y = 0
	player.move_and_slide()
	
	player.camera.look_at_target(player.targets[0])
	
	if player.is_moving():
		player.mesh.rotation.y = player.camera.rotation.y - Vector2(1, 0).angle_to(input_direction)
	
	if not player.is_on_floor():
		state_machine.transition_to("PlayerAir")
		player.camera.recenter()
		return
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("PlayerAir", {"init_y_vel" : player.JUMP_VELOCITY})
		player.camera.recenter()
		return

func enter(msg: Dictionary = {}) -> void:
	player.camera.rotation_enabled = false

func exit() -> void:
	player.camera.rotation_enabled = true
