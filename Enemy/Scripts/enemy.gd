class_name Enemy
extends CharacterBody2D

var is_dying :bool = false

@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var navigation_agent_2d : NavigationAgent2D = %NavigationAgent2D as NavigationAgent2D
@onready var hit_box : HitBox = $HitBox as HitBox
@onready var hurt_box: HurtBox = $HurtBox as HurtBox

@export var hit_effect_player: AudioStreamPlayer2D
@export var healthbar : ProgressBar
@export var heal_hurtbox_scene : PackedScene

var nextPoint : Vector2
var direction : Vector2

func _ready() -> void:
	hit_box.hit.connect(take_hit)

func _physics_process(delta: float) -> void:
	move_enemy(delta, 100)

func move_enemy(delta : float, movement_speed: float) -> void:
	if is_dying == true:
		hurt_box.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
		navigation_agent_2d.set_velocity(lerp(velocity, Vector2.ZERO, delta * 12))
		return
	navigation_agent_2d.target_position = player.global_position
	
	nextPoint = navigation_agent_2d.get_next_path_position()
	direction = global_position.direction_to(nextPoint)
	
	navigation_agent_2d.set_velocity(lerp(navigation_agent_2d.get_velocity(), direction * movement_speed, delta * 12))

func player_location() -> Vector2:
	return player.global_position
	
func die():
	get_tree().get_first_node_in_group('camera').add_trauma(.5, Vector2(randf_range(-1, 1), randf_range(-1, 1)))
	is_dying = true
	
	modulate = Color(0.0, 0.0, 0.0, 1.0)
	await get_tree().create_timer(0.35).timeout
	spawn_heal_pickup()
	self.queue_free()

func spawn_heal_pickup():
	var healingBox : HealingHurtBox = heal_hurtbox_scene.instantiate() as HealingHurtBox
	healingBox.global_position = global_position
	var cur_scene = get_tree().current_scene
	cur_scene.call_deferred("add_child", healingBox)

func update_health(health : int):
	health = hit_box.health_component.health
	healthbar.max_value = hit_box.health_component.max_health
	healthbar.value = health
	if health >= hit_box.health_component.max_health:
		healthbar.visible = false
	else:
		healthbar.visible = true
	var current_percentage = ((healthbar.value - healthbar.min_value) / (healthbar.max_value - healthbar.min_value)) * 100
	var sb = healthbar.get("theme_override_styles/fill")
	if sb == null:
		sb = StyleBoxFlat.new()
		healthbar.add_theme_stylebox_override("fill", sb)
	
	if current_percentage >= 70:
		sb.bg_color = Color('#8ab060')
	elif current_percentage >= 30:
		sb.bg_color = Color('#d3a068')
	else:
		sb.bg_color = Color('#b45252')

func take_hit():
	hit_effect_player.play()
