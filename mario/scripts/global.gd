extends Node

var score = 0
var coins = 0
var lives = 3
var power = 1
var world
var level

func oneup():
	lives += 1
		
func _process(delta):
	if score > 999999:
		score = 999999
	if coins == 100:
		lives += 1
		coins = 0
	

