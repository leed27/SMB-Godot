extends AnimatedSprite2D
@onready var oneup = $Oneup

var points

func get_points(int):
	points = int

# Called when the node enters the scene tree for the first time.
func _ready():
	if points == 1:
		play("1UP")
		Global.oneup()
		oneup.play()
	else:
		play(str(points))
	var points_tween = get_tree().create_tween()
	points_tween.tween_property(self, "position", position + Vector2(0, -10), .4)
	points_tween.tween_callback(queue_free)
