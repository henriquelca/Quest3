extends StaticBody2D

var ativo = true
@export var cogumelo_cena: PackedScene

@onready var sprite = $AnimatedSprite2D

func bater_por_baixo():
	if ativo:
		ativo = false
		sprite.play("vazio")
		spawn_cogumelo()

func spawn_cogumelo():
	if cogumelo_cena:
		var cogumelo = cogumelo_cena.instantiate()
		cogumelo.global_position = global_position + Vector2(0, -16)
		get_parent().add_child(cogumelo)
