extends Node

@onready var professor_edf_area = $ProfessorEDF
@onready var encounter_canvas_layer = $EmcounterProfessorEDF/CanvasLayer
@onready var encounter = $EmcounterProfessorEDF
@onready var player = $Player

func _ready():
	encounter_canvas_layer.visible = false
	professor_edf_area.connect("area_entered", Callable(self, "_on_npc_area_entered"))

func _process(_delta):
	if player.is_frozen != encounter_canvas_layer.visible:
		player.is_frozen = encounter_canvas_layer.visible

func _on_npc_area_entered(area):
	if area.is_in_group("player") or (area.get_parent() and area.get_parent().is_in_group("player")):
		encounter_canvas_layer.visible = true
		encounter.start_quiz()
		professor_edf_area.monitoring = false
		professor_edf_area.disconnect("area_entered", Callable(self, "_on_npc_area_entered"))
