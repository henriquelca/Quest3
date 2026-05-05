extends Area2D

class_name Star

func _on_area_entered(area):
	collect()

func collect():
	var current_scene = get_tree().current_scene.scene_file_path
	
	if current_scene.contains("phase_1"):
		get_tree().change_scene_to_file("res://Cenas/lailadc.tscn")
	elif current_scene.contains("lailadc"):
		get_tree().change_scene_to_file("res://Cenas/neve_level.tscn")
	elif current_scene.contains("neve_level"):
		get_tree().change_scene_to_file("res://Cenas/fase_duda.tscn")
	elif current_scene.contains("fase_duda"):
		get_tree().change_scene_to_file("res://Cenas/fase_jp.tscn")
	elif current_scene.contains("fase_jp"):
		get_tree().change_scene_to_file("res://Cenas/game_won.tscn")
	queue_free()
