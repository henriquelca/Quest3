extends CharacterBody2D
class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum PlayerMode {
	SMALL,
	BIG,
	SHOOTING
}

signal points_scored(points: int)

const POINTS_LABEL_SCENE = preload("res://Cenas/points_label.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D as PlayerAnimatedSprite
@onready var area_collision_shape_2d = $Area2D/AreaCollisionShape2D
@onready var body_collision_shape_2d = $BodyCollisionShape2D
@onready var area_2d = $Area2D

@export_group("Locomotion")
@export var speed = 500.0
@export var jump_velocity = -600
@export_group("")

@export_group("Stomping Enemies")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -150
@export_group("")

var player_mode = PlayerMode.SMALL
var is_dead = false
var is_transforming = false

func _physics_process(delta):
	if is_transforming:
		return

	if not is_on_floor():
		velocity.y += gravity * delta
		
	if position.y > 100 and not is_dead:
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5

	if is_on_ceiling():
		for i in get_slide_collision_count():
			var colisao = get_slide_collision(i)
			var collider = colisao.get_collider()
			if collider and collider.has_method("bater_por_baixo"):
				collider.bater_por_baixo()
		
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = speed * direction
	else:
		velocity.x = 0
		
	animated_sprite_2d.trigger_animation(velocity, direction, player_mode)
	move_and_slide()

	
func spawn_points_label(enemy):
	var points_label = POINTS_LABEL_SCENE.instantiate()
	points_label.position = enemy.position + Vector2(-20, -20)
	get_tree().root.add_child(points_label)
	points_scored.emit(100)

func crescer():
	if player_mode == PlayerMode.SMALL:
		is_transforming = true
		animated_sprite_2d.play("small_to_big")
		
		var nova_forma_corpo = RectangleShape2D.new()
		nova_forma_corpo.size = Vector2(16, 32)
		body_collision_shape_2d.shape = nova_forma_corpo
		body_collision_shape_2d.position.y = -8
		
		var nova_forma_area = RectangleShape2D.new()
		nova_forma_area.size = Vector2(16, 32)
		area_collision_shape_2d.shape = nova_forma_area
		area_collision_shape_2d.position.y = -8
		
		animated_sprite_2d.position.y = -8
		
		await animated_sprite_2d.animation_finished
		player_mode = PlayerMode.BIG
		is_transforming = false
