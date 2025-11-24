class_name DashEnemy extends Enemy

@onready var dash_timer : Timer = %DashTimer as Timer
@onready var dash_visualization: Node2D = $DashVisRotationHelper/DashVisualization
@onready var animation_tree: AnimationTree = $Sprite2D/AnimationTree
@onready var footsteps: AudioStreamPlayer2D = $Footsteps
@onready var spawn: AudioStreamPlayer2D = $Spawn

@export var moveSpeed : float = 100
@export var dashSpeed : float = 200

var dashTargetPosition : Vector2
var dashDirection : Vector2
var health : int

var state : States = States.TRACKING_PLAYER
enum States {DASHING, TRACKING_PLAYER, WAIT_DASH}

func _ready() -> void:
	spawn.play()
	dash_visualization.hide()
	super._ready()

func _physics_process(delta: float) -> void:
	animation_tree.set("parameters/Idle/blend_position", velocity.normalized().x)
	animation_tree.set("parameters/Move/blend_position", velocity.normalized().x)
	if footsteps.playing == false:
		footsteps.play()
	match state:
		States.DASHING:
			pass
		States.TRACKING_PLAYER:
			checkDash()
			move_enemy(delta, moveSpeed)
			velocity = navigation_agent_2d.get_velocity() 
		States.WAIT_DASH:
			velocity = lerp(velocity, Vector2.ZERO, 12 * delta)
			if velocity.x < 0.1:
				velocity = Vector2.ZERO
	
	move_and_slide()
	update_health(health)

func dash() -> void:
	dashTargetPosition = player_location()
	
	dashDirection = global_position.direction_to(dashTargetPosition)
	dash_visualization.rotation = dashDirection.angle()
	dash_visualization.show()
	state = States.WAIT_DASH
	await get_tree().create_timer(1).timeout
	state = States.DASHING
	dash_timer.start()
	
	velocity = dashDirection * dashSpeed * 2	

func checkDash() -> void:
	if global_position.distance_to(player_location()) < 100:
		state = States.DASHING
		dash()

func _on_dash_timer_timeout() -> void:
	state = States.TRACKING_PLAYER
	dash_visualization.hide()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	navigation_agent_2d.set_velocity(safe_velocity)
