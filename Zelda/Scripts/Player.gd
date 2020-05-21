extends KinematicBody2D

var level_tilemap
var objects_tilemap
var weapons_tilemap
var anim_player
var move_speed = 2.5
var player_spawn_pos
var weapon = false

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

	if coll and coll.collider.name == "Level_TileMap":

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

	if coll and coll.collider.name == "Weapons_TileMap":

		var weapons_tile_name = get_tile_name(coll, weapons_tilemap)[0]
		var cell = get_tile_name(coll, weapons_tilemap)[1]

		if weapons_tile_name:
			Globals.player_weapon = weapons_tile_name
			clear_tile(coll, cell)
			
			weapons_tilemap.tile_set.clear()

			weapon = true
	
			print(Globals.player_weapon)

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
		if !weapon:
			anim_player.play("Idle")
		else:
			anim_player.play("get_wep")
			yield(get_tree().create_timer(2), "timeout")
			weapon = false
			
	move_vec = move_vec.normalized()
	
	move_and_collide(move_vec * move_speed)
	
func get_tile_name(coll, tilemap):
	var cell = tilemap.world_to_map(coll.position - coll.normal)
	var tile_id = tilemap.get_cellv(cell)
	var tile_name = coll.collider.tile_set.tile_get_name(tile_id)

	return [tile_name, tile_id]

func clear_tile(coll, tile_id):
	return coll.collider.tile_set.remove_tile(tile_id)
	
	
	
#=======#	tween weapon above player with tween sprite: ===========
#		extends Label
#
#onready var effect = $effect
#
#func _ready():
#	effect.interpolate_property(self, "modulate:a", 1.0, 0.0, 15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#	effect.start()
#
#func _on_effect_tween_completed(_object, _key):
#	queue_free()
#

