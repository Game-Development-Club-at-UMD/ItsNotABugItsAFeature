extends Control

func start_text_shake(node: Node, display_text: String):
	node.text = ("[shake rate: 5.0 level -3 connected = 1][center]" + display_text + "[/center][/shake]")

func stop_text_shake(node: Node, display_text: String):
	node.text = "[center]" + display_text + "[/center]"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()



# Button shake shenanigans
func _on_play_mouse_entered() -> void:
	start_text_shake($VSplitContainer/MenuOptions/Play/PlayText, "Play")

func _on_play_mouse_exited() -> void:
	stop_text_shake($VSplitContainer/MenuOptions/Play/PlayText, "Play")

func _on_settings_mouse_entered() -> void:
	start_text_shake($VSplitContainer/MenuOptions/Settings/SettingsText, "Settings")


func _on_settings_mouse_exited() -> void:
	stop_text_shake($VSplitContainer/MenuOptions/Settings/SettingsText, "Settings")


func _on_credits_mouse_entered() -> void:
	start_text_shake($VSplitContainer/MenuOptions/Credits/CreditsText, "Credits")


func _on_credits_mouse_exited() -> void:
	stop_text_shake($VSplitContainer/MenuOptions/Credits/CreditsText, "Credits")


func _on_quit_mouse_entered() -> void:
	start_text_shake($VSplitContainer/MenuOptions/Quit/QuitText, "Quit")


func _on_quit_mouse_exited() -> void:
	stop_text_shake($VSplitContainer/MenuOptions/Quit/QuitText, "Quit")
