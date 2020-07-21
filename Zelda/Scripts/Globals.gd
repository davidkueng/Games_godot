extends Node

var player = null
var current_scene = null
var player_spawn_pos = Vector2(512, 300)
var player_weapon = false
var inventory
var prev_scene
var enemy_pos = [0,1,2,3,4,5]
var enemy_dir = [0,1,2,3,4,5]

func _ready():
	var root = get_tree().get_root()
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
	inventory = ResourceLoader.load("res://Scenes/Inventory.tscn").instance()
	
	if prev_scene != "start_screen":
		player_spawn_pos = current_scene.get_node("PlayerSpawn").position
#
	get_tree().get_root().add_child(current_scene)
	current_scene.add_child(player)
	player.add_child(inventory)
	inventory.rect_position = player.position
	player.position = player_spawn_pos
	
	if player_weapon and current_scene.name == "Shop":
		current_scene.get_node("Weapons_TileMap").tile_set.clear()
	
	for i in enemy_pos.size():
		spawn_enemies(i)
		i += 1
	
	print_stray_nodes()
	
func spawn_enemies(pos):
	var rand = RandomNumberGenerator.new()
	var screen_size = get_viewport().get_visible_rect().size
	var tilemap = current_scene.get_node("Level_TileMap")
	
	screen_size[0] = 2048

	if current_scene.name == "Starting_World" and prev_scene == "start_screen":
		var enemy = ResourceLoader.load("res://Scenes/Enemy_goober.tscn").instance() 
		current_scene.add_child(enemy)

		rand.randomize()
		enemy.position = Vector2(rand.randf_range(0, screen_size.x), rand.randf_range(0, screen_size.y))
#	
		var dir = [Vector2.DOWN, Vector2.UP, Vector2.RIGHT, Vector2.LEFT]
		enemy.move_vec = dir[rand.randi() % dir.size()]
		
		var distance_to_player = enemy.get_global_position().distance_to(player.get_global_position())

		if distance_to_player < 150:
			enemy.position = Vector2(rand.randf_range(0, screen_size.x), rand.randf_range(0, screen_size.y))
			
		if !tilemap.tile_set.tile_get_name(tilemap.get_cellv(tilemap.world_to_map(enemy.position))).begins_with("floor_tiles"):
			rand.randomize()
			enemy.position = Vector2(rand.randf_range(0, screen_size.x), rand.randf_range(0, screen_size.y))
			
#			possible BUG: enemy could spawn inside of a wall again, maybe use a loop?
		
		enemy_pos.remove(pos)
		enemy_dir.remove(pos)
		enemy_pos.push_front(Vector2(enemy.position.x, enemy.position.y))
		enemy_dir.push_front(enemy.move_vec)

	elif current_scene.name == "Starting_World":
		var enemy = ResourceLoader.load("res://Scenes/Enemy_goober.tscn").instance() 
		current_scene.add_child(enemy)
		enemy.position = enemy_pos[pos]
		enemy.move_vec = enemy_dir[pos]
		
		

