extends CanvasLayer

@onready var music = $AudioStreamPlayer
@onready var title_label = $VBoxContainer/Title

var musica_escola = preload("res://Musicas/escola.mp3")

func _ready():
	if title_label:
		title_label.text = "PARABÉNS!\nVOCÊ GANHOU!\n\nPONTUAÇÃO FINAL:\n" + str(GameManager.score) + "!!!"

func _on_retry_pressed():
	music.stream = musica_escola
	music.play()
	GameManager.reset_score()
	get_tree().change_scene_to_file("res://Cenas/phase_1.tscn")

func _on_menu_pressed():
	GameManager.reset_score()
	get_tree().change_scene_to_file("res://Cenas/main.tscn")
