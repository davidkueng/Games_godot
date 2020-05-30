extends Node

var player = null
var current_scene = null
var player_spawn_pos = Vector2(612, 300)
var player_weapon = false
var root

func _ready():
	root = get_tree().get_root()

	current_scene = root.get_child(root.get_child_count() - 1)
	
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
func goto_scene(path):

	call_deferred("_deferred_goto_scene", path)
	print_stray_nodes()

func _deferred_goto_scene(path):

	current_scene.free()
	
	var s = ResourceLoader.load(path)
	var player_instance = ResourceLoader.load("res://Scenes/Player.tscn")
	
	current_scene = s.instance()
	player = player_instance.instance()
	
	get_tree().get_root().add_child(current_scene)
	current_scene.add_child(player)
#	get_tree().set_current_scene(current_scene)
	player.position = player_spawn_pos

