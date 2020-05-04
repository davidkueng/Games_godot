extends KinematicBody2D

var move_speed = 1.5
onready var anim_player = $AnimationPlayer

var back_sprite = preload("res://Assets/back.png")
var front_sprite = preload("res://Assets/front.png")
var side_sprite = preload("res://Assets/side_left_dir.png")

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
func _physics_process(delta):
	var move_vec = Vector2()
	
	if Input.is_action_pressed("move_down"):
		move_vec += Vector2.DOWN
		anim_player.play("walking_front")
	if Input.is_action_pressed("move_up"):
		move_vec += Vector2.UP
		anim_player.play("walking_back")
	if Input.is_action_pressed("move_right"):
		move_vec += Vector2.RIGHT
		$Body.set_flip_h(true)
		anim_player.play("walking_side")
	if Input.is_action_pressed("move_left"):
		move_vec += Vector2.LEFT
		$Body.set_flip_h(false)
		anim_player.play("walking_side")
	elif move_vec == Vector2.ZERO:
		anim_player.play("Idle")
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * move_speed)
	
	
	
#
	
	
