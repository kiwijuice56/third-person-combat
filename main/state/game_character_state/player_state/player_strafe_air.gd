extends PlayerState
class_name PlayerStrafeAir

# CONNECTIONS
# Strafe <- jump complete

const HORIZONTAL_OFFSET: float = PlayerStrafe.HORIZONTAL_OFFSET

var flip_direction: Vector2

func physics_update(_delta) -> void:
	var old_y_vel = player.velocity.y
	var camera_basis: Basis = player.camera.global_transform.basis
	player.velocity = player.MAX_SPEED * (flip_direction.x * camera_basis.x + flip_direction.y * camera_basis.z)
	player.velocity.y = old_y_vel + player.gravity
	player.move_and_slide()
	
	# Rotate camera and player components to face target
	if len(player.targets) > 0:
		if flip_direction.x < 0:
			player.camera.look_at_target(player.targets[0], camera_basis.x * HORIZONTAL_OFFSET)
		elif flip_direction.x > 0:
			player.camera.look_at_target(player.targets[0], -camera_basis.x * HORIZONTAL_OFFSET)
		else:
			player.camera.look_at_target(player.targets[0])
		
		player.mesh.look_at(player.targets[0].global_transform.origin)
		player.shape.look_at(player.targets[0].global_transform.origin)
		player.targeting_range.look_at(player.targets[0].global_transform.origin)
		
		player.mesh.rotation = Vector3(0, player.mesh.rotation.y, 0)
		player.shape.rotation = Vector3(0, player.shape.rotation.y, 0)
		player.targeting_range.rotation = Vector3(0, player.targeting_range.rotation.y, 0)
	
	if player.is_on_floor():
		state_machine.transition_to("PlayerStrafe")

func enter(msg: Dictionary = {}) -> void:
	player.velocity = msg["init_velocity"] if "init_velocity" in msg else Vector3(0, player.gravity, 0)
	flip_direction = msg["flip_direction"] if "flip_direction" in msg else Vector2()
