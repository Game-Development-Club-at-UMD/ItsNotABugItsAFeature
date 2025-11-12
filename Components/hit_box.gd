class_name HitBox extends Area2D

@export var health_component : HealthComponent
@export var collision_shape2D : CollisionShape2D
@export var hit_effect : PackedScene

func enable() -> void:
	collision_shape2D.disabled = false

func disable() -> void:
	collision_shape2D.disabled = true

func do_hit_effect() -> void:
	add_child(hit_effect.instantiate())

func _on_area_entered(area: Area2D) -> void:
	if area is not HurtBox:
		return
	area = area as HurtBox
	do_hit_effect()
	
	if health_component != null:
		health_component.take_damage(area.do_attack())
