extends Node

var lives = 3
var max_lives = 3

signal lives_changed(new_lives: int)

func _ready():
	add_to_group("game_manager")

func lose_life():
	lives -= 1
	lives_changed.emit(lives)
	if lives <= 0:
		show_game_over()
	else:
		get_tree().reload_current_scene()

func reset_lives():
	lives = max_lives
	lives_changed.emit(lives)

func show_game_over():
	get_tree().change_scene_to_file("res://Cenas/game_over.tscn")
