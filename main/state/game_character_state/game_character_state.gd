extends State
class_name GameCharacterState

var character: GameCharacter

func _ready():
	super._ready()
	character = state_owner as GameCharacter
	assert(character != null)
