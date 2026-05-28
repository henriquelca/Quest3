extends CanvasLayer

func _on_retry_pressed():
	GameManager.reset_score()
	get_tree().change_scene_to_file("res://Cenas/phase_1.tscn")

func _on_menu_pressed():
	GameManager.reset_score()
	get_tree().change_scene_to_file("res://Cenas/main.tscn")
