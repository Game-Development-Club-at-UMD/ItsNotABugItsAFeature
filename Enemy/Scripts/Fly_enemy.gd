extends Enemy

@onready var animation_tree: AnimationTree = $Sprite2D/AnimationTree

var health: int

func _physics_process(delta: float) -> void:
	animation_tree.set("parameters/Idle/blend_position",velocity.normalized().x)
	animation_tree.set("parameters/Move/blend_position",velocity.normalized().x)
	
	move_enemy(delta, 100)
	velocity = navigation_agent_2d.get_velocity()
	move_and_slide()
	update_health(health)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	navigation_agent_2d.set_velocity(safe_velocity)
