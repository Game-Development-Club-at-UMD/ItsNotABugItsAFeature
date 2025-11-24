extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fade_player: AnimationPlayer = $FadePlayer
@onready var quit_text: RichTextLabel = $Quit/QuitText


func _ready() -> void:
	animation_player.play("sway")
	fade_player.play("FadeIn")



func _on_quit_pressed() -> void:
	fade_player.play("FadeOut")
	await fade_player.animation_finished
	get_parent().switch_scene(self, "res://Menus/main_menu.tscn")


func _on_quit_text_mouse_entered() -> void:
	quit_text.text = "[shake][center]Back[/center]"


func _on_quit_text_mouse_exited() -> void:
	quit_text.text = "[center]Back[/center]"
