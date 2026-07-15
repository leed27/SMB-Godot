extends CharacterBody2D

const SPEED = 75

@export var gravity = 450

var direction = 1

var colliding = false

@onready var left = $Left
@onready var right = $Right
@onready var mushroom_sprite = $MushroomSprite

@onready var collision_shape_2d = $CollisionShape2D

const POINTS = preload("res://mario/scenes/points.tscn")

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if right.is_colliding():
		direction = -1
	if left.is_colliding():
		direction = 1
		
	position.x += direction * SPEED * delta
		
		
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()




func _on_area_2d_body_entered(body):
	if body.get_name() == "Mario":#body.get_parent().get_name().begins_with("Mario"):
		body.activate_star()
		self.queue_free()
