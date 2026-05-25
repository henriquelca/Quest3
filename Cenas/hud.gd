extends CanvasLayer

@onready var lives_label = $VBoxContainer/LivesLabel


var time_left = 60


func _ready():
	var game_manager = get_tree().get_first_node_in_group("game_manager")
	if game_manager:
		lives_label.text = str(game_manager.lives)
		game_manager.lives_changed.connect(_on_lives_changed)

func _on_lives_changed(new_lives: int):
	lives_label.text = str(new_lives)
