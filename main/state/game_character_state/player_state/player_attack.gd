extends PlayerState
class_name PlayerAttack

# CONNECTIONS
# Idle <- input:none
# Strafe <- input:none & was strafing

const ATTACK_WINDOW_START: float = 0.4
const ATTACK_WINDOW_END: float = 0.325
const RUNNING_HIT_IMPULSE: float = 0.6
const IDLE_HIT_IMPULSE: float = 0.1
const MAX_COMBO: int = 2

var combo: int = 0
var timer: Timer 
var strafing: bool = false
var window_open: bool = false
var running_start: bool = false

func _ready() -> void:
	super._ready()
	timer = Timer.new()
	timer.one_shot = true
	timer.connect("timeout", attack_stage_transition)
	add_child(timer)

func physics_update(_delta) -> void:
	var player_mesh_basis: Basis = player.mesh.global_transform.basis
	
	player.anim_tree.set("parameters/Run/Speed/blend_amount", player.accel_direction.length())
	player.accel_direction = Vector2(0, RUNNING_HIT_IMPULSE if running_start and combo == 0 else IDLE_HIT_IMPULSE)
	player.velocity = (player.accel_direction.x * player_mesh_basis.x + player.accel_direction.y * player_mesh_basis.z) * -player.MAX_SPEED
	player.velocity.y = 0
	player.move_and_slide()
	
	if strafing:
		var camera_basis: Basis = player.camera.global_transform.basis
		var cam_to_target: Vector3 = (player.camera.global_transform.origin - player.targets[0].global_transform.origin).normalized()
		var cam_to_target_2d: Vector2 = Vector2(cam_to_target.x, cam_to_target.z).rotated(-player.camera.rotation.y).normalized()
		
		var cam_to_player: Vector3 = (player.camera.global_transform.origin - player.global_transform.origin).normalized()
		var cam_to_player_2d: Vector2 = Vector2(cam_to_player.x, cam_to_player.z).rotated(-player.camera.rotation.y).normalized()
		
		var angle_dif: float = cam_to_player_2d.angle_to(cam_to_target_2d)
		player.camera.look_at_target(player.targets[0], (1 if angle_dif > 0.0 else -1) * camera_basis.x * PlayerStrafe.NEUTRAL_HORIZONTAL_OFFSET)
	
	if window_open and Input.is_action_just_pressed("attack"):
		combo += 1
		if combo <= MAX_COMBO:
			attack_hit()

func enter(msg: Dictionary = {}) -> void:
	running_start = msg["running_start"] if "running_start" in msg else false
	strafing = msg["strafing"] if "strafing" in msg else false
	combo = 0
	attack_hit()

func attack_stage_transition() -> void:
	if not window_open:
		window_open = true
		timer.start(ATTACK_WINDOW_END)
	else:
		state_machine.transition_to("PlayerIdle" if not strafing else "PlayerStrafe")

func attack_hit() -> void:
	window_open = false
	timer.start(ATTACK_WINDOW_START)
	
	player.anim_playback.travel("Attack" + str(combo))
