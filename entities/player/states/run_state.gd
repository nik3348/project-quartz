extends State

class_name RunState

@export var acceleration := 0.2
@export var decceleration := 0.2
@export var move_speed := 500
@export var vel_power := 1
var direction := 0

func _ready():
	animated_sprite.play("running")

func _physics_process(_delta):
	var target_speed := direction * move_speed
	var speed_diff = target_speed - persistent_state.velocity.x
	var accel_rate = acceleration if abs(target_speed) > 0.01 else decceleration
	var movement := pow(abs(speed_diff) * accel_rate, vel_power) * sign(speed_diff)
	persistent_state.velocity.x += movement
	persistent_state.velocity.x *= 0.1

	if abs(persistent_state.velocity.x) < 1:
		direction = 0
		change_state.call_func("idle")

func move_left():
	direction = -1
	if not animated_sprite.flip_h:
		change_state.call_func("idle")

func move_right():
	direction = 1
	if animated_sprite.flip_h:
		change_state.call_func("idle")

func jump():
	change_state.call_func("jump")

func attack():
	change_state.call_func("attack")
