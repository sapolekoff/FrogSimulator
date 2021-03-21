extends Area2D

signal reached
signal eaten 

func _on_animation_finished():
	$AnimatedSprite.stop()
	$AnimatedSprite.set_frame(0)

func _on_Froge_body_entered(body):
	if body.get_name() == "Predator":
		emit_signal("eaten")
	elif body.get_name() == "Female":
		emit_signal("reached")
	$CollisionShape2D.set_deferred("disabled", true)
