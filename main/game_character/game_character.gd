extends CharacterBody3D
class_name GameCharacter

@export var mesh_path: NodePath
@onready var mesh: Node3D = get_node(mesh_path)
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var anim_playback: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")

var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	$StateMachine.connect("transitioned", update_state_label)

func update_state_label(new_state_name: String) -> void:
	$StateLabel.text = new_state_name

static func lerp_angle(from: float, to: float, weight: float) -> float:
	return from + short_angle_dist(from, to) * weight

static func short_angle_dist(from: float, to: float) -> float:
	var difference = fmod(to - from, PI * 2)
	return fmod(2 * difference, PI * 2) - difference
