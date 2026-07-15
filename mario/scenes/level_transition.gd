extends Control

@onready var start = $"1P_Start" as Button
@onready var other_start = $Other_Start as Button
@export var transition = preload("res://mario/scenes/level_transition.tscn") as PackedScene
@export var start_level = preload("res://mario/scenes/level_1_1.tscn") as PackedScene
@export var extra_level = preload("res://scenes/game.tscn") as PackedScene

func _ready():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(start_level)


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
