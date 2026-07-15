extends HittableBlock
class_name PowerupBlock

@export var powerup_rise_speed: float = -20.0

var powerup_goal_y_position: int = 0
var bounced = false

@onready var animated_sprite_2d_2 = $AnimatedSprite2D2
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var spawn = $Spawn
@onready var powerup = $Powerup
const MUSHROOM = preload("res://mario/scenes/mushroom.tscn")
const FIREFLOWER = preload("res://mario/scenes/fireflower.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	orig_y_position = animated_sprite_2d.position.y
	powerup.position.y = 1
	powerup.hide()
	animated_sprite_2d.hide()
	animated_sprite_2d_2.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if bounce_timer.is_stopped():
		animated_sprite_2d.position.y = orig_y_position
		y_speed = 0.0
		if int(powerup.position.y) == int(powerup_goal_y_position):
			if Global.power == 1:
				var mushroom
				mushroom = MUSHROOM.instantiate()
				mushroom.position = self.position + Vector2(0, -10)
				get_tree().root.add_child(mushroom)
				powerup.hide()
				set_process(false)
			elif Global.power >= 2:
				var fire
				fire = FIREFLOWER.instantiate()
				fire.position = self.position + Vector2(0, -10)
				get_tree().root.add_child(fire)
				powerup.hide()
				set_process(false)
	
	#hides coin and puts a points sprite

	if powerup.position.y != powerup_goal_y_position && powerup.position.y != 1:
		powerup.position.y += powerup_rise_speed * delta
		
		
		
		
		
	
func _bounce():
	if bounced == true:
		return
	animated_sprite_2d_2.hide()
	animated_sprite_2d.show()
	y_speed = initial_bounce_y_speed
	bounce_timer.start()
	bounced = true
	



func _on_area_2d_area_entered(area):
	super._on_area_2d_area_entered(area)
	if area.get_name() == "BlockCollision":
		_bounce()

func spawn_powerup():
	spawn.play()
	powerup.position.y = orig_y_position #- 15
	powerup_goal_y_position = orig_y_position - 16
	powerup.show()
	if Global.power == 1:
		powerup.play("mushroom")
	elif Global.power >= 2:
		powerup.play("fire")
	


func _on_bounce_timer_timeout():
	spawn_powerup()
