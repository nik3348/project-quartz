extends CharacterBody2D

class_name Player


## Run
@export var move_speed := 300
@export var acceleration := 3.0
@export var decceleration := 3.0
@export var vel_power := 1.4

## Friction
@export var ground_friction := 250
@export var recovery_time := 200

## Jump
@export var jump_force := 30000
@export var max_fall_speed := 650
@export var fall_speed := 1300
@export var apex_steps := 100
@export var apex_bonus_movement := 25.0
@export var apex_threshold := 200
@export var apex_gravity := 0.7
@export var gravity := 1200
@export var early_jump_modifier := 0.3
@export var jump_buffer_time := 50
@export var coyote_time := 50

enum {
	IDLE,
	RUN,
	AIR,
}

@onready var _particles := $GPUParticles2D
@onready var _particles2 := $GPUParticles2D2
@onready var _sprite := $AnimatedSprite2D
@onready var _state := AIR
@onready var _last_jump_pressed := 0

var _jump_ended: bool
var _move_direction: Vector2
var _last_grounded_time: int
var _recovery_time: int

func _ready():
	_sprite.connect("animation_finished", _animation_finished)


## State util
func _change_state(new_state: int) -> void:
	_state = new_state
	_enter_state()


func _enter_state() -> void:
	match _state:
		IDLE:
			_sprite.play("idle")
			velocity = Vector2.ZERO
		RUN:
			_sprite.play("running")
		AIR:
			_sprite.play("jumping")
			_last_grounded_time = Time.get_ticks_msec()
		_:
			return


func _physics_process(delta: float) -> void:
	print("velocity:", velocity)
	_gather_input()
	_state_machine(delta)
	_calculate_gravity(delta)
	_move(delta)


## Processes
func _gather_input() -> void:
	_move_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	if (Input.is_action_just_pressed("jump")):
		_last_jump_pressed = Time.get_ticks_msec()
		


func _state_machine(delta: float) -> void:
	match _state:
		IDLE:
			if _move_direction.x:
				_change_state(RUN)
			
			var jump_buffer = is_on_floor() and _last_jump_pressed + jump_buffer_time >= Time.get_ticks_msec()
			if jump_buffer:
				_jump(delta)
			
		RUN:
			velocity.x += _get_move_force() * delta
			
			var jump_buffer = is_on_floor() and _last_jump_pressed + jump_buffer_time >= Time.get_ticks_msec()
			if jump_buffer:
				_jump(delta)
			
			if is_on_floor() and not _move_direction.x:
				var amount := ground_friction * _move_direction.x
				velocity.x -= amount * delta
			
			if velocity.x > -5 and velocity.x < 5:
				_change_state(IDLE)
		
		AIR:
			velocity.x += _get_move_force() * delta
			
			## Variable jump height
			if (not _jump_ended and not Input.get_action_strength("jump")):
				_jump_ended = true
				velocity.y *= early_jump_modifier
			
			if is_on_floor():
				_particles.emitting = true
				_particles2.emitting = true
				if velocity.x:
					_change_state(IDLE)
				else:
					_change_state(RUN)


func _calculate_gravity(delta: float) -> void:
	if is_on_floor() and velocity.y >= 0:
		velocity.y = 0
	else:
		# If falling
		if sign(velocity.y) == 1:
			_jump_ended = true
			if _state != AIR:
				_change_state(AIR)
			
			_sprite.play("falling")
			velocity.y += fall_speed * delta
		
		## In apex
		if abs(velocity.y) <= apex_threshold:
			velocity.y += apex_gravity * gravity * delta
			
			# Apex movement
			var apex_point := inverse_lerp(apex_steps, 0, abs(velocity.y))
			var apex_bonus = _move_direction.x * apex_bonus_movement * abs(apex_point)
			velocity.x += apex_bonus
		else:
			velocity.y += gravity * delta
		
		velocity.y = min(velocity.y, max_fall_speed)


func _move(delta: float) -> void:
	move_and_slide()
	
	if _move_direction.x == 1:
		_sprite.flip_h = false
	elif _move_direction.x == -1:
		_sprite.flip_h = true


## Util
func _get_move_force() -> float:
	var target_speed := _move_direction.x * move_speed
	var speed_diff := target_speed - velocity.x
	var accel_rate := acceleration if abs(target_speed) > 0.01 else decceleration
	return pow(abs(speed_diff) * accel_rate, vel_power) * sign(speed_diff)


func _jump(delta: float) -> void:
	velocity.y -= jump_force * delta
	_jump_ended = false
	_change_state(AIR)

func _animation_finished() -> void:
	print('foo')
