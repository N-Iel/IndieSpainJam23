extends CharacterBody2D

@export_subgroup("Components")
@export var sprite: Sprite2D

@export_subgroup("Properties")
@export var movement_speed: float = 200.0

var movement_velocity: Vector2

func _physics_process(delta):
	handle_controls(delta)
	handle_position(delta)
	
	move_and_slide()

func handle_controls(delta):
	# Movement
	var input := Vector2.ZERO
	
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_up", "move_down")
	
	#velocity = cartesian_to_isommetric(input).normalized() * movement_speed
	velocity = input.normalized() * movement_speed
	
func handle_position(delta):
	position += velocity * delta
	
	if velocity.length() == 0: return
	sprite.flip_h = velocity.x < 0
	
func cartesian_to_isommetric(cartesian):
	return Vector2(cartesian.y - cartesian.x, (cartesian.y + cartesian.x) / 2)

