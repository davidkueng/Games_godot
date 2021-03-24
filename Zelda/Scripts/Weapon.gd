extends Area2D

var speed = 3.5
var velocity = Vector2.ZERO
var life_time = 3

func _ready():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()
	
func _physics_process(delta):
	position += velocity * speed
	
#BUG: body.y or x (not sure if either or both) are not == body.pos for some reason and the enemy cannot be freed with _body_entered therefore. loop does not work in these cases, because the if statement fails every time.

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if "Enemy" in body.name:#
		for i in Globals.enemy_pos.size():
			if str(body) == Globals.enemy_id[i]:
				Globals.enemy_id.remove(i)
				Globals.enemy_pos.remove(i)
				body.queue_free()
				break
#			if int(Globals.enemy_pos[i].x) == int(body.position.x) or int(Globals.enemy_pos[i].y) == int(body.position.y):
#				print("delete")
#				Globals.enemy_pos.remove(i)
#				body.queue_free()
#				break	
