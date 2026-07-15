extends Node2D

@onready var pause_sfx = $PauseSFX
@onready var bg = $"../BG"
@onready var mario = $"../Mario"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause_sfx.play()
		if get_tree().paused == true:
			bg.stream_paused = false
			mario.powerup_transition = false
			get_tree().paused = false
			return
		bg.stream_paused = true
		mario.powerup_transition = true
		get_tree().paused = true
