extends KinematicBody2D

var tilemap
var anim_player
var move_speed = 2.5

func _ready():
	anim_player = $AnimationPlayer
	tilemap = Globals.current_scene.get_node("TileMap")
	Globals.set("player", self)
	print(tilemap)

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
func _physics_process(delta):
	var move_vec = Vector2()	
	
	if Input.is_action_pressed("move_down"):
		move_vec += Vector2.DOWN
		anim_player.play("walking_front")
	if Input.is_action_pressed("move_up"):
		move_vec += Vector2.UP
		anim_player.play("walking_back")
	if Input.is_action_pressed("move_right"):
		move_vec += Vector2.RIGHT
		$Body.set_flip_h(true)
		anim_player.play("walking_side")
	if Input.is_action_pressed("move_left"):
		move_vec += Vector2.LEFT
		$Body.set_flip_h(false)
		anim_player.play("walking_side")
	if move_vec == Vector2.ZERO:
		anim_player.play("Idle")
	move_vec = move_vec.normalized()
	var coll = move_and_collide(move_vec * move_speed)
	
	if coll:
		if tilemap == null:
			tilemap = $"/root/Main/Starting_World/TileMap"
		
		var cell = tilemap.world_to_map(coll.position - coll.normal)
		var tile_id = tilemap.get_cellv(cell)
		
		
		if tile_id == 4:
			Globals.goto_scene("res://Scenes/Levels/Shop.tscn")
#			tilemap = Globals.current_scene.get_node("TileMap")
			print(tilemap)
		if tile_id == 7:
			Globals.goto_scene("res://Scenes/Levels/Starting_World.tscn") 

	
	
	
#
	
	
