extends Node

var player = null
var current_scene = null
var player_spawn_pos = Vector2(512, 300)
var player_weapon = false
var root
var prev_scene

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
	
	print_stray_nodes()

