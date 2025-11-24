class_name Bullet extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hurt_box: HurtBox = $HurtBox
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2

func _ready() -> void:
	animation_player.play("bullet_fade")
	hurt_box.doing_attack.connect(die)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func die():
	cpu_particles_2d.one_shot = true
	cpu_particles_2d_2.one_shot = true
	audio_stream_player_2d.play()
	await cpu_particles_2d_2.finished
	await get_tree().create_timer(.02).timeout
	self.queue_free()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	die()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is StaticBody2D or body is Player:
		die()
