extends CharacterBody2D
#class_name Enemy

const SPEED = 30

@export var gravity = 450

var direction = -1

var paused = true
var dead = false
var colliding = false
var is_stomped = false

@onready var left = $Left
@onready var right = $Right
@onready var animated_sprite = $AnimatedSprite2D

@onready var timer = $Timer
@onready var collision_shape_2d = $CollisionShape2D
@onready var killzone = $Killzone


const POINTS = preload("res://mario/scenes/points.tscn")

func disablecollision():
	killzone.queue_free()
	

func die():
	disablecollision()
	timer.start()
	paused = true
	velocity.y = 0
	position.y = position.y
	velocity.x = 0
	direction = 0
	animated_sprite.play("stomp")
	$Stomp.play()
	#
#func _ready():
	#left.add_exception()
	#right.add_exception()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#only moves once appeared on screen
	if paused == true:
		return
	if right.is_colliding() && right.get_collider() && !right.get_collider().has_method("hurt"):
		direction = -1
		animated_sprite.flip_h = true
	if left.is_colliding()&& left.get_collider() && !left.get_collider().has_method("hurt"):
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += direction * SPEED * delta
		
		
func _physics_process(delta):
	if not is_on_floor() && dead == false:
		velocity.y += gravity * delta
	move_and_slide()
	
func _on_timer_timeout():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered():
	paused = false
	
#TODO: finish this method
func die_from_hit(int):
	paused = true
	rotation_degrees = 180
	#velocity.y = 0
	#velocity.x = 0
	direction = int
	
	animated_sprite.stop()
	disablecollision()
	var die_tween = get_tree().create_tween()
	die_tween.tween_property(self, "position", position + Vector2(direction * 22, -25), .3)
	#TODO: make it so that the tween goes in a curve direction instead of in a vector
	die_tween.chain().tween_property(self, "position", position + Vector2(direction * 44, 200), .5)
	
	var points = 100#int
	var points_label
	Global.score += points
	points_label = POINTS.instantiate()
	points_label.get_points(points)
	points_label.position = self.position + Vector2(2, -10)
	get_tree().root.add_child(points_label)
	



func _on_killzone_area_entered(area):
	if area.get_parent().get_name().begins_with("Koopa") and area.get_parent().in_a_shell and area.get_parent().velocity.x != 0:
		if area.get_parent().velocity.x > 0:
			die_from_hit(1)
		else:
			die_from_hit(-1)
