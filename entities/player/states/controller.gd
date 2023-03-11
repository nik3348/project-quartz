extends CharacterBody2D

class_name Controller

var states = {
	"idle": IdleState,
	"run": RunState,
	"jump": InAirState,
	"attack": AttackState
}
var current_state
var velocity = Vector2()

func _ready():
	change_state("idle")

func _process(_delta):
	if Input.is_action_pressed("move_left"):
		current_state.move_left()
	elif Input.is_action_pressed("move_right"):
		current_state.move_right()
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			current_state.jump()
	
	if Input.is_action_just_pressed("attack"):
		current_state.attack()

func change_state(new_state_name):
	if current_state != null:
		current_state.queue_free()
	current_state = get_state(new_state_name).new()
	current_state.setup(funcref(self, "change_state"), $AnimatedSprite2D, self)
	add_child(current_state)

func get_state(state_name):
	if states.has(state_name):
		return states.get(state_name)
	else:
		printerr("No state ", state_name)
