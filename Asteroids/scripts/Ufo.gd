extends KinematicBody2D

onready var shot_timer = $Shot_Timer

var ufo_speed = 200
var velocity = Vector2(1,0)
var player = Globals.get("player")
var ufo_bullet

func _ready():
	shot_timer.start()
	shot_timer.set_wait_time(0.8)
	$ufo_sound.play()

func _physics_process(delta):
	position += velocity * ufo_speed * delta
	
func fire():
	ufo_bullet = preload("res://Scenes/Shot.tscn").instance()
	add_child(ufo_bullet)
	ufo_bullet.shotSpeed = 3
	ufo_bullet.global_position = self.global_position

	var direction_to_player = (player.global_position - self.global_position).normalized()
	ufo_bullet.velocity = direction_to_player * ufo_bullet.shotSpeed
	
	ufo_bullet.connect("body_entered", player, "_ufo_hits_player")

func _on_Shot_Timer_timeout():
	fire()
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
