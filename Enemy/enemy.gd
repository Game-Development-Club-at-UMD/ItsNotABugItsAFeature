class_name Enemy
extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("players")[0]
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D



#func _process(delta: float) -> void:
	#move_enemy(1.0)

func move_enemy(movement_speed: float):
	print(player.global_position)
	navigation_agent_2d.set_target_position(player.global_position)
	velocity = global_position.direction_to(navigation_agent_2d.get_next_path_position()) * movement_speed
	move_to_destination(velocity, movement_speed)
	
func move_to_destination(velocity : Vector2, movement_speed: float):
	global_position = global_position.move_toward(global_position + velocity, movement_speed)
	
	
