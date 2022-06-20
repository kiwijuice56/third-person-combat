extends PlayerState
class_name PlayerRun

func physics_update(delta) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("PlayerAir")
		return
	
	var input_direction: Vector2 = player.get_input_direction().normalized()
	var camera_basis: Basis = player.get_camera_basis()
	player.velocity = player.SPEED * (input_direction.x * camera_basis.x) + player.SPEED * (input_direction.y * camera_basis.z)
	player.velocity.y = 0
	player.move_and_slide()
	
	if is_equal_approx(player.velocity.x, 0.0) and is_equal_approx(player.velocity.z, 0.0):
		state_machine.transition_to("PlayerIdle")
