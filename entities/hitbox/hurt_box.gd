extends Area2D

class_name HurtBox

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", hit_box_detected)

func hit_box_detected(hit_box: HitBox):
	if hit_box == null:
		return
	
	print(hit_box)
	
	if owner.has_method("take_damage"):
		owner.take_damage(hit_box.damage)
