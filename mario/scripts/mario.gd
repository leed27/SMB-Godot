extends CharacterBody2D
class_name Player

signal points_scored(points: int)

#mario cant go below this speed
@export var min_walk_speed: float = 4.453125
#highest walking speed, ie. not pressing run button
@export var max_walk_speed: float = 93.75
#highest running speed
@export var max_run_speed: float = 153.75

@export var jump_velocity: float = -240
@export var run_jump_velocity: float = -300

@export var walk_accel: float = 133.59375
@export var run_accel: float = 200.390625

#no button held
@export var decel: float = 182.8125
#opposite button held
@export var skid_decel: float = 365.625

@export var stop_fall: float = 1575
@export var walk_fall: float = 1350
@export var run_fall: float = 2025

#lower gravity
@export var stop_fall_a: float = 450
@export var walk_fall_a: float = 421.875
@export var run_fall_a: float = 562.5

@export var max_fall: float = 270

@export var flag_fall: float = 120

@export_group("Stomping enemies")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -150
@export_group("")

# Get the gravity from the project settings to be synced with RgidBody nodes.
var gravity = stop_fall#ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var powerup_timer = $PowerupTimer
@onready var animated_sprite = $AnimatedSprite2D
@onready var powerup_animation = $Powerup
@onready var down = $Down
@onready var jump = $Jump
@onready var powerup_sound = $Powerup
@onready var big_mario = $BigMario
@onready var star_timer = $StarTimer
@onready var star = $Star
@onready var oneup_sfx = $SFX/OneupSFX
@onready var hurt_animation = $Hurt
@onready var jump_sfx = $SFX/JumpSFX
@onready var big_jump_sfx = $SFX/BigJumpSFX
@onready var die_sfx = $SFX/DieSFX

#scripts
@onready var bg = $"../BG"



const POINTS = preload("res://mario/scenes/points.tscn")



var frame = 0
const max_frames = 10

var powerup_transition = false
var combo = 0
var combopoints

func reset_gravity():
	gravity = stop_fall
	
func _ready():
	if Global.power == 1:
		animated_sprite = $AnimatedSprite2D
		big_mario.hide()
		animated_sprite.show()
		
	elif Global.power == 2:
		big_mario.show()
		animated_sprite.hide()
		animated_sprite = big_mario
		jump_sfx = big_jump_sfx
		
	#big_mario.hide()
	
#func _process(delta):
	#
	#if Global.power == 0:
		#die()


func _physics_process(delta):
	
	if powerup_transition == true:
		return
	
	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# tracking mario's x-momentum at a jump
	var start_jump = 0
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
		$BodyCollisionShape.disabled = true
		$SeparationRay.disabled = false
		$SeparationRay2.disabled = false
	else:
		$BodyCollisionShape.disabled = false
		$SeparationRay.disabled = true
		$SeparationRay2.disabled = true
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		#reset_gravity()
		jump_sfx.play()
		
		if (abs(velocity.x) < 60):
			velocity.y = jump_velocity
			gravity = stop_fall
		elif (abs(velocity.x) <= 138.75):
			velocity.y = jump_velocity
			gravity = walk_fall
		else:
			velocity.y = run_jump_velocity
			gravity = run_fall
		start_jump = velocity.x
	#mario still has gravity on the ground
	else:
		if (abs(velocity.x) < 60):
			gravity = stop_fall
		elif (abs(velocity.x) <= 138.75):
			gravity = walk_fall
		else:
			gravity = run_fall
	if (abs(velocity.y) > 0 && Input.is_action_pressed("jump")): #while holding a, mario's gravity is lower
		#find the normalized vector of the y velocity. if it is above 0, then dont increase the gravity
		if(velocity.normalized().y > 0):
			gravity = gravity
		elif (gravity == stop_fall):
			gravity = stop_fall_a
		elif (gravity == walk_fall):
			gravity = walk_fall_a
		elif (gravity == run_fall):
			gravity = run_fall_a
	elif (abs(velocity.y) > 0 && !Input.is_action_pressed("jump")):
		if(velocity.normalized().y > 0):
			gravity = gravity
		elif (gravity == stop_fall || stop_fall_a):
			gravity = stop_fall
		elif (gravity == walk_fall || walk_fall_a):
			gravity = walk_fall
		elif (gravity == run_fall || run_fall_a):
			gravity = run_fall
		
		
		# handling horizontal physics in the air
		if (direction == 1):
			if (Input.is_action_pressed("move_right")):
				if (abs(velocity.x) > max_walk_speed):
					velocity.x += run_accel * delta
				else:
					velocity.x += walk_accel * delta
			elif (Input.is_action_pressed("move_left")):
				if(abs(velocity.x) > max_walk_speed):
					velocity.x -= run_accel * delta
				elif(abs(velocity.x) > max_walk_speed && start_jump >= 116.25):
					velocity.x -= abs(decel) * delta
				elif(abs(velocity.x) > max_walk_speed && start_jump < 116.25):
					velocity.x -= walk_accel * delta
			else:
				velocity.x = velocity.x
				#if no direction is pressed, keep the horizontal velocity the same
		if (direction == -1):
			if (Input.is_action_pressed("move_right")):
				if(abs(velocity.x) > max_walk_speed):
					velocity.x += run_accel * delta
				elif(abs(velocity.x) > max_walk_speed && start_jump >= 116.25):
					velocity.x += abs(decel) * delta
				elif(abs(velocity.x) > max_walk_speed && start_jump < 116.25):
					velocity.x += walk_accel * delta
			elif (Input.is_action_pressed("move_left")):
				if (abs(velocity.x) > max_walk_speed):
					velocity.x -= run_accel * delta
				else:
					velocity.x -= walk_accel * delta
			else:
				velocity.x = velocity.x
				
	#Making sure mario doesn't go faster than intended
	if (velocity.y > max_fall):
		velocity.y = max_fall - 30
		#loops back to 240 pxls per second instead of max fall, which is 270
	if (velocity.x > max_run_speed):
		velocity.x = max_run_speed
	if (velocity.x < -max_run_speed):
		velocity.x = -max_run_speed
	if (velocity.x > max_walk_speed && !Input.is_action_pressed("move_right")):
		velocity.x = max_walk_speed
	if (velocity.x < -max_walk_speed && !Input.is_action_pressed("move_left")):
		velocity.x = -max_walk_speed


	
	# Flip the Sprite
	if is_on_floor():
		#resets bonus combo score
		combo = 0
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
		
	# Play animations
	if is_on_floor():
		if (abs(velocity.x) > abs(min_walk_speed)):
			animated_sprite.play("run")
			var frame_rates_by_speed: Array[float] = [1.0, 2.5, 3.0, 4.0, 5.0]
			var index: int = int(abs(velocity.x) / 30)
			index = min(index, 4)
			animated_sprite.speed_scale = frame_rates_by_speed[index]
		else:
			animated_sprite.play("idle")
	else:
		animated_sprite.play("jump")
	


			
	if direction:
		#sets mario to minimum walk speed either left or right
		if abs(velocity.x) < abs(min_walk_speed):
			if (direction == -1):
				velocity.x -= min_walk_speed
			if (direction == 1):
				velocity.x += min_walk_speed
		#changing max speed depending on sprint or no
		
		var max_speed: float = max_walk_speed
		
		
		if (sign(velocity.x) > 0 && abs(velocity.x) > abs(min_walk_speed) && is_on_floor()):
			if (Input.is_action_pressed("move_left")):
				animated_sprite.play("skid")
				velocity.x = move_toward(velocity.x, 0, skid_decel * delta)
		elif (sign(velocity.x) < 0 && abs(velocity.x) > abs(min_walk_speed) && is_on_floor()):
			if (Input.is_action_pressed("move_right")):
				animated_sprite.play("skid")
				velocity.x = move_toward(velocity.x, 0, skid_decel * delta)
		
		#checks for run or not
		if Input.is_action_pressed("run"):
			max_speed = max_run_speed
			#velocity.x += direction * run_accel * delta
			velocity.x = move_toward(velocity.x, direction * max_speed, run_accel * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * max_speed, walk_accel * delta)
			#velocity.x += direction * walk_accel * delta
			
		#sets a 10 frame window to stay at run speed
		if (velocity.x == max_run_speed):
			frame == 0
			while (frame <= max_frames):
				velocity.x == max_run_speed
				frame += 1
	else:
		velocity.x = move_toward(velocity.x, 0, decel * delta)
		if abs(velocity.x) < abs(min_walk_speed):
			velocity.x = 0

	move_and_slide()



func _on_area_2d_area_entered(area):
	if area is Enemy:
		handle_enemy_collision(area)
	else:
		if (gravity == stop_fall || stop_fall_a):
			gravity = stop_fall
		elif (gravity == walk_fall || walk_fall_a):
			gravity = walk_fall
		elif (gravity == run_fall || run_fall_a):
			gravity = run_fall
		
func handle_enemy_collision(enemy: Enemy):
	if powerup_transition == true:
		return
		
	if enemy == null:
		print("null")
		return
		
	if enemy.get_parent().get_name().begins_with("Koopa") and enemy.get_parent().in_a_shell:
		combo += 1
		enemy.get_parent().on_stomp(global_position)
		spawn_points_label(enemy, 400)
	else:
		combo += 1
		combo_points()
		if velocity.normalized().y > 0:
			spawn_points_label(enemy, combopoints)
			enemy.die()
			velocity.y = stomp_y_velocity
		else:

			hurt()
		
func spawn_points_label(enemy, int):
	var points = int
	var points_label
	if points != 1:
		Global.score += points
	points_label = POINTS.instantiate()
	points_label.get_points(points)
	if enemy == self:
		points_label.position = self.position + Vector2(0, -30)
	else:
		points_label.position = enemy.get_parent().position + Vector2(0, -10)
	get_tree().root.add_child(points_label)

func combo_points():
	if combo == 1:
		combopoints = 100
	elif combo == 2:
		combopoints = 200
	elif combo == 3:
		combopoints = 400
	elif combo == 4:
		combopoints = 500
	elif combo == 5:
		combopoints = 800
	elif combo == 6:
		combopoints = 1000
	elif combo == 7:
		combopoints = 2000
	elif combo == 8:
		combopoints = 4000
	elif combo == 9:
		combopoints = 5000
	elif combo == 10:
		combopoints = 8000
	elif combo >= 11:
		oneup()
	
func powerup():
	spawn_points_label(self, 1000)
	if Global.power == 3:
		return
	Global.power += 1
	print(Global.power)
	if Global.power == 2:
		transition("powerup")
		##TODO: fix powerup animation being weird while jumping
		powerup_animation.play("powerup")
		big_mario.show()
		animated_sprite.hide()
		animated_sprite = big_mario
		jump_sfx = big_jump_sfx
		
		
		
func transition(str):
	if str == "powerup":
		powerup_timer.start()
		powerup_transition = true
		get_tree().paused = true
	elif str == "death":
		powerup_transition = true
		get_tree().paused = true
	
	
func oneup():
	Global.lives += 1
	spawn_points_label(self, 1)
	oneup_sfx.play()

func hurt():
	Global.power -= 1
	#if Global.power == 2:
		#transition()
		#animated_sprite = big_mario
		#fire_mario.hide()
		#animated_sprite.show()
		#hurt_animation.play("bighurt")
		#invincible()
	if Global.power == 1:
		transition("powerup")
		##TODO: fix hurt animation, clipping into ground and not animated correctly with the right images
		hurt_animation.play("hurt")
		animated_sprite = $AnimatedSprite2D
		big_mario.hide()
		animated_sprite.show()
		invincible()
	if Global.power == 0:
		die()
	
	
	
func die():
	##TODO: make the death actually go up and down
	Global.power = 1
	hurt_animation.play("diehurt")
	get_tree().paused = true
	transition("death")
	bg.stream_paused = true
	animated_sprite = $AnimatedSprite2D
	big_mario.hide()
	animated_sprite.show()
	animated_sprite.play("dead")
	print("ong u really died for sure 4reals")
	die_sfx.play()
	await die_sfx.finished
	get_tree().paused = false
	get_tree().reload_current_scene()
	#bg.stream_paused = false
	#
	#print("ong u really died for sure 4reals")
	#powerup_transition = false

	
func invincible():
	print("haha you are invincible!!")


func _on_powerup_timer_timeout():
	powerup_transition = false
	powerup_timer.stop()
	get_tree().paused = false
	

func activate_star():
	star_timer.start()
	star.play("star")

func _on_star_timer_timeout():
	star.stop("star")
