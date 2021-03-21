extends ColorRect
var popupopen = false

func _on_Button_pressed():
	if popupopen == false:
		get_tree().change_scene("res://Main.tscn")


func _on_CreditsButton_pressed():
	popupopen == true
	$CreditsButton/Credits.show()


func _on_HelpButton_pressed():
	popupopen == true
	$HelpButton/HowToPlay.show()


func _input(event): ## What happens when you tap the screen
	if event is InputEventScreenTouch and event.pressed:
		popupopen = false
		$HelpButton/HowToPlay.hide()
		$CreditsButton/Credits.hide()
