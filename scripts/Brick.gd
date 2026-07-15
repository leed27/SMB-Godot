extends HittableBlock
class_name Brick


@onready var break_sound = $Break
@onready var break_timer = $BreakTimer
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var collision_shape_2d2 = $CollisionShape2D
@onready var area_2d = $Area2D
@onready var bottom_left = $BottomLeft
@onready var top_left = $TopLeft
@onready var bottom_right = $BottomRight
@onready var top_right = $TopRight
var particles_visible = false
@export var particle_gravity: float = 1200.0
@export var particle_y_speed: float = -300.0
@export var particle_top_y_speed: float = -400.0

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#super._procces(delta)
	if bounce_timer.is_stopped():
		sprite.position.y = orig_y_position
		
		if particles_visible == true:
			bottom_left.position.x -= 0.25
			bottom_right.position.x += 0.25
			top_left.position.x -= 0.25
			top_right.position.x += 0.25
			
			
			#instead of making it all particle_y_speed * delta, i made the positions equal due to the fact that they all spawn at slightly different times
			bottom_left.position.y += particle_y_speed * delta
			bottom_right.position.y = bottom_left.position.y
			top_left.position.y += particle_top_y_speed * delta
			top_right.position.y = top_left.position.y
			
			particle_y_speed += particle_gravity * delta
			particle_top_y_speed += particle_gravity * delta
		
		return
		
	sprite.position.y += y_speed * delta
	y_speed += bounce_gravity * delta
	
	
	
func _on_area_2d_area_entered(area):
	super._on_area_2d_area_entered(area)
	if area.get_name() == "BlockCollision":
		_bounce()
		
func _bounce():
	if Global.power == 1:
		y_speed = initial_bounce_y_speed
		bounce_timer.start()
	else:
		#TODO: change the particles to be closer to the original game
		break_sound.play()
		break_timer.start()
		sprite.visible = false
		_handle_particles()
		collision_shape_2d.queue_free()
		collision_shape_2d2.queue_free()
		ray_cast_2d.queue_free()

func _handle_particles():
	bottom_left.visible = true
	bottom_right.visible = true
	top_left.visible = true
	top_right.visible = true
	particles_visible = true

func _on_break_timer_timeout():
	self.queue_free()
