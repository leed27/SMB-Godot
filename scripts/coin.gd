extends Area2D

@onready var animation_player = $AnimationPlayer

func _on_area_entered(area):
	if area is Enemy:
		return
	Global.coins += 1
	Global.score += 200
	animation_player.play("pickup")
