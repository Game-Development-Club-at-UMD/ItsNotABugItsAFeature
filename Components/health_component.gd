class_name HealthComponent extends Resource
signal healthChanged
signal die

@export var health : int = 0
@export var max_health : int = 0


func take_damage(amount : int):
	health = clampi(health - amount, 0, max_health)
	healthChanged.emit()
	if health == 0:
		die.emit()

func heal(amount : int):
	health = clampi(health + amount, 0, max_health)
	
