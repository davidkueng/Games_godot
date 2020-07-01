extends Node

var current_highscores
var saved_highscores
var highscore
const filepath = "user://highscore.json"

func _ready():
	current_highscores = [$VBoxContainer/highscore_1, $VBoxContainer/highscore_2, $VBoxContainer/highscore_3, 
	$VBoxContainer/highscore_4, $VBoxContainer/highscore_5]
	highscore = Globals.get("highscore")
	
	load_highscore()
	
	call_deferred("replace_highscore")
	
func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		call_deferred("save_highscore")
	
		get_tree().change_scene("res://Scenes/Title_Screen.tscn")
	
func replace_highscore():
	var highscore_reached = false
	
	for i in current_highscores:
		var score = i.get_node("highscore_score")
		var name = i.get_node("name")
		if int(score.text) < highscore:
	#		&& !current_highscores.has(score):
			score.text = str(i) 
			name.text = ""
			name.editable = true
			highscore_reached = true
			break;

	if !highscore_reached:
		$No_Highscore.visible = true


func load_highscore():
	var file = File.new()
	if not file.file_exists(filepath): return
	file.open(filepath, file.READ)
	
	var load_highscores = JSON.parse(file.get_as_text())
	
	var loaded_highscores = load_highscores.result
	
	if typeof(loaded_highscores) == TYPE_ARRAY:
		var counter = 0
		for i in loaded_highscores:
			var j = current_highscores[counter]
			var score = j.get_node("highscore_score")
			var name = j.get_node("name")
			name.text = str(i[0])
			score.text = str(i[1])
			counter += 1
	else:
		pass

func save_highscore():
	saved_highscores = [
			[$VBoxContainer/highscore_1/name.text, $VBoxContainer/highscore_1/highscore_score.text],
			[$VBoxContainer/highscore_2/name.text, $VBoxContainer/highscore_2/highscore_score.text],
			[$VBoxContainer/highscore_3/name.text, $VBoxContainer/highscore_3/highscore_score.text],
			[$VBoxContainer/highscore_4/name.text, $VBoxContainer/highscore_4/highscore_score.text],
			[$VBoxContainer/highscore_5/name.text, $VBoxContainer/highscore_5/highscore_score.text],
	]
	
	#C:\Users\David\AppData\Roaming\Godot\app_userdata\Asteroids
	
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_line(to_json(saved_highscores))
	file.close()
	

func _on_Button_pressed():
	call_deferred("save_highscore")
	
	get_tree().change_scene("res://Scenes/Title_Screen.tscn")
