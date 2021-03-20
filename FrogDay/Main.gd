extends Node

var chirp = 0
var lastChirp = 0
var score = 0
var alive = false
var isLurking = false

export (PackedScene) var Popup ## Necessary to instantiate popups
onready var PopupSpawn = get_node("PopupSpawn") ## Necessary to instantiate popups
export (PackedScene) var Silhouette ## Necessary to instantiate pred warning

func _ready():
	randomize()
	new_game()


func new_game(): ## Resets all the variables so a new game can start
	score = 0
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
	## restart female's position as well
	## restart enemy timers (when I add)

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
	
func _on_FemaleTimer_timeout():
	## Female checks your score every 3 sec and moves accordingly
	## Then score is reset, so she will not move again if you stop chirping
	if score >= 25:
		MoveFemale(5)
	elif score >= 15:
		MoveFemale(2)
	elif score >= 10:
		MoveFemale(1)
	score = 0

func ScoreCalc(chrp):
	## You receive points based on your chirping interval
	if chrp >= 0.95 and chrp <= 1.05:
		score += 10
		CallPopup("Great!")
	elif chrp >= 0.9 and chrp <= 1.1:
		score += 5
		CallPopup("Nice!")
	elif chrp >= 0.8 and chrp <= 1.2:
		score += 2

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
	
func Predator(): ## This function controls predator actions
	isLurking = true
	## Now, add random extra time (0-6 seconds) then predator warning plays
	yield(get_tree().create_timer(rand_range(0, 6)), "timeout")
	## after timer timeout, play animation / sound indicating that predator is coming
	var pred = Silhouette.instance()
	add_child(pred)
	pred.position = $PredPath/PredPathSpawn.position
	pred.linear_velocity = Vector2(500,0)
	yield(get_tree().create_timer(2), "timeout")
	## 2 seconds after animation plays, predator attacks

	isLurking = false
	## If you have croaked since the predator animation played, you get attacked
	if chirp <= 1.9:
		GetEaten()
	
func GetEaten(): 
	$FemaleTimer.stop()
	$HUD/Text.text = "You were eaten..."
	$HUD/Text.show()
	alive = false

func _on_StartTimer_timeout():
	## This starts the female and predator timers a bit after the game starts
	$FemaleTimer.start() 
	Predator()

func game_over(): ## When the female reaches you (AKA you win)
	$FemaleTimer.stop()
	alive = false
	$HUD/Text.text = "You won!"
	$HUD/Text.show()



