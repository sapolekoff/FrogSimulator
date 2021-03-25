extends ColorRect
var popupopen = false
var score_file = "user://highscore.save"

func _ready():
	load_score()
	if Global.mode == "endless":
		$StartOpts/EndlessMode.set_pressed(true)

func load_score():
	var f = File.new()
	if f.file_exists(score_file):
		f.open(score_file, File.READ)
		Global.highscore = f.get_var()
		f.close()
	else:
		Global.highscore = 0

func _on_Button_pressed():
	if popupopen == false:
		get_tree().change_scene("res://Main.tscn")

func _on_CreditsButton_pressed():
	popupopen = true
	$CreditsButton/Credits.show()

func _on_HelpButton_pressed():
	popupopen = true
	$HelpButton/HowToPlay.show()

func _input(event): ## What happens when you tap the screen
	if event is InputEventScreenTouch and event.pressed:
		popupopen = false
		$HelpButton/HowToPlay.hide()
		$CreditsButton/Credits.hide()

func _on_EndlessMode_toggled(button_pressed):
	if button_pressed == false:
		Global.mode = "game"
	if button_pressed == true:
		Global.mode = "endless"
		
