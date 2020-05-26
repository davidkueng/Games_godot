extends Area2D

var speed = 2.5
var velocity = Vector2.ZERO
var life_time = 3

func _ready():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()
	
func _physics_process(delta):
	position += velocity * speed
