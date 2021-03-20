extends RigidBody2D

#var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#screen_size = get_viewport_rect().size

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
