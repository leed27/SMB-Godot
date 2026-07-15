extends StaticBody2D

@export var gravity: float = 900.0
@export var coin_gravity: float = 900.0
@export var initial_bounce_y_speed: float = -100.0
@export var coin_initial_bounce_y_speed: float = -300.0

var y_speed = 0
var coin_y_speed: int = 0
var orig_y_position = 0
var coin_orig_y_position: int = 0
const POINTS = preload("res://mario/scenes/points.tscn")

@onready var bounce_timer = $BounceTimer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var bump = $Bump
@onready var coin = $Coin
@onready var coin_sprite_2d = $Coin2

# Called when the node enters the scene tree for the first time.
func _ready():
	orig_y_position = animated_sprite_2d.position.y
	coin_sprite_2d.position.y = 1
	coin_sprite_2d.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bounce_timer.is_stopped():
		#print(int(coin_sprite_2d.position.y))
		animated_sprite_2d.position.y = orig_y_position
		y_speed = 0.0
		if int(coin_sprite_2d.position.y) == int(coin_orig_y_position):
			coin_y_speed = 0
			coin_sprite_2d.hide()
			spawn_points_label(coin_sprite_2d, 200)
			await(set_process(false))
			
	else:
		animated_sprite_2d.position.y += y_speed * delta
		y_speed += gravity * delta
	
	#hides coin and puts a points sprite

	if coin_sprite_2d.position.y != coin_orig_y_position && coin_sprite_2d.position.y != 1:
		coin_sprite_2d.position.y += coin_y_speed * delta
		coin_y_speed += coin_gravity * delta
		
		
		
		
		
	
func _bounce():
	bump.play()
	if animated_sprite_2d.animation == "collected":
		return
	give_coin()
	animated_sprite_2d.play("collected")
	y_speed = initial_bounce_y_speed
	bounce_timer.start()
	



func _on_area_2d_area_entered(area):
	if area.get_name() == "BlockCollision":
		_bounce()

func give_coin():
	Global.coins += 1
	coin.play()
	coin_sprite_2d.position.y = orig_y_position - 20
	coin_orig_y_position = orig_y_position - 30
	coin_sprite_2d.show()
	coin_sprite_2d.play("default")
	coin_y_speed = coin_initial_bounce_y_speed
	
func spawn_points_label(enemy, int):
	var points = int
	var points_label
	Global.score += points
	points_label = POINTS.instantiate()
	points_label.get_points(points)
	points_label.position = enemy.get_parent().position + Vector2(0, -20)
	get_tree().root.add_child(points_label)
	

	
	
	
