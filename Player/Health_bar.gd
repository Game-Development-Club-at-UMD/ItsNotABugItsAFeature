extends ProgressBar


@export var Hitbox : HitBox


func _ready():
	
	Hitbox.health_component.healthChanged.connect(update)
	update()
	

func update():

	value = Hitbox.health_component.health * 100 / Hitbox.health_component.max_health
	 	
