extends Node

var score_file = "user://highscore.save"

func _ready():
	if Global.mode == "game" and Global.ending == "win":
		$EndText.text = "You found love!"
		$EndText.show()
		$WinVisual.show()
	if Global.mode == "game" and Global.ending == "lose":
		$EndText.text = "You were eaten..."
		$EndText.show()
		$DeadVisual.show()
	if Global.mode == "endless":
		$Score.text = "Score: " + str(Global.prevscore)
		if Global.prevscore >= Global.highscore:
			Global.highscore = Global.prevscore
			save_score()
			$HS.text = "New high score!"
		else:
			$HS.text = "Record: " + str(Global.highscore)
		$Score.show()
		$HS.show()
		$DeadVisual.show()	


func save_score():
	var f = File.new()
	f.open(score_file, File.WRITE)
	f.store_var(Global.highscore)
	f.close()

func _on_Button_pressed():
	get_tree().change_scene("res://Splash.tscn")
	
func _on_Main_pressed():
	get_tree().change_scene("res://Main.tscn")
