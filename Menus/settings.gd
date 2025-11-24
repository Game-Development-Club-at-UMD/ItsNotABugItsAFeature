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


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")



# Button shake shenanigans
func _on_back_text_mouse_entered() -> void:
	start_text_shake($MarginContainer/VBoxContainer/PanelContainer/BackButton/BackText, "Back")

func _on_back_text_mouse_exited() -> void:
	stop_text_shake($MarginContainer/VBoxContainer/PanelContainer/BackButton/BackText, "Back")
