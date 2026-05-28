extends Node

@onready var amiga_m_area = $AmigaM
@onready var encounter_canvas_layer = $EmcounterAmigaM/CanvasLayer
@onready var encounter = $EmcounterAmigaM
@onready var player = $Player

func _ready():
	encounter_canvas_layer.visible = false
	amiga_m_area.connect("area_entered", Callable(self, "_on_npc_area_entered"))

func _process(_delta):
	if player.is_frozen != encounter_canvas_layer.visible:
		player.is_frozen = encounter_canvas_layer.visible

func _on_npc_area_entered(area):
	if area.is_in_group("player") or (area.get_parent() and area.get_parent().is_in_group("player")):
		encounter_canvas_layer.visible = true
		encounter.start_quiz()
		amiga_m_area.monitoring = false
		amiga_m_area.disconnect("area_entered", Callable(self, "_on_npc_area_entered"))
