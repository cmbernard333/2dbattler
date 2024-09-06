extends Panel

@export var label: NodePath

func _on_character_died(character: Character):
	var text = "You died!" if character.is_player else "You defeated!"
	var labelNode: Label = get_node(label)
	print(text)
	labelNode.text = text
	visible = true
	labelNode.visible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	var labelNode: Label = get_node(label)
	labelNode.visible = false
	SignalBus.character_died.connect(_on_character_died)
