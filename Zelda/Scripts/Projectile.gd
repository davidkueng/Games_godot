extends Area2D

var speed = 2.5
var velocity = Vector2.ZERO
var life_time = 3

func _ready():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()
	
func _physics_process(delta):
	position += velocity * speed

func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		Globals.enemy_pos.remove(Globals.enemy_pos.find(body.position))
		body.queue_free()
		
