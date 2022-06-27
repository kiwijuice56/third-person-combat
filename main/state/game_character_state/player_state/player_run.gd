extends PlayerState
class_name PlayerRun

# CONNECTIONS
# Idle <- input:none
# Air <- input:jump, fall
# Attack <- input:attack
# StrafeTarget <- input:target

const MESH_TURN_SPEED: float = 17.5
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
	
	player.anim_tree.set("parameters/Run/Speed/blend_amount", player.accel_direction.length())
	player.accel_direction += input_direction * player.ACCEL
	player.velocity = (player.accel_direction.x * camera_basis.x + player.accel_direction.y * camera_basis.z) * player.MAX_SPEED
	player.velocity.y = 0
	player.move_and_slide()
	
	# Update targeting range rotation
	player.targeting_range.rotation.y = player.camera.rotation.y
	
	# Update mesh rotation
	player.mesh.rotation.y = GameCharacter.lerp_angle(
		player.mesh.rotation.y, 
		player.camera.rotation.y - Vector2(0, -1).angle_to(input_direction),
		MESH_TURN_SPEED * delta)
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("PlayerAir", {"init_velocity" : Vector3(0, player.JUMP_VELOCITY, 0)})
		return
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("PlayerAttack", {"running_start": true})
		return
	if Input.is_action_just_pressed("target") and len(player.targets) > 0:
		state_machine.transition_to("PlayerStrafe")
		return

func enter(_msg: Dictionary = {}) -> void:
	player.anim_playback.travel("Run")
