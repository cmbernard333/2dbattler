extends Node

# global signal handling - in autoload scripts
signal character_died(character: Character)
signal character_begin_turn(character: Character)
signal character_end_turn(character: Character)
signal combat_button_pushed(action: CombatAction)
