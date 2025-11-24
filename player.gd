class_name Player extends CharacterBody2D

signal player_died

const SPEED: int = 200

var click_position = Vector2()
var target_position = Vector2()

var am_i_fucking_waiting : bool = false

@onready var inventory: Inventory = $CanvasLayer/Inventory
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var move_vis_rotation_helper: Node2D = $MoveVisRotationHelper
@onready var movement_visualization: Node2D = $MoveVisRotationHelper/MovementVisualization


@export var hitbox : HitBox
@export var item : PackedScene

var instanced_item : Item = null

var state : States = States.PlAYER_MOVE
enum States {PlAYER_MOVE, PLAYER_ATTACKING}

func _ready() -> void:
	hitbox.health_component.health = hitbox.health_component.max_health
	player_died.connect(get_parent().player_died)
	inventory.movement_visualization_updated.connect(update_movement_visualization)
	inventory.update_movement_visualization()
	inventory.item_finished.connect(end_attacking)
	

func _process(delta: float) -> void:
	move_vis_rotation_helper.look_at(get_global_mouse_position())
	match state:
		States.PlAYER_MOVE:
			if Input.is_action_pressed("left_click"):
				target_position = (get_global_mouse_position() - global_position).normalized()
				if (get_global_mouse_position() - global_position).length() > 5:
					velocity = lerp(velocity, target_position * SPEED, 12 * delta)
				else:
					velocity = lerp(velocity, Vector2.ZERO, 12 * delta)
			else:
				velocity = lerp(velocity, Vector2.ZERO, 12 * delta)
			
			if Input.is_action_just_pressed("right_click"):# && !am_i_fucking_waiting:
				inventory.activate()
				am_i_fucking_waiting = true
				var item_did_activate = await inventory.did_item_activate
				
				if item_did_activate:
					
					state = States.PLAYER_ATTACKING
				
				am_i_fucking_waiting = false
			if Input.is_action_just_pressed("switch_item"):
				inventory.swap_items()
		States.PLAYER_ATTACKING:
			velocity = lerp(velocity, Vector2.ZERO, 12 * delta)
			
			#waitForAttacking()
	
	move_and_slide()
	update_anim_parameters()

func update_anim_parameters():
	animation_tree.set("parameters/Idle/blend_position", velocity.normalized())
	animation_tree.set("parameters/Walk/blend_position", velocity.normalized())

func die():
	player_died.emit()

func end_attacking():
	print('pee')
	state = States.PlAYER_MOVE

#func waitForAttacking():
	#await inventory.active_item.start_cooldown
	#state = States.PlAYER_MOVE

func update_movement_visualization(dir : Vector2):
	#print("instructed to update rotation")
	movement_visualization.rotation = dir.angle()
	
	
