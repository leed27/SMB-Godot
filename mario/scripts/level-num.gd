extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = str(Global.level)
	
	if(Input.is_action_pressed("debug")):
		self.text = ("FPS %d" % Engine.get_frames_per_second())

