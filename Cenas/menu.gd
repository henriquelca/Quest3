extends CanvasLayer

func _on_play_pressed():
	GameManager.reset_lives()
	get_tree().change_scene_to_file("res://Cenas/phase_1.tscn")

func _on_quit_pressed():
	get_tree().quit()
