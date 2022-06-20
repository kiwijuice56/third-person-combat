extends PlayerState
class_name PlayerIdle

func physics_update(_delta) -> void:	
	# Keep colliding but cancel velocity
	player.velocity = Vector3()
	player.move_and_slide()
	
	if player.is_moving():
		state_machine.transition_to("PlayerRun")
	
	if not player.is_on_floor():
		state_machine.transition_to("PlayerAir")
		return
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("PlayerAir", {"init_y_vel" : player.JUMP_VELOCITY})
		return
	if Input.is_action_just_pressed("target"):
		state_machine.transition_to("PlayerStrafe")
