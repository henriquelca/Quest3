extends AnimatedSprite2D

class_name PlayerAnimatedSprite

@onready var original_scale_x: float = abs(scale.x)

func trigger_animation(
	velocity: Vector2,
	direction: int,
	player_mode: Player.PlayerMode
):
	var animation_prefix = Player.PlayerMode.keys()[player_mode].to_snake_case()

	# Flip sprite while preserving original scale
	if direction != 0:
		scale.x = original_scale_x * direction

	# Jump
	if not get_parent().is_on_floor():
		play("%s_jump" % animation_prefix)

	# Slide
	elif sign(velocity.x) != sign(direction) \
	and velocity.x != 0 \
	and direction != 0:
		play("%s_slide" % animation_prefix)

	# Run / Idle
	else:
		if velocity.x != 0:
			play("%s_run" % animation_prefix)
		else:
			play("%s_idle" % animation_prefix)
