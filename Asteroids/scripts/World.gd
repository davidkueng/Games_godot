extends Node2D

onready var asteroid_timer = $Asteroid_Timer
onready var ufo_timer = $Ufo_Timer
onready var difficulty_timer = $Difficulty_Timer
onready var sound_timer = $Sound_Timer

var ufo_scene
var asteroid_scene
var ufo_speed_increase = 100
var asteroid_speed_increase = 20
var sound_loop = true
var sound_alternation = 3

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().change_scene("res://Scenes/Title_Screen.tscn")
		
func _ready():
	asteroid_timer.start()
	ufo_timer.start(15)
	difficulty_timer.start(15)
	sound_timer.start(sound_alternation)
	
func asteroid_spawner():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var random_asteroid = rand.randf()
	var screen_size = get_viewport().get_visible_rect().size
	
	if random_asteroid > 0.5:
		asteroid_scene = load("res://Scenes/Asteroid_two.tscn")
	else:
		asteroid_scene = load("res://Scenes/Asteroid_one.tscn")
		
	var asteroid = asteroid_scene.instance()
	add_child(asteroid)
	
	asteroid.asteroid_speed = asteroid_speed_increase
	
	rand.randomize()
	asteroid.position.y = rand.randf_range(0, screen_size.y)
	
	rand.randomize()
	asteroid.position.x = rand.randf_range(0, screen_size.x)
	
	var distance_to_player = asteroid.get_global_position().distance_to($Player.get_global_position())
	
	if distance_to_player < 150:
		asteroid.position.y = rand.randf_range(0, screen_size.y)
		asteroid.position.x = rand.randf_range(0, screen_size.x)
		
func ufo_spawner():
	ufo_scene = load("res://Scenes/Ufo.tscn").instance()
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var random_pos = rand.randi_range(5, 550)
	
	ufo_scene.position.y = random_pos
	
	ufo_scene.ufo_speed = ufo_speed_increase
	
	call_deferred("add_child", ufo_scene) 
	
func _on_Timer_timeout():
	asteroid_spawner()
		
func _on_Ufo_Timer_timeout():
	ufo_spawner()
	
func _on_Difficulty_Timer_timeout():
	ufo_speed_increase += 10
	asteroid_speed_increase += 3
	if sound_alternation > 0:
		sound_alternation -= 0.05
		sound_timer.set_wait_time(sound_alternation)
		
	$Asteroid_Timer.wait_time -= 0.15
	
func _on_Sound_Timer_timeout():
	if sound_loop == true:
		$sound_one.play()
		sound_loop = false
	else:
		$sound_two.play()
		sound_loop = true
	
func _on_Player_shoot(Bullet, direction, location):
	var b = Bullet.instance()
	add_child(b)
	b.rotation = direction
	b.position = location
	b.velocity = b.velocity.rotated(direction)
	
	b.connect("body_entered", $GUI, "_score_points_on_asteroid_hit")

func _on_GUI_explosion_part(body):
	var explosion = load("res://Scenes/explosion_particles.tscn").instance()
	body.add_child(explosion)
	
	if "Comet" in body.name:
		explosion.lifetime = 0.3
		explosion.position = body.position
		explosion.emitting = true
	else:
		explosion.lifetime = 0.8
		explosion.position = body.position
		explosion.emitting = true
