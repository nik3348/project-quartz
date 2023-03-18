extends CharacterBody2D

enum states {
	IDLE,
	WANDER,
}

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var state = states.IDLE

@export var gravity = 1050
@export var acceleration = 0.25
@export var max_fall_speed = 1000

func _ready():
	timer.connect("timeout", _on_Timer_timeout)
	timer.paused = false
	animation_player.play("idle")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()

func _on_Timer_timeout():
	match state:
		states.IDLE:
			velocity.x = 0
			state = states.WANDER
		
		states.WANDER:
			var direction := (randi() % 2)
			var speed = 10.0
			
			scale.x = scale.y * 1
			if direction:
				scale.x = scale.y * -1
				speed *= -1
			velocity.x = speed
			state = states.IDLE

func take_damage(damage: int) -> void:
	animation_player.connect("animation_finished", _animation_finished)
	animation_player.play("death")
	

func _animation_finished(anim_name: String):
	if anim_name == "death":
		queue_free()
