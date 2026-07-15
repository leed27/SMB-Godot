extends Area2D
class_name Enemy

@onready var timer = $Timer

func die():
	get_parent().die()

	

#func _on_body_entered(body):
	#print("you dieded!!!!!")
	#Engine.time_scale = 0.5
	#body.get_node("CollisionShape2D").queue_free()
	#body.get_node("AnimatedSprite2D").play("dead")
	#timer.start()
	


#func _on_timer_timeout():
	#Engine.time_scale = 1
	#get_tree().reload_current_scene()
