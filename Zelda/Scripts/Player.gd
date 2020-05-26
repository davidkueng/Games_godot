extends KinematicBody2D

var level_tilemap
var objects_tilemap
var weapons_tilemap
var anim_player
var move_speed = 2.5
var player_spawn_pos
var weapon_achieved = false

func _ready():
	anim_player = $AnimationPlayer

	level_tilemap = Globals.current_scene.get_node("Level_TileMap")
#	objects_tilemap is currently empty in all scenes
#	objects_tilemap = Globals.current_scene.get_node("Objects_TileMap")
	weapons_tilemap = Globals.current_scene.get_node("Weapons_TileMap")

	if level_tilemap == null:
			level_tilemap = $"/root/Main/Starting_World/Level_TileMap"
#	if objects_tilemap == null:
#			objects_tilemap = $"/root/Main/Starting_World/Objects_TileMap"

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

#	move_speed = Globals.move_speed

func _physics_process(delta):
	
	player_movement()
	
	player_collision()

func player_collision():
	var coll = move_and_collide(Vector2() * move_speed)

	if coll:
	
		if coll.collider.name == "Level_TileMap":

			var level_tile_name = get_tile_name(coll, level_tilemap)[0]
			var cell = get_tile_name(coll, level_tilemap)[1]
	
			if level_tile_name == "shop_stairs_entry":
				Globals.goto_scene("res://Scenes/Levels/Shop.tscn")
				player_spawn("res://Scenes/Levels/Shop.tscn")
	
				Globals.player_spawn_pos = player_spawn_pos
	
			if level_tile_name == "shop_stairs_exit":
				Globals.goto_scene("res://Scenes/Levels/Starting_World.tscn") 
				player_spawn("res://Scenes/Levels/Starting_World.tscn")
	
				Globals.player_spawn_pos = player_spawn_pos

		if coll.collider.name == "Weapons_TileMap":

			var weapons_tile_name = get_tile_name(coll, weapons_tilemap)[0]
			var cell = get_tile_name(coll, weapons_tilemap)[1]
	
			if weapons_tile_name:
				Globals.player_weapon = weapons_tile_name
				clear_tile(coll, cell)
				
				weapons_tilemap.tile_set.clear()
				
				weapon_achieved = true
				
				var weapon_sprite = load("res://Scenes/weapons/" + Globals.player_weapon + ".tscn").instance()
				
				weapon_sprite.position.y = self.position.y - 270
				
				add_child(weapon_sprite)
				
				yield(get_tree().create_timer(2), "timeout")
				weapon_sprite.queue_free()
				
func get_tile_name(coll, tilemap):
	var cell = tilemap.world_to_map(coll.position - coll.normal)
	var tile_id = tilemap.get_cellv(cell)
	var tile_name = coll.collider.tile_set.tile_get_name(tile_id)

	return [tile_name, tile_id]

func clear_tile(coll, tile_id):
	return coll.collider.tile_set.remove_tile(tile_id)

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
		if !Globals.player_weapon:
			anim_player.play("walking_back")
		else:
			anim_player.play(Globals.player_weapon + "_back")
	if Input.is_action_pressed("move_right"):
		move_vec += Vector2.RIGHT
		$Body.set_flip_h(true)
		anim_player.play("walking_side")
	if Input.is_action_pressed("move_left"):
		move_vec += Vector2.LEFT
		$Body.set_flip_h(false)
		anim_player.play("walking_side")
	if move_vec == Vector2.ZERO:
		if !weapon_achieved:
			anim_player.play("Idle")
		else:
			anim_player.play("get_wep")
			yield(get_tree().create_timer(0.1), "timeout")
			get_tree().paused = true
			yield(get_tree().create_timer(2), "timeout")
			get_tree().paused = false
			weapon_achieved = false
	if Input.is_action_just_pressed("shoot"):
		if Globals.player_weapon and move_vec != Vector2.ZERO:
			var proj = load("res://Scenes/Projectile.tscn").instance()
			add_child(proj)

			if move_vec == Vector2.DOWN:
				proj.rotation_degrees = -90
				proj.velocity = Vector2.DOWN
			elif move_vec == Vector2.UP:
				proj.rotation_degrees = 90
				proj.velocity = Vector2.UP
			elif move_vec == Vector2.RIGHT:
				proj.rotation_degrees = 180
				proj.velocity = Vector2.RIGHT
			elif move_vec == Vector2.LEFT:
				proj.rotation_degrees = 0
				proj.velocity = Vector2.LEFT

	move_vec = move_vec.normalized()
	
	move_and_collide(move_vec * move_speed)
	


