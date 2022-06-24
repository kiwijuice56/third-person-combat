extends Control

@export var player_path: NodePath
@onready var player: Player

func _ready() -> void:
	player = get_node(player_path)
	player.connect("strafe_state_changed", strafe_state_changed)

func strafe_state_changed(is_strafing: bool) -> void:
	$AnimationPlayer.current_animation = "block" if is_strafing else "unblock"
