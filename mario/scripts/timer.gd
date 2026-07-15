extends Label

@export var time = 400
var paused = false

#if Global.world == 1 && Global.world == 4:
	#time == 300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = str(time).pad_zeros(3)
	if time == 0:
		paused = true


func _on_timer_timeout():
	if paused == true:
		return
	else:
		time -= 1
	
