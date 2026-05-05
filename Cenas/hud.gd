extends CanvasLayer

@onready var lives_label = $VBoxContainer/LivesLabel
@onready var timer_label = $VBoxContainer2/Label_Timer
@onready var game_timer = $Game_Timer


var time_left = 60


func _ready():
	var game_manager = get_tree().get_first_node_in_group("game_manager")
	if game_manager:
		lives_label.text = str(game_manager.lives)
		game_manager.lives_changed.connect(_on_lives_changed)
	
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()
	update_timer_display()

func _on_lives_changed(new_lives: int):
	lives_label.text = str(new_lives)

func _on_game_timer_timeout():
	if time_left > 0:
		time_left -= 1
		update_timer_display()
	else:
		game_timer.stop()
		on_time_up()

func update_timer_display():
	if timer_label:
		timer_label.text = "Tempo: " + str(time_left)
		
func on_time_up():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.die()
