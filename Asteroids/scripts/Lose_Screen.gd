extends Control

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("start"):
		get_tree().change_scene("res://Scenes/World.tscn")


