extends KinematicBody2D

var move_speed = 2.0

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move_down"):
		move_vec += Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		move_vec += Vector2.UP
	if Input.is_action_pressed("move_right"):
		move_vec += Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		move_vec += Vector2.LEFT
	
	move_vec = move_vec.normalized()
	var coll = move_and_collide(move_vec * move_speed)
	
	if coll:
		print("colliding")
