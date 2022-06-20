extends PlayerState
class_name PlayerAir

func physics_update(delta) -> void:
	var input_direction: Vector2 = player.get_input_direction().normalized()
	player.velocity.x = player.SPEED * input_direction.x
	player.velocity.z = player.SPEED * input_direction.y
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0) and is_equal_approx(player.velocity.z, 0.0):
			state_machine.transition_to("PlayerIdle")
		else:
			state_machine.transition_to("PlayerRun")
