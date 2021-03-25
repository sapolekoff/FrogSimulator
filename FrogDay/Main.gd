extends Node

var chirp = 0
var lastChirp = 0
var score = 0
var scoretot = 0
var alive = false
var isLurking = false
var game_over = preload("res://GameOver.tscn")

export (PackedScene) var Popup ## Necessary to instantiate popups
onready var PopupSpawn = get_node("PopupSpawn") ## Necessary to instantiate popups
export (PackedScene) var Silhouette ## Necessary to instantiate pred warning

func _ready():
	new_game()

func new_game(): ## Resets all the variables so a new game can start
	randomize() # Creates new random seed
	score = 0
	scoretot = 0
	chirp = 0
	lastChirp = 0
	alive = true
	$StartTimer.start()
	$Music.play()
	$FrogBGM.play()
	$HUD/Text.text = "Croak to the beat!"
	$HUD/Text.show()
	yield(get_tree().create_timer(1), "timeout")
	$HUD/Text.hide()

func _on_StartTimer_timeout():
	## This starts the female and predator timers a bit after the game starts
	$PredCheck.start()
	if Global.mode == "game":
		$FemaleTimer.start()

func _input(event): ## What happens when you tap the screen
	if alive == true and event is InputEventScreenTouch and event.pressed:
		$Froge/AnimatedSprite.play()
		$Froge/ChirpSound.play()
		lastChirp = chirp
		chirp = 0
		ScoreCalc(lastChirp)
		
func _process(delta):
	chirp += 1 * delta
	# This counts up internally so chirp = # seconds since you last tapped screen
	if Input.is_action_pressed("ui_accept"):
		scoretot = 1000
		GetEaten()
	
func _on_FemaleTimer_timeout():
	## Female checks your score every 3 sec and moves accordingly
	## Then score is reset, so she will not move again if you stop chirping
	if score >= 12:
		MoveFemale(6)
	elif score >= 9:
		MoveFemale(3)
	elif score >= 5:
		MoveFemale(2)
	score = 0

func ScoreCalc(chrp):
	## You receive points based on your chirping interval
	if chrp >= 0.95 and chrp <= 1.05:
		score += 5
		CallPopup("Great!")
	elif chrp >= 0.9 and chrp <= 1.1:
		score += 2
		CallPopup("Nice!")
	elif chrp >= 0.8 and chrp <= 1.2:
		score += 1
	scoretot += score

func MoveFemale(speed):
	$Female.walking = true
	$Female.linear_velocity = Vector2(20,-45) * speed
	## This controls both animation and movespeed (based on your score)

func CallPopup(text):
	var popup = Popup.instance() #creates new popup instance
	add_child(popup)
	popup.position = PopupSpawn.get_global_position() # Sets popup position to the spawn node
	$Popup.show_message(text)
	popup.linear_velocity = Vector2(50,-50)
	yield(get_tree().create_timer(0.5), "timeout")
	popup.queue_free() ## Deletes the popup instance
	
func _on_PredCheck_timeout():
	## Every 2 seconds, check if predator is currenly lurking
	## If not, begin predator lurking/attack loop
	if isLurking == false:
		Predator()
	else:
		pass
	
func Predator(): ## This function controls predator actions
	isLurking = true
	## Now, add random extra time (0-6 seconds) then predator warning plays
	yield(get_tree().create_timer(rand_range(1, 8)), "timeout")
	## after timer timeout, play animation / sound indicating that predator is coming
	var pred = Silhouette.instance()
	add_child(pred)
	pred.position = $PredPath/PredPathSpawn.position
	pred.linear_velocity = Vector2(1500,0)
	yield(get_tree().create_timer(2), "timeout")
	## 2 seconds after animation plays, predator attacks
	isLurking = false
	## If you have croaked since the predator animation played, you get attacked
	if chirp <= 1.8:
		alive = false
		$FemaleTimer.stop()
		$PredCheck.stop()
		$Predator.linear_velocity = Vector2(1500,1500)
		yield(get_tree().create_timer(0.1), "timeout")
		$Predator/AnimatedSprite.play()
	
func GetEaten(): ## When bat collides with frog (signal "eaten")
	$Predator.linear_velocity = Vector2(0,0)
	Global.prevscore = scoretot
	yield(get_tree().create_timer(0.1), "timeout")
	Global.ending = "lose"
	get_tree().change_scene_to(game_over)
	#$HUD/Text.text = "You were eaten..."
	#$HUD/Text.show()

func GetMate(): ## When the female reaches you (AKA you win)
	$FemaleTimer.stop()
	$PredCheck.stop()
	alive = false
	Global.ending = "win"
	get_tree().change_scene_to(game_over)
