extends Node2D

var change_state
var animated_sprite
var persistent_state

@export var gravity := 4000.0
@export var max_fall_speed := 500
@export var speed := 1000.0
@export var friction := 0.1


func _physics_process(delta):

	persistent_state.velocity.y += gravity * delta
	persistent_state.velocity.y = min(persistent_state.velocity.y, max_fall_speed)
	persistent_state.set_velocity(persistent_state.velocity)
	persistent_state.set_up_direction(Vector2.UP)
	persistent_state.move_and_slide()
	persistent_state.velocity = persistent_state.velocity

func setup(change_state, animated_sprite, persistent_state):
	self.change_state = change_state
	self.animated_sprite = animated_sprite
	self.persistent_state = persistent_state

func move_left():
	pass

func move_right():
	pass

func jump():
	pass

func attack():
	pass
