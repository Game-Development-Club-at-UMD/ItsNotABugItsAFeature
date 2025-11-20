class_name GameManager extends Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() ==  DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		elif (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED or
			DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func lost_game(old_loaded_scene : Node):
	print("nooo you lost the game!")
	#switch_scene(old_loaded_scene, "res://Menus/MainMenu.tscn")
	switch_scene(old_loaded_scene, "res://Main/main.tscn")

func won_game(old_loaded_scene : Node):
	print("yayyy you won the game!")
	#switch_scene(old_loaded_scene, "res://Menus/Credits.tscn")
	switch_scene(old_loaded_scene, "res://Main/main.tscn")

func switch_scene(old_loaded_scene: Node, new_scene: String):
	if old_loaded_scene.is_queued_for_deletion():
		return
	old_loaded_scene.queue_free()
	await old_loaded_scene.tree_exited
	var instanced_scene : Node = load(new_scene).instantiate()
	add_child.call_deferred(instanced_scene)
	#await instanced_scene.tree_entered
	#get_tree().current_scene = instanced_scene
