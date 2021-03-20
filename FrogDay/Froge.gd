extends Area2D

signal reached


func _on_animation_finished():
	$AnimatedSprite.stop()
	$AnimatedSprite.set_frame(0)


func _on_Froge_body_entered(_body):
	emit_signal("reached")
	$CollisionShape2D.set_deferred("disabled", true)
