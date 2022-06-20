extends PlayerState
class_name PlayerIdle

func physics_update(_delta) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("PlayerAir")
		return
	var input_direction: Vector2 = player.get_input_direction()
	if not is_equal_approx(input_direction.x, 0.0) or not is_equal_approx(input_direction.y, 0.0):
		state_machine.transition_to("PlayerRun")
