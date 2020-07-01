extends KinematicBody2D

var rand = RandomNumberGenerator.new()
var randomdir_x
var randomdir_y
var asteroid_speed = 20
var velocity

func _ready():	
	rand.randomize()
	randomdir_x = rand.randi_range(-7.0, 7.0)
	randomdir_y = rand.randi_range(-7.0, 7.0)
	
	if randomdir_y != 0 and randomdir_x != 0:
		velocity = Vector2(randomdir_x, randomdir_y)
	else:
		rand.randomize()
		randomdir_x = rand.randi_range(-7.0, 7.0)
		randomdir_y = rand.randi_range(-7.0, 7.0)
		velocity = Vector2(randomdir_x, randomdir_y)

func _physics_process(delta):
	position += velocity * asteroid_speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
		
#		TODO DRY this code (Asteroid_one + two etc)
#		TODO manipulate X and Y differently so the Asteroid flies in a straight line sometimes
	#	BUG Asteroids slow down if -= and gather in top left corner
