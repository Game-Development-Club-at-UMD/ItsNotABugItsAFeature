extends Enemy

func _physics_process(delta: float) -> void:
	move_and_slide()
	move_enemy(delta, 100)
