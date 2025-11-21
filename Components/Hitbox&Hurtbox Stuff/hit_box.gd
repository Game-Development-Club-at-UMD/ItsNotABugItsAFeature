class_name HitBox extends Area2D

@export var health_component : HealthComponent
@export var collision_shape2D : CollisionShape2D
@export var hit_effect : ParticleEmitter
@export var node_to_kill : Node

@onready var invinc_timer: Timer = $InvincTimer

var invinc_time : float = 0.5

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
	
	# allowing healing items even if invinc frames
	if area.hurt_component.power < 0:
		health_component.take_damage(area.do_attack())
		return
	
	if !invinc_timer.is_stopped():
		return
	
	do_hit_effect()
	invinc_timer.start(invinc_time)
	
	
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


func _on_invinc_timer_timeout() -> void:
	pass
