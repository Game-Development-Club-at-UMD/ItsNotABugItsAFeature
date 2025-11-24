extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fade_player: AnimationPlayer = $FadePlayer


func _ready() -> void:
	animation_player.play("sway")
	fade_player.play("FadeIn")



func _on_quit_pressed() -> void:
	fade_player.play("FadeOut")
	await fade_player.animation_finished
	get_tree().quit()
