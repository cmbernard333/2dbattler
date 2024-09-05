extends VBoxContainer

@export var buttons: Array[NodePath]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.character_begin_turn.connect(_on_character_begin_turn)
	SignalBus.character_end_turn.connect(_on_character_end_turn)

func _display_combat_actions(combat_actions: Array[CombatAction]):
	for i in len(buttons):
		var button = get_node(buttons[i])
		if i < len(combat_actions):
			button.text = combat_actions[i].display_name
			button.combat_action = combat_actions[i]
			button.visible = true
		else:
			button.visible = false

# change visibility of this node based on if the character is the player
func _on_character_begin_turn(character: Character):
	visible = character.is_player
	if character.is_player:
		_display_combat_actions(character.combat_actions)

func _on_character_end_turn(character: Character):
	visible = false
