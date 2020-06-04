extends Node

var player = null
var current_scene = null
var player_spawn_pos = Vector2(512, 300)
var player_weapon = false
var root
var prev_scene
var enemy_pos = []

func _ready():
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
func goto_scene(path, spawn):

	call_deferred("_deferred_goto_scene", path, spawn)

func _deferred_goto_scene(path, spawn):
	
	prev_scene = spawn
	current_scene.free()
	
	current_scene = ResourceLoader.load(path).instance()
	player = ResourceLoader.load("res://Scenes/Player.tscn").instance()
	if prev_scene != "start_screen":
		player_spawn_pos = current_scene.get_node("PlayerSpawn").position
#
	get_tree().get_root().add_child(current_scene)
	current_scene.add_child(player)
	player.position = player_spawn_pos
	
	spawn_enemies(0)
	spawn_enemies(1)
	spawn_enemies(2)
	
#	print_stray_nodes()

func spawn_enemies(pos):
#	enemies are stray nodes (hopefully bc they are not killed and freed yet)
	var enemy = ResourceLoader.load("res://Scenes/Enemy_goober.tscn").instance() 
	var rand = RandomNumberGenerator.new()
	var screen_size = get_viewport().get_visible_rect().size
	
	if current_scene.name == "Starting_World" and prev_scene == "start_screen":
		current_scene.add_child(enemy)
		
		rand.randomize()
		enemy.position.y = rand.randf_range(0, screen_size.y)
		enemy.position.x = rand.randf_range(0, screen_size.x)
		
		var distance_to_player = enemy.get_global_position().distance_to(player.get_global_position())
	
		if distance_to_player < 150:
			enemy.position.y = rand.randf_range(0, screen_size.y)
			enemy.position.x = rand.randf_range(0, screen_size.x)
			
		enemy_pos.push_front(Vector2(enemy.position.x, enemy.position.y))

	elif current_scene.name == "Starting_World":#
		current_scene.add_child(enemy)
		enemy.position = enemy_pos[pos]
#		
