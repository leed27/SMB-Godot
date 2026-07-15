class_name MainMenu
extends Control

@onready var start = $"1P_Start" as Button
@onready var other_start = $Other_Start as Button
@export var start_level = preload("res://mario/scenes/level_1_1.tscn") as PackedScene
@export var extra_level = preload("res://scenes/game.tscn") as PackedScene

func _ready():
	start.button_down.connect(on_start_pressed)
	other_start.button_down.connect(on_otherstart_pressed)


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_otherstart_pressed() -> void:
	get_tree().change_scene_to_packed(extra_level)
