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

	

		
		
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	


#func _on_visible_on_screen_notifier_2d_screen_entered():
	#paused = false
	



#func _on_area_2d_area_entered(area):
	#if area.get_parent().get_name().begins_with("Mario"):
		#area.get_parent().powerup()
		#self.queue_free()



func _on_area_2d_body_entered(body):
	if body.get_name() == "Mario":#body.get_parent().get_name().begins_with("Mario"):
		body.powerup()
		self.queue_free()
