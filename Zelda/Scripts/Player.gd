extends KinematicBody2D

var level_tilemap
var objects_tilemap
var weapons_tilemap
var anim_player
var move_speed = 2.5

func _ready():
	anim_player = $AnimationPlayer

	level_tilemap = Globals.current_scene.get_node("Level_TileMap")
	weapons_tilemap = Globals.current_scene.get_node("Weapons_TileMap")

	if level_tilemap == null:
			level_tilemap = $"/root/Main/Starting_World/Level_TileMap"

func _process(delta):
	pass	

#	move_speed = Globals.move_speed

func _physics_process(delta):
	
	player_movement()
	
	player_collision()
	
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
		anim_player.play("Idle")
	if Input.is_action_just_pressed("attack"):
		weapon_attack(move_vec)
#		
	move_vec = move_vec.normalized()
	
	move_and_collide(move_vec * move_speed)	

func player_collision():
	var coll = move_and_collide(Vector2() * move_speed)

	if coll:	
		if coll.collider.name == "Level_TileMap":
			var level_tile_name = get_tile_name(coll, level_tilemap)[0]
	
			if level_tile_name == "shop_stairs_entry":
				Globals.goto_scene("res://Scenes/Levels/Shop.tscn", "null")
	
			if level_tile_name == "shop_stairs_exit":
				Globals.goto_scene("res://Scenes/Levels/Starting_World.tscn", "null")

		if coll.collider.name == "Weapons_TileMap":
			var weapons_tile_name = get_tile_name(coll, weapons_tilemap)[0]
			var cell = get_tile_name(coll, weapons_tilemap)[1]
	
			if weapons_tile_name:
				weapon_achievement_anim(weapons_tile_name, coll, cell)
				
func weapon_achievement_anim(weapons_tile_name, coll, cell):
		Globals.player_weapon = weapons_tile_name
		clear_tile(coll, cell)
		weapons_tilemap.tile_set.clear()
		var weapon_sprite = load("res://Scenes/weapons/" + Globals.player_weapon + ".tscn").instance()
		add_child(weapon_sprite)
		weapon_sprite.position.y -= 32
		anim_player.play("get_wep")
		yield(get_tree().create_timer(0.01), "timeout")
		get_tree().paused = true
		yield(get_tree().create_timer(2), "timeout")
		get_tree().paused = false

		weapon_sprite.queue_free()
	
func get_tile_name(coll, tilemap):
	var cell = tilemap.world_to_map(coll.position - coll.normal)
	var tile_id = tilemap.get_cellv(cell)
	var tile_name = coll.collider.tile_set.tile_get_name(tile_id)

	return [tile_name, tile_id]

func clear_tile(coll, tile_id):
	return coll.collider.tile_set.remove_tile(tile_id)
	
func weapon_attack(move_vec):
	if Globals.player_weapon:
		var weap = load("res://Scenes/Weapon.tscn").instance()
		add_child(weap)

		if Globals.player_weapon == "axe":
			var axe = preload("res://Assets/axe_small.png")
			weap.get_node("weapon").set_texture(axe)
			weap.speed = 0

		if Globals.player_weapon == "bow": 
			if move_vec == Vector2.DOWN or move_vec == Vector2.ZERO:
				weap.rotation_degrees = -90
				weap.velocity = Vector2.DOWN
			elif move_vec == Vector2.UP:
				weap.rotation_degrees = 90
				weap.velocity = Vector2.UP
			elif move_vec == Vector2.RIGHT:
				weap.rotation_degrees = 180
				weap.velocity = Vector2.RIGHT
			elif move_vec == Vector2.LEFT:
				weap.rotation_degrees = 0
				weap.velocity = Vector2.LEFT
		
	
	


