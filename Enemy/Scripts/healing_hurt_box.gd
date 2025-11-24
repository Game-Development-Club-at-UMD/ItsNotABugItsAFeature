class_name HealingHurtBox extends CharacterBody2D

@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var timer: Timer = $Timer
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2
@onready var hurt_box: HurtBox = $HurtBox

var following : bool = false

func _physics_process(delta: float) -> void:
	if following && player != null:
		velocity = lerp(velocity, global_position.direction_to(player.global_position) * 200, 12 * delta)
	move_and_slide()

func die():
	get_tree().get_first_node_in_group('camera').add_trauma(.5, Vector2(randf_range(-1, 1), randf_range(-1, 1)))
	cpu_particles_2d.one_shot = true
	cpu_particles_2d_2.one_shot = true
	audio_stream_player_2d.play()
	#await get_tree().create_timer(0.7).timeout
	hurt_box.queue_free()
	await cpu_particles_2d_2.finished
	queue_free()


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is Player:
		die()


func _on_timer_timeout() -> void:
	following = true
