class_name Bullet extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var hurt_box: HurtBox = $HurtBox

func _ready() -> void:
	animation_player.play("bullet_fade")
	hurt_box.doing_attack.connect(die)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func die():
	self.queue_free()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	die()
