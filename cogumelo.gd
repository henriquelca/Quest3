extends CharacterBody2D

var velocidade = 60.0
var direcao = 1
var gravidade = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocity.y = -100

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravidade * delta

	if is_on_wall():
		direcao *= -1

	velocity.x = direcao * velocidade
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body is Player:
		body.crescer()
		queue_free()
