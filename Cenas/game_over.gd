extends CanvasLayer
@onready var music = $AudioStreamPlayer
var musica_escola = preload("res://Musicas/escola.mp3")
func _on_retry_pressed():
	# toca música da escola
	music.stream = musica_escola
	music.play()
	GameManager.reset_score()
	get_tree().change_scene_to_file("res://Cenas/phase_1.tscn")

func _on_menu_pressed():
	GameManager.reset_score()
	get_tree().change_scene_to_file("res://Cenas/main.tscn")
