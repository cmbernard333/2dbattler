extends Button

var combat_action: CombatAction

func _on_pressed() -> void:
	print(combat_action.display_name + "button pushed")
	SignalBus.combat_button_pushed.emit(combat_action)
