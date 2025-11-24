class_name HealingHurtBox extends CharacterBody2D

@onready var player : Player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	velocity = lerp(velocity, global_position.direction_to(player.global_position) * 200, 12 * delta)
	move_and_slide()


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is Player:
		queue_free()
