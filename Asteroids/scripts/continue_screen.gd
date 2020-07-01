extends Control

var highscore

func _ready():
		pass
	
func _on_GUI_show_pause():
	self.visible = true
	get_tree().paused = true

func _process(_delta):
	if self.visible == true:
		if Input.is_action_just_pressed("exit"):
			get_tree().paused = false
			get_tree().change_scene("res://Scenes/Highscores.tscn")
		
		if Input.is_action_just_pressed("start"):
			self.visible = false
			get_tree().paused = false

func _on_GUI_score(current_score):
	$point_info/highscore_label.text = "You've reached " + str(current_score) + " points and you get one life back" 
	
	highscore = current_score
	Globals.set("highscore", highscore)

func _on_Continue_pressed():
	self.visible = false
	get_tree().paused = false


func _on_Exit_pressed():
	if self.visible == true:
		get_tree().paused = false
		get_tree().change_scene("res://Scenes/Highscores.tscn")
