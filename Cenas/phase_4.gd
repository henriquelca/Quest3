extends Node

@onready var amigo_h_area = $AmigoH
@onready var encounter_canvas_layer = $EmcounterAmigoH/CanvasLayer
@onready var encounter = $EmcounterAmigoH
@onready var player = $Player

func _ready():
	encounter_canvas_layer.visible = false
	amigo_h_area.connect("area_entered", Callable(self, "_on_npc_area_entered"))

func _process(_delta):
	if player.is_frozen != encounter_canvas_layer.visible:
		player.is_frozen = encounter_canvas_layer.visible

func _on_npc_area_entered(area):
	if area.is_in_group("player") or (area.get_parent() and area.get_parent().is_in_group("player")):
		encounter_canvas_layer.visible = true
		encounter.start_quiz()
		amigo_h_area.monitoring = false
		amigo_h_area.disconnect("area_entered", Callable(self, "_on_npc_area_entered"))
