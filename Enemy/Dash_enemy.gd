extends Enemy

var isDashing : bool

func _physics_process(delta: float) -> void:
	if isDashing:
		pass
	else:
		move_enemy(delta, 100)

func dashing() -> void:
	pass
	
