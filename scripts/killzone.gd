extends Area2D

@onready var timer = $Timer




	

#func _on_body_entered(body):
	
	


#func _on_timer_timeout():
	#Engine.time_scale = 1
	#get_tree().reload_current_scene()


func _on_area_entered(area):
	if area is Enemy:
		return
	area.get_parent().die()
	#area.get_node("BodyCollisionShape").queue_free()
	#timer.start()
