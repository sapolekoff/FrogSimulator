extends Node

func _ready():
	if Global.ending == "win":
		$EndText.text = "You found love!"
		$WinVisual.show()
	if Global.ending == "lose":
		$EndText.text = "You were eaten..."
		$DeadVisual.show()

func _on_Button_pressed():
	get_tree().change_scene("res://Splash.tscn")
	
func _on_Main_pressed():
	get_tree().change_scene("res://Main.tscn")
