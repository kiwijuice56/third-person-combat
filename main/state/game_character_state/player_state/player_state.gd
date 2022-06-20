extends GameCharacterState
class_name PlayerState

var player: Player

func _ready() -> void:
	super._ready()
	player = state_owner as Player
	assert(player != null)
