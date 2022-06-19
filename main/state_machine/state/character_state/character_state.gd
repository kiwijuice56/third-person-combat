extends State
class_name CharacterState

var character: Character

func _ready():
	character = state_owner as Character
	assert(character != null)
