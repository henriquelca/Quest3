extends Area2D
class_name Enemy

const POINTS_LABEL_SCENE = preload("res://Cenas/points_label.tscn")

@export var horizontal_speed = 20
@export var vertical_speed = 200

@onready var ray_cast_2d = $RayCast2D as RayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D

var wall_raycast: RayCast2D

func _ready():
	set_collision_layer_value(3, true)
	set_collision_mask_value(3, true)
	set_collision_mask_value(4, true)
	
	ray_cast_2d.collision_mask = 2
	
	wall_raycast = RayCast2D.new()
	add_child(wall_raycast)
	wall_raycast.collision_mask = 2
	
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)

func _process(delta):
	position.x -= horizontal_speed * delta
	
	if horizontal_speed != 0:
		animated_sprite_2d.flip_h = horizontal_speed < 0
	
	if !ray_cast_2d.is_colliding():
		position.y += vertical_speed * delta

	var direction_x = -13 if horizontal_speed > 0 else 13
	wall_raycast.target_position = Vector2(direction_x, 0)
	wall_raycast.force_raycast_update()
	
	if wall_raycast.is_colliding():
		horizontal_speed *= -1

func die():
	horizontal_speed = 0
	vertical_speed = 0
	animated_sprite_2d.play("dead")

func die_from_hit():
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	
	rotation_degrees = 180
	horizontal_speed = 0
	vertical_speed = 0
	
	var die_tween = get_tree().create_tween()
	die_tween.tween_property(self, "position", position + Vector2(0, -25), .2)
	die_tween.chain().tween_property(self, "position", position + Vector2(0, 500), 4)
	
	var points_label = POINTS_LABEL_SCENE.instantiate()
	points_label.position = self.position + Vector2(-20, -20)
	get_tree().root.add_child(points_label)

func _on_area_entered(area):
	if area is Koopa and area.in_a_shell and area.horizontal_speed != 0:
		if self is Koopa and self.in_a_shell:
			horizontal_speed *= -1
		else:
			die_from_hit()
	elif area is Enemy:
		if self is Koopa and self.in_a_shell and self.horizontal_speed != 0:
			return
		horizontal_speed *= -1

func _on_visible_on_screen_notifier_2d_screen_exited():
	pass
