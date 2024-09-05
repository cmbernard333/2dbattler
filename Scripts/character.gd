extends Node2D

class_name Character

@export var is_player: bool
@export var cur_hp : int = 25
@export var max_hp : int = 25
@export var combat_actions : Array[CombatAction]
# @export var opponent: Node # should probably be in turn_manager
@export var visual: Texture2D
@export var flip_visual: bool

@onready var health_bar : ProgressBar = get_node("HealthBar")
@onready var health_text : Label = get_node("HealthBar/HealthText")

func take_damage (damage : int):
	cur_hp = 0 if cur_hp - damage < 0 else cur_hp - damage
	if cur_hp == 0:
		# signal via signal bus that this character has died
		SignalBus.character_died.emit(self)
		queue_free()
	_update_health_bar()
	
func heal (amount: int):
	cur_hp = max_hp if cur_hp + amount > max_hp else cur_hp + amount
	_update_health_bar()

# use the provided combat action on the current character
func use_combat_action(action: CombatAction, opponent: Character):
	if action.damage > 0:
		opponent.take_damage(action.damage)
	elif action.heal > 0:
		self.heal(action.heal)
	SignalBus.character_end_turn.emit()
	
	
func _decide_combat_action(opponent: Character):
	var health_percent: float = float(cur_hp) / float(max_hp)
	if randf() > health_percent + 0.2:
		# find the heal action and use it - first is fine
		var heal_actions: Array[CombatAction] = combat_actions.filter(func(action): return action.heal > 0)
		use_combat_action(heal_actions[0], opponent)
	else:
		# find the highest damage action and use it
		var damage_actions: Array[CombatAction] = combat_actions.filter(func(action): return action.damage > 0)
		use_combat_action(damage_actions[0], opponent)

func _on_character_begin_turn(character: Character, opponent: Character):
	if character == self and !is_player:
		# basic AI decision function
		_decide_combat_action(opponent)
	
func _update_health_bar():
	health_bar.value = cur_hp
	health_text.text = str(cur_hp, "/", max_hp)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.character_begin_turn.connect(_on_character_begin_turn)
	health_bar.max_value = max_hp
	# accessing the $Sprite node of the character node tree
	$Sprite.texture = visual
	$Sprite.flip_h = flip_visual

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
