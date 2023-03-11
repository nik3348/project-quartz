extends State

class_name AttackState

func _ready():
	animated_sprite.connect("animation_finished",Callable(self,"_animation_finished"))	
	animated_sprite.play("attack")

func _animation_finished():
	if animated_sprite.animation == "attack":
		change_state.call_func("idle")
