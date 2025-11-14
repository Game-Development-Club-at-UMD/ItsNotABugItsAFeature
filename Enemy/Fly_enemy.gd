extends Enemy

#@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


func _process(delta: float) -> void:
	move_enemy(1.0)
