extends Label




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#fix eventually maybe? should show 7 digits when it gets up to that amount i think
	self.text = str(Global.score).pad_zeros(6)

