extends CanvasLayer

func _ready():
	GameManager.reset_lives()

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Cenas/phase_1.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Cenas/main.tscn")
