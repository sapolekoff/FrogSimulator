extends RigidBody2D

func show_message(txt):
	$Message.text = txt
	if txt == "Great!":
		$Message.add_color_override("font_color", Color( 0, .8, 0.2, 1))
	elif txt == "Nice!":
		$Message.add_color_override("font_color", Color( 1, 1, 0.6, .8))
		$Message.set_scale(Vector2(0.8,0.8))
	$Message.show()
