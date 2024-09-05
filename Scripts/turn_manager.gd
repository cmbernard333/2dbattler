extends Node

@export var player_char: Node
@export var enemy_char: Node
@export var cur_char: Character # TODO: why not make the others Character?
@export var next_turn_delay: float = 1.0
@export var game_over: bool = false
var turn_order_decider: RandomNumberGenerator

func _roll_turn_order() -> int:
	return turn_order_decider.randi() % 20

# inform the character their turn has begun
func begin_next_turn():
	if cur_char == player_char:
		cur_char = enemy_char
	elif cur_char == enemy_char:
		cur_char = player_char
	else:
		# roll to see who goes first
		var player_roll = _roll_turn_order()
		var enemy_roll = _roll_turn_order()
		# favor player with ties
		cur_char = player_char if player_roll >= enemy_roll else enemy_char
	
	SignalBus.character_begin_turn.emit(cur_char)
	
# end the current turn
func end_current_turn():
	# SignalBus.character_end_turn.emit(cur_char)
	await get_tree().create_timer(next_turn_delay).timeout
	if game_over == false:
		begin_next_turn()
	
# a character has died
func character_died(character: Character):
	game_over = true
	if character.is_player == true:
		print("You died!")
	else:
		print("You defeated!")

func character_combat_action(combat_action: CombatAction):
	var target = enemy_char if cur_char == player_char else player_char
	cur_char.use_combat_action(combat_action, target)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turn_order_decider = RandomNumberGenerator.new()
	turn_order_decider.randomize()
	# global signal handling
	SignalBus.combat_button_pushed.connect(character_combat_action)
	SignalBus.character_died.connect(character_died)
	SignalBus.character_end_turn.connect(end_current_turn)
	await get_tree().create_timer(0.5).timeout
	begin_next_turn()
