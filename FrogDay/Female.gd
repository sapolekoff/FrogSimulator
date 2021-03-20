extends RigidBody2D

var screen_size
export var walking = false


func _ready():
	screen_size = get_viewport_rect().size
	#hide()

func _process(_delta):
	if walking == true:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

func _on_AnimatedSprite_animation_finished():
	walking = false
	$AnimatedSprite.set_frame(0)
	linear_velocity = Vector2(0,0)
