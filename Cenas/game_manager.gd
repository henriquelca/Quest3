extends Node

var score = 0

signal score_changed(new_score: int)

func _ready():
	add_to_group("game_manager")

func add_score(points: int):
	score += points
	score_changed.emit(score)

func reset_score():
	score = 0
	score_changed.emit(score)
