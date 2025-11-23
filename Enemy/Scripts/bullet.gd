class_name Bullet extends CharacterBody2D

@onready var hurt_box: HurtBox = $HurtBox

func _ready() -> void:
	hurt_box.doing_attack.connect(die)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func die():
	self.queue_free()
