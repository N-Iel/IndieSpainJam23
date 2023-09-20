extends CharacterBody2D

@export_subgroup("Components")
@export var sprite: Sprite2D

@export_subgroup("Properties")
@export var movement_speed: float = 200.0
@export var diagonal_adjustment: float = 0.7

var movement_velocity: Vector2

func _physics_process(delta):
	handle_controls()
	handle_position(delta)
	
	move_and_slide()

func handle_controls():
	# Movement
	var input := Vector2.ZERO
	
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_up", "move_down")
	
	velocity = adjust_diagonal_movement(input.normalized()) * movement_speed
	
func handle_position(delta):
	position += velocity * delta
	
	if velocity.length() == 0: return
	sprite.flip_h = velocity.x < 0
	
func cartesian_to_isommetric(cartesian):
	return Vector2(cartesian.y - cartesian.x, (cartesian.y + cartesian.x) / 2)
	
func adjust_diagonal_movement(dir):
	if 0.70 <= abs(dir.x) && abs(dir.x) <= 0.71:
		return Vector2(dir.x + (sign(dir.x) * diagonal_adjustment), dir.y).normalized()
	else:
		return dir

