extends CanvasLayer

@onready var score_label = $VBoxContainer/ScoreLabel

func _ready():
	var game_manager = get_tree().get_first_node_in_group("game_manager")
	if game_manager:
		score_label.text = str(game_manager.score)
		game_manager.score_changed.connect(_on_score_changed)

func _on_score_changed(new_score: int):
	score_label.text = str(new_score)
