extends Block
class_name HittableBlock

@export var bounce_gravity: float = 900.0
@export var initial_bounce_y_speed: float = -100.0

var y_speed = 0
var orig_y_position = 0
const POINTS = preload("res://mario/scenes/points.tscn")

@onready var bounce_timer = $BounceTimer
@onready var sprite = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D as RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#super._procces(delta)
	if bounce_timer.is_stopped():
		return
	sprite.position.y += y_speed * delta
	y_speed += bounce_gravity * delta
	
func _on_area_2d_area_entered(area):
	super._on_area_2d_area_entered(area)
	check_for_enemy_collision()
		
func check_for_enemy_collision():
	if ray_cast_2d.is_colliding() && ray_cast_2d.get_collider() is Enemy:
		var enemy = ray_cast_2d.get_collider() as Enemy
		enemy.get_parent().die_from_hit(1)
	elif ray_cast_2d.is_colliding() && ray_cast_2d.get_collider().get_parent().get_name() == "Mushroom":
		var mushroom = ray_cast_2d.get_collider()
		mushroom.get_parent().bump()
