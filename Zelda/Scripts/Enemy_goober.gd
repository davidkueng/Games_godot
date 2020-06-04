extends KinematicBody2D

onready var follow_path = get_parent()

var move_speed = 20
var move_dir = 0
var anim_player
var hit_area

func _ready():
	anim_player = $AnimationPlayer

func _physics_process(delta):
#	var prev_pos = follow_path.get_global_position()
#	follow_path.set_offset(follow_path.get_offset() + move_speed * delta)
#	var pos = follow_path.get_global_position()
#	move_dir = (pos.angle_to_point(prev_pos) / 3.14) * 180
	anim_player.play("enemy_goober_walk")	
	

#func _process(delta):
#	anim_player.play("enemy_goober_walk"
