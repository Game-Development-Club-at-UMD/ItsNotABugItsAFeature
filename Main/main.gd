extends Node2D

var enemy = preload("res://Enemy/Fly_enemy.tscn")
@onready var fade_player: AnimationPlayer = $FadePlayer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

signal lost_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.visible = true
	fade_player.play("fade_in")
	await fade_player.animation_finished
	color_rect.visible = false

## signal connects from Player
func player_died():
	lost_game.emit()
	fade_player.play("fade_out")
	await fade_player.animation_finished
	ready_to_switch_scenes()

func ready_to_switch_scenes():
	var game_manager : GameManager = get_parent() as GameManager
	game_manager.lost_game(self)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		fade_player.play("fade_out")
		await fade_player.animation_finished
		(get_parent() as GameManager).switch_scene(self,  "res://Menus/MainMenu.tscn")

func _on_spawnTimer_timeout() -> void:
	var enemy_instance = enemy.instantiate()
	add_child(enemy_instance)
	enemy_instance.position = $SpawnLocation.position
	
	var nodes = get_tree().get_nodes_in_group("spawn")
	var node = nodes[randi()%nodes.size()]
	var position1 = node.position
	$SpawnLocation.position = position1
