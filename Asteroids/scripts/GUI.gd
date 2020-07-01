extends MarginContainer
#
var current_score = 0
var player_lifes
var highscores = []

signal show_pause
signal score (score, current_score)
#
func _ready():
	player_lifes = [$GUI_Container/First_Life, $GUI_Container/Second_Life, $GUI_Container/Third_Life]
	
func add_to_score():
	if current_score%2000 == 0 and current_score != 0 and highscores.has(current_score) == false:
		highscores.push_front(current_score)
		call_deferred("emit_signal", "show_pause")
		emit_signal("score", current_score)
		if player_lifes.size() < 3 and player_lifes.has($GUI_Container/First_Life) == false:
			player_lifes.push_front($GUI_Container/First_Life)
			player_lifes[0].visible = true
		elif player_lifes.size() < 3 and player_lifes.has($GUI_Container/Second_Life) == false:
			player_lifes.push_front($GUI_Container/Second_Life)
			player_lifes[0].visible = true
		else:
			player_lifes.push_front($GUI_Container/Third_Life)
			player_lifes[0].visible = true

func _score_points_on_asteroid_hit(body):
	if "Asteroid" in body.name:
		explosion(body)
		current_score += 50
		$enemy_explosion.play()
		$GUI_Container/Score/Score_Count.text = str(current_score)
		var small_asteroid_one = load("res://Scenes/Comet.tscn").instance()
		var small_asteroid_two = load("res://Scenes/Comet.tscn").instance()
		var small_asteroid_three = load("res://Scenes/Comet.tscn").instance()
		
		small_asteroid_one.position.x = body.position.x
		small_asteroid_one.position.y = body.position.y
		
		small_asteroid_two.position.x = body.position.x
		small_asteroid_two.position.y = body.position.y
		
		small_asteroid_three.position.x = body.position.x
		small_asteroid_three.position.y = body.position.y
		
		call_deferred("add_child", small_asteroid_one) 
		call_deferred("add_child", small_asteroid_two) 
		call_deferred("add_child", small_asteroid_three)
		
		body.queue_free()
		
		add_to_score()
		
	elif "Ufo" in body.name:
		current_score += 50
		$enemy_explosion.play()
		$GUI_Container/Score/Score_Count.text = str(current_score)
		body.queue_free()
		add_to_score()
	elif "Comet" in body.name:
		explosion(body)
		current_score += 50
		$enemy_explosion.play()
		$GUI_Container/Score/Score_Count.text = str(current_score)
		body.queue_free()
		add_to_score()
	else:
		self.hide()

func _on_Player_loose_hp():
	if player_lifes.size() > 0:
		player_lifes[0].visible = false
		player_lifes.pop_front()
	else:
		get_tree().change_scene("res://Scenes/Lose_Screen.tscn")
		
func explosion(body):
	var explosion = load("res://Scenes/explosion_particles.tscn").instance()
	add_child(explosion)
	
	if "Comet" in body.name:
		explosion.lifetime = 0.3
		explosion.position = body.position
		explosion.emitting = true
	else:
		explosion.lifetime = 0.8
		explosion.position = body.position
		explosion.emitting = true
		
	yield(get_tree().create_timer(1), "timeout")
	explosion.queue_free()
