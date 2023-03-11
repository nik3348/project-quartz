extends State

class_name InAirState

@export var jump_speed = -1800.0
@export var acceleration := 0.1

func _ready():
	animated_sprite.connect("animation_finished",Callable(self,"_animation_finished"))	
	animated_sprite.play("jump")
	persistent_state.velocity.y = lerp(0, jump_speed, 0.6)

func _physics_process(_delta):
	if Input.is_action_just_released("jump") and persistent_state.velocity.y < 0.0:
		persistent_state.velocity.y = lerp(persistent_state.velocity.y, 0, 0.6)
	if persistent_state.velocity.y == 0:
		change_state.call_func("idle")
	elif persistent_state.velocity.y > 0:
		animated_sprite.play("falling")

func _flip_direction():
	animated_sprite.flip_h = not animated_sprite.flip_h

func move_left():
	if not animated_sprite.flip_h:
		_flip_direction()
	else:
		persistent_state.velocity.x = lerp(persistent_state.velocity.x, -speed, acceleration)

func move_right():
	if animated_sprite.flip_h:
		_flip_direction()
	else:
		persistent_state.velocity.x = lerp(persistent_state.velocity.x, speed, acceleration)

func _animation_finished():
	if animated_sprite.animation == "jump":
		animated_sprite.stop()
