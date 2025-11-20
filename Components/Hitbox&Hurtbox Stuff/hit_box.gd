class_name HitBox extends Area2D

@export var health_component : HealthComponent
@export var collision_shape2D : CollisionShape2D
@export var hit_effect : ParticleEmitter
@export var node_to_kill : Node

func _ready() -> void:
	health_component.die.connect(die)

func enable() -> void:
	collision_shape2D.disabled = false

func disable() -> void:
	collision_shape2D.disabled = true

func do_hit_effect() -> void:
	if hit_effect != null:
		hit_effect.emit(self)

func _on_area_entered(area: Area2D) -> void:
	if area is not HurtBox:
		return
	
	do_hit_effect()
	
	if health_component != null:
		health_component.take_damage((area as HurtBox).do_attack())
		# apply knockback
		var target_vector = node_to_kill.global_position.direction_to(area.global_position) * area.hurt_component.power
		node_to_kill.velocity = lerp(node_to_kill.velocity, target_vector, 3)

func die():
	if node_to_kill == null:
		return
	
	if node_to_kill.has_method("die"):
		node_to_kill.die()
	else:
		node_to_kill.queue_free()
