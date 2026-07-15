extends StaticBody2D

@export var gravity: float = 900.0
@export var initial_bounce_y_speed: float = -100.0

var y_speed = 0
var orig_y_position = 0
const POINTS = preload("res://mario/scenes/points.tscn")

@onready var bounce_timer = $BounceTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
