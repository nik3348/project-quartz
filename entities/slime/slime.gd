extends CharacterBody2D

enum states {
	IDLE,
	WANDER,
}

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var state = states.IDLE

@export var gravity = 4000.0
@export var acceleration = 0.25
@export var max_fall_speed = 1000
var velocity = Vector2.ZERO

func _ready():
	timer.connect("timeout",Callable(self,"_on_Timer_timeout")) 

func _physics_process(delta: float) -> void:
	if timer.paused:
		timer.wait_time = 3
		timer.start()

	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity

func _on_Timer_timeout():
	match state:
		states.IDLE:
			velocity.x = 0
			state = states.WANDER

		states.WANDER:
			var direction := (randi() % 2)
			var speed = 10.0

			animated_sprite.flip_h = false
			if direction:
				animated_sprite.flip_h = true
				speed *= -1
			velocity.x = speed
			state = states.IDLE
