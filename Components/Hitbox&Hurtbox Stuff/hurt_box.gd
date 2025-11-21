class_name HurtBox extends Area2D

@export var hurt_component : HurtComponent
@export var collision_shape2D : CollisionShape2D


func enable() -> void:
	collision_shape2D.disabled = false

func disable() -> void:
	collision_shape2D.disabled = true

func do_attack() -> int:
	return hurt_component.power
	
