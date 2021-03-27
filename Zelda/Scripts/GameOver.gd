extends Control

func _process(delta):
	if Input.is_action_just_pressed("start"):
		Globals.goto_scene("res://Scenes/Levels/Starting_World.tscn", self.name)
