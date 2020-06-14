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
		
		for i in Globals.enemy_pos.size():
			if Globals.enemy_pos[i].x == body.position.x or Globals.enemy_pos[i].y == body.position.y:
				Globals.enemy_pos.remove(i)
				body.queue_free()
				break
	
	
#BUG: enemy sometimes changes Vector.x or y for some reason and cannot be freed therefore. loop does not work in these cases, because the if statement fails every time.
