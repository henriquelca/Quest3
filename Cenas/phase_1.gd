extends Node

@onready var professor_area = $Professor
@onready var encounter_canvas_layer = $EmcounterProfessor/CanvasLayer
@onready var player = $Player

func _ready():
	encounter_canvas_layer.visible = false
	professor_area.connect("area_entered", Callable(self , "_on_professor_area_entered"))

func _process(_delta):
	if player.is_frozen != encounter_canvas_layer.visible:
		player.is_frozen = encounter_canvas_layer.visible

func _on_professor_area_entered(area):
	if area.is_in_group("player") or (area.get_parent() and area.get_parent().is_in_group("player")):
		encounter_canvas_layer.visible = true
		professor_area.monitoring = false
		professor_area.disconnect("area_entered", Callable(self , "_on_professor_area_entered"))
		
