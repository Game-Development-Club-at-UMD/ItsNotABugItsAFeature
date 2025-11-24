class_name RangedEnemy extends Enemy

@onready var shoot_timer: Timer = $ShootTimer

enum States {TRACKING_PLAYER, SHOOTING}
var state : States = States.TRACKING_PLAYER
var health : int
var distance : float

@onready var animation_tree: AnimationTree = $Sprite2D/AnimationTree as AnimationTree
#@onready var attack_waring: Sprite2D = $AttackWaring

@export var moveSpeed : float = 100
@export var shoot_threshold : float = 250
@export var projectile : PackedScene
@export var init_proj_velocity : float = 100
@export var attack_waring: Sprite2D


@onready var footsteps: AudioStreamPlayer2D = $Footsteps
@onready var spawn: AudioStreamPlayer2D = $Spawn

func _ready() -> void:
	attack_waring.hide()
	spawn.play()
	super._ready()

func _physics_process(delta: float) -> void:
	animation_tree.set("parameters/Idle/blend_position", velocity.normalized().x)
	animation_tree.set("parameters/Move/blend_position", velocity.normalized().x)
	if footsteps.playing == false:
		footsteps.play()
	match state:
		States.TRACKING_PLAYER:
			attack_waring.hide()
			move_enemy(delta, moveSpeed)
			velocity = navigation_agent_2d.get_velocity()
			check_for_shoot()
		States.SHOOTING:
			attack_waring.show()
			velocity = lerp(velocity, Vector2.ZERO, 12 * delta)
			if velocity.x < 0.1:
				velocity = Vector2.ZERO
	
	move_and_slide()
	update_health(health)

func check_for_shoot():
	distance = global_position.distance_to(player.global_position)
	if distance < shoot_threshold:
		state = States.SHOOTING
		shoot_timer.start()
	else:
		state = States.TRACKING_PLAYER

func _on_shoot_timer_timeout() -> void:
	var bullet = projectile.instantiate()
	var angle_to_player = self.global_position.angle_to_point(player.global_position)
	bullet.global_position = global_position
	add_child(bullet)
	bullet.velocity = (Vector2.RIGHT * init_proj_velocity).rotated(angle_to_player)
	check_for_shoot()
