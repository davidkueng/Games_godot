extends KinematicBody2D

var level_tilemap
var objects_tilemap
var anim_player
var move_speed = 2.5
var player_spawn_pos

func _ready():
	anim_player = $AnimationPlayer
	level_tilemap = Globals.current_scene.get_node("Level_TileMap")
	objects_tilemap = Globals.current_scene.get_node("Objects_TileMap")
#	print(level_tilemap)
	if level_tilemap == null:
			level_tilemap = $"/root/Main/Starting_World/Level_TileMap"
	if objects_tilemap == null:
			objects_tilemap = $"/root/Main/Starting_World/Objects_TileMap"
			

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
#	move_speed = Globals.move_speed
		
func _physics_process(delta):
	
	player_movement()

	var coll = move_and_collide(Vector2() * move_speed)
	
	if coll and coll.collider.name == "Level_TileMap":
		
		var level_tile_name = get_tile_name(coll, level_tilemap)#		
		
		print(level_tile_name)
#
		if level_tile_name == "shop_stairs_entry":
			Globals.goto_scene("res://Scenes/Levels/Shop.tscn")
			player_spawn("res://Scenes/Levels/Shop.tscn")
##			
			Globals.player_spawn_pos = player_spawn_pos
#
		if level_tile_name == "shop_stairs_exit":
			Globals.goto_scene("res://Scenes/Levels/Starting_World.tscn") 
			player_spawn("res://Scenes/Levels/Starting_World.tscn")

			Globals.player_spawn_pos = player_spawn_pos
			
	if coll and coll.collider.name == "Objects_TileMap":
			
#			var objects_tile_name = get_tile_name(coll, objects_tilemap)

		var cell = objects_tilemap.world_to_map(coll.position - coll.normal)
		var tile_id = objects_tilemap.get_cellv(cell)
		var tile_name = coll.collider.tile_set.tile_get_name(tile_id)
			
		print(tile_id)
#
##		if tile_id == 5:
#			Globals.move_speed = 5
	
func player_spawn(path):
	player_spawn_pos = load(path).instance().get_node("PlayerSpawn").position
	

#func _goober_damage(body):
#		if "Player" in body.name:
#			print("take damage")
			
			
func player_movement():
	var move_vec = Vector2()	
#
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
	
	move_and_collide(move_vec * move_speed)
	
func get_tile_name(coll, tilemap):
		var cell = tilemap.world_to_map(coll.position - coll.normal)
		var tile_id = tilemap.get_cellv(cell)
		var tile_name = coll.collider.tile_set.tile_get_name(tile_id)
		
		return tile_name
		
