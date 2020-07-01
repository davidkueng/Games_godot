extends KinematicBody2D

export (int) var speed = 0
export (float) var rotation_speed = 3.5

signal shoot(bullet, direction, location)
signal loose_hp()

var velocity = Vector2()
var rotation_dir = 0
var Bullet = preload("res://Scenes/Shot.tscn")
var collision
var invulnerability
var decelaration

func _ready():
	invulnerability = false
	Globals.set("player", self)
	$thrusting.visible = false

func get_input():
	rotation_dir = 0
	if Input.is_action_pressed("turn_right"):
		rotation_dir += 1.15
		rotation_speed += 0.05
	elif Input.is_action_pressed("turn_left"):
		rotation_dir -= 1.15
		rotation_speed += 0.05
	else:
		rotation_speed = 3.5
	if Input.is_action_pressed('move'):
		velocity = Vector2(0, -speed).rotated(rotation)
		speed += 3
		$thrusting.visible = true
		$thrusting.play()
		$thrusting.animation = "thrust"
	else:
		$thrusting.stop()
		$thrusting.visible = false
		
	if Input.is_action_just_pressed("shoot"):
			emit_signal("shoot", Bullet, rotation-1.55, $turnAxis.get_global_position())
			
func _ufo_hits_player(body):
	if "Player" in body.name and invulnerability == false:
		$Invul_Timer.start()
		emit_signal("loose_hp")
		invulnerability = true

func _physics_process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	collision = move_and_collide(velocity * delta)
	
	if speed > 0:
		speed -= 0.6
	
	velocity = Vector2(0, -speed).rotated(rotation)
	
	if collision and invulnerability == false:
		$Invul_Timer.start()
		emit_signal("loose_hp")
		invulnerability = true
		self.visible = false

	if self.position.x > get_viewport().get_visible_rect().size.x:
		self.position.x = 0
	elif self.position.x < 0:
		self.position.x = get_viewport().get_visible_rect().size.x
		
	if self.position.y > get_viewport().get_visible_rect().size.y:
		self.position.y = 0
	elif self.position.y < 0:
		self.position.y = get_viewport().get_visible_rect().size.y
		
func _on_Invul_Timer_timeout():
	invulnerability = false
	self.visible = true

	
# TODO:
#	fix the rotation (-1.55) hack
