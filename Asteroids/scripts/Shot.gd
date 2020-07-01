extends Area2D
#
var life_time = 3
var shotSpeed = 10
var player = Globals.get("player")
var velocity = Vector2(cos(self.rotation), sin(self.rotation))

func _ready():
	selfDestruct()
	$Shot_sound.play()
	
	if player.speed > shotSpeed+200:
		shotSpeed = player.speed/20

func selfDestruct():
	if self.position.x > 1000:
		yield(get_tree().create_timer(life_time), "timeout")
		queue_free()
	else:
		yield(get_tree().create_timer(0), "timeout")

func _physics_process(_delta):
	position += velocity * shotSpeed
