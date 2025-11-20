extends ProgressBar


@export var Hitbox : HitBox

func _ready():
	print("haiiiii")
	if Hitbox == null:
		print("haiiiii2")
		return
	Hitbox.healthChanged.connect(update)
	update()


func update():

	value = Hitbox.health_component.health * 100 / Hitbox.health_component.max_health
	 	
