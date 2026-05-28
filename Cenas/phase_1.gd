extends Node

@onready var professor_area = $Professor
@onready var encounter_canvas_layer = $EmcounterProfessor/CanvasLayer
@onready var encounter_professor = $EmcounterProfessor
@onready var player = $Player
@onready var music = $AudioStreamPlayer

var musica_escola = preload("res://Musicas/escola.mp3")
var musica_pergunta = preload("res://Musicas/Battle.mp3")

func _ready():
	encounter_canvas_layer.visible = false
	professor_area.connect("area_entered", Callable(self , "_on_professor_area_entered"))
	# toca música da escola
	music.stream = musica_escola
	music.play()


func _process(_delta):
	if player.is_frozen != encounter_canvas_layer.visible:
		player.is_frozen = encounter_canvas_layer.visible

func _on_professor_area_entered(area):
	if area.is_in_group("player") or (area.get_parent() and area.get_parent().is_in_group("player")):
		# troca música
		music.stop()
		music.stream = musica_pergunta
		music.play()

		encounter_canvas_layer.visible = true
		encounter_professor.start_quiz()
		professor_area.monitoring = false
		professor_area.disconnect("area_entered", Callable(self , "_on_professor_area_entered"))

func finalizar_quiz():
	encounter_canvas_layer.visible = false
	# volta música da escola
	music.stop()
	music.stream = musica_escola
	music.play()
