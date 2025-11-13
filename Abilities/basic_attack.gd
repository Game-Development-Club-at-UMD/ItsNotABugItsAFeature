extends Node2D

@onready var attack_animation: AnimatedSprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_animation.play()

func _on_sprite_2d_animation_finished() -> void:
	attack_animation.stop()
	attack_animation.visible = false
	await get_tree().create_timer(0.2).timeout
	self.queue_free()
