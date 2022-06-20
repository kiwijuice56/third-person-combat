extends GameCharacter
class_name Player

const SPEED := 12.0
const JUMP_VELOCITY := 24.0

@onready var camera: Camera3D = $Camera3D
var targets: Array[CharacterBody3D] = []

func _ready():
	super._ready()
	$TargetingRange.connect("body_entered", target_entered)
	$TargetingRange.connect("body_exited", target_exited)

func get_input_direction() -> Vector2:
	return Vector2(
		-Input.get_action_strength("move_left") +
		Input.get_action_strength("move_right"),
		-Input.get_action_strength("move_forward") +
		Input.get_action_strength("move_backward"))

func is_moving() -> bool:
	var input_direction: Vector2 = get_input_direction()
	return not is_equal_approx(input_direction.x, 0.0) or not is_equal_approx(input_direction.y, 0.0)

func target_entered(target_area: Object) -> void:
	targets.append(target_area as CharacterBody3D)
	print("player.gd targets: " + str(targets))

func target_exited(target_area: Object) -> void:
	targets.erase(target_area as CharacterBody3D)
	print("player.gd targets: " + str(targets))
