extends Enemy

@onready var enemy: Enemy = %Enemy as Enemy


func _physics_process(delta: float) -> void:
	move_enemy(delta, 100)
