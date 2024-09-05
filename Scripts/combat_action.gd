extends Resource

class_name CombatAction

enum Target {SELF, SINGLE}

@export var display_name: String = "Action (x DMG)"
@export var damage: int = 0
@export var heal: int = 0
@export var target: Target = Target.SINGLE
